import sys
import os
from pathlib import Path

def generate_disks(option, mount_point="/mnt/disk", uuid="1234-5678", fs_type="ext4"):
    script_dir = Path(__file__).resolve().parent.parent
    nix_file = nix_file = script_dir / "modules/hosts/my-machine/disks.nix"

    # per fs options
    if fs_type in ["ntfs-3g", "vfat", "ntfs"]:
        options_str = '[ "rw" "uid=1000" "gid=100" "umask=0022" ]'
    else:
        options_str = '[ "defaults" ]'

    # replace / overwrite login
    if option in ["--replace", "-r"]:
        content = f'''{{ ... }}:
{{
    fileSystems = {{
        "{mount_point}" = {{
            device = "/dev/disk/by-uuid/{uuid}";
            fsType = "{fs_type}";
            options = {options_str};
        }};
    }};
}}
'''
        with open(nix_file, "w") as f:
            f.write(content)
        print(f">> overwrote {nix_file} with disk: {mount_point}")
        return
    # append logic
    elif option in ["--append", "-a"]:
        # check that the file exists
        if os.path.exists(nix_file):
            with open(nix_file, "r") as f:
                content = f.read()
        else:
            content = "{ ... }:\n{\n  fileSystems = {\n  };\n}"

        if uuid in content:
            print(f"!! error! disk {uuid} already exists in config.")
            return

        nix_entry = f'''
        "{mount_point}" = {{
            device = "/dev/disk/by-uuid/{uuid}";
            fsType = "{fs_type}";
            options = {options_str};
        }};
'''
        # insert the entry before the LAST closing brace pair
        insertion_point = content.rfind("};")
        new_content = content[:insertion_point] + nix_entry + "    };\n}"
        with open(nix_file, "w") as f:
            f.write(new_content)
        print(f">> added {mount_point} to disks.nix!")
    # delete eveything option
    elif option in ["--delete", "-d"]:
        content = "{ ... }:\n{\n}\n"
        with open(nix_file, "w") as f:
            f.write(content)
        print(f">> wiped all fileSystems in {nix_file}")
        return
    else:
        print(f"!! unknown option {option}")

if __name__ == "__main__":
    # show help menu
    if len(sys.argv) > 1 and sys.argv[1] in ["--help", "-h"]:
        print("usage: python generate-disks.py [OPTION] [MOUNT_POINT] [UUID] [FS_TYPE]")
        print("  -d || --delete  : delete every file system from disks.nix")
        print("  -a || --append  : append disk to disks.nix")
        print("  -r || --replace : replace file with new disk config")
        sys.exit(0)
    elif len(sys.argv) == 1:
        print("usage: python generate-disks.py --'OPTION' /mnt/'MOUNT_FOLDER' UUID [fs_type]")
    # show second help menu when passing incorrect args
    elif sys.argv[1] in ["--delete", "-d"]:
        generate_disks(sys.argv[1])
    elif len(sys.argv) == 5:
        generate_disks(
            sys.argv[1],
            sys.argv[2],
            sys.argv[3],
            sys.argv[4]
        )

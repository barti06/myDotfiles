{ ... }:
{
    fileSystems = {
        "/mnt/ssd-sata" = {
            device = "/dev/disk/by-uuid/6EACD427ACD3E79B";
            fsType = "ntfs-3g";
            options = [ "rw" "uid=1000" "gid=100" "umask=0022" ];
        };
    
        "/mnt/hdd-stuff" = {
            device = "/dev/disk/by-uuid/385A324B5A3205E2";
            fsType = "ntfs-3g";
            options = [ "rw" "uid=1000" "gid=100" "umask=0022" ];
        };
    };
}

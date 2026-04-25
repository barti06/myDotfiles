{ self, inputs, ... }: {

    flake.nixosModules.barti-pcConfiguration = { pkgs, lib, ... }: {

        nixpkgs.config.allowUnfree = true;
        imports = [
            self.nixosModules.barti-pcHardware
            self.nixosModules.barti-pcGaming
            self.nixosModules.barti-pcDev
            self.nixosModules.barti-pcHome
            self.nixosModules.niri
            self.nixosModules.headsetcontrol
        ];

        fonts.packages = with pkgs; [
            nerd-fonts.jetbrains-mono
        ];

        users.users.barti = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" "audio" "video" "corectrl" ];
            shell = pkgs.fish;
            packages = with pkgs; [
                tree
            ];
        };

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelPackages = pkgs.linuxPackages_7_0;

        networking.hostName = "barti-pc";
        networking.networkmanager.enable = true;
        time.timeZone = "America/Buenos_Aires";

        services.getty.autologinUser = "barti";
        services.gnome.gnome-keyring.enable = true;
        security.polkit.enable = true;
        services.flatpak.enable = true;

        xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
            config.common.default = "gtk";
        };

        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        services.pipewire.extraConfig.pipewire = {
            "99-corsair" = {
                "context.properties" = {
                "module.x11.bell" = false;
                "core.daemon" = true;
                };
            };
        };

        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };

        programs.fish.enable = true;
        programs.firefox.enable = true;

        programs.corectrl.enable = true;
        programs.corectrl.gpuOverclock.enable = true;
        boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];

        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        system.stateVersion = "26.05";

        fileSystems."/mnt/ssd-sata" = {
            device = "/dev/disk/by-uuid/6EACD427ACD3E79B";
            fsType = "ntfs-3g";
            options = [ "rw" "uid=1000" "gid=100" "umask=0022" ];
        };

        systemd.user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };

        hardware.ckb-next.enable = true;

        environment.systemPackages = with pkgs; [
            jq
            psmisc
            eza
            unzip
            zip
            fastfetch
            stow
            neovim
            vim
            wget
            git
            wl-clipboard
            ripgrep
            fd
            fzf
            pwvucontrol
            ntfs3g
            polkit_gnome
            p7zip
            unrar
            pkgs.ckb-next
        ];

        nixpkgs.config.permittedInsecurePackages = [
            "ventoy-1.1.10"
        ];

        environment.sessionVariables = {
            FILE_MANAGER = "nemo";
        };
    };
}

{ self, inputs, ... }: {
    flake.nixosModules.bartiHome = {
        imports = [ inputs.home-manager.nixosModules.home-manager ];
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            extraSpecialArgs = { inherit inputs; };
            users.barti = self.homeModules.barti;
        };
    };

    flake.homeModules.barti = { config, pkgs, ... }: {
        home.username = "barti";
        home.homeDirectory = "/home/barti";
        home.stateVersion = "25.11";

        home.packages = with pkgs; [
            kitty
            spotify
            vesktop
            kdePackages.okular
            nemo
            papirus-icon-theme
            ffmpegthumbnailer
            evince
            corectrl
            qdiskinfo
            scrcpy
            universal-android-debloater
            libreoffice
            mpv
            yt-dlg
            ventoy-full
            qbittorrent
            rofi
            waybar
            hyprpaper
            hyprshot
            niri
        ];

        home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.apple-cursor;
            name = "macOS";
            size = 24;
        };

        gtk = {
            enable = true;
            iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
            };
        };

        xdg.desktopEntries.nemo = {
            name = "Nemo";
            genericName = "File Manager";
            exec = "${pkgs.nemo-with-extensions}/bin/nemo";
            icon = "/home/barti/Pictures/folder-icon.png";
            terminal = false;
            categories = [ "Utility" "Core" "System" ];
            mimeType = [ "inode/directory" ];
            settings = {
                StartupWMClass = "nemo";
            };
        };

        xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.jsonc;

        programs.git = {
            enable = true;
            package = pkgs.gitFull;
            settings = {
                user = {
                    name = "barti06";
                    email = "bartipdl1@gmail.com";
                };
                credential.helper = "${pkgs.gh}/bin/gh auth git-credential";
            };
        };

        programs.gh = {
            enable = true;
        };

        programs.fish = {
            enable = true;
            loginShellInit = ''
	            if test (tty) = /dev/tty1
                    # maybe i should add ts as env vars
	                set -x XDG_SESSION_TYPE wayland
                    set -x XDG_SESSION_DESKTOP niri
                    set -x XDG_CURRENT_DESKTOP niri

                    exec niri-session -l
	            end
	        '';
            interactiveShellInit = ''
                set fish_greeting ""
 
                # git settings
                set -g __fish_git_prompt_char_stateseparator ""
                set -g __fish_git_prompt_showdirtystate 1
                set -g __fish_git_prompt_char_dirtystate "*"

                fastfetch
            '';
            shellAliases = {
                ls = "eza -la --icons --group-directories-first";
                btw = "echo i use nixos, btw";
                nef = "cd ~/cfg && nvim";
                nrs = "sudo nixos-rebuild switch --flake ~/cfg#barti";
            };
            functions = {
                fish_prompt = ''
                set -l git (fish_git_prompt | string trim -c '() ')
                set_color blue
                echo -n (prompt_pwd)
                set_color green
                echo " $git"
                set_color magenta
                echo -n "❯ "
                set_color normal
                '';
            };
        };

        programs.kitty = {
            enable = true;
            font = {
                name = "JetBrainsMono Nerd Font";
                size = 12;
            };
            settings = {
                background_opacity = "0.95";
                # darkplus bg colors
                background = "#1e1e1e";
                foreground = "#d4d4d4";
                cursor = "#d4d4d4";
                selection_background  = "#264f78";
                selection_foreground  = "#d4d4d4";

                # black
                color0 = "#1e1e1e";
                color8 = "#808080";
                # red
                color1 = "#f44747";
                color9 = "#f44747";
                # green
                color2 = "#608b4e";
                color10 = "#608b4e";
                # yellow (changes to orange)
                color3 = "#ce9178";
                color11 = "#ce9178";
                # blue
                color4 = "#569cd6";
                color12 = "#569cd6";
                # magenta
                color5 = "#c678dd";
                color13 = "#c678dd";
                # cyan
                color6 = "#4ec9b0";
                color14 = "#4ec9b0";
                # white
                color7 = "#d4d4d4";
                color15 = "#d4d4d4";
            };
        };

        systemd.user.services.corectrl = {
            Unit = {
                Description = "CoreCtrl (Background Service)";
                After = [ "graphical-session.target" ];
                PartOf = [ "graphical-session.target" ];
            };

            Service = {
                ExecStart = "${pkgs.corectrl}/bin/corectrl --minimize-systray";
                Restart = "on-failure";
                RestartSec = 5;
            };

            Install = {
                WantedBy = [ "graphical-session.target" ];
            };
        };
    };
}

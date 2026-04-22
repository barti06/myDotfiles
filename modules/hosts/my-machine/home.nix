{ self, inputs, ... }: {
    flake.nixosModules.barti-pcHome = {
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
        home.stateVersion = "26.05";
        
        home.packages = with pkgs; [
            kitty
            spotify
            discord
        ];
        
        home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.apple-cursor;
            name = "macOS";
            size = 24;
        };

        programs.git = {
            enable = true;
            package = pkgs.gitFull;
            settings = {
                user = {
                    name = "barti06";
                    email = "bartipdl1@gmail.com";
                };
                credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
            };
        };

        programs.fish = {
            enable = true;
            loginShellInit = ''
	            if test (tty) = /dev/tty1
	                set -x XDG_SESSION_TYPE wayland
                    set -x XDG_SESSION_DESKTOP niri
                    set -x XDG_CURRENT_DESKTOP niri
                    exec niri-session -l
	            end
	        '';
            interactiveShellInit = ''
                set fish_greeting ""
                fastfetch
            '';
            shellAliases = {
                ls = "eza -la --icons --group-directories-first";
                btw = "echo i use nixos, btw";
            };
            functions = {
                fish_prompt = ''
                set_color blue
                echo (prompt_pwd)
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
                background_opacity = "0.8";
            };
        };
    };
}

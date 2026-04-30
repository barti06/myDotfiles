{ self, inputs, ... }: 
{ # THIS FILE IS UNUSED
    perSystem = { pkgs, lib, ... }: {
        packages.myHyprlock =
        let
            hyprlockConf = pkgs.writeText "hyprlock.conf" ''
                $font = JetBrains Nerd Mono

                general {
                    hide_cursor = false
                    disable_loading_bar = true
                }

                animations {
                    enabled = true
                    bezier = linear, 1, 1, 0, 0
                    animation = fadeIn, 1, 5, linear
                    animation = fadeOut, 1, 5, linear
                    animation = inputFieldDots, 1, 2, linear
                }

                background {
                    monitor =
                    path = /home/barti/wallpapers/wallpaper6.jpg
                    blur_passes = 1
                }

                input-field {
                    monitor =
                    size = 250, 60
                    outline_thickness = 2
                    inner_color = rgba(0, 0, 0, 0.6)
                    outer_color = rgba(33, 204, 255, 0.93) rgba(0, 255, 153, 0.93) 45deg
                    check_color = rgba(0, 255, 153, 0.93) rgba(255, 102, 51, 0.93) 120deg
                    fail_color = rgba(255, 102, 51, 0.93) rgba(255, 0, 102, 0.93) 40deg
                    font_color = rgb(233, 233, 233)
                    fade_on_empty = false
                    rounding = 15
                    font_family = $font
                    placeholder_text = Input password...
                    fail_text = $PAMFAIL
                    dots_size = 0.175
                    dots_spacing = 0.3
                    position = 0, -100
                    halign = center
                    valign = center
                }

                label {
                    monitor =
                    text = $TIME
                    font_size = 120
                    font_family = $font
                    position = 0, -350
                    halign = center
                    valign = top
                }

                label {
                    monitor =
                    text = cmd[update:60000] date +"%A, %d %B %Y"
                    font_size = 40
                    font_family = $font
                    position = 0, -550
                    halign = center
                    valign = top
                }
            '';
        in 
            pkgs.writeShellScriptBin "hyprlock" ''
            exec ${lib.getExe pkgs.hyprlock} --config ${hyprlockConf} "$@"
            '';  };
}

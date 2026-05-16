{ pkgs, lib, ...}:
let
    wallpaper = ../wallpapers/wallpaper6.jpg;
in
{
  #services.xserver.enable = true;
  services.displayManager.sddm.theme = "breeze";

  environment.systemPackages = [
    (
      pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background = ${wallpaper}
      ''
    )
  ];
}

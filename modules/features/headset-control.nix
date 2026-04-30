{ self, inputs, pkgs, ... }: {
    flake.nixosModules.headsetcontrol = { pkgs, lib, ... }:
    let
        customHeadsetControl = pkgs.headsetcontrol.overrideAttrs (oldAttrs: {
        src = inputs.headsetcontrol;
        });
    in {
        environment.systemPackages = [ customHeadsetControl ];
        services.udev.packages = [ customHeadsetControl ];
        services.udev.extraRules = ''
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2a08", TAG+="uaccess", MODE="0666"
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2a09", TAG+="uaccess", MODE="0666"        '';
    };
}

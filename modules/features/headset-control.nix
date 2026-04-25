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
            SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2a08", MODE="0666"
            SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="2a09", MODE="0666"
        '';
    };
}

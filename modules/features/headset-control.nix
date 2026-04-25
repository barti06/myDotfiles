{ self, inputs, pkgs, ... }: {
    flake.nixosModules.headsetcontrol = { pkgs, lib, ... }:
    let
        customHeadsetControl = pkgs.headsetcontrol.overrideAttrs (oldAttrs: {
        src = inputs.headsetcontrol;
        });
    in {
        environment.systemPackages = [ customHeadsetControl ];
        services.udev.packages = [ customHeadsetControl ];
    };
}

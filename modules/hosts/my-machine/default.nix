{ self, inputs, ... }: {
    flake.nixosConfigurations.barti = inputs.nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.bartiConfiguration
            ./hardware.nix
        ];
    };
}

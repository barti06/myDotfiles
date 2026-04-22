{ self, inputs, ... }: {
    
    flake.nixosConfigurations.barti-pc = inputs.nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.barti-pcConfiguration
        ];
    };
}

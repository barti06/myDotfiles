{
  description = "my nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    headsetcontrol = {
        url = "github:Sapd/HeadsetControl";
        flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # host name
    nixosConfigurations."barti" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # pass inputs to all modules
      specialArgs = { inherit inputs; };

      modules = [
        ./modules/hosts/my-machine/configuration.nix
        ./modules/hosts/my-machine/hardware.nix
      ];
    };
  };}

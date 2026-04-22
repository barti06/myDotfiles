{ self, inputs, ... }: {
  flake.nixosModules.barti-pcGaming = { pkgs, ... }: {
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
    
    environment.systemPackages = with pkgs; [
        gamemode
        mangohud
        wine
        winetricks
        lutris
        heroic
        protontricks
    ];
  };
}

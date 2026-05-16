{ pkgs, inputs, ... }: {
    imports = [
        inputs.helium.nixosModules.default
    ];

    programs.helium = {
        enable = true;
        policies = {
            "BrowserSignin" = 0;
            "SpellcheckEnabled" = true;
            "SpellcheckLanguage" = [ "en-US" ];
        };
    };
}

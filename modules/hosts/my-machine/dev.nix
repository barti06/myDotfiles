{ self, inputs, ... }: {
    flake.nixosModules.bartiDev = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
        clang
        clang-tools
        cmake
        ninja
        gdb
        lldb
        nodejs_25
        python3
        tree-sitter
        lazygit
        cargo
        lua-language-server
        pyright
        typescript-language-server
        bash-language-server
        nixd
        mesa
        libGL
        vulkan-loader
        vulkan-tools
        vulkan-headers
        vulkan-validation-layers
        mesa-demos
        renderdoc
        ];
    };
}

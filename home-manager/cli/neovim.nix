{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim

    # formatters
    alejandra
    stylua
    biome
    prettierd
    nodePackages.prettier
    shfmt
    rustfmt

    # linters
    luajitPackages.luacheck
    ruff
    shellcheck
    cpplint
    hadolint

    # LSPs
    lua-language-server
    vscode-langservers-extracted # jsonls
    pyright
    nodePackages.bash-language-server
    dockerfile-language-server-nodejs
    clang-tools
    nodePackages.typescript-language-server
    ltex-ls
    emmet-ls
    nil

    # misc
    luajitPackages.jsregexp
  ];

  programs.neovim.defaultEditor = true;
}
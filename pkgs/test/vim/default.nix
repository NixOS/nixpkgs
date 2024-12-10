{
  vimUtils,
  vim-full,
  writeText,
  vimPlugins,
  lib,
  fetchFromGitHub,
  pkgs,
}:
let
  inherit (vimUtils) buildVimPlugin;

  packages.myVimPackage.start = with vimPlugins; [ vim-nix ];

in
pkgs.recurseIntoAttrs (rec {
  vim_empty_config = vimUtils.vimrcFile {
    beforePlugins = "";
    customRC = "";
  };

  ### vim tests
  ##################

  test_vim_with_vim_nix_using_plug = vim-full.customize {
    name = "vim-with-vim-addon-nix-using-plug";
    vimrcConfig.plug.plugins = with vimPlugins; [ vim-nix ];
  };

  test_vim_with_vim_nix = vim-full.customize {
    name = "vim-with-vim-addon-nix";
    vimrcConfig.packages.myVimPackage.start = with vimPlugins; [ vim-nix ];
  };
})

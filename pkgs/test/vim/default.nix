{ vimUtils, vim_configurable, writeText, vimPlugins
, lib, fetchFromGitHub
, pkgs
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;

  packages.myVimPackage.start = with vimPlugins; [ vim-nix ];

in
  pkgs.recurseIntoAttrs (rec {
  vim_empty_config = vimUtils.vimrcFile { beforePlugins = ""; customRC = ""; };

  ### vim tests
  ##################

  test_vim_with_vim_nix_using_plug = vim_configurable.customize {
    name = "vim-with-vim-addon-nix-using-plug";
    vimrcConfig.plug.plugins = with vimPlugins; [ vim-nix ];
  };

  test_vim_with_vim_nix = vim_configurable.customize {
    name = "vim-with-vim-addon-nix";
    vimrcConfig.packages.myVimPackage.start = with vimPlugins; [ vim-nix ];
  };
})

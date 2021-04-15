{ vimUtils, vim_configurable, neovim, vimPlugins
, lib, fetchFromGitHub,
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;

  packages.myVimPackage.start = with vimPlugins; [ vim-nix ];
in
{
  vim_empty_config = vimUtils.vimrcFile { beforePlugins = ""; customRC = ""; };

  vim_with_vim2nix = vim_configurable.customize {
    name = "vim"; vimrcConfig.vam.pluginDictionaries = [ "vim-addon-vim2nix" ];
  };

  # test cases:
  test_vim_with_vim_nix_using_vam = vim_configurable.customize {
   name = "vim-with-vim-addon-nix-using-vam";
    vimrcConfig.vam.pluginDictionaries = [{name = "vim-nix"; }];
  };

  test_vim_with_vim_nix_using_pathogen = vim_configurable.customize {
    name = "vim-with-vim-addon-nix-using-pathogen";
    vimrcConfig.pathogen.pluginNames = [ "vim-nix" ];
  };

  test_vim_with_vim_nix_using_plug = vim_configurable.customize {
    name = "vim-with-vim-addon-nix-using-plug";
    vimrcConfig.plug.plugins = with vimPlugins; [ vim-nix ];
  };

  test_vim_with_vim_nix = vim_configurable.customize {
    name = "vim-with-vim-addon-nix";
    vimrcConfig.packages.myVimPackage.start = with vimPlugins; [ vim-nix ];
  };

  # only neovim makes use of `requiredPlugins`, test this here
  test_nvim_with_vim_nix_using_pathogen = neovim.override {
    configure.pathogen.pluginNames = [ "vim-nix" ];
  };

  # regression test for https://github.com/NixOS/nixpkgs/issues/53112
  # The user may have specified their own plugins which may not be formatted
  # exactly as the generated ones. In particular, they may not have the `pname`
  # attribute.
  test_vim_with_custom_plugin = vim_configurable.customize {
    name = "vim_with_custom_plugin";
    vimrcConfig.vam.knownPlugins =
      vimPlugins // ({
        vim-trailing-whitespace = buildVimPluginFrom2Nix {
          name = "vim-trailing-whitespace";
          src = fetchFromGitHub {
            owner = "bronson";
            repo = "vim-trailing-whitespace";
            rev = "4c596548216b7c19971f8fc94e38ef1a2b55fee6";
            sha256 = "0f1cpnp1nxb4i5hgymjn2yn3k1jwkqmlgw1g02sq270lavp2dzs9";
          };
          # make sure string dependencies are handled
          dependencies = [ "vim-nix" ];
        };
      });
    vimrcConfig.vam.pluginDictionaries = [ { names = [ "vim-trailing-whitespace" ]; } ];
  };

  # system remote plugin manifest should be generated, deoplete should be usable
  # without the user having to do `UpdateRemotePlugins`. To test, launch neovim
  # and do `:call deoplete#enable()`. It will print an error if the remote
  # plugin is not registered.
  test_nvim_with_remote_plugin = neovim.override {
    configure.pathogen.pluginNames = with vimPlugins; [ deoplete-nvim ];
  };
}

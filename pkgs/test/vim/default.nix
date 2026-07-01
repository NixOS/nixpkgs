{
  lib,
  vimUtils,
  vim-full,
  vimPlugins,

  pkgs,
}:
lib.recurseIntoAttrs {
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

  # test that all vimPlugins have `passthru.vimPlugin = true`
  test-all-plugins-have-vimPlugin-true =
    let
      # we remove aliases as they are irrelevant here and cause warning when evaling this test
      pkgsNoAliases = (
        pkgs.extend (
          self: prev: {
            config = prev.config // {
              allowAliases = false;
            };
          }
        )
      );
      vimPluginsNoAliases = pkgsNoAliases.vimPlugins;
    in
    assert
      lib.attrNames (
        lib.filterAttrs (
          name: elem:
          # exclude non-plugins
          lib.isDerivation elem
          && name != "corePlugins"
          # only plugins that don't have `vimPlugin = true`
          && elem.passthru.vimPlugin or false != true
        ) vimPluginsNoAliases
      ) == [ ];
    # testing is done during evaluation above so this derivation is irrelevant
    vim-full;
}

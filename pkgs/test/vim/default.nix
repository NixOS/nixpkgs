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

  test_vim_plugin_dont_unpack =
    let
      plugin = vimUtils.buildVimPlugin {
        pname = "vim-plugin-dont-unpack-test";
        version = "0";
        src = pkgs.writeText "probe.vim" "";
        dontUnpack = true;
        buildPhase = ''
          install -D "$src" "$out/colors/probe.vim"
        '';
      };
    in
    pkgs.runCommand "vim-plugin-dont-unpack-test" { } ''
      test -f ${plugin}/colors/probe.vim
      for file in env-vars .attrs.json .attrs.sh; do
        test ! -e ${plugin}/"$file"
      done
      mkdir -p "$out"
    '';

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

  test_vim_plugin_install_phase =
    let
      plugin = vimUtils.buildVimPlugin {
        pname = "vim-plugin-install-phase-test";
        version = "0";
        src = pkgs.runCommand "vim-plugin-install-phase-test-src" { } ''
          mkdir -p $out/plugin $out/extra
          touch $out/plugin/probe.vim $out/extra/unwanted
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r plugin $out/
          runHook postInstall
        '';
      };
    in
    pkgs.runCommand "vim-plugin-install-phase-test" { } ''
      test -f ${plugin}/plugin/probe.vim
      test ! -e ${plugin}/extra
      mkdir -p "$out"
    '';
}

{stdenv, vimPlugins, vim_configurable, buildEnv, writeText, writeScriptBin}:

  /* usage example::
     let vimrcConfig = {

       # If you like pathogen use such
       pathogen.knownPlugins = vimPlugins; # optional
       pathogen.pluginNames = ["vim-addon-nix"];

       # If you like VAM use such:
       vam.knownPlugins = vimPlugins; # optional
       vam.pluginDictionaries = [
         # load always
         { name = "youcompleteme"; }
         { names = ["youcompleteme" "foo"]; }
         # only load when opening a .php file
         { name = "phpCompletion"; ft_regex = "^php\$"; }
         { name = "phpCompletion"; filename_regex = "^.php\$"; }

         # provide plugin which can be loaded manually:
         { name = "phpCompletion"; tag = "lazy"; }
       ];

       # if you like NeoBundle or Vundle provide an implementation

       # add custom .vimrc lines like this:
       customRC = ''
         set hidden
       '';
     };
     in vim_configurable.customize { name = "vim-with-plugins"; inherit vimrcConfig; };

  */

let
  inherit (stdenv) lib;

  findDependenciesRecursively = {knownPlugins, names}:

    let depsOf = name: (builtins.getAttr name knownPlugins).dependencies or [];

        recurseNames = path: names: lib.concatMap (name: recurse ([name]++path)) names;

        recurse = path:
          let name = builtins.head path;
          in if builtins.elem name (builtins.tail path)
            then throw "recursive vim dependencies"
            else [name] ++ recurseNames path (depsOf name);

    in lib.uniqList { inputList = recurseNames [] names; };

  vimrcFile = {
    vam ? null,
    pathogen ? null,
    customRC ? ""
  }:

    let
      /* pathogen mostly can set &rtp at startup time. Its used very commonly.
      */
      pathogenImpl = lib.optionalString (pathogen != null)
      (let
        knownPlugins = pathogen.knownPlugins or vimPlugins;

        plugins = map (name: knownPlugins.${name}) (findDependenciesRecursively { inherit knownPlugins; names = pathogen.pluginNames; });

        pluginsEnv = buildEnv {
          name = "pathogen-plugin-env";
          paths = map (x: "${x}/${vimPlugins.rtpPath}") plugins;
        };
      in
      ''
        let &rtp.=(empty(&rtp)?"":',')."${vimPlugins.pathogen.rtp}"
        execute pathogen#infect('${pluginsEnv}/{}')
      '');

      /*
       vim-addon-manager = VAM

       * maps names to plugin location

       * manipulates &rtp at startup time
         or when Vim has been running for a while

       * can activate plugins laziy (eg when loading a specific filetype)

       * knows about vim plugin dependencies (addon-info.json files)

       * still is minimalistic (only loads one file), the "check out" code it also
         has only gets loaded when a plugin is requested which is not found on disk
         yet

      */
      vamImpl = lib.optionalString (vam != null)
      (let
        knownPlugins = vam.knownPlugins or vimPlugins;

        toNames = x:
            if builtins.isString x then [x]
            else (lib.optional (x ? name) x.name)
                  ++ (x.names or []);

        names = findDependenciesRecursively { inherit knownPlugins; names = lib.concatMap toNames vam.pluginDictionaries; };

        # Vim almost reads JSON, so eventually JSON support should be added to Nix
        # TODO: proper quoting
        toNix = x:
          if (builtins.isString x) then "'${x}'"
          else if builtins.isAttrs x && builtins ? out then toNix "${x}" # a derivation
          else if builtins.isAttrs x then "{${lib.concatStringsSep ", " (lib.mapAttrsToList (n: v: "${toNix n}: ${toNix v}") x)}}"
          else if builtins.isList x then "[${lib.concatMapStringsSep ", " toNix x}]"
          else throw "turning ${lib.showVal x} into a VimL thing not implemented yet";

      in assert builtins.hasAttr "vim-addon-manager" knownPlugins;
      ''
        let g:nix_plugin_locations = {}
        ${lib.concatMapStrings (name: ''
          let g:nix_plugin_locations['${name}'] = "${knownPlugins.${name}.rtp}"
        '') names}
        let g:nix_plugin_locations['vim-addon-manager'] = "${vimPlugins."vim-addon-manager".rtp}"

        let g:vim_addon_manager = {}

        if exists('g:nix_plugin_locations')
          " nix managed config

          " override default function making VAM aware of plugin locations:
          fun! NixPluginLocation(name)
            let path = get(g:nix_plugin_locations, a:name, "")
            return path == "" ? vam#DefaultPluginDirFromName(a:name) : path
          endfun
          let g:vim_addon_manager.plugin_dir_by_name = 'NixPluginLocation'
          " tell Vim about VAM:
          let &rtp.=(empty(&rtp)?"":','). g:nix_plugin_locations['vim-addon-manager']
        else
          " standalone config

          let &rtp.=(empty(&rtp)?"":',').c.plugin_root_dir.'/vim-addon-manager'
          if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
            " checkout VAM
            execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
                \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
          endif
        endif

        " tell vam about which plugins to load when:
        let l = []
        ${lib.concatMapStrings (p: "call add(l, ${toNix p})\n") vam.pluginDictionaries}
        call vam#Scripts(l, {})
      '');

      # somebody else could provide these implementations
      vundleImpl = "";

      neobundleImpl = "";


  in writeText "vimrc" ''
  " minimal setup, generated by NIX
  set nocompatible
  filetype indent plugin on | syn on

  ${vamImpl}
  ${pathogenImpl}
  ${vundleImpl}
  ${neobundleImpl}

  ${customRC}
  '';

in

rec {
  inherit vimrcFile;

  # shell script with custom name passing [-u vimrc] [-U gvimrc] to vim
  vimWithRC = {vimExecutable, name ? null, vimrcFile ? null, gvimrcFile ? null}:
    let rcOption = o: file: stdenv.lib.optionalString (file != null) "-${o} ${file}";
    in writeScriptBin (if name == null then "vim" else name) ''
      #!/bin/sh
      exec ${vimExecutable} ${rcOption "u" vimrcFile} ${rcOption "U" gvimrcFile} "$@"
      '';

  # add a customize option to a vim derivation
  makeCustomizable = vim: vim // {
    customize = {name, vimrcConfig}: vimWithRC {
      vimExecutable = "${vim}/bin/vim";
      inherit name;
      vimrcFile = vimrcFile vimrcConfig;
    };
  };

  # test cases:
  test_vim_with_vim_addon_nix_using_vam = vim_configurable.customize {
    name = "vim-with-vim-addon-nix-using-vam";
    vimrcConfig.vam.pluginDictionaries = [{name = "vim-addon-nix"; }];
  };

  test_vim_with_vim_addon_nix_using_pathogen = vim_configurable.customize {
    name = "vim-with-vim-addon-nix-using-pathogen";
    vimrcConfig.pathogen.pluginNames = [ "vim-addon-nix" ];
  };
}

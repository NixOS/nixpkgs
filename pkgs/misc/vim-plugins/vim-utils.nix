{stdenv, vim, vimPlugins, vim_configurable, buildEnv, writeText, writeScriptBin
, nix-prefetch-hg, nix-prefetch-git }:

/*

USAGE EXAMPLE
=============

Install Vim like this eg using nixos option environment.systemPackages which will provide
vim-with-plugins in PATH:

  vim_configurable.customize {
    name = "vim-with-plugins";

    # add custom .vimrc lines like this:
    vimrcConfig.customRC = ''
      set hidden
    '';

    # store your plugins in Vim packages
    vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
      # loaded on launch
      start = [ youcompleteme fugitive ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [ phpCompletion elm-vim ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
    };

    # plugins can also be managed by VAM
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins; # optional
    vimrcConfig.vam.pluginDictionaries = [
      # load always
      { name = "youcompleteme"; }
      { names = ["youcompleteme" "foo"]; }

      # only load when opening a .php file
      { name = "phpCompletion"; ft_regex = "^php\$"; }
      { name = "phpCompletion"; filename_regex = "^.php\$"; }

      # provide plugin which can be loaded manually:
      { name = "phpCompletion"; tag = "lazy"; }

      # full documentation at github.com/MarcWeber/vim-addon-manager
    ];

    # there is a pathogen implementation as well, but its startup is slower and [VAM] has more feature
    # vimrcConfig.pathogen.knownPlugins = vimPlugins; # optional
    # vimrcConfig.pathogen.pluginNames = ["vim-addon-nix"];
  };

WHAT IS A VIM PLUGIN?
=====================
Typical plugin files:

  plugin/P1.vim
  autoload/P1.vim
  ftplugin/xyz.vim
  doc/plugin-documentation.txt (traditional documentation)
  README(.md) (nowadays thanks to github)


Vim offers the :h rtp setting which works for most plugins. Thus adding
this to your .vimrc should make most plugins work:

  set rtp+=~/.nix-profile/share/vim-plugins/youcompleteme
  " or for p in ["youcompleteme"] | exec 'set rtp+=~/.nix-profile/share/vim-plugins/'.p | endfor

which is what the [VAM]/pathogen solutions above basically do.

Learn about about plugin Vim plugin mm managers at
http://vim-wiki.mawercer.de/wiki/topic/vim%20plugin%20managment.html.

The documentation can be accessed by Vim's :help command if it was tagged.
See vimHelpTags sample code below.

CONTRIBUTING AND CUSTOMIZING
============================
The example file pkgs/misc/vim-plugins/default.nix provides both:
* manually mantained plugins
* plugins created by VAM's nix#ExportPluginsForNix implementation

I highly recommend to lookup vim plugin attribute names at the [vim-pi] project
 which is a database containing all plugins from
vim.org and quite a lot of found at github and similar sources. vim-pi's documented purpose
is to associate vim.org script ids to human readable names so that dependencies
can be describe easily.

How to find a name?
  * http://vam.mawercer.de/ or VAM's
  * grep vim-pi
  * use VAM's completion or :AddonsInfo command

It might happen than a plugin is not known by vim-pi yet. We encourage you to
contribute to vim-pi so that plugins can be updated automatically.


CREATING DERVITATIONS AUTOMATICALLY BY PLUGIN NAME
==================================================
Most convenient is to use a ~/.vim-scripts file putting a plugin name into each line
as documented by [VAM]'s README.md
It is the same format you pass to vimrcConfig.vam.pluginDictionaries from the
usage example above.

Then create a temp vim file and insert:

  let opts = {}
  let opts.path_to_nixpkgs = '/etc/nixos/nixpkgs'
  let opts.cache_file = '/tmp/export-vim-plugin-for-nix-cache-file'
  let opts.plugin_dictionaries = map(readfile("vim-plugins"), 'eval(v:val)')
  " add more files
  " let opts.plugin_dictionaries += map(.. other file )
  call nix#ExportPluginsForNix(opts)

Then ":source %" it.

nix#ExportPluginsForNix is provided by ./vim2nix

A buffer will open containing the plugin derivation lines as well list
fitting the vimrcConfig.vam.pluginDictionaries option.

Thus the most simple usage would be:

  vim_with_plugins =
    let vim = vim_configurable;
        inherit (vimUtil.override {inherit vim}) rtpPath addRtp buildVimPlugin vimHelpTags;
        vimPlugins = [
          # the derivation list from the buffer created by nix#ExportPluginsForNix
          # don't set which will default to pkgs.vimPlugins
        ];
    in vim.customize {
      name = "vim-with-plugins";

      vimrcConfig.customRC = '' .. '';

      vimrcConfig.vam.knownPlugins = vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
          # the plugin list form ~/.vim-scripts turned into nix format added to
          # the buffer created by the nix#ExportPluginsForNix
      ];
    }

vim_with_plugins can be installed like any other application within Nix.

[VAM]    https://github.com/MarcWeber/vim-addon-manager
[vim-pi] https://bitbucket.org/vimcommunity/vim-pi
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
    packages ? null,
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
        let g:nix_plugin_locations['vim-addon-manager'] = "${knownPlugins."vim-addon-manager".rtp}"

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
            execute '!git clone --depth=1 https://github.com/MarcWeber/vim-addon-manager '
                \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
          endif
        endif

        " tell vam about which plugins to load when:
        let l = []
        ${lib.concatMapStrings (p: "call add(l, ${toNix p})\n") vam.pluginDictionaries}
        call vam#Scripts(l, {})
      '');

      nativeImpl = lib.optionalString (packages != null)
      (let
        link = (packageName: dir: pluginPath: "ln -sf ${pluginPath}/share/vim-plugins/* $out/pack/${packageName}/${dir}");
        packageLinks = (packageName: {start ? [], opt ? []}:
          ["mkdir -p $out/pack/${packageName}/start"]
          ++ (builtins.map (link packageName "start") start)
          ++ ["mkdir -p $out/pack/${packageName}/opt"]
          ++ (builtins.map (link packageName "opt") opt)
        );
        packDir = (packages:
          stdenv.mkDerivation rec {
            name = "vim-pack-dir";
            src = ./.;
            installPhase = lib.concatStringsSep
                             "\n"
                             (lib.flatten (lib.mapAttrsToList packageLinks packages));
          }
        );
      in
      ''
        set packpath-=~/.vim/after
        set packpath+=${packDir packages}
        set packpath+=~/.vim/after
      '');

      # somebody else could provide these implementations
      vundleImpl = "";

      neobundleImpl = "";


  in writeText "vimrc" ''
  " minimal setup, generated by NIX
  set nocompatible

  ${vamImpl}
  ${pathogenImpl}
  ${vundleImpl}
  ${neobundleImpl}
  ${nativeImpl}

  filetype indent plugin on | syn on

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

  pluginnames2Nix = {name, namefiles} : vim_configurable.customize {
    inherit name;
    vimrcConfig.vam.knownPlugins = vimPlugins;
    vimrcConfig.vam.pluginDictionaries = ["vim2nix"];
    vimrcConfig.customRC = ''
      " Yes - this is impure and will create the cache file and checkout vim-pi
      " into ~/.vim/vim-addons
      let g:vim_addon_manager.plugin_root_dir = "/tmp/vim2nix-".$USER
      if !isdirectory(g:vim_addon_manager.plugin_root_dir)
        call mkdir(g:vim_addon_manager.plugin_root_dir)
      else
        echom repeat("=", 80)
        echom "WARNING: reusing cache directory :".g:vim_addon_manager.plugin_root_dir
        echom repeat("=", 80)
      endif
      let opts = {}
      let opts.nix_prefetch_git = "${nix-prefetch-git}/bin/nix-prefetch-git"
      let opts.nix_prefetch_hg  = "${nix-prefetch-hg}/bin/nix-prefetch-hg"
      let opts.cache_file = g:vim_addon_manager.plugin_root_dir.'/cache'
      let opts.plugin_dictionaries = []
      ${lib.concatMapStrings (file: "let opts.plugin_dictionaries += map(readfile(\"${file}\"), 'eval(v:val)')\n") namefiles }

      " uncomment for debugging failures
      " let opts.try_catch = 0

      " add more files
      " let opts.plugin_dictionaries += map(.. other file )
      call nix#ExportPluginsForNix(opts)
    '';
  };

  rtpPath = "share/vim-plugins";

  vimHelpTags = ''
  vimHelpTags(){
    if [ -d "$1/doc" ]; then
      ${vim}/bin/vim -N -u NONE -i NONE -n -E -s -c "helptags $1/doc" +quit! || echo "docs to build failed"
    fi
  }
  '';

  addRtp = path: derivation:
    derivation // { rtp = "${derivation}/${path}"; };

  buildVimPlugin = a@{
    name,
    namePrefix ? "vimplugin-",
    src,
    unpackPhase ? "",
    configurePhase ? "",
    buildPhase ? "",
    path ? (builtins.parseDrvName name).name,
    addonInfo ? null,
    ...
  }:
    addRtp "${rtpPath}/${path}" (stdenv.mkDerivation (a // {
      name = namePrefix + name;

      inherit unpackPhase configurePhase buildPhase addonInfo;

      installPhase = ''
        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target
        ${vimHelpTags}
        vimHelpTags $target
        if [ -n "$addonInfo" ]; then
          echo "$addonInfo" > $target/addon-info.json
        fi
      '';
    }));

  vim_with_vim2nix = vim_configurable.customize { name = "vim"; vimrcConfig.vam.pluginDictionaries = [ "vim-addon-vim2nix" ]; };

  buildVimPluginFrom2Nix = a: buildVimPlugin ({
    buildPhase = ":";
    configurePhase =":";
  } // a);

  # test cases:
  test_vim_with_vim_addon_nix_using_vam = vim_configurable.customize {
   name = "vim-with-vim-addon-nix-using-vam";
    vimrcConfig.vam.pluginDictionaries = [{name = "vim-addon-nix"; }];
  };

  test_vim_with_vim_addon_nix_using_pathogen = vim_configurable.customize {
    name = "vim-with-vim-addon-nix-using-pathogen";
    vimrcConfig.pathogen.pluginNames = [ "vim-addon-nix" ];
  };

  test_vim_with_vim_addon_nix = vim_configurable.customize {
    name = "vim-with-vim-addon-nix";
    vimrcConfig.packages.myVimPackage.start = with vimPlugins; [ vim-addon-nix ];
  };

}

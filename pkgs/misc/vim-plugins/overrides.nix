{ lib
, stdenv

  # nixpkgs functions
, buildGoModule
, buildVimPluginFrom2Nix
, fetchFromGitHub
, fetchpatch
, fetchurl
, substituteAll

  # Language dependencies
, python
, python3
, rustPlatform

  # Misc dependencies
, Cocoa
, code-minimap
, dasht
, direnv
, fzf
, gnome
, khard
, languagetool
, llvmPackages
, meson
, nim
, nodePackages
, skim
, sqlite
, stylish-haskell
, tabnine
, vim
, which
, xkb-switch
, ycmd

  # command-t dependencies
, rake
, ruby

  # cpsm dependencies
, boost
, cmake
, icu
, ncurses

  # LanguageClient-neovim dependencies
, CoreFoundation
, CoreServices

# nvim-treesitter dependencies
, tree-sitter

  # sved dependencies
, glib
, gobject-introspection
, wrapGAppsHook

  # vim-clap dependencies
, curl
, libgit2
, libiconv
, openssl
, pkg-config

# vim-go dependencies
, asmfmt
, delve
, errcheck
, gnused
, go-motion
, go-tools
, gocode
, gocode-gomod
, godef
, gogetdoc
, golangci-lint
, golint
, gomodifytags
, gopls
, gotags
, gotools
, iferr
, impl
, reftools
}:

self: super: {

  clang_complete = super.clang_complete.overrideAttrs (old: {
    # In addition to the arguments you pass to your compiler, you also need to
    # specify the path of the C++ std header (if you are using C++).
    # These usually implicitly set by cc-wrapper around clang (pkgs/build-support/cc-wrapper).
    # The linked ruby code shows generates the required '.clang_complete' for cmake based projects
    # https://gist.github.com/Mic92/135e83803ed29162817fce4098dec144
    preFixup = ''
      substituteInPlace "$out"/share/vim-plugins/clang_complete/plugin/clang_complete.vim \
        --replace "let g:clang_library_path = '' + "''" + ''" "let g:clang_library_path='${llvmPackages.libclang.lib}/lib/libclang.so'"

      substituteInPlace "$out"/share/vim-plugins/clang_complete/plugin/libclang.py \
        --replace "/usr/lib/clang" "${llvmPackages.clang.cc}/lib/clang"
    '';
  });

  clighter8 = super.clighter8.overrideAttrs (old: {
    preFixup = ''
      sed "/^let g:clighter8_libclang_path/s|')$|${llvmPackages.clang.cc.lib}/lib/libclang.so')|" \
        -i "$out"/share/vim-plugins/clighter8/plugin/clighter8.vim
    '';
  });

  command-t = super.command-t.overrideAttrs (old: {
    buildInputs = [ ruby rake ];
    buildPhase = ''
      rake make
      rm ruby/command-t/ext/command-t/*.o
    '';
  });

  compe-tabnine = super.compe-tabnine.overrideAttrs (old: {
    buildInputs = [ tabnine ];

    postFixup = ''
      mkdir $target/binaries
      ln -s ${tabnine}/bin/TabNine $target/binaries/TabNine_$(uname -s)
    '';
  });

  completion-buffers = super.completion-buffers.overrideAttrs (old: {
    dependencies = with self; [ completion-nvim ];
  });

  completion-tabnine = super.completion-tabnine.overrideAttrs (old: {
    dependencies = with self; [ completion-nvim ];
    buildInputs = [ tabnine ];
    postFixup = ''
      mkdir $target/binaries
      ln -s ${tabnine}/bin/TabNine $target/binaries/TabNine_$(uname -s)
    '';
  });

  completion-treesitter = super.completion-treesitter.overrideAttrs (old: {
    dependencies = with self; [ completion-nvim nvim-treesitter ];
  });

  cpsm = super.cpsm.overrideAttrs (old: {
    buildInputs = [
      python3
      stdenv
      cmake
      boost
      icu
      ncurses
    ];
    buildPhase = ''
      patchShebangs .
      export PY3=ON
      ./install.sh
    '';
  });

  ctrlp-cmatcher = super.ctrlp-cmatcher.overrideAttrs (old: {
    buildInputs = [ python ];
    buildPhase = ''
      patchShebangs .
      ./install.sh
    '';
  });

  defx-nvim = super.defx-nvim.overrideAttrs (old: {
    dependencies = with self; [ nvim-yarp ];
  });

  deoplete-fish = super.deoplete-fish.overrideAttrs (old: {
    dependencies = with self; [ deoplete-nvim vim-fish ];
  });

  deoplete-go = super.deoplete-go.overrideAttrs (old: {
    buildInputs = [ python3 ];
    buildPhase = ''
      pushd ./rplugin/python3/deoplete/ujson
      python3 setup.py build --build-base=$PWD/build --build-lib=$PWD/build
      popd
      find ./rplugin/ -name "ujson*.so" -exec mv -v {} ./rplugin/python3/ \;
    '';
  });

  deoplete-khard = super.deoplete-khard.overrideAttrs (old: {
    dependencies = with self; [ deoplete-nvim ];
    passthru.python3Dependencies = ps: [ (ps.toPythonModule khard) ];
    meta = {
      description = "Address-completion for khard via deoplete";
      homepage = "https://github.com/nicoe/deoplete-khard";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ jorsn ];
    };
  });

  direnv-vim = super.direnv-vim.overrideAttrs (oa: {
    preFixup = oa.preFixup or "" + ''
      substituteInPlace $out/share/vim-plugins/direnv-vim/autoload/direnv.vim \
        --replace "let s:direnv_cmd = get(g:, 'direnv_cmd', 'direnv')" \
          "let s:direnv_cmd = get(g:, 'direnv_cmd', '${lib.getBin direnv}/bin/direnv')"
    '';
  });

  ensime-vim = super.ensime-vim.overrideAttrs (old: {
    passthru.python3Dependencies = ps: with ps; [ sexpdata websocket_client ];
    dependencies = with self; [ vimproc-vim vimshell-vim self.self forms ];
  });

  forms = super.forms.overrideAttrs (old: {
    dependencies = with self; [ self.self ];
  });

  fruzzy =
    let
      # until https://github.com/NixOS/nixpkgs/pull/67878 is merged, there's no better way to install nim libraries with nix
      nimpy = fetchFromGitHub {
        owner = "yglukhov";
        repo = "nimpy";
        rev = "4840d1e438985af759ddf0923e7a9250fd8ea0da";
        sha256 = "0qqklvaajjqnlqm3rkk36pwwnn7x942mbca7nf2cvryh36yg4q5k";
      };
      binaryheap = fetchFromGitHub {
        owner = "bluenote10";
        repo = "nim-heap";
        rev = "c38039309cb11391112571aa332df9c55f625b54";
        sha256 = "05xdy13vm5n8dw2i366ppbznc4cfhq23rdcklisbaklz2jhdx352";
      };
    in
    super.fruzzy.overrideAttrs (old: {
      buildInputs = [ nim ];
      patches = [
        (substituteAll {
          src = ./patches/fruzzy/get_version.patch;
          version = old.version;
        })
      ];
      configurePhase = ''
        substituteInPlace Makefile \
          --replace \
            "nim c" \
            "nim c --nimcache:$TMP --path:${nimpy} --path:${binaryheap}"
      '';
      buildPhase = ''
        make build
      '';
    });

  fzf-vim = super.fzf-vim.overrideAttrs (old: {
    dependencies = with self; [ fzfWrapper ];
  });

  # Mainly used as a dependency for fzf-vim. Wraps the fzf program as a vim
  # plugin, since part of the fzf vim plugin is included in the main fzf
  # program.
  fzfWrapper = buildVimPluginFrom2Nix {
    inherit (fzf) src version;
    pname = "fzf";
    postInstall = ''
      ln -s ${fzf}/bin/fzf $target/bin/fzf
    '';
  };

  ghcid = super.ghcid.overrideAttrs (old: {
    configurePhase = "cd plugins/nvim";
  });

  gitsigns-nvim = super.gitsigns-nvim.overrideAttrs (old: {
    dependencies = with self; [ plenary-nvim ];
  });

  gruvbox-nvim = super.gruvbox-nvim.overrideAttrs (old: {
    dependencies = with self; [ lush-nvim ];
  });

  jedi-vim = super.jedi-vim.overrideAttrs (old: {
    # checking for python3 support in vim would be neat, too, but nobody else seems to care
    buildInputs = [ python3.pkgs.jedi ];
    meta = {
      description = "code-completion for python using python-jedi";
      license = lib.licenses.mit;
    };
  });

  LanguageClient-neovim =
    let
      version = "0.1.161";
      LanguageClient-neovim-src = fetchFromGitHub {
        owner = "autozimu";
        repo = "LanguageClient-neovim";
        rev = version;
        sha256 = "Z9S2ie9RxJCIbmjSV/Tto4lK04cZfWmK3IAy8YaySVI=";
      };
      LanguageClient-neovim-bin = rustPlatform.buildRustPackage {
        pname = "LanguageClient-neovim-bin";
        inherit version;
        src = LanguageClient-neovim-src;

        cargoSha256 = "H34UqJ6JOwuSABdOup5yKeIwFrGc83TUnw1ggJEx9o4=";
        buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

        # FIXME: Use impure version of CoreFoundation because of missing symbols.
        #   Undefined symbols for architecture x86_64: "_CFURLResourceIsReachable"
        preConfigure = lib.optionalString stdenv.isDarwin ''
          export NIX_LDFLAGS="-F${CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS"
        '';
      };
    in
    buildVimPluginFrom2Nix {
      pname = "LanguageClient-neovim";
      inherit version;
      src = LanguageClient-neovim-src;

      propagatedBuildInputs = [ LanguageClient-neovim-bin ];

      preFixup = ''
        substituteInPlace "$out"/share/vim-plugins/LanguageClient-neovim/autoload/LanguageClient.vim \
          --replace "let l:path = s:root . '/bin/'" "let l:path = '${LanguageClient-neovim-bin}' . '/bin/'"
      '';
    };

  lens-vim = super.lens-vim.overrideAttrs (old: {
    # remove duplicate g:lens#animate in doc/lens.txt
    # https://github.com/NixOS/nixpkgs/pull/105810#issuecomment-740007985
    # https://github.com/camspiers/lens.vim/pull/40/files
    patches = [
      (substituteAll {
        src = ./patches/lens-vim/remove_duplicate_g_lens_animate.patch;
        inherit languagetool;
      })
    ];
  });

  lf-vim = super.lf-vim.overrideAttrs (old: {
    dependencies = with self; [ vim-floaterm ];
  });

  meson = buildVimPluginFrom2Nix {
    inherit (meson) pname version src;
    preInstall = "cd data/syntax-highlighting/vim";
    meta.maintainers = with lib.maintainers; [ vcunat ];
  };

  minimap-vim = super.minimap-vim.overrideAttrs (old: {
    preFixup = ''
      substituteInPlace $out/share/vim-plugins/minimap-vim/plugin/minimap.vim \
        --replace "code-minimap" "${code-minimap}/bin/code-minimap"
      substituteInPlace $out/share/vim-plugins/minimap-vim/bin/minimap_generator.sh \
        --replace "code-minimap" "${code-minimap}/bin/code-minimap"
    '';
  });

  ncm2 = super.ncm2.overrideAttrs (old: {
    dependencies = with self; [ nvim-yarp ];
  });

  ncm2-jedi = super.ncm2-jedi.overrideAttrs (old: {
    dependencies = with self; [ nvim-yarp ncm2 ];
    passthru.python3Dependencies = ps: with ps; [ jedi ];
  });

  ncm2-neoinclude = super.ncm2-neoinclude.overrideAttrs (old: {
    dependencies = with self; [ neoinclude-vim ];
  });

  ncm2-neosnippet = super.ncm2-neosnippet.overrideAttrs (old: {
    dependencies = with self; [ neosnippet-vim ];
  });

  ncm2-syntax = super.ncm2-syntax.overrideAttrs (old: {
    dependencies = with self; [ neco-syntax ];
  });

  ncm2-ultisnips = super.ncm2-ultisnips.overrideAttrs (old: {
    dependencies = with self; [ ultisnips ];
  });

  nvim-lsputils = super.nvim-lsputils.overrideAttrs (old: {
    dependencies = with self; [ popfix ];
  });

  # Usage:
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.tree-sitter-c p.tree-sitter-java ... ])
  # or for all grammars:
  # pkgs.vimPlugins.nvim-treesitter.withPlugins (_: tree-sitter.allGrammars)
  nvim-treesitter = super.nvim-treesitter.overrideAttrs (old: {
    passthru.withPlugins =
      grammarFn: self.nvim-treesitter.overrideAttrs (_: {
        postPatch =
          let
            grammars = tree-sitter.withPlugins grammarFn;
          in
          ''
            rm -r parser
            ln -s ${grammars} parser
          '';
      });
  });

  onehalf = super.onehalf.overrideAttrs (old: {
    configurePhase = "cd vim";
  });

  skim = buildVimPluginFrom2Nix {
    pname = "skim";
    version = skim.version;
    src = skim.vim;
  };

  skim-vim = super.skim-vim.overrideAttrs (old: {
    dependencies = with self; [ skim ];
  });

  sql-nvim = super.sql-nvim.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace lua/sql/defs.lua \
        --replace "vim.g.sql_clib_path or" "vim.g.sql_clib_path or '${sqlite.out}/lib/libsqlite3.so' or"
    '';
  });

  sved =
    let
      # we put the script in its own derivation to benefit the magic of wrapGAppsHook
      svedbackend = stdenv.mkDerivation {
        name = "svedbackend-${super.sved.name}";
        inherit (super.sved) src;
        nativeBuildInputs = [ wrapGAppsHook ];
        buildInputs = [
          gobject-introspection
          glib
          (python3.withPackages (ps: with ps; [ pygobject3 pynvim dbus-python ]))
        ];
        preferLocalBuild = true;
        installPhase = ''
          install -Dt $out/bin ftplugin/evinceSync.py
        '';
      };
    in
    super.sved.overrideAttrs (old: {
      preferLocalBuild = true;
      postPatch = ''
        rm ftplugin/evinceSync.py
        ln -s ${svedbackend}/bin/evinceSync.py ftplugin/evinceSync.py
      '';
      meta = {
        description = "synctex support between vim/neovim and evince";
      };
    });

  telescope-frecency-nvim = super.telescope-frecency-nvim.overrideAttrs (old: {
    dependencies = with self; [ sql-nvim telescope-nvim ];
  });

  telescope-fzf-writer-nvim = super.telescope-fzf-writer-nvim.overrideAttrs (old: {
    dependencies = with self; [ telescope-nvim ];
  });

  telescope-fzy-native-nvim = super.telescope-fzy-native-nvim.overrideAttrs (old: {
    dependencies = with self; [ telescope-nvim ];
    preFixup =
      let
        fzy-lua-native-path = "deps/fzy-lua-native";
        fzy-lua-native =
          stdenv.mkDerivation {
            name = "fzy-lua-native";
            src = "${old.src}/${fzy-lua-native-path}";
            # remove pre-compiled binaries
            preBuild = "rm -rf static/*";
            installPhase = ''
              install -Dm 444 -t $out/static static/*
              install -Dm 444 -t $out/lua lua/*
            '';
          };
      in
      ''
        rm -rf $target/${fzy-lua-native-path}/*
        ln -s ${fzy-lua-native}/static $target/${fzy-lua-native-path}/static
        ln -s ${fzy-lua-native}/lua $target/${fzy-lua-native-path}/lua
      '';
    meta.platforms = lib.platforms.all;
  });

  telescope-nvim = super.telescope-nvim.overrideAttrs (old: {
    dependencies = with self; [ plenary-nvim popup-nvim ];
  });

  telescope-symbols-nvim = super.telescope-symbols-nvim.overrideAttrs (old: {
    dependencies = with self; [ telescope-nvim ];
  });

  telescope-z-nvim = super.telescope-z-nvim.overrideAttrs (old: {
    dependencies = with self; [ telescope-nvim ];
  });

  unicode-vim =
    let
      unicode-data = fetchurl {
        url = "http://www.unicode.org/Public/UNIDATA/UnicodeData.txt";
        sha256 = "16b0jzvvzarnlxdvs2izd5ia0ipbd87md143dc6lv6xpdqcs75s9";
      };
    in
    super.unicode-vim.overrideAttrs (old: {

      # redirect to /dev/null else changes terminal color
      buildPhase = ''
        cp "${unicode-data}" autoload/unicode/UnicodeData.txt
        echo "Building unicode cache"
        ${vim}/bin/vim --cmd ":set rtp^=$PWD" -c 'ru plugin/unicode.vim' -c 'UnicodeCache' -c ':echohl Normal' -c ':q' > /dev/null
      '';
    });

  vCoolor-vim = super.vCoolor-vim.overrideAttrs (old: {
    # on linux can use either Zenity or Yad.
    propagatedBuildInputs = [ gnome.zenity ];
    meta = {
      description = "Simple color selector/picker plugin";
      license = lib.licenses.publicDomain;
    };
  });

  vim-addon-actions = super.vim-addon-actions.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  });

  vim-addon-async = super.vim-addon-async.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-signs ];
  });

  vim-addon-background-cmd = super.vim-addon-background-cmd.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-mw-utils ];
  });

  vim-addon-completion = super.vim-addon-completion.overrideAttrs (old: {
    dependencies = with self; [ tlib_vim ];
  });

  vim-addon-goto-thing-at-cursor = super.vim-addon-goto-thing-at-cursor.overrideAttrs (old: {
    dependencies = with self; [ tlib_vim ];
  });

  vim-addon-manager = super.vim-addon-manager.overrideAttrs (old: {
    buildInputs = lib.optional stdenv.isDarwin Cocoa;
  });

  vim-addon-mru = super.vim-addon-mru.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-other vim-addon-mw-utils ];
  });

  vim-addon-nix = super.vim-addon-nix.overrideAttrs (old: {
    dependencies = with self; [
      vim-addon-completion
      vim-addon-goto-thing-at-cursor
      vim-addon-errorformats
      vim-addon-actions
      vim-addon-mw-utils
      tlib_vim
    ];
  });

  vim-addon-sql = super.vim-addon-sql.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-completion vim-addon-background-cmd tlib_vim ];
  });

  vim-addon-syntax-checker = super.vim-addon-syntax-checker.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  });

  vim-addon-toggle-buffer = super.vim-addon-toggle-buffer.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  });

  vim-addon-xdebug = super.vim-addon-xdebug.overrideAttrs (old: {
    dependencies = with self; [ webapi-vim vim-addon-mw-utils vim-addon-signs vim-addon-async ];
  });

  vim-bazel = super.vim-bazel.overrideAttrs (old: {
    dependencies = with self; [ vim-maktaba ];
  });

  vim-beancount = super.vim-beancount.overrideAttrs (old: {
    passthru.python3Dependencies = ps: with ps; [ beancount ];
  });

  vim-clap = super.vim-clap.overrideAttrs (old: {
    preFixup =
      let
        maple-bin = rustPlatform.buildRustPackage {
          name = "maple";
          src = old.src;

          nativeBuildInputs = [
            pkg-config
          ];

          buildInputs = [
            openssl
          ] ++ lib.optionals stdenv.isDarwin [
            CoreServices
            curl
            libgit2
            libiconv
          ];

          cargoSha256 = "16fhiv6qmf7dv968jyybkgs1wkphy383s78g8w5wnz4i0czld8dq";
        };
      in
      ''
        ln -s ${maple-bin}/bin/maple $target/bin/maple
      '';

    meta.platforms = lib.platforms.all;
  });

  vim-codefmt = super.vim-codefmt.overrideAttrs (old: {
    dependencies = with self; [ vim-maktaba ];
  });

  vim-dasht = super.vim-dasht.overrideAttrs (old: {
    preFixup = ''
      substituteInPlace $out/share/vim-plugins/vim-dasht/autoload/dasht.vim \
        --replace "['dasht']" "['${dasht}/bin/dasht']"
    '';
  });

  vim-easytags = super.vim-easytags.overrideAttrs (old: {
    dependencies = with self; [ vim-misc ];
    patches = [
      (fetchpatch {
        # https://github.com/xolox/vim-easytags/pull/170 fix version detection for universal-ctags
        url = "https://github.com/xolox/vim-easytags/commit/46e4709500ba3b8e6cf3e90aeb95736b19e49be9.patch";
        sha256 = "0x0xabb56xkgdqrg1mpvhbi3yw4d829n73lsnnyj5yrxjffy4ax4";
      })
    ];
  });

  # change the go_bin_path to point to a path in the nix store. See the code in
  # fatih/vim-go here
  # https://github.com/fatih/vim-go/blob/155836d47052ea9c9bac81ba3e937f6f22c8e384/autoload/go/path.vim#L154-L159
  vim-go = super.vim-go.overrideAttrs (old:
    let
      binPath = lib.makeBinPath [
        asmfmt
        delve
        errcheck
        go-motion
        go-tools
        gocode
        gocode-gomod
        godef
        gogetdoc
        golint
        golangci-lint
        gomodifytags
        gopls
        gotags
        gotools
        iferr
        impl
        reftools
      ];
    in
    {
      postPatch = ''
        ${gnused}/bin/sed \
          -Ee 's@"go_bin_path", ""@"go_bin_path", "${binPath}"@g' \
          -i autoload/go/config.vim
      '';
    });

  vim-gist = super.vim-gist.overrideAttrs (old: {
    dependencies = with self; [ webapi-vim ];
  });

  vim-grammarous = super.vim-grammarous.overrideAttrs (old: {
    # use `:GrammarousCheck` to initialize checking
    # In neovim, you also want to use set
    #   let g:grammarous#show_first_error = 1
    # see https://github.com/rhysd/vim-grammarous/issues/39
    patches = [
      (substituteAll {
        src = ./patches/vim-grammarous/set_default_languagetool.patch;
        inherit languagetool;
      })
    ];
  });

  vim-hexokinase = super.vim-hexokinase.overrideAttrs (old: {
    preFixup =
      let
        hexokinase = buildGoModule {
          name = "hexokinase";
          src = old.src + "/hexokinase";
          vendorSha256 = "pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
        };
      in
      ''
        ln -s ${hexokinase}/bin/hexokinase $target/hexokinase/hexokinase
      '';

    meta.platforms = lib.platforms.all;
  });

  vim-hier = super.vim-hier.overrideAttrs (old: {
    buildInputs = [ vim ];
  });

  vim-isort = super.vim-isort.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace ftplugin/python_vimisort.vim \
        --replace 'import vim' 'import vim; import sys; sys.path.append("${python.pkgs.isort}/${python.sitePackages}")'
    '';
  });

  vim-markdown-composer =
    let
      vim-markdown-composer-bin = rustPlatform.buildRustPackage rec {
        pname = "vim-markdown-composer-bin";
        inherit (super.vim-markdown-composer) src version;
        cargoSha256 = "1cvnjsw5dd02wrm1q5xi8b033rsn44f7fkmw5j7lhskv5j286zrh";
      };
    in
    super.vim-markdown-composer.overrideAttrs (oldAttrs: rec {
      preFixup = ''
        substituteInPlace "$out"/share/vim-plugins/vim-markdown-composer/after/ftplugin/markdown/composer.vim \
          --replace "let l:args = [s:plugin_root . '/target/release/markdown-composer']" \
          "let l:args = ['${vim-markdown-composer-bin}/bin/markdown-composer']"
      '';
    });

  vim-metamath = super.vim-metamath.overrideAttrs (old: {
    preInstall = "cd vim";
  });

  vim-snipmate = super.vim-snipmate.overrideAttrs (old: {
    dependencies = with self; [ vim-addon-mw-utils tlib_vim ];
  });

  vim-stylish-haskell = super.vim-stylish-haskell.overrideAttrs (old: {
    postPatch = old.postPatch or "" + ''
      substituteInPlace ftplugin/haskell/stylish-haskell.vim --replace \
        'g:stylish_haskell_command = "stylish-haskell"' \
        'g:stylish_haskell_command = "${stylish-haskell}/bin/stylish-haskell"'
    '';
  });

  vim-wakatime = super.vim-wakatime.overrideAttrs (old: {
    buildInputs = [ python ];
  });

  vim-xdebug = super.vim-xdebug.overrideAttrs (old: {
    postInstall = false;
  });

  vim-xkbswitch = super.vim-xkbswitch.overrideAttrs (old: {
    patchPhase = ''
      substituteInPlace plugin/xkbswitch.vim \
        --replace /usr/local/lib/libxkbswitch.so ${xkb-switch}/lib/libxkbswitch.so
    '';
    buildInputs = [ xkb-switch ];
  });

  vim-yapf = super.vim-yapf.overrideAttrs (old: {
    buildPhase = ''
      substituteInPlace ftplugin/python_yapf.vim \
        --replace '"yapf"' '"${python3.pkgs.yapf}/bin/yapf"'
    '';
  });

  vim2nix = buildVimPluginFrom2Nix {
    pname = "vim2nix";
    version = "1.0";
    src = ./vim2nix;
    dependencies = with self; [ vim-addon-manager ];
  };

  vimacs = super.vimacs.overrideAttrs (old: {
    buildPhase = ''
      substituteInPlace bin/vim \
        --replace '/usr/bin/vim' 'vim' \
        --replace '/usr/bin/gvim' 'gvim'
      # remove unnecessary duplicated bin wrapper script
      rm -r plugin/vimacs
    '';
    meta = with lib; {
      description = "Vim-Improved eMACS: Emacs emulation plugin for Vim";
      homepage = "http://algorithm.com.au/code/vimacs";
      license = licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ millerjason ];
    };
  });

  vimsence = super.vimsence.overrideAttrs (old: {
    meta = with lib; {
      description = "Discord rich presence for Vim";
      homepage = "https://github.com/hugolgst/vimsence";
      maintainers = with lib.maintainers; [ hugolgst ];
    };
  });

  vimproc-vim = super.vimproc-vim.overrideAttrs (old: {
    buildInputs = [ which ];

    buildPhase = ''
      substituteInPlace autoload/vimproc.vim \
        --replace vimproc_mac.so vimproc_unix.so \
        --replace vimproc_linux64.so vimproc_unix.so \
        --replace vimproc_linux32.so vimproc_unix.so
      make -f make_unix.mak
    '';
  });

  vimshell-vim = super.vimshell-vim.overrideAttrs (old: {
    dependencies = with self; [ vimproc-vim ];
  });

  YankRing-vim = super.YankRing-vim.overrideAttrs (old: {
    sourceRoot = ".";
  });

  YouCompleteMe = super.YouCompleteMe.overrideAttrs (old: {
    buildPhase = ''
      substituteInPlace plugin/youcompleteme.vim \
        --replace "'ycm_path_to_python_interpreter', '''" \
        "'ycm_path_to_python_interpreter', '${python3}/bin/python3'"

      rm -r third_party/ycmd
      ln -s ${ycmd}/lib/ycmd third_party
    '';

    meta = with lib; {
      description = "A code-completion engine for Vim";
      homepage = "https://github.com/Valloric/YouCompleteMe";
      license = licenses.gpl3;
      maintainers = with maintainers; [ marcweber jagajaga ];
      platforms = platforms.unix;
    };
  });

} // (
  let
    nodePackageNames = [
      "coc-clangd"
      "coc-cmake"
      "coc-css"
      "coc-diagnostic"
      "coc-emmet"
      "coc-eslint"
      "coc-explorer"
      "coc-git"
      "coc-go"
      "coc-highlight"
      "coc-html"
      "coc-imselect"
      "coc-java"
      "coc-jest"
      "coc-json"
      "coc-lists"
      "coc-markdownlint"
      "coc-metals"
      "coc-pairs"
      "coc-prettier"
      "coc-pyright"
      "coc-python"
      "coc-r-lsp"
      "coc-rls"
      "coc-rust-analyzer"
      "coc-smartf"
      "coc-snippets"
      "coc-solargraph"
      "coc-stylelint"
      "coc-tabnine"
      "coc-texlab"
      "coc-tslint"
      "coc-tslint-plugin"
      "coc-tsserver"
      "coc-vetur"
      "coc-vimlsp"
      "coc-vimtex"
      "coc-wxml"
      "coc-yaml"
      "coc-yank"
    ];
    nodePackage2VimPackage = name: buildVimPluginFrom2Nix {
      pname = name;
      inherit (nodePackages.${name}) version meta;
      src = "${nodePackages.${name}}/lib/node_modules/${name}";
    };
  in
  lib.genAttrs nodePackageNames nodePackage2VimPackage
)

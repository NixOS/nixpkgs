{config, lib, stdenv
, python, cmake, vim, vimUtils, ruby
, which, fetchgit, llvmPackages, rustPlatform
, xkb_switch, fzf, skim
, python3, boost, icu, ncurses
, ycmd, rake
, pythonPackages, python3Packages
, substituteAll
, languagetool
, Cocoa, CoreFoundation, CoreServices
, buildVimPluginFrom2Nix
}:

let

  _skim = skim;

in

generated:

with generated;

{

  vim2nix = buildVimPluginFrom2Nix {
    name = "vim2nix";
    src = ./vim2nix;
    dependencies = ["vim-addon-manager"];
  };

  fzfWrapper = buildVimPluginFrom2Nix {
    name = fzf.name;
    src = fzf.src;
    dependencies = [];
  };

  skim = buildVimPluginFrom2Nix {
    name = _skim.name;
    src = _skim.vim;
    dependencies = [];
  };

  LanguageClient-neovim = let
    LanguageClient-neovim-src = fetchgit {
      url = "https://github.com/autozimu/LanguageClient-neovim";
      rev = "59f0299e8f7d7edd0653b5fc005eec74c4bf4aba";
      sha256 = "0x6729w7v3bxlpvm8jz1ybn23qa0zqfgxl88q2j0bbs6rvp0w1jq";
    };
    LanguageClient-neovim-bin = rustPlatform.buildRustPackage {
      name = "LanguageClient-neovim-bin";
      src = LanguageClient-neovim-src;

      cargoSha256 = "1afmz14j7ma2nrsx0njcqbh2wa430dr10hds78c031286ppgwjls";
      buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

      # FIXME: Use impure version of CoreFoundation because of missing symbols.
      #   Undefined symbols for architecture x86_64: "_CFURLResourceIsReachable"
      preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
        export NIX_LDFLAGS="-F${CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS"
      '';
    };
  in buildVimPluginFrom2Nix {
    name = "LanguageClient-neovim-2018-09-07";
    src = LanguageClient-neovim-src;

    dependencies = [];
    propogatedBuildInputs = [ LanguageClient-neovim-bin ];

    preFixup = ''
      substituteInPlace "$out"/share/vim-plugins/LanguageClient-neovim/autoload/LanguageClient.vim \
        --replace "let l:path = s:root . '/bin/'" "let l:path = '${LanguageClient-neovim-bin}' . '/bin/'"
    '';
  };

  # do not auto-update this one, as the name clashes with vim-snippets
  vim-docbk-snippets = buildVimPluginFrom2Nix {
    name = "vim-docbk-snippets-2017-11-02";
    src = fetchgit {
      url = "https://github.com/jhradilek/vim-snippets";
      rev = "69cce66defdf131958f152ea7a7b26c21ca9d009";
      sha256 = "1363b2fmv69axrl2hm74dmx51cqd8k7rk116890qllnapzw1zjgc";
    };
    dependencies = [];
  };

  clang_complete = clang_complete.overrideAttrs(old: {
    # In addition to the arguments you pass to your compiler, you also need to
    # specify the path of the C++ std header (if you are using C++).
    # These usually implicitly set by cc-wrapper around clang (pkgs/build-support/cc-wrapper).
    # The linked ruby code shows generates the required '.clang_complete' for cmake based projects
    # https://gist.github.com/Mic92/135e83803ed29162817fce4098dec144
    # as an alternative you can execute the following command:
    # $ eval echo $(nix-instantiate --eval --expr 'with (import <nixpkgs>) {}; clang.default_cxx_stdlib_compile')
    preFixup = ''
      substituteInPlace "$out"/share/vim-plugins/clang_complete/plugin/clang_complete.vim \
        --replace "let g:clang_library_path = '' + "''" + ''" "let g:clang_library_path='${llvmPackages.clang.cc.lib}/lib/libclang.so'"
    '';
  });

  clighter8 = clighter8.overrideAttrs(old: {
    preFixup = ''
      sed "/^let g:clighter8_libclang_path/s|')$|${llvmPackages.clang.cc}/lib/libclang.so')|" \
        -i "$out"/share/vim-plugins/clighter8/plugin/clighter8.vim
    '';
  });

  command-t = command-t.overrideAttrs(old: {
    buildInputs = [ ruby rake ];
    buildPhase = ''
      rake make
      rm ruby/command-t/ext/command-t/*.o
    '';
  });

  cpsm = cpsm.overrideAttrs(old: {
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

  ctrlp-cmatcher = ctrlp-cmatcher.overrideAttrs(old: {
    buildInputs = [ python ];
    buildPhase = ''
      patchShebangs .
      ./install.sh
    '';
  });

  deoplete-go = deoplete-go.overrideAttrs(old: {
    buildInputs = [ python3 ];
    buildPhase = ''
      pushd ./rplugin/python3/deoplete/ujson
      python3 setup.py build --build-base=$PWD/build --build-lib=$PWD/build
      popd
      find ./rplugin/ -name "ujson*.so" -exec mv -v {} ./rplugin/python3/ \;
   '';
  });

  ensime-vim = ensime-vim.overrideAttrs(old: {
    passthru.python3Dependencies = ps: with ps; [ sexpdata websocket_client ];
    dependencies = ["vimproc" "vimshell" "self" "forms"];
  });

  forms = forms.overrideAttrs(old: {
    dependencies = ["self"];
  });

  gitv = gitv.overrideAttrs(old: {
    dependencies = ["gitv"];
  });

  ncm2 = ncm2.overrideAttrs(old: {
    dependencies = ["nvim-yarp"];
  });

  ncm2-ultisnips = ncm2-ultisnips.overrideAttrs(old: {
    dependencies = ["ultisnips"];
  });

  taglist-vim = taglist-vim.overrideAttrs(old: {
    setSourceRoot = ''
      export sourceRoot=taglist
      mkdir taglist
      mv doc taglist
      mv plugin taglist
    '';
  });

  vimshell-vim = vimshell-vim.overrideAttrs(old: {
    dependencies = [ "vimproc-vim" ];
  });

  vim-addon-manager = vim-addon-manager.overrideAttrs(old: {
    buildInputs = stdenv.lib.optional stdenv.isDarwin Cocoa;
  });

  vim-addon-actions = vim-addon-actions.overrideAttrs(old: {
    dependencies = [ "vim-addon-mw-utils" "tlib" ];
  });

  vim-addon-async = vim-addon-async.overrideAttrs(old: {
    dependencies = [ "vim-addon-signs" ];
  });

  vim-addon-background-cmd = vim-addon-background-cmd.overrideAttrs(old: {
    dependencies = [ "vim-addon-mw-utils" ];
  });

  vim-addon-completion = vim-addon-completion.overrideAttrs(old: {
    dependencies = [ "tlib" ];
  });

  vim-addon-goto-thing-at-cursor = vim-addon-goto-thing-at-cursor.overrideAttrs(old: {
    dependencies = [ "tlib" ];
  });

  vim-addon-mru = vim-addon-mru.overrideAttrs(old: {
    dependencies = ["vim-addon-other" "vim-addon-mw-utils"];
  });

  vim-addon-nix = vim-addon-nix.overrideAttrs(old: {
    dependencies = [
      "vim-addon-completion"
      "vim-addon-goto-thing-at-cursor"
      "vim-addon-errorformats"
      "vim-addon-actions"
      "vim-addon-mw-utils" "tlib"
    ];
  });

  vim-addon-sql = vim-addon-sql.overrideAttrs(old: {
    dependencies = ["vim-addon-completion" "vim-addon-background-cmd" "tlib"];
  });

  vim-addon-syntax-checker = vim-addon-syntax-checker.overrideAttrs(old: {
    dependencies = ["vim-addon-mw-utils" "tlib"];
  });

  vim-addon-toggle-buffer = vim-addon-toggle-buffer.overrideAttrs(old: {
    dependencies = [ "vim-addon-mw-utils" "tlib" ];
  });

  vim-addon-xdebug = vim-addon-xdebug.overrideAttrs(old: {
    dependencies = [ "WebAPI" "vim-addon-mw-utils" "vim-addon-signs" "vim-addon-async" ];
  });

  vim-bazel = vim-bazel.overrideAttrs(old: {
    dependencies = ["maktaba"];
  });

  vim-codefmt = vim-codefmt.overrideAttrs(old: {
    dependencies = ["maktaba"];
  });

  vim-easytags = vim-easytags.overrideAttrs(old: {
    dependencies = ["vim-misc"];
  });

  vim-grammarous = vim-grammarous.overrideAttrs(old: {
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

  vim-hier = vim-hier.overrideAttrs(old: {
    buildInputs = [ vim ];
  });

  vim-isort = vim-isort.overrideAttrs(old: {
    postPatch = ''
      substituteInPlace ftplugin/python_vimisort.vim \
        --replace 'import vim' 'import vim; import sys; sys.path.append("${pythonPackages.isort}/${python.sitePackages}")'
    '';
  });

  vim-snipmate = vim-snipmate.overrideAttrs(old: {
    dependencies = ["vim-addon-mw-utils" "tlib"];
  });


  vim-wakatime = vim-wakatime.overrideAttrs(old: {
    buildInputs = [ python ];
  });

  vim-xdebug = vim-xdebug.overrideAttrs(old: {
    postInstall = false;
  });

  vim-xkbswitch = vim-xkbswitch.overrideAttrs(old: {
    patchPhase = ''
      substituteInPlace plugin/xkbswitch.vim \
        --replace /usr/local/lib/libxkbswitch.so ${xkb_switch}/lib/libxkbswitch.so
    '';
    buildInputs = [ xkb_switch ];
  });

  vim-yapf = vim-yapf.overrideAttrs(old: {
    buildPhase = ''
      substituteInPlace ftplugin/python_yapf.vim \
        --replace '"yapf"' '"${python3Packages.yapf}/bin/yapf"'
    '';
  });

  vimproc-vim = vimproc-vim.overrideAttrs(old: {
    buildInputs = [ which ];

    buildPhase = ''
      substituteInPlace autoload/vimproc.vim \
        --replace vimproc_mac.so vimproc_unix.so \
        --replace vimproc_linux64.so vimproc_unix.so \
        --replace vimproc_linux32.so vimproc_unix.so
      make -f make_unix.mak
    '';
  });

  YankRing-vim = YankRing-vim.overrideAttrs(old: {
    sourceRoot = ".";
  });

  youcompleteme = youcompleteme.overrideAttrs(old: {
    buildPhase = ''
      substituteInPlace plugin/youcompleteme.vim \
        --replace "'ycm_path_to_python_interpreter', '''" \
        "'ycm_path_to_python_interpreter', '${python}/bin/python'"

      rm -r third_party/ycmd
      ln -s ${ycmd}/lib/ycmd third_party
    '';

    meta = {
      description = "A code-completion engine for Vim";
      homepage = https://github.com/Valloric/YouCompleteMe;
      license = stdenv.lib.licenses.gpl3;
      maintainers = with stdenv.lib.maintainers; [marcweber jagajaga];
      platforms = stdenv.lib.platforms.unix;
    };
  });

}

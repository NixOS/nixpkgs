{ lib, stdenv
, python, cmake, vim, ruby
, which, fetchgit, llvmPackages, rustPlatform
, xkb-switch, fzf, skim
, python3, boost, icu, ncurses
, ycmd, rake
, substituteAll
, languagetool
, Cocoa, CoreFoundation, CoreServices
, buildVimPluginFrom2Nix

# vim-go denpencies
, asmfmt, delve, errcheck, godef, golint
, gomodifytags, gotags, gotools, go-motion
, gnused, reftools, gogetdoc, gometalinter
, impl, iferr, gocode, gocode-gomod, go-tools
}:

self: super: {

  vim2nix = buildVimPluginFrom2Nix {
    pname = "vim2nix";
    version = "1.0";
    src = ./vim2nix;
    dependencies = with super; [ vim-addon-manager ];
  };

  fzfWrapper = buildVimPluginFrom2Nix {
    pname = "fzf";
    version = fzf.version;
    src = fzf.src;
  };

  skim = buildVimPluginFrom2Nix {
    pname = "skim";
    version = skim.version;
    src = skim.vim;
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
    pname = "LanguageClient-neovim";
    version = "2018-09-07";
    src = LanguageClient-neovim-src;

    propogatedBuildInputs = [ LanguageClient-neovim-bin ];

    preFixup = ''
      substituteInPlace "$out"/share/vim-plugins/LanguageClient-neovim/autoload/LanguageClient.vim \
        --replace "let l:path = s:root . '/bin/'" "let l:path = '${LanguageClient-neovim-bin}' . '/bin/'"
    '';
  };

  # do not auto-update this one, as the name clashes with vim-snippets
  vim-docbk-snippets = buildVimPluginFrom2Nix {
    pname = "vim-docbk-snippets";
    version = "2017-11-02";
    src = fetchgit {
      url = "https://github.com/jhradilek/vim-snippets";
      rev = "69cce66defdf131958f152ea7a7b26c21ca9d009";
      sha256 = "1363b2fmv69axrl2hm74dmx51cqd8k7rk116890qllnapzw1zjgc";
    };
  };

  clang_complete = super.clang_complete.overrideAttrs(old: {
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

      substituteInPlace "$out"/share/vim-plugins/clang_complete/plugin/libclang.py \
        --replace "/usr/lib/clang" "${llvmPackages.clang.cc}/lib/clang"
    '';
  });

  clighter8 = super.clighter8.overrideAttrs(old: {
    preFixup = ''
      sed "/^let g:clighter8_libclang_path/s|')$|${llvmPackages.clang.cc.lib}/lib/libclang.so')|" \
        -i "$out"/share/vim-plugins/clighter8/plugin/clighter8.vim
    '';
  });

  command-t = super.command-t.overrideAttrs(old: {
    buildInputs = [ ruby rake ];
    buildPhase = ''
      rake make
      rm ruby/command-t/ext/command-t/*.o
    '';
  });

  cpsm = super.cpsm.overrideAttrs(old: {
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

  ctrlp-cmatcher = super.ctrlp-cmatcher.overrideAttrs(old: {
    buildInputs = [ python ];
    buildPhase = ''
      patchShebangs .
      ./install.sh
    '';
  });

  deoplete-go = super.deoplete-go.overrideAttrs(old: {
    buildInputs = [ python3 ];
    buildPhase = ''
      pushd ./rplugin/python3/deoplete/ujson
      python3 setup.py build --build-base=$PWD/build --build-lib=$PWD/build
      popd
      find ./rplugin/ -name "ujson*.so" -exec mv -v {} ./rplugin/python3/ \;
   '';
  });

  ensime-vim = super.ensime-vim.overrideAttrs(old: {
    passthru.python3Dependencies = ps: with ps; [ sexpdata websocket_client ];
    dependencies = with super; [ vimproc-vim vimshell-vim super.self forms ];
  });

  forms = super.forms.overrideAttrs(old: {
    dependencies = with super; [ super.self ];
  });

  gist-vim = super.gist-vim.overrideAttrs(old: {
    dependencies = with super; [ webapi-vim ];
  });

  ncm2 = super.ncm2.overrideAttrs(old: {
    dependencies = with super; [ nvim-yarp ];
  });

  ncm2-jedi = super.ncm2-jedi.overrideAttrs(old: {
    dependencies = with super; [ nvim-yarp ncm2 ];
    passthru.python3Dependencies = ps: with ps; [ jedi ];
  });

  ncm2-ultisnips = super.ncm2-ultisnips.overrideAttrs(old: {
    dependencies = with super; [ ultisnips ];
  });

  vimshell-vim = super.vimshell-vim.overrideAttrs(old: {
    dependencies = with super; [ vimproc-vim ];
  });

  vim-addon-manager = super.vim-addon-manager.overrideAttrs(old: {
    buildInputs = stdenv.lib.optional stdenv.isDarwin Cocoa;
  });

  vim-addon-actions = super.vim-addon-actions.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-mw-utils tlib_vim ];
  });

  vim-addon-async = super.vim-addon-async.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-signs ];
  });

  vim-addon-background-cmd = super.vim-addon-background-cmd.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-mw-utils ];
  });

  vim-addon-completion = super.vim-addon-completion.overrideAttrs(old: {
    dependencies = with super; [ tlib_vim ];
  });

  vim-addon-goto-thing-at-cursor = super.vim-addon-goto-thing-at-cursor.overrideAttrs(old: {
    dependencies = with super; [ tlib_vim ];
  });

  vim-addon-mru = super.vim-addon-mru.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-other vim-addon-mw-utils ];
  });

  vim-addon-nix = super.vim-addon-nix.overrideAttrs(old: {
    dependencies = with super; [
      vim-addon-completion
      vim-addon-goto-thing-at-cursor
      vim-addon-errorformats
      vim-addon-actions
      vim-addon-mw-utils tlib_vim
    ];
  });

  vim-addon-sql = super.vim-addon-sql.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-completion vim-addon-background-cmd tlib_vim ];
  });

  vim-addon-syntax-checker = super.vim-addon-syntax-checker.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-mw-utils tlib_vim ];
  });

  vim-addon-toggle-buffer = super.vim-addon-toggle-buffer.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-mw-utils tlib_vim ];
  });

  vim-addon-xdebug = super.vim-addon-xdebug.overrideAttrs(old: {
    dependencies = with super; [ webapi-vim vim-addon-mw-utils vim-addon-signs vim-addon-async ];
  });

  vim-bazel = super.vim-bazel.overrideAttrs(old: {
    dependencies = with super; [ vim-maktaba ];
  });

  vim-codefmt = super.vim-codefmt.overrideAttrs(old: {
    dependencies = with super; [ vim-maktaba ];
  });

  vim-easytags = super.vim-easytags.overrideAttrs(old: {
    dependencies = with super; [ vim-misc ];
  });

  # change the go_bin_path to point to a path in the nix store. See the code in
  # fatih/vim-go here
  # https://github.com/fatih/vim-go/blob/155836d47052ea9c9bac81ba3e937f6f22c8e384/autoload/go/path.vim#L154-L159
  vim-go = super.vim-go.overrideAttrs(old: let
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
      gometalinter
      gomodifytags
      gotags
      gotools
      iferr
      impl
      reftools
    ];
    in {
    postPatch = ''
      ${gnused}/bin/sed \
        -Ee 's@"go_bin_path", ""@"go_bin_path", "${binPath}"@g' \
        -i autoload/go/config.vim
    '';
  });

  vim-grammarous = super.vim-grammarous.overrideAttrs(old: {
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

  vim-hier = super.vim-hier.overrideAttrs(old: {
    buildInputs = [ vim ];
  });

  vim-isort = super.vim-isort.overrideAttrs(old: {
    postPatch = ''
      substituteInPlace ftplugin/python_vimisort.vim \
        --replace 'import vim' 'import vim; import sys; sys.path.append("${python.pkgs.isort}/${python.sitePackages}")'
    '';
  });

  vim-snipmate = super.vim-snipmate.overrideAttrs(old: {
    dependencies = with super; [ vim-addon-mw-utils tlib_vim ];
  });


  vim-wakatime = super.vim-wakatime.overrideAttrs(old: {
    buildInputs = [ python ];
  });

  vim-xdebug = super.vim-xdebug.overrideAttrs(old: {
    postInstall = false;
  });

  vim-xkbswitch = super.vim-xkbswitch.overrideAttrs(old: {
    patchPhase = ''
      substituteInPlace plugin/xkbswitch.vim \
        --replace /usr/local/lib/libxkbswitch.so ${xkb-switch}/lib/libxkbswitch.so
    '';
    buildInputs = [ xkb-switch ];
  });

  vim-yapf = super.vim-yapf.overrideAttrs(old: {
    buildPhase = ''
      substituteInPlace ftplugin/python_yapf.vim \
        --replace '"yapf"' '"${python3.pkgs.yapf}/bin/yapf"'
    '';
  });

  vimproc-vim = super.vimproc-vim.overrideAttrs(old: {
    buildInputs = [ which ];

    buildPhase = ''
      substituteInPlace autoload/vimproc.vim \
        --replace vimproc_mac.so vimproc_unix.so \
        --replace vimproc_linux64.so vimproc_unix.so \
        --replace vimproc_linux32.so vimproc_unix.so
      make -f make_unix.mak
    '';
  });

  YankRing-vim = super.YankRing-vim.overrideAttrs(old: {
    sourceRoot = ".";
  });

  youcompleteme = super.youcompleteme.overrideAttrs(old: {
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

  jedi-vim = super.jedi-vim.overrideAttrs(old: {
    # checking for python3 support in vim would be neat, too, but nobody else seems to care
    buildInputs = [ python3.pkgs.jedi ];
    meta = {
      description = "code-completion for python using python-jedi";
      license = stdenv.lib.licenses.mit;
    };
  });

}

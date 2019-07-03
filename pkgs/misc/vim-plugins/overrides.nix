{ lib, stdenv
, python, cmake, meson, vim, ruby
, which, fetchFromGitHub, fetchgit, fetchurl, fetchzip
, llvmPackages, rustPlatform
, xkb-switch, fzf, skim, stylish-haskell
, python3, boost, icu, ncurses
, ycmd, rake
, gobject-introspection, glib, wrapGAppsHook
, substituteAll
, languagetool
, Cocoa, CoreFoundation, CoreServices
, buildVimPluginFrom2Nix

# vim-go denpencies
, asmfmt, delve, errcheck, godef, golint
, gomodifytags, gotags, gotools, go-motion
, gnused, reftools, gogetdoc, gometalinter
, impl, iferr, gocode, gocode-gomod, go-tools

# vCoolor dep
, gnome3
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
    version = "0.1.146";
    LanguageClient-neovim-src = fetchurl {
      url = "https://github.com/autozimu/LanguageClient-neovim/archive/${version}.tar.gz";
      sha256 = "1xm98pyzf2dlh04ijjf3nkh37lyqspbbjddkjny1g06xxb4kfxnk";
    };
    LanguageClient-neovim-bin = rustPlatform.buildRustPackage {
      name = "LanguageClient-neovim-bin";
      src = LanguageClient-neovim-src;

      cargoSha256 = "0dixvmwq611wg2g3rp1n1gqali46904fnhb90gcpl9a1diqb34sh";
      buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

      # FIXME: Use impure version of CoreFoundation because of missing symbols.
      #   Undefined symbols for architecture x86_64: "_CFURLResourceIsReachable"
      preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
        export NIX_LDFLAGS="-F${CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS"
      '';
    };
  in buildVimPluginFrom2Nix {
    pname = "LanguageClient-neovim";
    inherit version;
    src = LanguageClient-neovim-src;

    propagatedBuildInputs = [ LanguageClient-neovim-bin ];

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


  coc-nvim = let
    version = "0.0.71";
    index_js = fetchzip {
        url = "https://github.com/neoclide/coc.nvim/releases/download/v${version}/coc.tar.gz";
        sha256 = "1bhkyrmrpriizg3f76x4vp94f2bfwcf7a6cp3jvv7vj4zaqhsjzz";
      };
  in super.coc-nvim.overrideAttrs(old: {
    # you still need to enable the node js provider in your nvim config
    postInstall = ''
      mkdir -p $out/share/vim-plugins/coc-nvim/build
      cp ${index_js}/index.js $out/share/vim-plugins/coc-nvim/build/
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

  deoplete-fish = super.deoplete-fish.overrideAttrs(old: {
    dependencies = with super; [ deoplete-nvim vim-fish ];
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

  gruvbox-community = buildVimPluginFrom2Nix {
    pname = "gruvbox-community";
    version = "2019-05-31";
    src = fetchFromGitHub {
      owner = "gruvbox-community";
      repo = "gruvbox";
      rev = "e122091dad968a5524f3e8136615a479c7b6f247";
      sha256 = "1hncjyfi1gbw62b2pngy5qxyzibrhbyzgfmm9a58sdh1272l8ls8";
    };
    meta.maintainers = with stdenv.lib.maintainers; [ minijackson ];
  };

  meson = buildVimPluginFrom2Nix {
    inherit (meson) pname version src;
    preInstall = "cd data/syntax-highlighting/vim";
    meta.maintainers = with stdenv.lib.maintainers; [ vcunat ];
  };

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

  sved = let
    # we put the script in its own derivation to benefit the magic of wrapGAppsHook
    svedbackend = stdenv.mkDerivation {
      name = "svedbackend-${super.sved.name}";
      inherit (super.sved) src;
      nativeBuildInputs = [ wrapGAppsHook ];
      buildInputs = [
        gobject-introspection
        glib
        (python3.withPackages(ps: with ps; [ pygobject3 pynvim dbus-python ]))
      ];
      preferLocalBuild = true;
      installPhase = ''
        install -Dt $out/bin ftplugin/evinceSync.py
      '';
    };
  in
    super.sved.overrideAttrs(old: {
      preferLocalBuild = true;
      postPatch = ''
        rm ftplugin/evinceSync.py
        ln -s ${svedbackend}/bin/evinceSync.py ftplugin/evinceSync.py
      '';
      meta = {
        description = "synctex support between vim/neovim and evince";
      };
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

  vim-stylish-haskell = super.vim-stylish-haskell.overrideAttrs (old: {
    postPatch = old.postPatch or "" + ''
      substituteInPlace ftplugin/haskell/stylish-haskell.vim --replace \
        'g:stylish_haskell_command = "stylish-haskell"' \
        'g:stylish_haskell_command = "${stylish-haskell}/bin/stylish-haskell"'
    '';
  });

  vCoolor-vim = super.vCoolor-vim.overrideAttrs(old: {
    # on linux can use either Zenity or Yad.
    propagatedBuildInputs = [ gnome3.zenity ];
    meta = {
      description = "Simple color selector/picker plugin";
      license = stdenv.lib.licenses.publicDomain;
    };
  });

  unicode-vim = let
    unicode-data = fetchurl {
      url = http://www.unicode.org/Public/UNIDATA/UnicodeData.txt;
      sha256 = "16b0jzvvzarnlxdvs2izd5ia0ipbd87md143dc6lv6xpdqcs75s9";
    };
  in super.unicode-vim.overrideAttrs(old: {

      # redirect to /dev/null else changes terminal color
      buildPhase = ''
        cp "${unicode-data}" autoload/unicode/UnicodeData.txt
        echo "Building unicode cache"
        ${vim}/bin/vim --cmd ":set rtp^=$PWD" -c 'ru plugin/unicode.vim' -c 'UnicodeCache' -c ':echohl Normal' -c ':q' > /dev/null
      '';
  });
}

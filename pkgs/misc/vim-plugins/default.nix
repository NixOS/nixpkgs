{ fetchurl, bash, stdenv, python, cmake, vim, perl, ruby, unzip, which, fetchgit, clang }:

/*
About Vim and plugins
=====================
Let me tell you how Vim plugins work, so that you can decide on how to orginize
your setup.

typical plugin files:

  plugin/P1.vim
  autoload/P1.vim
  ftplugin/xyz.vim
  doc/plugin-documentation.txt (traditional documentation)
  README(.md) (nowadays thanks to github)

Traditionally plugins were installed into ~/.vim/* so it was your task to keep track
of which files belong to what plugin. Now this problem is "fixed" by nix which
assembles your profile for you.


Vim offers the :h rtp setting which works for most plugins. Thus adding adding
this to your .vimrc should make most plugins work:

  set rtp+=~/.nix-profile/vim-plugins/YouCompleteMe
  " or for p in ["YouCompleteMe"] | exec 'set rtp+=~/.nix-profile/vim-plugins/'.p | endfor

Its what pathogen, vundle, vim-addon-manager (VAM) use.

VAM's benefits:
- allows activating plugins at runtime, eg when you need them. (works around
  some au command hooks, eg required for TheNerdTree plugin)
- VAM checkous out all sources (vim.sf.net, git, mercurial, ...)
- runs :helptags on update/installation only. Obviously it cannot do that on
  store paths.
- it reads addon-info.json files which can declare dependencies by name
  (without version)

VAM is made up of
- the code loading plugins
- an optional pool (github.com/MarcWeber/vim-addon-manager-known-repositories)

That pool probably is the best source to automatically derive plugin
information from or to lookup about how to get data from www.vim.org.

I'm not sure we should package them all. Most of them are not used much.
You need your .vimrc anyway, and then VAM gets the job done ?

How to install VAM? eg provide such a bash function:

    vim-install-vam () {
    mkdir -p ~/.vim/vim-addons && git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager.git ~/.vim/vim-addons/vim-addon-manager && cat >> ~/.vimrc <<EOF
    set nocompatible
    set hidden
    filetype indent plugin on | syn on
    fun ActivateAddons()
      let g:vim_addon_manager = {}
      let g:vim_addon_manager.log_to_buf =1
      set runtimepath+=~/.vim/vim-addons/vim-addon-manager
      call vam#ActivateAddons([])
    endf
    call ActivateAddons()
    EOF
    }

Marc Weber thinks that having no plugins listed might be better than having
outdated ones.

So which plugins to add here according to what Marc Weber thinks is best?
Complicated plugins requiring dependencies, such as YouCompleteMe.
Then its best to symlink ~/.nix-profile/vim-plugins/YouCompleteMe to
~/.vim/{vim-addons,bundle} or whatever plugin management solution you use.

If you feel differently change the comments and proceed.
*/

# provide a function creating tag files for vim help documentation (doc/*.txt)
let vimHelpTags = ''
    vimHelpTags(){
      if [ -d "$1/doc" ]; then
        ${vim}/bin/vim -N -u NONE -i NONE -n -e -s -c "helptags $1/doc" +quit!
      fi
    }
  '';

  # install a simple standard vim plugin
  simpleDerivation = a@{name, src, path, buildPhase ? "", ...} : stdenv.mkDerivation (a // {
    inherit buildPhase;

    installPhase = ''
      target=$out/share/vim-plugins/${path}
      mkdir -p $out/share/vim-plugins
      cp -r . $target
      ${vimHelpTags}
      vimHelpTags $target
    '';
  });

in rec

{

  vimAddonNix = {
    # github.com/MarcWeber/vim-addon-nix provides some additional support for
    # editing .nix files

    # This is a placeholder, because I think you always should be using latest
    # git version. It also depends on some additional plugins (see addon-info.json)
  };

  YouCompleteMe = stdenv.mkDerivation {
    src = fetchgit {
      url = "https://github.com/Valloric/YouCompleteMe.git";
      rev = "67288080ea7057ea3111cb4c863484e3b150e738";
      sha256 = "1a3rwdl458z1yrp50jdwp629j4al0zld21n15sad28g51m8gw5ka";
     };

    name = "youcompleteme-git-6728808";
    buildInputs = [ python cmake clang.clang ];

    configurePhase = ":";

    buildPhase = ''
      target=$out/share/vim-plugins/YouCompleteMe
      mkdir -p $target
      cp -a ./ $target


      mkdir $target/build
      cd $target/build
      cmake -G "Unix Makefiles" . $target/third_party/ycmd/cpp -DPYTHON_LIBRARIES:PATH=${python}/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR:PATH=${python}/include/python2.7 -DUSE_CLANG_COMPLETER=ON -DUSE_SYSTEM_LIBCLANG=ON
      make ycm_support_libs -j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}
      ${bash}/bin/bash $target/install.sh --clang-completer

      ${vimHelpTags}
      vimHelpTags $target
    '';

    # TODO: implement proper install phase rather than keeping everything in store
    # TODO: support llvm based C completion, See README of git repository
    installPhase = ":";

    meta = {
      description = "fastest non utf-8 aware word and C completion engine for Vim";
      homepage = http://github.com/Valloric/YouCompleteMe;
      license = stdenv.lib.licenses.gpl3;
      maintainers = [stdenv.lib.maintainers.marcweber];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  syntastic = simpleDerivation rec {
    version = "3.4.0";
    name    = "vim-syntastic-${version}";

    src = fetchurl {
      url    = "https://github.com/scrooloose/syntastic/archive/${version}.tar.gz";
      sha256 = "0h8vfs6icpfwc41qx6n6rc1m35haxp2gaswg9fhcki2w2ikp6knb";
    };

    path = "syntastic";
  };

  coffeeScript = simpleDerivation {
    name = "vim-coffee-script-v002";
    src = fetchurl {
      url = "https://github.com/vim-scripts/vim-coffee-script/archive/v002.tar.gz";
      sha256 = "1xln6i6jbbihcyp5bsdylr2146y41hmp2xf7wi001g2ymj1zdsc0";
    };
    path = "vim-coffee-script";
  };

  command_T = simpleDerivation rec {
    version = "1.8";
    name = "vim-command-t-${version}";
    src = fetchurl {
      url    = "https://github.com/wincent/Command-T/archive/${version}.tar.gz";
      sha256 = "ad8664292e6eee40fbe195d856d20d93a8630e8c0149317ad72cc39423630800";
    };
    path = "Command-T";
    buildInputs = [ perl ruby ];
    buildPhase = ''
      pushd ruby/command-t
      ruby extconf.rb
      make
      popd
    '';
  };

  eighties = simpleDerivation rec {
    version = "1.0.4";
    name = "vim-eighties-${version}";
    src = fetchurl {
      url    = "https://github.com/justincampbell/vim-eighties/archive/${version}.tar.gz";
      sha256 = "0cjd9hbg2qd7jjkvyi15f9ysp7m3aa2sg8nvbf80yb890rfkwaqr";
    };
    path = "eighties";
    meta = with stdenv.lib; {
      description = "Automatically resizes your windows to 80 characters";
      homepage    = https://github.com/justincampbell/vim-eighties;
      license     = licenses.publicDomain;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  golang = simpleDerivation {
    name = "vim-golang-20131127";
    src = fetchgit {
      url = "https://github.com/jnwhiteh/vim-golang.git";
      rev = "832d64e5a813511ed52217aa24f0255c49671bab";
      sha256 = "6858eb674be132477c5dc7f7d3cbe550371f90d1aba480547a614965412a7b3c";
    };
    path = "golang";
    meta = with stdenv.lib; {
      description = "Vim plugins for Go";
      homepage    = https://github.com/jnwhiteh/vim-golang;
      license     = licenses.publicDomain;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  ipython = simpleDerivation {
    name = "vim-ipython-ff8f88f3fe518851a91dc88aaa5a75f8f352a960";
    src = fetchurl {
      url    = "https://github.com/ivanov/vim-ipython/archive/ff8f88f3fe518851a91dc88aaa5a75f8f352a960.tar.gz";
      sha256 = "0hlx526dm8amrvh41kwnmgvvdzs6sh5yc5sfq4nk1zjkfcp1ah5j";
    };
    path = "ipython";
    meta = with stdenv.lib; {
      description = "A two-way integration between vim and iPython";
      homepage    = https://github.com/ivanov/vim-ipython;
      repositories.git = https://github.com/ivanov/vim-ipython.git;
      license     = licenses.publicDomain;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  taglist = simpleDerivation {
    name = "vim-taglist-4.6";
    meta = with stdenv.lib; {
      description = "Source code browser plugin";
      homepage    = "http://www.vim.org/scripts/script.php?script_id=273";
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=19574";
      name   = "taglist_46.zip";
      sha256 = "18cbv462vwg7vip2p99qlahm99hswav96cj4ki227kyi05q2lkjj";
    };
    setSourceRoot = ''
      export sourceRoot=taglist
      mkdir taglist
      mv doc taglist
      mv plugin taglist
    '';
    buildInputs = [ unzip ];
    path = "taglist";
  };

  tagbar = simpleDerivation rec {
    version = "2.6.1";
    name    = "vim-tagbar-${version}";

    meta = with stdenv.lib; {
      description = "A vim plugin for browsing the tags of source code files";
      homepage    = https://github.com/majutsushi/tagbar;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    src = fetchurl {
      url    = "https://github.com/majutsushi/tagbar/archive/v${version}.tar.gz";
      sha256 = "c061a7e0a45a166f4558b31e6c47b9fd701f5fa1319527b65a268ea054dea5fb";
    };

    path = "tagbar";
  };

  xdebug = simpleDerivation {
    name = "vim-xdebug-a4980fa65f7f159780593ee37c178281691ba2c4";
    src = fetchurl {
      url = "https://github.com/joonty/vim-xdebug/archive/a4980fa65f7f159780593ee37c178281691ba2c4.tar.gz";
      sha256 = "1348gzp0zhc2wifvs5vmf92m9y8ik8ldnvy7bawsxahy8hmhiksk";
    };
    path = "xdebug";
    postInstall = false;
  };

  vimshell = simpleDerivation rec {
    version = "9.2";
    name = "vimshell-${version}";

    meta = with stdenv.lib; {
      description = "An extreme shell that doesn't depend on external shells and is written completely in Vim script";
      homepage    = https://github.com/Shougo/vimshell.vim;
      repositories.git = https://github.com/Shougo/vimshell.vim.git;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    src = fetchurl {
      url    = "https://github.com/Shougo/vimshell.vim/archive/ver.${version}.tar.gz";
      sha256 = "1pbwxdhpv6pr09b6hwkgy7grpmpwlqpsgsawl38r40q6yib8zb4a";
    };

    buildInputs = [ vimproc ];

    preBuild = ''
      sed -ie '1 i\
      set runtimepath+=${vimproc}/share/vim-plugins/vimproc\
      ' autoload/vimshell.vim
    '';

    path = "vimshell";
  };

  vimproc = simpleDerivation rec {
    version = "7788b5f934bc7460c1e9134b51fe5690b21de83c";
    name    = "vimproc-${version}";

    meta = with stdenv.lib; {
      description = "An asynchronous execution library for Vim";
      homepage    = https://github.com/Shougo/vimproc.vim;
      repositories.git = https://github.com/Shougo/vimproc.vim.git;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };

    src = fetchgit {
      url = "https://github.com/Shougo/vimproc.vim.git";
      rev = "${version}";
      sha256 = "0ahmnzccf5rv8rwg7b6pfgxh8pcmq955aznjv64slyh0mjqmh6jl";
     };

    buildInputs = [ which ];

    buildPhase = ''
      sed -i 's/vimproc_mac\.so/vimproc_unix\.so/' autoload/vimproc.vim
      make -f make_unix.mak
    '';

    path = "vimproc";
  };

  colorsamplerpack = simpleDerivation rec {
    version = "2012.10.28";
    name    = "vim-colorsamplerpack-${version}";

    setSourceRoot = "sourceRoot=.";
    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=18915";
      name   = "colorsamplerpack.zip";
      sha256 = "1wsrb3vpqn9fncnalfpvc8r92wk1mcskm4shb3s2h9x5dyihf2rd";
    };

    buildInputs = [ unzip ];

    path = "colorsamplerpack";
  };

  yankring = simpleDerivation rec {
    version = "18.0";
    name    = "vim-yankring-${version}";

    setSourceRoot = "sourceRoot=.";
    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=20842";
      name   = "yankring_180.zip";
      sha256 = "0bsq4pxagy12jqxzs7gcf25k5ahwif13ayb9k8clyhm0jjdkf0la";
    };

    buildInputs = [ unzip ];

    path = "yankring";
  };

  ctrlp = simpleDerivation rec {
    version = "1.79";
    name    = "vim-ctrlp-${version}";

    setSourceRoot = "sourceRoot=.";
    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=19448";
      name   = "ctrlp_180.zip";
      sha256 = "1x9im8g0g27mxc3c9k7v0jg5bb1dmnbjygmqif5bizab5g69n2mi";
    };

    buildInputs = [ unzip ];

    path = "ctrlp";
  };

  alternate = stdenv.mkDerivation rec {
    version = "2.18";
    name    = "vim-a-${version}";

    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=7218";
      name   = "a.vim";
      sha256 = "1q22vfkv60sshp9yj3mmfc8azavgzz7rpmaf72iznzq4wccy6gac";
    };
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/share/vim-plugins/vim-a
      cp ${src} $out/share/vim-plugins/vim-a/a.vim
    '';
  };

}

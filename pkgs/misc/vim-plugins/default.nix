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

  vundle = simpleDerivation {
    name = "vundle-vim-git-0b28e334";
    src = fetchgit {
      url = "https://github.com/gmarik/Vundle.vim.git";
      rev = "0b28e334e65b6628b0a61c412fcb45204a2f2bab";
      sha256 = "9681d471d1391626cb9ad22b2b469003d9980cd23c5c3a8d34666376447e6204";
     };
    path = "vundle";
  };

  tslime = simpleDerivation {
    name = "tslime-vim-git-e801a32b";
    src = fetchgit {
      url = "https://github.com/jgdavey/tslime.vim.git";
      rev = "e801a32b27d83cb5d91afbf7c3d71bb6220f32bd";
      sha256 = "47fb7165c1dcc444285cdff6fa89bbd4ace82ca79ec14ba0da6091c5f78d1251";
     };
    path = "tslime";
  };

  supertab = simpleDerivation {
    name = "supertab-git-23db5585";
    src = fetchgit {
      url = "https://github.com/ervandew/supertab.git";
      rev = "23db558596d4a73e4afa8fbedcde23b95bf72251";
      sha256 = "21fa675969f4cfd2686ab3b63cba632fa55d62481e61d36193403bea9c02ebde";
     };
    path = "supertab";
    buildInputs = [ vim ];
  };

  fugitive = simpleDerivation {
    name = "vim-fugitive-git-90ee6fb5";
    src = fetchgit {
      url = "https://github.com/tpope/vim-fugitive.git";
      rev = "90ee6fb5d255d14d9f12f2469f92ee50149f5b44";
      sha256 = "0297512f7fee62af601a99a68617591ecb2e244475ff0d79ebee9c7e6eff2eaf";
     };
    path = "fugitive";
  };

  extradite = simpleDerivation {
    name = "vim-extradite-git-af4f3a51";
    src = fetchgit {
      url = "https://github.com/int3/vim-extradite.git";
      rev = "af4f3a51b6b654d655121b93c0cd9d8fe9a0c85d";
      sha256 = "d1d29cfbc654134be383747f2cd6b14b7a87de75f997af6a041f14d7ef61ade6";
     };
    path = "extradite";
  };

  nerdtree = simpleDerivation {
    name = "nerdtree-git-4f1e6ecb";
    src = fetchgit {
      url = "https://github.com/scrooloose/nerdtree.git";
      rev = "4f1e6ecb057fc0bac189171c1430d71ef25f6bb1";
      sha256 = "67ff2e7b9a7f39e58e9e334b1b79343a4c11aae10a657ab4fece289d8fe59300";
     };
    path = "nerdtree";
  };

  airline = simpleDerivation {
    name = "vim-airline-git-2114e702";
    src = fetchgit {
      url = "https://github.com/bling/vim-airline.git";
      rev = "2114e7025188a941e5c63b1f942d576adb98d8a4";
      sha256 = "b6fc4d0545f8b7e107c5f80b94cf536a2b1fdd55d9f2484a29a007911e96130f";
     };
    path = "airline";
  };

  ultisnips = simpleDerivation {
    name = "ultisnips-git-279d6e63";
    src = fetchgit {
      url = "https://github.com/SirVer/ultisnips.git";
      rev = "279d6e63c9a8dbaa20ffc43c3c5f057dfc8f1121";
      sha256 = "f8d93849ef2bce798aa599ba860694ced37d12450010a48dd6bd3004bc52b503";
     };
    path = "ultisnips";
  };

  align = simpleDerivation {
    name = "align-git-787662fe";
    src = fetchgit {
      url = "https://github.com/vim-scripts/Align.git";
      rev = "787662fe90cd057942bc5b682fd70c87e1a9dd77";
      sha256 = "f7b5764357370f03546556bd45558837f3790b0e86afadb63cd04d714a668a29";
     };
    path = "align";
  };

  gundo = simpleDerivation {
    name = "gundo-git-f443470b";
    src = fetchgit {
      url = "https://github.com/vim-scripts/Gundo.git";
      rev = "f443470b96364c24a775629418a6b2562ec9173e";
      sha256 = "b7a949167e59c936d6eae0d23635b87491b2cd2f46a197683b171d30165a90f9";
     };
    path = "gundo";
  };

  commentary = simpleDerivation {
    name = "vim-commentary-git-8b4df6ca";
    src = fetchgit {
      url = "https://github.com/tpope/vim-commentary.git";
      rev = "8b4df6ca0ba9cd117d97a8fd26b44b2439d5e3f1";
      sha256 = "5496ed31706552957d4caa76669ecd04e9b2853cf7a7e40bd0164726b21fcca0";
     };
    path = "commentary";
  };

  tabular = simpleDerivation {
    name = "tabular-git-60f25648";
    src = fetchgit {
      url = "https://github.com/godlygeek/tabular.git";
      rev = "60f25648814f0695eeb6c1040d97adca93c4e0bb";
      sha256 = "28c860ad621587f2c3213fae47d1a3997746527c17d51e9ab94c209eb7bfeb0f";
     };
    path = "tabular";
  };

  vim2hs = simpleDerivation {
    name = "vim2hs-git-f2afd557";
    src = fetchgit {
      url = "https://github.com/dag/vim2hs.git";
      rev = "f2afd55704bfe0a2d66e6b270d247e9b8a7b1664";
      sha256 = "485fc58595bb4e50f2239bec5a4cbb0d8f5662aa3f744e42c110cd1d66b7e5b0";
     };
    path = "vim2hs";
  };

  hasksyn = simpleDerivation {
    name = "hasksyn-git-175cd460";
    src = fetchgit {
      url = "https://github.com/travitch/hasksyn.git";
      rev = "175cd4605afa5d9b9c75758112c8159fd118c631";
      sha256 = "3488e38d1f45a9a3363da62c1c946591621151a0a9cdaedd22b3fe8f666bbdb9";
     };
    path = "hasksyn";
  };

  haskellConceal = simpleDerivation {
    name = "vim-haskellConceal-git-73a8d712";
    src = fetchgit {
      url = "https://github.com/begriffs/vim-haskellConceal.git";
      rev = "73a8d712d3342b2ffdc087b12924f1cf81053860";
      sha256 = "be60ca030e2d39e972a8c71c0ab3b75b893589d26d5dd78a20cd6779f1f5cfa8";
     };
    path = "haskellConceal";
  };

  ghcmod = simpleDerivation {
    name = "ghcmod-vim-git-0c4e9428";
    src = fetchgit {
      url = "https://github.com/eagletmt/ghcmod-vim.git";
      rev = "0c4e94281e57c475752e799adc261f7d5e4ab124";
      sha256 = "f6a085f7b8198747fae3fff0bc38e4d030e5c97aaeb84958fbf96fa658bbe862";
     };
    path = "ghcmod";
  };

  necoGhc = simpleDerivation {
    name = "neco-ghc-git-0311f31b";
    src = fetchgit {
      url = "https://github.com/eagletmt/neco-ghc.git";
      rev = "0311f31b3acaccec5b651ae7089d627a3a49239b";
      sha256 = "302f29f54c56e9cee647745a8355aeafe323c4efe2f3593d5e4f586acc1c06a5";
     };
    path = "neco-ghc";
  };

  hoogle = simpleDerivation {
    name = "vim-hoogle-git-81f28318";
    src = fetchgit {
      url = "https://github.com/Twinside/vim-hoogle.git";
      rev = "81f28318b0d4174984c33df99db7752891c5c4e9";
      sha256 = "0f96f3badb6218cac87d0f7027ff032ecc74f08ad3ada542898278ce11cbd5a0";
     };
    path = "hoogle";
  };

  hdevtools = simpleDerivation {
    name = "vim-hdevtools-git-474947c5";
    src = fetchgit {
      url = "https://github.com/bitc/vim-hdevtools.git";
      rev = "474947c52ff9c93dd36f3c49de90bd9a78f0baa1";
      sha256 = "bf5f096b665c51ce611c6c1bfddc3267c4b2f94af84b04482b07272a6a5a92f3";
     };
    path = "hdevtools";
  };

  stylishHaskell = simpleDerivation {
    name = "vim-stylish-haskell-git-453fd203";
    src = fetchgit {
      url = "https://github.com/nbouscal/vim-stylish-haskell.git";
      rev = "453fd203aee3d7305ea8e4088ff53bd1f5933d75";
      sha256 = "c0e5010e1e8e56b179ce500387afb569f051c45b37ce92feb4350f293df96a8c";
     };
    path = "stylish-haskell";
  };

  wombat256 = simpleDerivation {
    name = "wombat256-vim-git-8734ba45";
    src = fetchgit {
      url = "https://github.com/vim-scripts/wombat256.vim.git";
      rev = "8734ba45dcf5e38c4d2686b35c94f9fcb30427e2";
      sha256 = "2feb7d57ab0a9f2ea44ccd606e540db64ab3285956398a50ecc562d7b8dbcd05";
     };
    path = "wombat256";
  };

  tmuxNavigator = simpleDerivation {
    name = "vim-tmux-navigator-git-3de98bfc";
    src = fetchgit {
      url = "https://github.com/christoomey/vim-tmux-navigator.git";
      rev = "3de98bfcee1289ce8edc6daf9a18f243180c7168";
      sha256 = "3843f92e0a21fe5ccf613f8a561abd06c822b2ee98bd82c98937548144e4e8df";
     };
    path = "tmux-navigator";
  };

  pathogen = simpleDerivation {
    name = "vim-pathogen-git-3de98bfc";
    src = fetchgit {
      url = "https://github.com/tpope/vim-pathogen.git";
      rev = "91e6378908721d20514bbe5d18d292a0a15faf0c";
      sha256 = "24c1897d6b58576b2189c90050a7f8ede72a51343c752e9d030e833dbe5cac6f";
     };
    path = "pathogen";
  };

}

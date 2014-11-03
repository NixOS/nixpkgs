{ fetchurl, bash, stdenv, python, cmake, vim, perl, ruby, unzip, which, fetchgit, fetchzip, clang, zip }:

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

  set rtp+=~/.nix-profile/vim-plugins/youcompleteme
  " or for p in ["youcompleteme"] | exec 'set rtp+=~/.nix-profile/vim-plugins/'.p | endfor

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
Then its best to symlink ~/.nix-profile/vim-plugins/youcompleteme to
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

  buildVimPlugin = a@{name, namePrefix ? "vimplugin-", src, buildPhase ? "", ...}: stdenv.mkDerivation (a // {
    name = namePrefix + name;

    inherit buildPhase;

    installPhase = let path = (builtins.parseDrvName name).name; in ''
      target=$out/share/vim-plugins/${path}
      mkdir -p $out/share/vim-plugins
      cp -r . $target
      ${vimHelpTags}
      vimHelpTags $target
    '';
  });

in rec

{
  a = buildVimPlugin {
    name = "a-git-2010-11-06";
    src = fetchgit {
      url = "https://github.com/vim-scripts/a.vim.git";
      rev = "2cbe946206ec622d9d8cf2c99317f204c4d41885";
      sha256 = "ca0982873ed81e7f6545a6623b735104c574fe580d5f21b0aa3dc1557edac240";
     };
    meta = {
      homepage = https://github.com/vim-scripts/a.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  alternative = a; # backwards compat, added 2014-10-21

  airline = buildVimPlugin {
    name = "airline-git-2014-10-18";
    src = fetchgit {
      url = "https://github.com/bling/vim-airline.git";
      rev = "616daceb735771ed27535abe8a6e4907320f1e82";
      sha256 = "05ee7f6d58b14c35edda36183745e508bab19d2289b02af73f980062e51316e7";
     };
    meta = {
      homepage = https://github.com/bling/vim-airline; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  align = buildVimPlugin {
    name = "align-git-2012-08-07";
    src = fetchgit {
      url = "https://github.com/vim-scripts/align.git";
      rev = "787662fe90cd057942bc5b682fd70c87e1a9dd77";
      sha256 = "f7b5764357370f03546556bd45558837f3790b0e86afadb63cd04d714a668a29";
     };
    meta = {
      homepage = https://github.com/vim-scripts/align; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  calendar = buildVimPlugin {
    name = "calendar-git-2014-10-19";
    src = fetchgit {
      url = "https://github.com/itchyny/calendar.vim.git";
      rev = "44890a96d80bcd5fe62307e4bcb4d4085010e324";
      sha256 = "55f38e3e0af0f95229c654420c332668f93ac941f044c0573c7f1b26030e9202";
     };
    meta = {
      homepage = https://github.com/itchyny/calendar.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  coffee-script = buildVimPlugin {
    name = "coffee-script-002";
    src = fetchurl {
      url = "https://github.com/vim-scripts/vim-coffee-script/archive/v002.tar.gz";
      sha256 = "1xln6i6jbbihcyp5bsdylr2146y41hmp2xf7wi001g2ymj1zdsc0";
    };
  };

  coffeeScript = coffee-script; # backwards compat, added 2014-10-18

  colors-solarized = buildVimPlugin {
    name = "colors-solarized-git-2011-05-09";
    src = fetchgit {
      url = "https://github.com/altercation/vim-colors-solarized.git";
      rev = "528a59f26d12278698bb946f8fb82a63711eec21";
      sha256 = "a1b2ef696eee94dafa76431c31ee260acdd13a7cf87939f27eca431d5aa5a315";
     };
    meta = {
      homepage = https://github.com/altercation/vim-colors-solarized; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  colorsamplerpack = buildVimPlugin rec {
    version = "2012.10.28";
    name    = "colorsamplerpack-${version}";

    setSourceRoot = "sourceRoot=.";
    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=18915";
      name   = "colorsamplerpack.zip";
      sha256 = "1wsrb3vpqn9fncnalfpvc8r92wk1mcskm4shb3s2h9x5dyihf2rd";
    };

    buildInputs = [ unzip ];
  };

  command-t = buildVimPlugin rec {
    version = "1.8";
    name = "command-t-${version}";
    src = fetchzip {
      inherit name;
      url    = "https://github.com/wincent/Command-T/archive/${version}.tar.gz";
      sha256 = "186qz1smf7w91r68p724whg6d821f7ph6ks63l2vkhff8f9qqhrc";
    };
    buildInputs = [ perl ruby ];
    buildPhase = ''
      pushd ruby/command-t
      ruby extconf.rb
      make
      popd
    '';
  };

  command_T = command-t; # backwards compat, added 2014-10-18

  commentary = buildVimPlugin {
    name = "commentary-git-2014-06-27";
    src = fetchgit {
      url = "https://github.com/tpope/vim-commentary.git";
      rev = "8b4df6ca0ba9cd117d97a8fd26b44b2439d5e3f1";
      sha256 = "5496ed31706552957d4caa76669ecd04e9b2853cf7a7e40bd0164726b21fcca0";
     };
    meta = {
      homepage = https://github.com/tpope/vim-commentary; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  ctrlp = buildVimPlugin rec {
    version = "1.79";
    name    = "ctrlp-${version}";

    setSourceRoot = "sourceRoot=.";
    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=19448";
      name   = "ctrlp_180.zip";
      sha256 = "1x9im8g0g27mxc3c9k7v0jg5bb1dmnbjygmqif5bizab5g69n2mi";
    };

    buildInputs = [ unzip ];
  };

  easy-align = buildVimPlugin {
    name = "easy-align-git-2014-10-03";
    src = fetchgit {
      url = "https://github.com/junegunn/vim-easy-align.git";
      rev = "2595ebf9333f3598502276b29f78ad39965bc595";
      sha256 = "1223b587c515169d4b735bf56f109f7bfc4f7c1327e76865f498309f7472ef78";
     };
    meta = {
      homepage = https://github.com/junegunn/vim-easy-align; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  easymotion = buildVimPlugin {
    name = "easymotion-git-2014-09-29";
    src = fetchgit {
      url = "https://github.com/lokaltog/vim-easymotion.git";
      rev = "868cd71710a48e8ec8acffeabd1eebfb10812c77";
      sha256 = "13c8b93c257fcbb0f6e0eb197700b4f8cbe4cf4846d29f1aba65f625202b9d77";
     };
    meta = {
      homepage = https://github.com/lokaltog/vim-easymotion; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  eighties = buildVimPlugin rec {
    version = "1.0.4";
    name = "eighties-${version}";
    src = fetchurl {
      url    = "https://github.com/justincampbell/vim-eighties/archive/${version}.tar.gz";
      sha256 = "0cjd9hbg2qd7jjkvyi15f9ysp7m3aa2sg8nvbf80yb890rfkwaqr";
    };
    meta = with stdenv.lib; {
      description = "Automatically resizes your windows to 80 characters";
      homepage    = https://github.com/justincampbell/vim-eighties;
      license     = licenses.publicDomain;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  extradite = buildVimPlugin {
    name = "extradite-git-2014-06-18";
    src = fetchgit {
      url = "https://github.com/int3/vim-extradite.git";
      rev = "af4f3a51b6b654d655121b93c0cd9d8fe9a0c85d";
      sha256 = "d1d29cfbc654134be383747f2cd6b14b7a87de75f997af6a041f14d7ef61ade6";
     };
    meta = {
      homepage = https://github.com/int3/vim-extradite; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  fugitive = buildVimPlugin {
    name = "fugitive-git-2014-09-02";
    src = fetchgit {
      url = "https://github.com/tpope/vim-fugitive.git";
      rev = "0374322ba5d85ae44dd9dc44ef31ca015a59097e";
      sha256 = "3bb09693726c4f9fc1695bc8b40c45d64a6a0f1d9a4243b4a79add841013ad6c";
     };
    meta = {
      homepage = https://github.com/tpope/vim-fugitive; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  ghcmod-vim = buildVimPlugin {
    name = "ghcmod-vim-git-2014-10-19";
    src = fetchgit {
      url = "https://github.com/eagletmt/ghcmod-vim.git";
      rev = "d5c6c7f3c85608b5b76dc3e7e001f60b86c32cb9";
      sha256 = "ab56d470ea18da3fae021e22bba14460505e61a94f8bf707778dff5eec51cd6d";
     };
    meta = {
      homepage = https://github.com/eagletmt/ghcmod-vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  gist-vim = buildVimPlugin {
    name = "gist-vim-git-2014-10-19";
    src = fetchgit {
      url = "https://github.com/mattn/gist-vim.git";
      rev = "9265aaa3fb3f090a292c3fb883eab4cea9d2a722";
      sha256 = "2a1b6c589a60af7acd68f7686d1cbadc60a1da8a407b02d96f86ddfe8bc70c18";
     };
    buildInputs = [ zip ];
    meta = {
      homepage = https://github.com/mattn/gist-vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  gitgutter = buildVimPlugin {
    name = "gitgutter-git-2014-10-17";
    src = fetchgit {
      url = "https://github.com/airblade/vim-gitgutter.git";
      rev = "39f011909620e0c7ae555efdace20c3963ac88af";
      sha256 = "585c367c8cf72d7ef511b3beca3d1eae1d68bbd61b9a8d4dc7aea6e0caa4813a";
     };
    meta = {
      homepage = https://github.com/airblade/vim-gitgutter; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  golang = buildVimPlugin {
    name = "golang-git-2014-08-06";
    src = fetchgit {
      url = "https://github.com/jnwhiteh/vim-golang.git";
      rev = "e6d0c6a72a66af2674b96233c4747661e0f47a8c";
      sha256 = "1231a2eff780dbff4f885fcb4f656f7dd70597e1037ca800470de03bf0c5e7af";
     };
    meta = {
      homepage = https://github.com/jnwhiteh/vim-golang; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  gundo = buildVimPlugin {
    name = "gundo-git-2013-08-11";
    src = fetchgit {
      url = "https://github.com/vim-scripts/gundo.git";
      rev = "f443470b96364c24a775629418a6b2562ec9173e";
      sha256 = "b7a949167e59c936d6eae0d23635b87491b2cd2f46a197683b171d30165a90f9";
     };
    meta = {
      homepage = https://github.com/vim-scripts/gundo; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  hardtime = buildVimPlugin {
    name = "hardtime-git-2014-10-21";
    src = fetchgit {
      url = "https://github.com/takac/vim-hardtime.git";
      rev = "b401c72528d1c23e4cc9bc9585fda4361d0199bf";
      sha256 = "65e4bda7531076147fc46f496c8e56c740d1fcf8fe85c18cb2d2070d0c3803cd";
     };
    meta = {
      homepage = https://github.com/takac/vim-hardtime; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  haskellconceal = buildVimPlugin {
    name = "haskellconceal-git-2014-08-07";
    src = fetchgit {
      url = "https://github.com/twinside/vim-haskellconceal.git";
      rev = "1d85e8f10b675d38ec117368ec8032f486c27f98";
      sha256 = "8ae762939ea435333031a094f3c63e6edd534ac849f0008fa0440440f1f2f633";
     };
    meta = {
      homepage = https://github.com/twinside/vim-haskellconceal; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  haskellConceal = haskellconceal; # backwards compat, added 2014-10-18

  hasksyn = buildVimPlugin {
    name = "hasksyn-git-2014-09-03";
    src = fetchgit {
      url = "https://github.com/travitch/hasksyn.git";
      rev = "c434040bf13a17ca20a551223021b3ace7e453b9";
      sha256 = "b1a735928aeca7011b83133959d59b9c95ab8535fd00ce9968fae4c3b1381931";
     };
    meta = {
      homepage = https://github.com/travitch/hasksyn; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  hdevtools = buildVimPlugin {
    name = "hdevtools-git-2012-12-29";
    src = fetchgit {
      url = "https://github.com/bitc/vim-hdevtools.git";
      rev = "474947c52ff9c93dd36f3c49de90bd9a78f0baa1";
      sha256 = "bf5f096b665c51ce611c6c1bfddc3267c4b2f94af84b04482b07272a6a5a92f3";
     };
    meta = {
      homepage = https://github.com/bitc/vim-hdevtools; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  hier = buildVimPlugin {
    name = "hier-git-2011-08-27";
    src = fetchgit {
      url = "https://github.com/jceb/vim-hier.git";
      rev = "0b8c365263551a67404ebd7e528c55e17c1d3de7";
      sha256 = "f62836545abfe379f9c5410da28409947407cd282ef784b2db89aed0756a1785";
     };
    buildInputs = [ vim ];
    meta = {
      homepage = https://github.com/jceb/vim-hier; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };


  hoogle = buildVimPlugin {
    name = "hoogle-git-2013-11-26";
    src = fetchgit {
      url = "https://github.com/twinside/vim-hoogle.git";
      rev = "81f28318b0d4174984c33df99db7752891c5c4e9";
      sha256 = "0f96f3badb6218cac87d0f7027ff032ecc74f08ad3ada542898278ce11cbd5a0";
     };
    meta = {
      homepage = https://github.com/twinside/vim-hoogle; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  idris-vim = buildVimPlugin {
    name = "idris-vim-git-2014-10-14";
    src = fetchgit {
      url = "https://github.com/idris-hackers/idris-vim.git";
      rev = "78730e511cae0a067f79da1168466601553f619b";
      sha256 = "47638b25fa53203e053e27ec6f135fd63ae640edbe37e62d7450a8c434a4cc6b";
     };
    meta = {
      homepage = https://github.com/idris-hackers/idris-vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  ipython = buildVimPlugin {
    name = "ipython-git-2014-07-17";
    src = fetchgit {
      url = "https://github.com/ivanov/vim-ipython.git";
      rev = "9ce4f201ce26e9f01d56a6040ddf9255aab27272";
      sha256 = "444dede544f9b519143ecc3a6cdfef0c4c32043fc3cd69f92fdcd86c1010e824";
     };
    meta = {
      homepage = https://github.com/ivanov/vim-ipython; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  latex-box = buildVimPlugin {
    name = "latex-box-git-2014-10-05";
    src = fetchgit {
      url = "https://github.com/latex-box-team/latex-box.git";
      rev = "3e000fb161bdf6efe7aef517aef276554aeabb65";
      sha256 = "462803aceec5904943074e11888482ef6c49c8a5e26d6728ebcb2c4f5dbbb6a4";
     };
    meta = {
      homepage = https://github.com/latex-box-team/latex-box; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  latex-live-preview = buildVimPlugin {
    name = "latex-live-preview-git-2013-11-25";
    src = fetchgit {
      url = "https://github.com/xuhdev/vim-latex-live-preview.git";
      rev = "18625ceca4de5984f3df50cdd0202fc13eb9e37c";
      sha256 = "261852d3830189a50176f997a4c6b4ec7e25893c5b7842a3eb57eb7771158722";
     };
    meta = {
      homepage = https://github.com/xuhdev/vim-latex-live-preview; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  lushtags = buildVimPlugin {
    name = "lushtags-git-2013-12-27";
    src = fetchgit {
      url = "https://github.com/bitc/lushtags.git";
      rev = "429fab3b748ae04ee5de0cbf75d947f15441e798";
      sha256 = "5170019fbe64b15be30a0ba82e6b01364d115ccad6ef690a6df86f73af22a0a7";
     };
    meta = {
      homepage = https://github.com/bitc/lushtags; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  neco-ghc = buildVimPlugin {
    name = "neco-ghc-git-2014-10-17";
    src = fetchgit {
      url = "https://github.com/eagletmt/neco-ghc.git";
      rev = "fffdf57dcb312f874a43a202157b5efecfe3d9de";
      sha256 = "464b24e3151ebaf0e95c25f09cb047e2542d5dd9100087e538d0a5e46bd0e638";
     };
    meta = {
      homepage = https://github.com/eagletmt/neco-ghc; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  necoGhc = neco-ghc; # backwards compat, added 2014-10-18

  nerdcommenter = buildVimPlugin {
    name = "nerdcommenter-git-2014-07-08";
    src = fetchgit {
      url = "https://github.com/scrooloose/nerdcommenter.git";
      rev = "6549cfde45339bd4f711504196ff3e8b766ef5e6";
      sha256 = "ef270ae5617237d68b3d618068e758af8ffd8d3ba27a3799149f7a106cfd178e";
     };
    meta = {
      homepage = https://github.com/scrooloose/nerdcommenter; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  nerdtree = buildVimPlugin {
    name = "nerdtree-git-2014-08-06";
    src = fetchgit {
      url = "https://github.com/scrooloose/nerdtree.git";
      rev = "4f1e6ecb057fc0bac189171c1430d71ef25f6bb1";
      sha256 = "67ff2e7b9a7f39e58e9e334b1b79343a4c11aae10a657ab4fece289d8fe59300";
     };
    meta = {
      homepage = https://github.com/scrooloose/nerdtree; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  pathogen = buildVimPlugin {
    name = "pathogen-git-2014-07-19";
    src = fetchgit {
      url = "https://github.com/tpope/vim-pathogen.git";
      rev = "91e6378908721d20514bbe5d18d292a0a15faf0c";
      sha256 = "24c1897d6b58576b2189c90050a7f8ede72a51343c752e9d030e833dbe5cac6f";
     };
    meta = {
      homepage = https://github.com/tpope/vim-pathogen; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  quickfixstatus = buildVimPlugin {
    name = "quickfixstatus-git-2011-09-02";
    src = fetchgit {
      url = "https://github.com/dannyob/quickfixstatus.git";
      rev = "fd3875b914fc51bbefefa8c4995588c088163053";
      sha256 = "7b6831d5da1c23d95f3158c67e4376d32c2f62ab2e30d02d3f3e14dcfd867d9b";
     };
    meta = {
      homepage = https://github.com/dannyob/quickfixstatus; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  quickrun = buildVimPlugin {
    name = "quickrun-git-2014-10-08";
    src = fetchgit {
      url = "https://github.com/thinca/vim-quickrun.git";
      rev = "ae97cef42ae142306e9431dce9ab97c4353e5254";
      sha256 = "3219fadb3732c895c82b8bcff1d6e86f0917cd5ac7bf34180c27bb3f75ed1787";
     };
    meta = {
      homepage = https://github.com/thinca/vim-quickrun; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };


  rainbow_parentheses = buildVimPlugin {
    name = "rainbow_parentheses-git-2013-03-04";
    src = fetchgit {
      url = "https://github.com/kien/rainbow_parentheses.vim.git";
      rev = "eb8baa5428bde10ecc1cb14eed1d6e16f5f24695";
      sha256 = "47975a426d06f41811882691d8a51f32bc72f590477ed52b298660486b2488e3";
     };
    meta = {
      homepage = https://github.com/kien/rainbow_parentheses.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  rust = buildVimPlugin {
    name = "rust-git-2014-10-15";
    src = fetchgit {
      url = "https://github.com/wting/rust.vim.git";
      rev = "aaeb7b51f1b188fb1edc29c3a3824053b3e5e265";
      sha256 = "be858b1e2cb0b37091a3d79a51e264b3101229b007cfc16bcd28c740f3823c01";
     };
    meta = {
      homepage = https://github.com/wting/rust.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  shabadou = buildVimPlugin {
    name = "shabadou-git-2014-07-27";
    src = fetchgit {
      url = "https://github.com/osyo-manga/shabadou.vim.git";
      rev = "c5af30bb0c028d53cfd89e00cab636c844034a9a";
      sha256 = "392efa8a5e725219e478b571d9a30ddba88d47662467ed3123a168e8b55c4de6";
     };
    meta = {
      homepage = https://github.com/osyo-manga/shabadou.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  stylish-haskell = buildVimPlugin {
    name = "stylish-haskell-git-2014-07-14";
    src = fetchgit {
      url = "https://github.com/nbouscal/vim-stylish-haskell.git";
      rev = "453fd203aee3d7305ea8e4088ff53bd1f5933d75";
      sha256 = "c0e5010e1e8e56b179ce500387afb569f051c45b37ce92feb4350f293df96a8c";
     };
    meta = {
      homepage = https://github.com/nbouscal/vim-stylish-haskell; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  stylishHaskell = stylish-haskell; # backwards compat, added 2014-10-18

  supertab = buildVimPlugin {
    name = "supertab-git-2014-10-17";
    src = fetchgit {
      url = "https://github.com/ervandew/supertab.git";
      rev = "fd4e0d06c2b1d9bff2eef1d15e7895b3b4da7cd7";
      sha256 = "5919521b95519d4baa8ed146c340ca739fa7f31dfd305c74ca0ace324ba93d74";
     };
    buildInputs = [ vim ];
    meta = {
      homepage = https://github.com/ervandew/supertab; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  surround = buildVimPlugin {
    name = "surround-git-2014-07-26";
    src = fetchgit {
      url = "https://github.com/tpope/vim-surround.git";
      rev = "fa433e0b7330753688f715f3be5d10dc480f20e5";
      sha256 = "5f01daf72d23fc065f4e4e8eac734275474f32bfa276a9d90ce0d20dfe24058d";
     };
    meta = {
      homepage = https://github.com/tpope/vim-surround; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  signature = buildVimPlugin {
    name = "signature-git-2014-10-17";
    src = fetchgit {
      url = "https://github.com/kshenoy/vim-signature.git";
      rev = "f012d6f4d288ef6006f61b06f5240bc461a1f89e";
      sha256 = "bef5254e343758d609856c745fe9d83639546f3af4ca50542429c1cb91ab577a";
     };
    meta = {
      homepage = https://github.com/kshenoy/vim-signature; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  syntastic = buildVimPlugin {
    name = "syntastic-git-2014-10-17";
    src = fetchgit {
      url = "https://github.com/scrooloose/syntastic.git";
      rev = "77c125170aa6b8c553d58f876021b0cedd8ac820";
      sha256 = "ec9b1e22134cb16d07bef842be26b4f1f74a9f8b9a0afd9ab771ff79935920af";
     };
    meta = {
      homepage = https://github.com/scrooloose/syntastic; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  table-mode = buildVimPlugin {
    name = "table-mode-git-2014-09-17";
    src = fetchgit {
      url = "https://github.com/dhruvasagar/vim-table-mode.git";
      rev = "ef0eef0f35f2ca172907f6d696dc8859acd8a0da";
      sha256 = "0377059972580f621f1bb4b35738e0e00d386b23d839115e8c5fa8fd3acbc98d";
     };
    meta = {
      homepage = https://github.com/dhruvasagar/vim-table-mode; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  tabmerge = buildVimPlugin {
    name = "tabmerge-git-2010-10-17";
    src = fetchgit {
      url = "https://github.com/vim-scripts/tabmerge.git";
      rev = "074e5f06f26e7108a0570071a0f938a821768c06";
      sha256 = "b84501b0fc5cd51bbb58f12f4c2b3a7c97b03fe2a76446b56a2c111bd4f7335f";
     };
    meta = {
      homepage = https://github.com/vim-scripts/tabmerge; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  tabular = buildVimPlugin {
    name = "tabular-git-2013-05-16";
    src = fetchgit {
      url = "https://github.com/godlygeek/tabular.git";
      rev = "60f25648814f0695eeb6c1040d97adca93c4e0bb";
      sha256 = "28c860ad621587f2c3213fae47d1a3997746527c17d51e9ab94c209eb7bfeb0f";
     };
    meta = {
      homepage = https://github.com/godlygeek/tabular; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  tagbar = buildVimPlugin {
    name = "tagbar-git-2014-10-14";
    src = fetchgit {
      url = "https://github.com/majutsushi/tagbar.git";
      rev = "64e935fe5812d3b7022aba1dee63ec9f7456b02f";
      sha256 = "2a66b86328e395bd594c8673a6420307a32468e4040dafe2b877ad4afcf6b7f9";
     };
    meta = {
      homepage = https://github.com/majutsushi/tagbar; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  taglist = buildVimPlugin {
    name = "taglist-4.6";
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
  };

  thumbnail = buildVimPlugin {
    name = "thumbnail-git-2014-07-24";
    src = fetchgit {
      url = "https://github.com/itchyny/thumbnail.vim.git";
      rev = "e59a1791862ed470510a58456cc001226e177a39";
      sha256 = "f36d915804e36b5f2dcea7db481da97ec60d0c90df87599a5d5499e649d97f66";
     };
    meta = {
      homepage = https://github.com/itchyny/thumbnail.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  tmux-navigator = buildVimPlugin {
    name = "tmux-navigator-git-2014-09-09";
    src = fetchgit {
      url = "https://github.com/christoomey/vim-tmux-navigator.git";
      rev = "195cdf087fea7beaf6274d0a655d157dfab3130c";
      sha256 = "4235c2bfb64a9094b854cdd7303a64bbb994717f24704911c4b358b2373dfaa9";
     };
    meta = {
      homepage = https://github.com/christoomey/vim-tmux-navigator; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  tmuxNavigator = tmux-navigator; # backwards compat, added 2014-10-18

  tslime = buildVimPlugin {
    name = "tslime-git-2014-06-12";
    src = fetchgit {
      url = "https://github.com/jgdavey/tslime.vim.git";
      rev = "e801a32b27d83cb5d91afbf7c3d71bb6220f32bd";
      sha256 = "47fb7165c1dcc444285cdff6fa89bbd4ace82ca79ec14ba0da6091c5f78d1251";
     };
    meta = {
      homepage = https://github.com/jgdavey/tslime.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  ultisnips = buildVimPlugin {
    name = "ultisnips-git-2014-10-11";
    src = fetchgit {
      url = "https://github.com/sirver/ultisnips.git";
      rev = "1ad970379edaec1a386bab5ff26c385b9e89a0ff";
      sha256 = "5d6858a153d79f596513d01d4ed9cd6dcff853e2c42c4b4546d38bd15423af98";
     };
    meta = {
      homepage = https://github.com/sirver/ultisnips; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  undotree = buildVimPlugin {
    name = "undotree-git-2014-09-17";
    src = fetchgit {
      url = "https://github.com/mbbill/undotree.git";
      rev = "14655d87774b1f35b5bd23c6de64f535d90ed48d";
      sha256 = "ad55b88db051f57d0c7ddc226a7b7778daab58fa67dc8ac1d78432c0e7d38520";
     };
    meta = {
      homepage = https://github.com/mbbill/undotree; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  vim2hs = buildVimPlugin {
    name = "vim2hs-git-2014-04-16";
    src = fetchgit {
      url = "https://github.com/dag/vim2hs.git";
      rev = "f2afd55704bfe0a2d66e6b270d247e9b8a7b1664";
      sha256 = "485fc58595bb4e50f2239bec5a4cbb0d8f5662aa3f744e42c110cd1d66b7e5b0";
     };
    meta = {
      homepage = https://github.com/dag/vim2hs; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  vimoutliner = buildVimPlugin {
    name = "vimoutliner-git-2014-10-20";
    src = fetchgit {
      url = "https://github.com/vimoutliner/vimoutliner.git";
      rev = "4e924d9e42b6955a696e087d22795f5fe0e6c857";
      sha256 = "6a9a27526c51202fb15374b40c5a759df0e10977dbe3045dabef0439c3e62c72";
     };
    meta = {
      homepage = https://github.com/vimoutliner/vimoutliner; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  vimproc = buildVimPlugin {
    name = "vimproc-git-2014-10-03";
    src = fetchgit {
      url = "https://github.com/shougo/vimproc.vim.git";
      rev = "3e055023dfab4f5a4dfa05a834f9d0cb7294a82e";
      sha256 = "63c2786897e8315eed2473822879b7ceb847e6021695a861892d7b9ab15a69fb";
     };
    buildInputs = [ which ];

    buildPhase = ''
      sed -i 's/vimproc_mac\.so/vimproc_unix\.so/' autoload/vimproc.vim
      make -f make_unix.mak
    '';

    meta = {
      homepage = https://github.com/shougo/vimproc.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  vimshell = buildVimPlugin rec {
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
  };

  vundle = buildVimPlugin {
    name = "vundle-git-2014-07-18";
    src = fetchgit {
      url = "https://github.com/gmarik/vundle.vim.git";
      rev = "0b28e334e65b6628b0a61c412fcb45204a2f2bab";
      sha256 = "9681d471d1391626cb9ad22b2b469003d9980cd23c5c3a8d34666376447e6204";
     };
    meta = {
      homepage = https://github.com/gmarik/vundle.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  watchdogs = buildVimPlugin {
    name = "watchdogs-git-2014-10-18";
    src = fetchgit {
      url = "https://github.com/osyo-manga/vim-watchdogs.git";
      rev = "ad222796eb88b44954340c19c39938046af26e05";
      sha256 = "4c621ac2834864cf0c46f776029837913e1ba0c725a12d7cb24bf92e04ed1279";
     };
    meta = {
      homepage = https://github.com/osyo-manga/vim-watchdogs; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  webapi-vim = buildVimPlugin {
    name = "webapi-vim-git-2014-10-19";
    src = fetchgit {
      url = "https://github.com/mattn/webapi-vim.git";
      rev = "99e11199838ccbeb7213cbc30698200170d355c9";
      sha256 = "599e282ef45bf6587c34579ab08d4e4a1f2cb54589e1e386c75d701880c90b9e";
     };
    buildInputs = [ zip ];
    meta = {
      homepage = https://github.com/mattn/webapi-vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  wombat256 = buildVimPlugin {
    name = "wombat256-git-2010-10-17";
    src = fetchgit {
      url = "https://github.com/vim-scripts/wombat256.vim.git";
      rev = "8734ba45dcf5e38c4d2686b35c94f9fcb30427e2";
      sha256 = "2feb7d57ab0a9f2ea44ccd606e540db64ab3285956398a50ecc562d7b8dbcd05";
     };
    meta = {
      homepage = https://github.com/vim-scripts/wombat256.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  xdebug = buildVimPlugin {
    name = "xdebug-git-2012-08-15";
    src = fetchgit {
      url = "https://github.com/joonty/vim-xdebug.git";
      rev = "a4980fa65f7f159780593ee37c178281691ba2c4";
      sha256 = "1ccb0e63eaf68548feb1c37b09c07c84b6bea9b350c4257549f091aa414601e2";
     };
    postInstall = false;
    meta = {
      homepage = https://github.com/joonty/vim-xdebug; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  yankring = buildVimPlugin rec {
    version = "18.0";
    name    = "yankring-${version}";

    setSourceRoot = "sourceRoot=.";
    src = fetchurl {
      url    = "http://www.vim.org/scripts/download_script.php?src_id=20842";
      name   = "yankring_180.zip";
      sha256 = "0bsq4pxagy12jqxzs7gcf25k5ahwif13ayb9k8clyhm0jjdkf0la";
    };

    buildInputs = [ unzip ];
  };

  vim-addon-nix = {
    # github.com/MarcWeber/vim-addon-nix provides some additional support for
    # editing .nix files

    # This is a placeholder, because I think you always should be using latest
    # git version. It also depends on some additional plugins (see addon-info.json)
  };

  youcompleteme = stdenv.mkDerivation {
    src = fetchgit {
      url = "https://github.com/Valloric/YouCompleteMe.git";
      rev = "87b42c689391b69968950ae99c3aaacf2e14c329";
      sha256 = "1f3pywv8bsqyyakvyarg7z9m73gmvp1lfbfp2f2jj73jmmlzb2kv";
     };

    name = "vimplugin-youcompleteme-2014-10-06";

    buildInputs = [ python cmake clang.clang ];

    configurePhase = ":";

    buildPhase = ''
      patchShebangs .

      target=$out/share/vim-plugins/youcompleteme
      mkdir -p $target
      cp -a ./ $target

      mkdir $target/build
      cd $target/build
      cmake -G "Unix Makefiles" . $target/third_party/ycmd/cpp -DPYTHON_LIBRARIES:PATH=${python}/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR:PATH=${python}/include/python2.7 -DUSE_CLANG_COMPLETER=ON -DUSE_SYSTEM_LIBCLANG=ON
      make ycm_support_libs -j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}
      ${bash}/bin/bash $target/install.sh --clang-completer --system-libclang

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

  YouCompleteMe = youcompleteme; # backwards compat, added 2014-10-18

}

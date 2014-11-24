# TODO check that no license information gets lost
{ fetchurl, bash, stdenv, python, cmake, vim, perl, ruby, unzip, which, fetchgit, fetchzip, llvmPackages, zip }:

/*
Typical plugin files:

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

Its what pathogen, vundle, vim-addon-manager (VAM) and others use.
Learn about some differences by visiting http://vim-wiki.mawercer.de/wiki/topic/vim%20plugin%20managment.html.

If you want Nix to create a .vimrc for you have a look at vimrc in all-packages.nix.
It also contains VAM code illustrating how to make VAM find plugins in arbitrary locations
*/

# provide a function creating tag files for vim help documentation (doc/*.txt)

let rtpPath = "share/vim-plugins";

    vimHelpTags = ''
    vimHelpTags(){
      if [ -d "$1/doc" ]; then
        ${vim}/bin/vim -N -u NONE -i NONE -n -e -s -c "helptags $1/doc" +quit!
      fi
    }
  '';

  addRtp = path: derivation:
    derivation // { rtp = "${derivation}/${path}"; };

  buildVimPlugin = a@{
    name,
    namePrefix ? "vimplugin-",
    src,
    buildPhase ? "",
    path ? (builtins.parseDrvName name).name,
    ...
  }:
    addRtp "${rtpPath}/${path}" (stdenv.mkDerivation (a // {
      name = namePrefix + name;

      inherit buildPhase;

      installPhase = ''
        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target
        ${vimHelpTags}
        vimHelpTags $target
      '';
    }));

in

# The attr names in this set should be equal to names used in the vim-pi project [1] so that
# VAM's dependencies work. How to find the name?
#  * http://vam.mawercer.de/ or VAM's
#  * grep vim-pi
#  * use VAM's completion or :AddonsInfo command
#
# How to create derivations? Experimental derivation creation is provided by VAM, example usage:
# call nix#ExportPluginsForNix({'path_to_nixpkgs': '/etc/nixos/nixpkgs', 'names': ["vim-addon-manager", "vim-addon-nix"], 'cache_file': 'cache'})
#
# [1] https://bitbucket.org/vimcommunity/vim-pi
/*
    Some of the plugin definitions below are generated the following VimL command
    provided by vim-addon-manager.

    " Copy /tmp/tmp.vim file and run: :source /tmp/tmp.vim
    call nix#ExportPluginsForNix({
    \  'path_to_nixpkgs': '/etc/nixos/nixpkgs',
    \  'cache_file': '/tmp/vim2nix-cache',
    \  'names': [
    \    "vim-addon-syntax-checker",
    \    "vim-addon-other",
    \    "vim-addon-local-vimrc",
    \    "snipmate",
    \    "vim-snippets",
    \    "vim-addon-mru",
    \    "vim-addon-commenting",
    \    "vim-addon-sql",
    \    "vim-addon-async",
    \    "vim-addon-toggle-buffer",
    \    "vim-addon-mw-utils",
    \    "matchit.zip",
    \    "vim-addon-xdebug",
    \    "vim-addon-php-manual",
    \    "sourcemap.vim",
    \    "vim-iced-coffee-script",
    \    "ctrlp",
    \    "commentary",
    \    "Colour_Sampler_Pack",
    \    "Solarized",
    \    "vim-coffee-script",
    \    "vim-easy-align",
    \    "Tagbar",
    \    "Tabular",
    \    "table-mode",
    \    "Syntastic",
    \    "vim-signature",
    \    "surround",
    \    "Supertab",
    \    "rust",
    \    "rainbow_parentheses",
    \    "pathogen",
    \    "quickfixstatus",
    \    "The_NERD_Commenter",
    \    "The_NERD_tree",
    \    "vim-latex-live-preview",
    \    "Hoogle",
    \    "Gundo",
    \    "vim-gitgutter",
    \    "Gist",
    \    "ghcmod",
    \    "fugitive",
    \    "extradite",
    \    "vim-airline",
    \    "VimOutliner",
    \    "vim2hs",
    \    "undotree",
    \    "UltiSnips",
    \    "wombat256",
    \    "vundle",
    \    "WebAPI",
    \    "YankRing",
    \    "vim-addon-manager",
    \    "vim-addon-nix",
    \    "YUNOcommit"
    \ ],
    \ })

# TODO: think about how to add license information?
*/

rec {
  inherit rtpPath;

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

  airline = vim-airline;

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

  alternative = a; # backwards compat, added 2014-10-21

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

  coffee-script = vim-coffee-script;

  coffeeScript = coffee-script; # backwards compat, added 2014-10-18

  colors-solarized = Solarized;

  colorsamplerpack = Colour_Sampler_Pack;

  Colour_Sampler_Pack = buildVimPlugin {
    name = "Colour_Sampler_Pack";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=18915";
      name = "ColorSamplerPack.zip";
      sha256 = "1wsrb3vpqn9fncnalfpvc8r92wk1mcskm4shb3s2h9x5dyihf2rd";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=625";
    };
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
    name = "commentary";
    src = fetchgit {
      url = "git://github.com/tpope/vim-commentary";
      rev = "401dbd8abee69defe66acf5e9ccc85e2746c27e2";
      sha256 = "3deec79d6c40a6c91fa504423f38c9f6a9e3495804f1996e2420d0ad34fe2da8";
    };
    dependencies = [];
  };

  ctrlp = buildVimPlugin {
    name = "ctrlp";
    src = fetchgit {
      url = "git://github.com/kien/ctrlp.vim";
      rev = "b5d3fe66a58a13d2ff8b6391f4387608496a030f";
      sha256 = "41f7884973770552395b96f8693da70999dc815462d4018c560d3ff6be462e76";
    };
    dependencies = [];
  };

  easy-align = vim-easy-align;

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
    name = "extradite";
    src = fetchgit {
      url = "git://github.com/int3/vim-extradite";
      rev = "af4f3a51b6b654d655121b93c0cd9d8fe9a0c85d";
      sha256 = "d1d29cfbc654134be383747f2cd6b14b7a87de75f997af6a041f14d7ef61ade6";
    };
    dependencies = [];
  };

  fugitive = buildVimPlugin {
    name = "fugitive";
    src = fetchgit {
      url = "git://github.com/tpope/vim-fugitive";
      rev = "0374322ba5d85ae44dd9dc44ef31ca015a59097e";
      sha256 = "3bb09693726c4f9fc1695bc8b40c45d64a6a0f1d9a4243b4a79add841013ad6c";
    };
    dependencies = [];
  };

  ghc-mod-vim = ghcmod;

  ghcmod = buildVimPlugin {
    name = "ghcmod";
    src = fetchgit {
      url = "git://github.com/eagletmt/ghcmod-vim";
      rev = "d5c6c7f3c85608b5b76dc3e7e001f60b86c32cb9";
      sha256 = "ab56d470ea18da3fae021e22bba14460505e61a94f8bf707778dff5eec51cd6d";
    };
    dependencies = [];
  };

  Gist = buildVimPlugin {
    name = "Gist";
    src = fetchgit {
      url = "git://github.com/mattn/gist-vim";
      rev = "d609d93472db9cf45bd701bebe51adc356631547";
      sha256 = "e5cabc03d5015c589a32f11c654ab9fbd1e91d26ba01f4b737685be81852c511";
    };
    buildInputs = [ zip ];
    dependencies = [];
  };

  gist-vim = Gist;

  gitgutter = vim-gitgutter;

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

  Gundo = buildVimPlugin {
    name = "Gundo";
    src = fetchgit {
      url = "https://bitbucket.org/sjl/gundo.vim";
      rev = "";
      sha256 = "";
    };
    dependencies = [];
  };

  gundo = Gundo;

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

  Hoogle = buildVimPlugin {
    name = "Hoogle";
    src = fetchgit {
      url = "git://github.com/Twinside/vim-hoogle";
      rev = "81f28318b0d4174984c33df99db7752891c5c4e9";
      sha256 = "0f96f3badb6218cac87d0f7027ff032ecc74f08ad3ada542898278ce11cbd5a0";
    };
    dependencies = [];
  };

  hoogle = Hoogle;

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

  latex-live-preview = vim-latex-live-preview;

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

  matchit.zip = buildVimPlugin {
    name = "matchit.zip";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=8196";
      name = "matchit.zip";
      sha256 = "1bbm8j1bhb70kagwdimwy9vcvlrz9ax5bk2a7wrmn4cy87f9xj4l";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=39";
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

  neocomplete = buildVimPlugin {
    name = "neocomplete-git-2014-11-18";
    src = fetchgit {
      url = "https://github.com/Shougo/neocomplete.vim.git";
      rev = "26aef680ece29047089e7540b78696f1e6336be2";
      sha256 = "42734ddb29f6661de687e0d18c5ddbd443adc6d2f69fe8e44d0e47473f1bc0ae";
     };
    meta = {
      homepage = https://github.com/Shougo/neocomplete.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  neosnippet = buildVimPlugin {
    name = "neosnippet-git-2014-11-18";
    src = fetchgit {
      url = "https://github.com/Shougo/neosnippet.vim.git";
      rev = "811176b29b1a60a164c9878f8dcbe4a680ee32e5";
      sha256 = "903b6fa01511e319e5ce3efa3a7007047512f5f7ee7d61b69cd4a324420cf718";
     };
    meta = {
      homepage = https://github.com/Shougo/neosnippet.vim; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  neosnippet-snippets = buildVimPlugin {
    name = "neosnippet-snippets-git-2014-11-17";
    src = fetchgit {
      url = "https://github.com/Shougo/neosnippet-snippets.git";
      rev = "a15cdc307a62d64c3510b4a1097a8bd174746894";
      sha256 = "8d69b93163dd93474422bf4f362130151f25e2c9fad3500ba170161c24bf5bce";
     };
    meta = {
      homepage = https://github.com/Shougo/neosnippet-snippets; 
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  nerdcommenter = The_NERD_Commenter;

  nerdtree = The_NERD_tree;

  pathogen = buildVimPlugin {
    name = "pathogen";
    src = fetchgit {
      url = "git://github.com/tpope/vim-pathogen";
      rev = "91e6378908721d20514bbe5d18d292a0a15faf0c";
      sha256 = "24c1897d6b58576b2189c90050a7f8ede72a51343c752e9d030e833dbe5cac6f";
    };
    dependencies = [];
  };

  quickfixstatus = buildVimPlugin {
    name = "quickfixstatus";
    src = fetchgit {
      url = "git://github.com/dannyob/quickfixstatus";
      rev = "fd3875b914fc51bbefefa8c4995588c088163053";
      sha256 = "7b6831d5da1c23d95f3158c67e4376d32c2f62ab2e30d02d3f3e14dcfd867d9b";
    };
    dependencies = [];
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

  racer = buildVimPlugin {
    name = "racer-git-2014-11-24";
    src = fetchgit {
      url = https://github.com/phildawes/racer;
      rev = "50655ffd509bea09ea9b310970dedfeaf5a33cf3";
      sha256 = "0bd456i4nz12z39ljnw1kjg8mcflvm7rjql2r80fb038c7rd6xi1";
    };
    buildPhase = ''
      find . -type f -not -name 'racer.vim' -exec rm -rf {} \;
      mkdir plugin
      mv ./editors/racer.vim plugin/racer.vim
      rm -rf editors images src
    '';
    meta = {
      homepage = https://github.com/phildawes/racer;
      maintainers = [ stdenv.lib.maintainers.jagajaga ];
    };
  };

  rainbow_parentheses = buildVimPlugin {
    name = "rainbow_parentheses";
    src = fetchgit {
      url = "git://github.com/kien/rainbow_parentheses.vim";
      rev = "eb8baa5428bde10ecc1cb14eed1d6e16f5f24695";
      sha256 = "47975a426d06f41811882691d8a51f32bc72f590477ed52b298660486b2488e3";
    };
    dependencies = [];
  };

  rust = buildVimPlugin {
    name = "rust";
    src = fetchgit {
      url = "git://github.com/wting/rust.vim";
      rev = "0cf510adc5a83ad4c256f576fd36b38c74349d43";
      sha256 = "839f4ea2e045fc41fa2292882576237dc36d714bd78e46728c6696c44d2851d8";
    };
    dependencies = [];
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

  signature = vim-signature;

  snipmate = buildVimPlugin {
    name = "snipmate";
    src = fetchgit {
      url = "git://github.com/garbas/vim-snipmate";
      rev = "e6eb057a58e2fe98137997157d0eff9d1a975888";
      sha256 = "4d8f9091b92a75f21d96a6f6a862aa4ad5671ab8317ceef4498eeb14a1524190";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };

  Solarized = buildVimPlugin {
    name = "Solarized";
    src = fetchgit {
      url = "git://github.com/altercation/vim-colors-solarized";
      rev = "528a59f26d12278698bb946f8fb82a63711eec21";
      sha256 = "a1b2ef696eee94dafa76431c31ee260acdd13a7cf87939f27eca431d5aa5a315";
    };
    dependencies = [];
  };

  sourcemap.vim = buildVimPlugin {
    name = "sourcemap.vim";
    src = fetchgit {
      url = "git://github.com/chikatoike/sourcemap.vim";
      rev = "0dd82d40faea2fdb0771067f46c01deb41610ba1";
      sha256 = "a08c77aea39be4a0a980d62673d1d17fecc518a8aeb9101210e453aaacb78fbd";
    };
    dependencies = [];
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

  Supertab = buildVimPlugin {
    name = "Supertab";
    src = fetchgit {
      url = "git://github.com/ervandew/supertab";
      rev = "fd4e0d06c2b1d9bff2eef1d15e7895b3b4da7cd7";
      sha256 = "5919521b95519d4baa8ed146c340ca739fa7f31dfd305c74ca0ace324ba93d74";
    };
    dependencies = [];
  };

  supertab = Supertab;

  surround = buildVimPlugin {
    name = "surround";
    src = fetchgit {
      url = "git://github.com/tpope/vim-surround";
      rev = "fa433e0b7330753688f715f3be5d10dc480f20e5";
      sha256 = "5f01daf72d23fc065f4e4e8eac734275474f32bfa276a9d90ce0d20dfe24058d";
    };
    dependencies = [];
  };

  Syntastic = buildVimPlugin {
    name = "Syntastic";
    src = fetchgit {
      url = "git://github.com/scrooloose/syntastic";
      rev = "e4c94d67a9ba7f35397b4a2f0daa8f346a84a8b9";
      sha256 = "366b5568ddf0db0e35a19bbd3ae4d0dc4accaefe5fdd14159540d26a76e3a96e";
    };
    dependencies = [];
  };

  syntastic = Syntastic;

  table-mode = buildVimPlugin {
    name = "table-mode";
    src = fetchgit {
      url = "git://github.com/dhruvasagar/vim-table-mode";
      rev = "ea78f6256513b4b853ea01b55b18baf0f9d99f8c";
      sha256 = "570a9660b17489ec6a976d878aec45470bc91c8da41f0e3ab8f09962683b2da7";
    };
    dependencies = [];
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

  Tabular = buildVimPlugin {
    name = "Tabular";
    src = fetchgit {
      url = "git://github.com/godlygeek/tabular";
      rev = "60f25648814f0695eeb6c1040d97adca93c4e0bb";
      sha256 = "28c860ad621587f2c3213fae47d1a3997746527c17d51e9ab94c209eb7bfeb0f";
    };
    dependencies = [];
  };

  tabular = Tabular;

  Tagbar = buildVimPlugin {
    name = "Tagbar";
    src = fetchgit {
      url = "git://github.com/majutsushi/tagbar";
      rev = "5283bc834a8c39b058d5eef1173e323b23b04fa0";
      sha256 = "ed2bcbbb9caf476251cbbe650fc685b9e781390f9966f0c75ff02da0677deb1c";
    };
    dependencies = [];
  };

  tagbar = Tagbar;

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

  The_NERD_Commenter = buildVimPlugin {
    name = "The_NERD_Commenter";
    src = fetchgit {
      url = "git://github.com/scrooloose/nerdcommenter";
      rev = "6549cfde45339bd4f711504196ff3e8b766ef5e6";
      sha256 = "ef270ae5617237d68b3d618068e758af8ffd8d3ba27a3799149f7a106cfd178e";
    };
    dependencies = [];
  };

  The_NERD_tree = buildVimPlugin {
    name = "The_NERD_tree";
    src = fetchgit {
      url = "git://github.com/scrooloose/nerdtree";
      rev = "f8fd2ecce20f5005e6313ce57d6d2a209890c946";
      sha256 = "b86f8923d4068add210101d34c5272b575dcb1c1352992ee878af59db581fd75";
    };
    dependencies = [];
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

  tlib = buildVimPlugin {
    name = "tlib";
    src = fetchgit {
      url = "git://github.com/tomtom/tlib_vim";
      rev = "88c5a2427e12397f9b5b1819e3d80c2eebe2c411";
      sha256 = "6cbbeb7fcda26028f73836ce3bae880db3e250cf8289804e6e28cb914854b7de";
    };
    dependencies = [];
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

  UltiSnips = buildVimPlugin {
    name = "UltiSnips";
    src = fetchgit {
      url = "git://github.com/sirver/ultisnips";
      rev = "cb8536d7240f5f458c292f8aa38fc50278222fe8";
      sha256 = "95bc88fc3dae45896893797cff9bb697f3701572c27442898c661d004b50be16";
    };
    dependencies = [];
  };

  undotree = buildVimPlugin {
    name = "undotree";
    src = fetchgit {
      url = "git://github.com/mbbill/undotree";
      rev = "88e4a9bc2f7916f24441faf884853a01ba11d294";
      sha256 = "ad55b88db051f57d0c7ddc226a7b7778daab58fa67dc8ac1d78432c0e7d38520";
    };
    dependencies = [];
  };

  vim-addon-actions = buildVimPlugin {
    name = "vim-addon-actions";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-actions";
      rev = "a5d20500fb8812958540cf17862bd73e7af64936";
      sha256 = "d2c3eb7a1f29e7233c6fcf3b02d07efebe8252d404ee593419ad399a5fdf6383";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };

  vim-addon-async = buildVimPlugin {
    name = "vim-addon-async";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-async";
      rev = "dadc96e188f1cdacbac62129eb29a1eacfed792c";
      sha256 = "27f941e21a8ca5940bd20914e2a9e3809e554f3ef2c27b3bafb9a153107a5d07";
    };
    dependencies = ["vim-addon-signs"];
  };

  vim-addon-background-cmd = buildVimPlugin {
    name = "vim-addon-background-cmd";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-background-cmd";
      rev = "14df72660a95804a57c02b9ff0ae3198608e2491";
      sha256 = "5c2ece1f3ff7653eb7c1b40180554e8e89e5ae43d67e7cc159d95c0156135687";
    };
    dependencies = ["vim-addon-mw-utils"];
  };

  vim-addon-commenting = buildVimPlugin {
    name = "vim-addon-commenting";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-commenting";
      rev = "b7cf748ac1c9bf555cbd347589e3b7196030d20b";
      sha256 = "4ad7d5f6669f0a1b4a24c9ce3649c030d7d3fc8588de4d4d6c3269140fbe9b3e";
    };
    dependencies = [];
  };

  vim-addon-completion = buildVimPlugin {
    name = "vim-addon-completion";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-completion";
      rev = "80f717d68df5b0d7b32228229ddfd29c3e86e435";
      sha256 = "c8c0af8760f2622c4caef371482916861f68a850eb6a7cd746fe8c9ab405c859";
    };
    dependencies = ["tlib"];
  };

  vim-addon-errorformats = buildVimPlugin {
    name = "vim-addon-errorformats";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-errorformats";
      rev = "dcbb203ad5f56e47e75fdee35bc92e2ba69e1d28";
      sha256 = "a1260206545d5ae17f2e6b3319f5cf1808b74e792979b1c6667d75974cc53f95";
    };
    dependencies = [];
  };

  vim-addon-goto-thing-at-cursor = buildVimPlugin {
    name = "vim-addon-goto-thing-at-cursor";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-goto-thing-at-cursor";
      rev = "f052e094bdb351829bf72ae3435af9042e09a6e4";
      sha256 = "34658ac99d9a630db9c544b3dfcd2c3df69afa5209e27558cc022b7afc2078ea";
    };
    dependencies = ["tlib"];
  };

  vim-addon-local-vimrc = buildVimPlugin {
    name = "vim-addon-local-vimrc";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-local-vimrc";
      rev = "7689b55ee86dd6046923fd28ceab49da3881abfe";
      sha256 = "f11d13676e2fdfcc9cabc991577f0b2e85909665b6f245aa02f21ff78d6a8556";
    };
    dependencies = [];
  };

  vim-addon-manager = buildVimPlugin {
    name = "vim-addon-manager";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-manager";
      rev = "d6de0d52bfe338eb373a4908b51b0eb89eaf42b0";
      sha256 = "4becba76d3389e4ace9e01c4393bc7bf38767eecf9eee239689054b9ee0c1fc9";
    };
    dependencies = [];
  };

  vim-addon-mru = buildVimPlugin {
    name = "vim-addon-mru";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-mru";
      rev = "e41e39bd9d1bf78ccfd8d5e1bc05ae5e1026c2bb";
      sha256 = "15b70f796f28cbd999060fea7f47408fa8a6cb176cd4915b9cc3dc6c53eed960";
    };
    dependencies = ["vim-addon-other" "vim-addon-mw-utils"];
  };

  vim-addon-mw-utils = buildVimPlugin {
    name = "vim-addon-mw-utils";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-mw-utils";
      rev = "0c5612fa31ee434ba055e21c76f456244b3b5109";
      sha256 = "4e1b6d1b59050f1063e58ef4bee9e9603616ad184cd9ef7466d0ec3d8e22b91c";
    };
    dependencies = [];
  };

  vim-addon-nix = buildVimPlugin {
    name = "vim-addon-nix";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-nix";
      rev = "7b0a376bb1797fef8da2dc14e768f318bcb671e8";
      sha256 = "c2b0f6f50083063b5e801b872f38d4f00307fe5d7a4f3977a108e5cd10c1c410";
    };
    dependencies = ["vim-addon-completion" "vim-addon-goto-thing-at-cursor" "vim-addon-errorformats" "vim-addon-actions" "vim-addon-mw-utils" "tlib"];
  };

  vim-addon-other = buildVimPlugin {
    name = "vim-addon-other";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-other";
      rev = "f78720c9cb5bf871cabb13c7cbf94378dbf0163b";
      sha256 = "43f027e4b7576031072515c23c2b09f7f2c8bba7ee43a1e2041a4371bd954d1b";
    };
    dependencies = ["vim-addon-actions" "vim-addon-mw-utils"];
  };

  vim-addon-php-manual = buildVimPlugin {
    name = "vim-addon-php-manual";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-php-manual";
      rev = "e09ccdce3d2132771d0bd32884553207cc7122d0";
      sha256 = "b2f44be3a1ceca9de7789ea9b5fd36035b720ea529f4301f3771b010d1e453c2";
    };
    dependencies = [];
  };

  vim-addon-signs = buildVimPlugin {
    name = "vim-addon-signs";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-signs";
      rev = "17a49f293d18174ff09d1bfff5ba86e8eee8e8ae";
      sha256 = "a9c03a32e758d51106741605188cb7f00db314c73a26cae75c0c9843509a8fb8";
    };
    dependencies = [];
  };

  vim-addon-sql = buildVimPlugin {
    name = "vim-addon-sql";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-sql";
      rev = "05b8a0c211f1ae4c515c64e91dec555cdf20d90b";
      sha256 = "a1334ae694e0a03229bacc8ba7e08e7223df240244c7378e3f1bd91d74e957c2";
    };
    dependencies = ["vim-addon-completion" "vim-addon-background-cmd" "tlib"];
  };

  vim-addon-syntax-checker = buildVimPlugin {
    name = "vim-addon-syntax-checker";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-syntax-checker";
      rev = "8eb7217e636ca717d4de5cd03cc0180c5b66ae77";
      sha256 = "aef048e664653b5007df71ac24ed34ec55d8938c763d3f80885a122e445a9b3d";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };

  vim-addon-toggle-buffer = buildVimPlugin {
    name = "vim-addon-toggle-buffer";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-toggle-buffer";
      rev = "a1b38b9c5709cba666ed2d84ef06548f675c6b0b";
      sha256 = "672166ecfe0599177afb56b444366f587f77e9659c256ac4e41ee45cb2df6055";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };

  vim-addon-xdebug = buildVimPlugin {
    name = "vim-addon-xdebug";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-xdebug";
      rev = "45f26407305b4ce6f8f5f37d2b5e6e4354104172";
      sha256 = "0a7bf2caf36772c94bd25bfbf46bf628623809c9cfab447ff788eb74149464ef";
    };
    dependencies = ["WebAPI" "vim-addon-mw-utils" "vim-addon-signs" "vim-addon-async"];
  };

  vim-airline = buildVimPlugin {
    name = "vim-airline";
    src = fetchgit {
      url = "git://github.com/bling/vim-airline";
      rev = "256dec6800342c121c1b26dabc06dafb0c91edca";
      sha256 = "9bb684da91bffc80d8489210fc74476895be81772b1d1370ee0b9a9ec7469750";
    };
    dependencies = [];
  };

  vim-coffee-script = buildVimPlugin {
    name = "vim-coffee-script";
    src = fetchgit {
      url = "git://github.com/kchmck/vim-coffee-script";
      rev = "827e4a38b07479433b619091469a7495a392df8a";
      sha256 = "89ee4c7cce9f3310be502df6b2dd2e70a715c0b06882afc9c8169fbf58b207d0";
    };
    dependencies = [];
  };

  vim-easy-align = buildVimPlugin {
    name = "vim-easy-align";
    src = fetchgit {
      url = "git://github.com/junegunn/vim-easy-align";
      rev = "2595ebf9333f3598502276b29f78ad39965bc595";
      sha256 = "1223b587c515169d4b735bf56f109f7bfc4f7c1327e76865f498309f7472ef78";
    };
    dependencies = [];
  };

  vim-gitgutter = buildVimPlugin {
    name = "vim-gitgutter";
    src = fetchgit {
      url = "git://github.com/airblade/vim-gitgutter";
      rev = "39f011909620e0c7ae555efdace20c3963ac88af";
      sha256 = "585c367c8cf72d7ef511b3beca3d1eae1d68bbd61b9a8d4dc7aea6e0caa4813a";
    };
    dependencies = [];
  };

  vim-iced-coffee-script = buildVimPlugin {
    name = "vim-iced-coffee-script";
    src = fetchgit {
      url = "git://github.com/noc7c9/vim-iced-coffee-script";
      rev = "e42e0775fa4b1f8840c55cd36ac3d1cedbc1dea2";
      sha256 = "c7859591975a51a1736f99a433d7ca3e7638b417340a0472a63995e16d8ece93";
    };
    dependencies = ["vim-coffee-script"];
  };

  vim-latex-live-preview = buildVimPlugin {
    name = "vim-latex-live-preview";
    src = fetchgit {
      url = "git://github.com/xuhdev/vim-latex-live-preview";
      rev = "18625ceca4de5984f3df50cdd0202fc13eb9e37c";
      sha256 = "261852d3830189a50176f997a4c6b4ec7e25893c5b7842a3eb57eb7771158722";
    };
    dependencies = [];
  };

  vim-signature = buildVimPlugin {
    name = "vim-signature";
    src = fetchgit {
      url = "git://github.com/kshenoy/vim-signature";
      rev = "29fc095535c4a3206d3194305739b33cd72ffad2";
      sha256 = "46101330cd291dd819552ba1f47571342fe671d6985d06897c34465b87fd7bc4";
    };
    dependencies = [];
  };

  vim-snippets = buildVimPlugin {
    name = "vim-snippets";
    src = fetchgit {
      url = "git://github.com/honza/vim-snippets";
      rev = "d05ca095ef93e256b45accb1e4b56ae3c44af125";
      sha256 = "1685ebe317ad1029bfc25e06c8f14cc3c14db887a7e1d743378c3748e416ac77";
    };
    dependencies = [];
  };

  vim2hs = buildVimPlugin {
    name = "vim2hs";
    src = fetchgit {
      url = "git://github.com/dag/vim2hs";
      rev = "f2afd55704bfe0a2d66e6b270d247e9b8a7b1664";
      sha256 = "485fc58595bb4e50f2239bec5a4cbb0d8f5662aa3f744e42c110cd1d66b7e5b0";
    };
    dependencies = [];
  };

  VimOutliner = buildVimPlugin {
    name = "VimOutliner";
    src = fetchgit {
      url = "git://github.com/vimoutliner/vimoutliner";
      rev = "91dccce033ca3924ad47831d29cd93fccc546013";
      sha256 = "c6dd19df1432908574e84a339a15076ddf8bfd6dfd2544b220928c29d9f752d3";
    };
    dependencies = [];
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
      set runtimepath+=${vimproc}/${rtpPath}/vimproc\
      ' autoload/vimshell.vim
    '';
  };

  vundle = buildVimPlugin {
    name = "vundle";
    src = fetchgit {
      url = "git://github.com/gmarik/vundle";
      rev = "0b28e334e65b6628b0a61c412fcb45204a2f2bab";
      sha256 = "9681d471d1391626cb9ad22b2b469003d9980cd23c5c3a8d34666376447e6204";
    };
    dependencies = [];
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

  WebAPI = buildVimPlugin {
    name = "WebAPI";
    src = fetchgit {
      url = "git://github.com/mattn/webapi-vim";
      rev = "a7789abffe936db56e3152e23733847f94755753";
      sha256 = "455b84d9fd13200ff5ced5d796075f434a7fb9c00f506769174579266ae2be80";
    };
    buildInputs = [ zip ];
    dependencies = [];
  };

  webapi-vim = WebAPI;

  wombat256 = buildVimPlugin {
    name = "wombat256";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=13400";
      name = "wombat256mod.vim";
      sha256 = "1san0jg9sfm6chhnr1wc5nhczlp11ibca0v7i4gf68h9ick9mysn";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=2465";
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

  YankRing = buildVimPlugin {
    name = "YankRing";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=20842";
      name = "yankring_180.zip";
      sha256 = "0bsq4pxagy12jqxzs7gcf25k5ahwif13ayb9k8clyhm0jjdkf0la";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=1234";
    };
  };

  yankring = YankRing;

  YouCompleteMe = addRtp "${rtpPath}/youcompleteme" (stdenv.mkDerivation {
    src = fetchgit {
      url = "https://github.com/Valloric/YouCompleteMe.git";
      rev = "87b42c689391b69968950ae99c3aaacf2e14c329";
      sha256 = "1f3pywv8bsqyyakvyarg7z9m73gmvp1lfbfp2f2jj73jmmlzb2kv";
     };

    name = "vimplugin-youcompleteme-2014-10-06";

    buildInputs = [ python cmake llvmPackages.clang ];

    configurePhase = ":";

    buildPhase = ''
      patchShebangs .

      target=$out/${rtpPath}/youcompleteme
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
  });

  youcompleteme = YouCompleteMe;

  YUNOcommit = buildVimPlugin {
    name = "YUNOcommit";
    src = fetchgit {
      url = "git://github.com/esneide/YUNOcommit.vim";
      rev = "10e0d674bfba05e88359dbe0ded4eb1d806b1342";
      sha256 = "8efe7129ccc1cd13a09ffd4b5f8abe1fca12c434768ff57b865844cf40d49b41";
    };
    dependencies = [];
  };

}

{fetchurl, stdenv, python, cmake, vim}:

/*
About Vim and plugins
=====================
Let me tell you how Vim plugins work, so that you can decide on how to orginize
your setup.

typical plugin files:

  plugin/P1.vim
  autoload/P1.vim
  ftplugin/xyz.vim
  doc/plugin-documentation.txt
  README(.md) (nowadays thanks to github)

Traditionally plugins were installed into ~/.vim/* so it was your task to keep track
of which files belong to what plugin. Now this problem is "fixed" by nix which
assembles your profile for you.


Vim offers the :h rtp setting which works for most plugins. Thus adding adding
this to your .vimrc should make most plugins work:

  set rtp+=~/.nix-profile/vim-plugins/YouCompleteMe
  " or for p in ["YouCompleteMe"] | exec 'set rtp+=~/.nix-profile/vim-plugins/'.p | endfor

Its what
pathogen, vundle, vim-addon-manager (VAM) use.

VAM's benefits:
- works around after/* directories if they are used in non ~/.vim locations
- allows activating plugins at runtime, eg when you need them. (works around
  some au command hooks, eg required for TheNerdTree plugin)
- VAM checkous out all sources (vim.sf.net, git, mercurial, ...)
- runs :helptags on update/installation only. Obviously it cannot do that on
  store paths.

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

IMHO having no plugins listed might be better than having outdated ones.

So which plugins to add here according to what Marc Weber thinks is best?
complicated plugins requiring dependencies, such as YouCompleteMe.
Then its best to symlink ~/.nix-profile/vim-plugins/YouCompleteMe to
~/.vim/{vim-addons,bundle} or whatever plugin management solution you use.

If you feel differently change the comments and proceed.
*/

let vimHelptags = path: ''
  ${vim}/bin/vim -N -u NONE -i NONE -n -e -s -c "helptags ${path}" +quit!
'';

in

{

  #TODO :helptags should be run

  vimAddonNix = {
    # github.com/MarcWeber/vim-addon-nix provides some additional support for
    # editing .nix files

    # This is a placeholder, because I think you always should be using latest git version
  };

  YouCompleteMe = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="youcompleteme"; type="git"; url="git://github.com/Valloric/YouCompleteMe"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/youcompleteme-git-97306.tar.bz2"; sha256 = "b9b892f5a723370c2034491dc72a4ca722c6cf1e5de4d60501141bba151bc719"; });
    name = "youcompleteme-git-97306";
    # END
    buildInputs = [ python cmake ];

    configurePhase = ":";

    buildPhase = ''
      set -x
      target=$out/vim-plugins/YouCompleteMe
      mkdir -p $target
      cp -a ./ $target

      mkdir $target/build
      cd $target/build
      cmake -G "Unix Makefiles" . $target/cpp -DPYTHON_LIBRARIES:PATH=${python}/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR:PATH=${python}/include/python2.7
      make -j -j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}

      ${vimHelptags "$out/vim-plugins/YouCompleteMe/doc"}
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

  syntastic = stdenv.mkDerivation {
    name = "vim-syntastic-3.0.0";
   
    src = fetchurl {
      url = "https://github.com/scrooloose/syntastic/archive/3.0.0.tar.gz";
      sha256 = "0nf69wpa8qa7xcfvywy2khmazs4dn1i2nal9qwjh2bzrbwbbkdyl";
    };

    buildPhase = "";

    installPhase = ''
      mkdir -p "$out/vim-plugins"
      cp -R autoload "$out/vim-plugins"
      cp -R doc "$out/vim-plugins"
      cp -R plugin "$out/vim-plugins"
      cp -R syntax_checkers "$out/vim-plugins"
    '';
  };

  coffeeScript = stdenv.mkDerivation {
    name = "vim-coffee-script-v002";

    src = fetchurl {
      url = "https://github.com/vim-scripts/vim-coffee-script/archive/v002.tar.gz";
      sha256 = "1xln6i6jbbihcyp5bsdylr2146y41hmp2xf7wi001g2ymj1zdsc0";
    };

    buildPhase = "";

    installPhase = ''
      mkdir -p "$out/vim-plugins"
      cp -R after "$out/vim-plugins"
      cp -R compiler "$out/vim-plugins"
      cp -R doc "$out/vim-plugins"
      cp -R ftdetect "$out/vim-plugins"
      cp -R ftplugin "$out/vim-plugins"
      cp -R indent "$out/vim-plugins"
      cp -R syntax "$out/vim-plugins"
    '';
  };
}


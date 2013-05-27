{fetchurl, stdenv, python, cmake}: {

# Note: Marc Weber thinks that github.com/MarcWeber/vim-addon-manager is the
# easiest way to manager your Vim environment

/*
    sample bootstrapping bash function for vim-addon-manager:

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
    " experimental: run after gui has been started [3]
    " option1:  au VimEnter * call Activate()
    " option2:  au GUIEnter * call Activate()
    EOF
    }
*/

# Exceptions: complicated plugins requiring dependencies, such as YouCompleteMe
# vim-addon-manager still can be used, install vimPlugins.YouCompleteMe into
# your user profile, then symlink ~/.nix-profiles/vim-plugins/YouCompleteMe to
# ~/.vim/vim-addons/YouCompleteMe, and VAM will pick it up

# you may feel different about it.



  YouCompleteMe = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="youcompleteme"; type="git"; url="git://github.com/Valloric/YouCompleteMe"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/youcompleteme-git-97306.tar.bz2"; sha256 = "b9b892f5a723370c2034491dc72a4ca722c6cf1e5de4d60501141bba151bc719"; });
    name = "youcompleteme-git-97306";
    # END
    buildInputs = [ python cmake] ;

    configurePhase = ":";

    buildPhase = ''
      set -x
      target=$out/vim-plugins
      mkdir -p $target
      cp -a ./ $target

      mkdir $target/build
      cd $target/build
      cmake -G "Unix Makefiles" . $target/cpp -DPYTHON_LIBRARIES:PATH=${python}/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR:PATH=${python}/include/python2.7
      make -j -j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}
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

}

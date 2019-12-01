{stdenv, vim, zsh, ncurses, isNeovim ? false}:
let athame = fetchGit {
      rev = "ded4200cb3312334d99ace794c4b308cd45f6b6e";
      url = "https://github.com/ardagnir/athame";
    };
    vimbed = fetchGit {
      rev = "6b8e8cb45353167988c7bbbe2d9cd4d41989e490";
      url = "https://github.com/ardagnir/vimbed";
    };
    vimbin = if isNeovim then "${vim}/bin/nvim" else "${vim}/bin/vim";
in
zsh.overrideAttrs(o: {
  pname = "athame-zsh";
  unpackPhase = ''
    tar xf $src
    mv zsh-${o.version}/* ./
    cp "${athame}/athame".* ./Src/Zle
    cp ${athame}/athame_util.h ./Src/Zle
    cp ${athame}/athame_zsh.h ./Src/Zle/athame_intermediary.h
    cp -r ${vimbed} ./Src/Zle/vimbed
    '';
  #patches = o.upstreamPatches;
  buildInputs = [vim ncurses zsh];
  makeFlags = [
    "ATHAME_VIM_BIN=${vimbin}"
    #"SHLIB_LIBS=\"-lncurses -lutil\""
    "ATHAME_USE_JOBS_DEFAULT=1"
  ];
  postPatch = ''
    #echo \'#!/bin/sh\' > patcher.sh
    #sed -i 's|-Wl,-rpath,$(libdir) ||g' support/shobj-conf
    patch -p1 -i ${athame}/zsh.patch
    '';
  meta = with stdenv.lib; {
    description = "Athame patches zsh to add full Vim support by routing your keystrokes through an actual Vim process.";
    homepage = https://github.com/ardagnir/athame;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bananPasha ];
  };
})

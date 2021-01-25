{ stdenv, lib, fetchFromGitHub, ncurses }:

let
  INSTALL_PATH="${placeholder "out"}/share/fzf-tab";
in stdenv.mkDerivation rec {
  pname = "zsh-fzf-tab";
  version = "unstable-2021-01-24";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "78b4cefb27dc2bef5e4c9ac3bf2bd28413620fcd";
    sha256 = "1f5m7vf7wxzczis2nzvhgqaqnphhp3a0wv8b612m7g4fnvk3lnkn";
  };

  buildInputs = [ ncurses ];

  postConfigure = ''
    pushd modules
    ./configure --disable-gdbm --without-tcsetpgrp
    popd
  '';

  postBuild = ''
    pushd modules
    make -j$NIX_BUILD_CORES
    popd
  '';

  installPhase = ''
     mkdir -p ${INSTALL_PATH}
     cp -r lib ${INSTALL_PATH}/lib
     install -D fzf-tab.zsh ${INSTALL_PATH}/fzf-tab.zsh
     install -D fzf-tab.plugin.zsh ${INSTALL_PATH}/fzf-tab.plugin.zsh
     install -D modules/Src/aloxaf/fzftab.so ${INSTALL_PATH}/modules/Src/aloxaf/fzftab.so
  '';

  meta = with lib; {
    homepage = "https://github.com/Aloxaf/fzf-tab";
    description = "Replace zsh's default completion selection menu with fzf!";
    license = licenses.mit;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.linux;
  };
}

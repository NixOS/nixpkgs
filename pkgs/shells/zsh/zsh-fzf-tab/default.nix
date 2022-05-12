{ stdenv, lib, fetchFromGitHub, ncurses }:

let
  INSTALL_PATH="${placeholder "out"}/share/fzf-tab";
in stdenv.mkDerivation rec {
  pname = "zsh-fzf-tab";
  version = "unstable-2022-04-15";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "7e0eee64df6c7c81a57792674646b5feaf89f263";
    sha256 = "sha256-ixUnuNtxxmiigeVjzuV5uG6rIBPY/1vdBZF2/Qv0Trs=";
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
    platforms = platforms.unix;
  };
}

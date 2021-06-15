{ stdenv, lib, fetchFromGitHub, ncurses }:

let
  INSTALL_PATH="${placeholder "out"}/share/fzf-tab";
in stdenv.mkDerivation rec {
  pname = "zsh-fzf-tab";
  version = "unstable-2021-04-01";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "0c36bdcf6a80ec009280897f07f56969f94d377e";
    sha256 = "0ymp9ky0jlkx9b63jajvpac5g3ll8snkf8q081g0yw42b9hwpiid";
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

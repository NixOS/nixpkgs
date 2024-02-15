{ stdenv, lib, fetchFromGitHub, ncurses, nix-update-script }:

let
  INSTALL_PATH="${placeholder "out"}/share/fzf-tab";
in stdenv.mkDerivation rec {
  pname = "zsh-fzf-tab";
  version = "unstable-2024-02-01";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "b06e7574577cd729c629419a62029d31d0565a7a";
    hash = "sha256-ilUavAIWmLiMh2PumtErMCpOcR71ZMlQkKhVOTDdHZw=";
  };

  strictDeps = true;
  buildInputs = [ ncurses ];

  # https://github.com/Aloxaf/fzf-tab/issues/337
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
    ];
  };

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

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version" "branch=master" ];
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Aloxaf/fzf-tab";
    description = "Replace zsh's default completion selection menu with fzf!";
    license = licenses.mit;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.unix;
  };
}

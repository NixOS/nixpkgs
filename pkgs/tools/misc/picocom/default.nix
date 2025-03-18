{ lib, stdenv
, fetchFromGitHub
, installShellFiles
, lrzsz
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "picocom";
  # last tagged release is 3.1 but 3.2 is still considered a release
  version = "3.2a";

  # upstream is quiet as the original author is no longer active since March 2018
  src = fetchFromGitHub {
    owner = "npat-efault";
    repo = "picocom";
    rev = "1acf1ddabaf3576b4023c4f6f09c5a3e4b086fb8";
    sha256 = "sha256-cs2bxqZfTbnY5d+VJ257C5hssaFvYup3tBKz68ROnAo=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '.picocom_history' '.cache/picocom_history'

    substituteInPlace picocom.c \
      --replace '"rz -vv -E"' '"${lrzsz}/bin/rz -vv -E"' \
      --replace '"sz -vv"' '"${lrzsz}/bin/sz -vv"'
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optional stdenv.isDarwin IOKit;

  installPhase = ''
    install -Dm555 -t $out/bin picocom
    installManPage picocom.1
    installShellCompletion --bash bash_completion/picocom
  '';

  meta = with lib; {
    description = "Minimal dumb-terminal emulation program";
    homepage = "https://github.com/npat-efault/picocom/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "picocom";
  };
}

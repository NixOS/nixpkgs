{ lib, stdenv, fetchFromGitHub, curl, libzip, pkg-config }:

stdenv.mkDerivation rec {
  pname = "tldr";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-cpp-client";
    rev = "v${version}";
    sha256 = "sha256-dsEqnHIs6vamdfLrkstRcV90tt7QcKIJwrPr+ksTVlQ=";
  };

  buildInputs = [ curl libzip ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = ["CC=${stdenv.cc.targetPrefix}cc" "LD=${stdenv.cc.targetPrefix}cc" "CFLAGS="];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simplified and community-driven man pages";
    longDescription = ''
      tldr pages gives common use cases for commands, so you don't need to hunt
      through a man page for the correct flags.
    '';
    homepage = "http://tldr-pages.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ taeer carlosdagos ];
    platforms = platforms.all;
  };
}

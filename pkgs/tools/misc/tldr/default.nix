{ stdenv, fetchFromGitHub, curl, libzip, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "tldr";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-cpp-client";
    rev = "v${version}";
    sha256 = "10ylpiqc06p0qpma72vwksd7hd107s0vlx9c6s9rz4vc3i274lb6";
  };

  buildInputs = [ curl libzip ];
  nativeBuildInputs = [ pkgconfig ];

  makeFlags = ["CC=cc" "LD=cc" "CFLAGS="];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
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

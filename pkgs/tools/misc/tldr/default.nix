{ stdenv, fetchFromGitHub, clang, curl, libzip, pkgconfig }:

stdenv.mkDerivation rec {
  name = "tldr-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    sha256 = "1dyvmxdxm92bfs5i6cngk8isa65qp6xlpim4yizs5rnm0rynf9kr";
    rev = "v${version}";
    repo = "tldr-cpp-client";
    owner = "tldr-pages";
  };

  buildInputs = [ curl clang libzip ];
  nativeBuildInputs = [ pkgconfig ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Simplified and community-driven man pages";
    longDescription = ''
      tldr pages gives common use cases for commands, so you don't need to hunt
      through a man page for the correct flags.
    '';
    homepage = http://tldr-pages.github.io;
    license = licenses.mit;
    maintainers = with maintainers; [ taeer nckx ];
    platforms = platforms.linux;
  };
}

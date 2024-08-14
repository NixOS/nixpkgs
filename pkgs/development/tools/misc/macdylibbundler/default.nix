{ lib, stdenv, makeWrapper, fetchFromGitHub, cctools }:

stdenv.mkDerivation rec {
  pname = "macdylibbundler";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "auriamg";
    repo = "macdylibbundler";
    rev = version;
    sha256 = "0j4ij48jf5izgymzxxaakf6vc50w9q0761yir6nfj1n6qlnrlidf";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/dylibbundler \
      --prefix PATH ":" "${cctools}/bin"
  '';

  meta = with lib; {
    description = "Utility to ease bundling libraries into executables for OSX";
    longDescription = ''
      dylibbundler is a small command-line programs that aims to make bundling
      .dylibs as easy as possible. It automatically determines which dylibs are
      needed by your program, copies these libraries inside the app bundle, and
      fixes both them and the executable to be ready for distribution... all
      this with a single command on the teminal! It will also work if your
      program uses plug-ins that have dependencies too.
    '';
    homepage = "https://github.com/auriamg/macdylibbundler";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.nomeata ];

  };
}

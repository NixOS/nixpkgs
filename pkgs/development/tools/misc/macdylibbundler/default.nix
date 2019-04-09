{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "macdylibbundler-${version}";
  version = "20180825";

  src = fetchFromGitHub {
    owner = "auriamg";
    repo = "macdylibbundler";
    rev = "ce13cb585ead5237813b85e68fe530f085fc0a9e";
    sha256 = "149p3dcnap4hs3nhq5rfvr3m70rrb5hbr5xkj1h0gsfp0d7gvxnj";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Utility to ease bundling libraries into executables for OSX";
    longDescription = ''
      dylibbundler is a small command-line programs that aims to make bundling
      .dylibs as easy as possible. It automatically determines which dylibs are
      needed by your program, copies these libraries inside the app bundle, and
      fixes both them and the executable to be ready for distribution... all
      this with a single command on the teminal! It will also work if your
      program uses plug-ins that have dependencies too.
    '';
    homepage = https://github.com/auriamg/macdylibbundler;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.nomeata ];

  };
}

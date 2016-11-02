{ stdenv, fetchFromGitHub,
  bison, re2c, scons
}:

let
  version = "5.1.0";
in

stdenv.mkDerivation rec {
  name = "clingo-${version}";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "clingo";
    rev = "v${version}";
    sha256 = "1rvaqqa8xfagsqxk45lax3l29sksijd3zvl662vpvdi1sy0d71xv";
  };

  buildInputs = [ bison re2c scons ];

  buildPhase = ''
    scons --build-dir=release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/release/{gringo,clingo,reify,lpconvert} $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A grounder and solver for logic programs.";
    homepage = http://potassco.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}

{ stdenv, fetchFromGitHub, autoreconfHook, apacheHttpd, apr, cairo, iniparser, mapnik }:

stdenv.mkDerivation rec {
  pname = "mod_tile";
  version = "unstable-2017-01-08";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    rev = "e25bfdba1c1f2103c69529f1a30b22a14ce311f1";
    sha256 = "12c96avka1dfb9wxqmjd57j30w9h8yx4y4w34kyq6xnf6lwnkcxp";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ apacheHttpd apr cairo iniparser mapnik ];

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
  ];

  installPhase = ''
    mkdir -p $out/modules
    make install-mod_tile DESTDIR=$out
    mv $out${apacheHttpd}/* $out
    rm -rf $out/nix
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/openstreetmap/mod_tile";
    description = "Efficiently render and serve OpenStreetMap tiles using Apache and Mapnik";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jglukasik ];
    platforms = platforms.linux;
  };
}

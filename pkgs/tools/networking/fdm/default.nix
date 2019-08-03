{ stdenv, fetchFromGitHub, autoreconfHook, openssl, tdb, zlib, flex, bison }:

let

  baseName = "fdm";
  version = "1.9.0.20170124";

in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "nicm";
    repo = baseName;
    rev = "cae4ea37b6b296d1b2e48f62934ea3a7f6085e33";
    sha256 = "048191wdv1yprwinipmx2152gvd2iq1ssv7xfb1bzh6zirh1ya3n";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl tdb zlib flex bison ];


  meta = with stdenv.lib; {
    description = "Mail fetching and delivery tool - should do the job of getmail and procmail";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux;
    homepage = https://github.com/nicm/fdm;
    downloadPage = https://github.com/nicm/fdm/releases;
    license = licenses.isc;
  };
}

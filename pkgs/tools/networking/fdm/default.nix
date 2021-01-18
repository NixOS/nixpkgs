{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, tdb, zlib, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fdm";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "nicm";
    repo = pname;
    rev = version;
    sha256 = "0j2n271ni5wslgjq1f4zgz1nsvqjf895dxy3ij5c904bbp8ckcwq";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl tdb zlib flex bison ];


  meta = with lib; {
    description = "Mail fetching and delivery tool - should do the job of getmail and procmail";
    maintainers = with maintainers; [ ninjin raskin ];
    platforms = with platforms; linux;
    homepage = "https://github.com/nicm/fdm";
    downloadPage = "https://github.com/nicm/fdm/releases";
    license = licenses.isc;
  };
}

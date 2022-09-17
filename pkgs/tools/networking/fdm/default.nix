{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, tdb, zlib, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fdm";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "nicm";
    repo = pname;
    rev = version;
    sha256 = "sha256-w7jgFq/uWGTF8+CsQCwXKu3eJ7Yjp1WWY4DGQhpBFmQ=";
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

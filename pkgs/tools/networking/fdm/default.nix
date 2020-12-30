{ stdenv, fetchFromGitHub, autoreconfHook, openssl, tdb, zlib, flex, bison }:

let

  baseName = "fdm";
  version = "2.0";

in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "nicm";
    repo = baseName;
    rev = "370b04f165b0bb2989be378bb7e66b14f042d3f9";
    sha256 = "0j2n271ni5wslgjq1f4zgz1nsvqjf895dxy3ij5c904bbp8ckcwq";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl tdb zlib flex bison ];


  meta = with stdenv.lib; {
    description = "Mail fetching and delivery tool - should do the job of getmail and procmail";
    maintainers = with maintainers; [ ninjin raskin ];
    platforms = with platforms; linux;
    homepage = "https://github.com/nicm/fdm";
    downloadPage = "https://github.com/nicm/fdm/releases";
    license = licenses.isc;
  };
}

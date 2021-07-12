{ stdenv, lib, fetchurl, dev86, sharutils }:

stdenv.mkDerivation rec {
  pname = "lilo";
  version = "24.2";
  src = fetchurl {
    url = "https://www.joonet.de/lilo/ftp/sources/${pname}-${version}.tar.gz";
    hash = "sha256-4VjxneRWDJNevgUHwht5v/F2GLkjDYB2/oxf/5/b1bE=";
  };
  nativeBuildInputs = [ dev86 sharutils ];
  DESTDIR = placeholder "out";

  meta = with lib; {
    homepage = "https://www.joonet.de/lilo/";
    description = "Linux bootloader";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kaction ];
  };
}

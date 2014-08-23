{ stdenv, fetchsvn, wine, perl, which, coreutils, zenity, curl
, cabextract, unzip, p7zip, gnused, gnugrep, bash } :

stdenv.mkDerivation rec {
  rev = "1199";
  name = "winetricks-${rev}";

  src = fetchsvn {
    url = "http://winetricks.googlecode.com/svn/trunk";
    inherit rev;
    sha256 = "1kji1n6ps09g8xnl9m7vqk3vkl03abzwnc43c52i8p0adnv06khb";
  };

  buildInputs = [ perl which ];

  pathAdd = stdenv.lib.concatStringsSep "/bin:" # coreutils is for sha1sum
    [ wine perl which coreutils zenity curl cabextract unzip p7zip gnused gnugrep bash ]
    + "/bin";

  patch = ./winetricks.patch;

  builder = ./build_winetricks.sh;

  meta = {
    description = "A script to install DLLs needed to work around problems in Wine";
    license = stdenv.lib.licenses.lgpl21;
    homepage = http://code.google.com/p/winetricks/;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}

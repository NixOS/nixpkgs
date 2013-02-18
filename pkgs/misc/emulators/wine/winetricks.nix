{ stdenv, fetchsvn, wine, perl, which, coreutils, zenity, curl, cabextract, unzip, p7zip } :

stdenv.mkDerivation rec {
  rev = "939";
  name = "winetricks-${rev}";

  src = fetchsvn {
    url = "http://winetricks.googlecode.com/svn/trunk";
    inherit rev;
  };

  buildInputs = [ perl which ];

  pathAdd = stdenv.lib.concatStringsSep "/bin:" # coreutils is for sha1sum
    [ wine perl which coreutils zenity curl cabextract unzip p7zip ]
    + "/bin";

  patch = ./winetricks.patch;

  builder = ./build_winetricks.sh;

  meta = {
    description = "A script to install DLLs needed to work around problems in Wine";
    license = "LGPLv2.1";
    homepage = http://code.google.com/p/winetricks/;
  };
}


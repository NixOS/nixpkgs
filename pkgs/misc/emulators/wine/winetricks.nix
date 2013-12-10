{ stdenv, fetchsvn, wine, perl, which, coreutils, zenity, curl
, cabextract, unzip, p7zip, gnused, gnugrep, bash } :

stdenv.mkDerivation rec {
  rev = "1078";
  name = "winetricks-${rev}";

  src = fetchsvn {
    url = "http://winetricks.googlecode.com/svn/trunk";
    inherit rev;
    sha256 = "0ipvld0r5h6x2pgqkqa82q0w9flx6fn9aha8fd7axf5ji2gzmidm";
  };

  buildInputs = [ perl which ];

  pathAdd = stdenv.lib.concatStringsSep "/bin:" # coreutils is for sha1sum
    [ wine perl which coreutils zenity curl cabextract unzip p7zip gnused gnugrep bash ]
    + "/bin";

  patch = ./winetricks.patch;

  builder = ./build_winetricks.sh;

  meta = {
    description = "A script to install DLLs needed to work around problems in Wine";
    license = "LGPLv2.1";
    homepage = http://code.google.com/p/winetricks/;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}


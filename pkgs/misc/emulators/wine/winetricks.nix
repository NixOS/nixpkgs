{ stdenv, fetchsvn, wine, perl, which, coreutils, zenity, curl
, cabextract, unzip, p7zip, gnused, gnugrep, bash } :

stdenv.mkDerivation rec {
  rev = "1083";
  name = "winetricks-${rev}";

  src = fetchsvn {
    url = "http://winetricks.googlecode.com/svn/trunk";
    inherit rev;
    sha256 = "0zakwn7g2ni6xw92i1y3pngyaxsr93714s4jy11adf7rxdkj0a32";
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


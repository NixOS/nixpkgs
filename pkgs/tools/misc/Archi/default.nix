{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  pname = "Archi";
  version = "4.7.1";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://www.archimatetool.com/downloads/archi/Archi-Linux64-${version}.tgz";
        sha256 = "0sd57cfnh5q2p17sd86c8wgmqyipg29rz6iaa5brq8mwn8ps2fdw";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      throw "Unsupported system"
      /*
       * A Mac version is available; needs to be tested on a Mac system:
       * fetchurl {
       *   url = "https://www.archimatetool.com/downloads/archi/Archi-Mac-${version}.zip";
       *   sha256 = "0zg0bs9i2kkr11bbssfxhrp4ym2zzhb2bk7m38z9cj99h7pmgyhr";
       * }
       */
    else
       throw "Unsupported system";

  installPhase = ''
    cp -r . $out
    mkdir -p $out/bin
    ln -s $out/Archi $out/bin/Archi
  '';

  meta = with stdenv.lib; {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ earldouglas ];
  };
}

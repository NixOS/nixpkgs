{ stdenv, fetchurl, unzip }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ngrok-${version}";
  version = "2.2.8";

  src = if stdenv.isLinux && stdenv.isi686 then fetchurl {
    url = "https://bin.equinox.io/a/bAxP1reZDmJ/ngrok-${version}-linux-386.tar.gz";
    sha256 = "0s5ymlaxrvm13q3mlvfirh74sx60qh56c5sgdma2r7q5qlsq41xg";
  } else if stdenv.isLinux && stdenv.isx86_64 then fetchurl {
    url = "https://bin.equinox.io/a/iVLSfdAz1X4/ngrok-${version}-linux-amd64.tar.gz";
    sha256 = "1mn9iwgy6xzrjihikwc2k2j59igqmph0cwx17qp0ziap9lp5xxad";
  } else if stdenv.isDarwin then fetchurl {
    url = "https://bin.equinox.io/a/dFaKVcgrvJ3/ngrok-${version}-darwin-386.zip";
    sha256 = "0yfd250b55wcpgqd00rqfaa7a82f35fmybb31q5xwdbgc2i47pbh";
  } else throw "platform ${stdenv.hostPlatform.system} not supported!";

  sourceRoot = ".";

  nativeBuildInputs = optional stdenv.isDarwin unzip;

  installPhase = ''
    install -D ngrok $out/bin/ngrok
  '';

  meta = {
    description = "ngrok";
    longDescription = ''
      Allows you to expose a web server running on your local machine to the internet.
    '';
    homepage = https://ngrok.com/;
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.bobvanderlinden ];
  };
}

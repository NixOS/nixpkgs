{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "ngrok-${version}";
  version = "2.2.8";

  src = if stdenv.system == "i686-linux" then fetchurl {
    url = "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-i386.tgz";
    sha256 = "0s5ymlaxrvm13q3mlvfirh74sx60qh56c5sgdma2r7q5qlsq41xg";
  } else if stdenv.system == "x86_64-linux" then fetchurl {
    url = "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz";
    sha256 = "1mn9iwgy6xzrjihikwc2k2j59igqmph0cwx17qp0ziap9lp5xxad";
  } else throw "platform ${stdenv.system} not supported!";

  sourceRoot = ".";

  installPhase = ''
    install -D ngrok $out/bin/ngrok
  '';

  meta = with stdenv.lib; {
    description = "ngrok";
    longDescription = ''
      Allows you to expose a web server running on your local machine to the internet.
    '';
    homepage = https://ngrok.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.bobvanderlinden ];
  };
}

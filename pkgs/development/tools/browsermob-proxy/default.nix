{stdenv, jre, fetchzip}:

stdenv.mkDerivation rec {
  version = "2.1.4";
  name = "browsermob-proxy-${version}";
  src = fetchzip {
    url = "https://github.com/lightbody/browsermob-proxy/releases/download/${name}/${name}-bin.zip";
    sha256 = "0phymlikfx70mn4x9551bi92ljkdpycxpalib30zhq3slsavfraz";
  };
  buildInputs = [ jre ];
  patchPhase = ''
    patchShebangs .
    sed -i 's|JAVACMD="java"|JAVACMD="${jre}/bin/java"|' bin/browsermob*
  '';
  installPhase = ''
    mkdir -p $out/{bin,lib,ssl-support}
    cp -r bin/* $out/bin/
    cp -r lib/* $out/lib/
    cp -r ssl-support/* $out/ssl-support/
  '';

  meta = {

    description = ''
      A free utility to help web developers watch and manipulate network traffic from their AJAX applications
    '';

    longDescription = ''
      BrowserMob Proxy allows you to manipulate HTTP requests and responses,
      capture HTTP content, and export performance data as a HAR file. BMP works
      well as a standalone proxy server, but it is especially useful when
      embedded in Selenium tests.
    '';

    homepage = https://github.com/lightbody/browsermob-proxy;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
 }

{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "besttrace";
  version = "1.3.2";

  src = fetchzip {
    url = "https://cdn.ipip.net/17mon/besttrace4linux.zip";
    sha256 = "sha256-uRRZ5nNUg0MyK2ZRCZeAYi2P2UHyxUHFNTzgnU+I8gY=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/bin
    cp besttrace $out/bin
    chmod +x $out/bin/besttrace
  '';

  postFixup = ''
    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/bin/besttrace
  '';

  meta = with lib; {
    homepage = "https://www.ipip.net/product/client.html#besttrace";
    description = "IPIP.net 开发的加强版 traceroute，附带链路可视化";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}

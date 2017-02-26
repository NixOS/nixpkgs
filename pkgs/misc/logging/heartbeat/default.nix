{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "heartbeat-${version}";
  version = "5.2.1";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/beats/heartbeat/${name}-linux-x86_64.tar.gz";
    sha256 = "1sq3va0kbpqsjbd0bnziv2hwnp6nc2vk32hc9drjk7bhcxkp440l";
  };

  # statically linked binary, no need to build anything
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    cp heartbeat $out/bin/
  '';

  meta = {
    description = "Lightweight shipper for uptime monitoring";
    homepage = https://www.elastic.co/products/beats;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}

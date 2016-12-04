{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "filebeat-${version}";
  version = "5.2.1";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/beats/filebeat/${name}-linux-x86_64.tar.gz";
    sha256 = "0kwkd3n6jmd0mwbvk2dng8843mxyq4mfvlm3hc8d1vd2m1m9wlhi";
  };

  # statically linked binary, no need to build anything
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    cp filebeat $out/bin/
  '';

  meta = {
    description = "Lightweight shipper for logfiles";
    homepage = https://www.elastic.co/products/beats;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = [ "x86_64-linux" ];
  };
}

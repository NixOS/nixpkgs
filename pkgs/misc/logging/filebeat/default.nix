{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "filebeat-${version}";
  version = "5.0.2";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/beats/filebeat/${name}-linux-x86_64.tar.gz";
    sha256 = "1i00ndkzf4v4m6i8vdncsm3bya3jkn0lwhpjwhw6dv2w091vbw6g";
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
    platforms = stdenv.lib.platforms.all;
  };
}

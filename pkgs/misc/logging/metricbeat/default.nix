{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "metricbeat-${version}";
  version = "5.2.1";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/beats/metricbeat/${name}-linux-x86_64.tar.gz";
    sha256 = "0shpyqgrqiiqv9anipqms1xy0wn5n2m11fvicdzr3x1v3jygm1ds";
  };

  # statically linked binary, no need to build anything
  dontBuild = true;
  doCheck = false;

  # need to patch interpreter to be able to run on NixOS
  patchPhase = ''
    patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) metricbeat
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp metricbeat $out/bin/
  '';

  meta = {
    description = "Lightweight shipper for metrics";
    homepage = https://www.elastic.co/products/beats;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}

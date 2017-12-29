{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-exporter-${version}";
  version = "0.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/joe-pll/minio-exporter";

  src= fetchFromGitHub {
    inherit rev;
    owner = "joe-pll";
    repo = "minio-exporter";
    sha256 = "14lz4dg0n213b6xy12fh4r20k1rcnflnfg6gjskk5zr8h7978hjx";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A Prometheus exporter for Minio cloud storage server";
    homepage = https://github.com/joe-pll/minio-exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.unix;
  };
}

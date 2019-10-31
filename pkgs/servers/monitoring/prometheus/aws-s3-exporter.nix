{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "aws-s3-exporter";
  version = "0.3.0";

  goPackagePath = "github.com/ribbybibby/s3_exporter";

  goDeps = ./aws-s3-exporter_deps.nix;

  src = fetchFromGitHub {
    owner = "ribbybibby";
    repo = "s3_exporter";
    rev = "v${version}";
    sha256 = "062qi4rfqkxwknncwcvx4g132bxhkn2bhbxi4l90wl93v6sdp9l2";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Exports Prometheus metrics about S3 buckets and objects";
    homepage = "https://github.com/ribbybibby/s3_exporter";
    license = licenses.asl20;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.all;
  };
}

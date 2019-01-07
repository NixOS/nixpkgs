{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "aws-xray-daemon-${version}";
  version = "V3.0.0";

  goPackagePath = "github.com/aws/aws-xray-daemon";
  subPackages = [ "daemon" ];

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-xray-daemon";
    rev = "${version}";
    sha256 = "090z5q7iw6y9c0d70z29mxqw55yxxh9d8bnl6lxda72rhmdnvfcq";
  };

  goDeps = ./deps.nix;

  meta = {
    homepage = "https://docs.aws.amazon.com/xray/latest/devguide/xray-daemon.html";
    description = "aws X-RAY daemon.";
    license = stdenv.lib.licenses.asl20;
  };
}
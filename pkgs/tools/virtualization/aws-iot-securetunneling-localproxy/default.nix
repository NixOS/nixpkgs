{ lib, stdenv, fetchFromGitHub, cmake, boost, protobuf, openssl, catch2 }:

stdenv.mkDerivation rec {
  pname = "aws-iot-securetunneling-localproxy";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "aws-samples";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WGAzf66TaDpzqbdDzP8wyaC89G8FOH0tgR4to+QtYEU=";
  };

  # The patch addresses several issues:
  #  1. aws-iot-securetunneling-localproxy sources declare Boost dependency at 1.68.0. We have
  #     1.69.0 at Nixpkgs currently. I've tested that the application works just fine when compiled
  #     against 1.69.0, so the patch modifies build scripts to allow for it.
  #  2. Current version of boost (1.69.0 at the moment of writing) emits warnings that break the
  #     build. Workaround is to use `BOOST_ALLOW_DEPRECATED_HEADERS` and comes from
  #     https://github.com/boostorg/random/issues/49
  #  3. aws-iot-securetunneling-localproxy attemps to link to Boost Log library statically while
  #     Nixpkgs builds it for dynamic linking. The patch switches linkage mode.
  patches = [ ./cmake.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost protobuf openssl catch2 ];

  meta = with lib; {
    description = "C++ implementation of a local proxy for the AWS IoT Secure Tunneling service";
    homepage = "https://github.com/aws-samples/aws-iot-securetunneling-localproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}

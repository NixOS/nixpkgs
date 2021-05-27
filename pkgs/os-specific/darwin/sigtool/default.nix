{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, makeWrapper, openssl }:

stdenv.mkDerivation {
  name = "sigtool";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "sigtool";
    rev = "4a3719b42dc91c3f513df94048851cc98e7c7fcf";
    sha256 = "04ra1cx7k1sdbkj5yrvl0s3l333vpir8rnm8k1dh2zy1w0a6hpqa";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

  # Upstream (me) asserts the driver script is optional.
  postInstall = ''
    substitute $NIX_BUILD_TOP/$sourceRoot/codesign.sh $out/bin/codesign \
      --replace sigtool "$out/bin/sigtool"
    chmod a+x $out/bin/codesign
  '';
}

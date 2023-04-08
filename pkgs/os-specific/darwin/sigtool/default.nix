{ lib, stdenv, fetchFromGitHub, pkg-config, openssl }:

stdenv.mkDerivation rec {
  pname = "sigtool";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "sigtool";
    rev = "v${version}";
    sha256 = "sha256-K3VSFaqcZEomF7kROJz+AwxdW1MmxxEFDaRnWnzcw54=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];
}

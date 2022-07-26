{ lib, stdenv, fetchFromGitHub, pkg-config, openssl }:

stdenv.mkDerivation rec {
  pname = "sigtool";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "sigtool";
    rev = "v${version}";
    sha256 = "sha256-v4udqW37vwcqBdqfvfwHnoyXpuLFt188ekVCPCPsTPM";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];
}

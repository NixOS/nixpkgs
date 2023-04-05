{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Q/FLvZqmih3StVmLvEmJ5tY7Lz3dqFPUEn9HNubLNMY=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-SCaP6JtLztIO9Od75i4GkMPbLqpf52sAZVPHG86VcX0=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre shyim ];
    platforms = platforms.unix;
  };
}

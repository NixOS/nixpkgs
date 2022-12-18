{ lib, rustPlatform, fetchFromGitHub, stdenv, Security, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "bindle";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "deislabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mc3LaEOWx8cN7g0r8CtWkGZ746gAXTaFmAZhEIkbWgM=";
  };

  doCheck = false; # Tests require a network

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-brsemnw/9YEsA2FEIdYGmQMdlIoT1ZEMjvOpF44gcRE=";

  cargoBuildFlags = [
    "--bin" "bindle"
    "--bin" "bindle-server"
    "--all-features"
  ];

  meta = with lib; {
    description = "Bindle: Aggregate Object Storage";
    homepage = "https://github.com/deislabs/bindle";
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
    platforms = platforms.unix;
  };
}


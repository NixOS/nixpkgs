{ lib, rustPlatform, fetchFromGitHub, stdenv, Security, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "bindle";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "deislabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xehn74fqP0tEtP4Qy9TRGv+P2QoHZLxRHzGoY5cQuv0=";
  };

  postPatch = ''
    rm .cargo/config
  '';

  doCheck = false; # Tests require a network

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-RECEeo0uoGO5bBe+r++zpTjYYX3BIkT58uht2MLYkN0=";

  cargoBuildFlags = [
    "--bin" "bindle"
    "--bin" "bindle-server"
    "--all-features"
  ];

  meta = with lib; {
    description = "Bindle: Aggregate Object Storage";
    homepage = "https://github.com/deislabs/bindle";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}


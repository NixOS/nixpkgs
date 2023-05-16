{ lib, rustPlatform, fetchFromGitHub, stdenv, Security, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "bindle";
<<<<<<< HEAD
  version = "0.9.1";
=======
  version = "0.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deislabs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-xehn74fqP0tEtP4Qy9TRGv+P2QoHZLxRHzGoY5cQuv0=";
  };

  postPatch = ''
    rm .cargo/config
  '';

=======
    sha256 = "sha256-Mc3LaEOWx8cN7g0r8CtWkGZ746gAXTaFmAZhEIkbWgM=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false; # Tests require a network

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

<<<<<<< HEAD
  cargoSha256 = "sha256-RECEeo0uoGO5bBe+r++zpTjYYX3BIkT58uht2MLYkN0=";
=======
  cargoSha256 = "sha256-brsemnw/9YEsA2FEIdYGmQMdlIoT1ZEMjvOpF44gcRE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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


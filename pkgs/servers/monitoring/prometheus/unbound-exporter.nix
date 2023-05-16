<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

let
  version = "0.4.4";
in
buildGoModule {
  pname = "unbound_exporter";
  inherit version;

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "unbound_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-0eo56z5b+hzKCY5OKg/9F7rjLyoSKPJoHLoXeMjCuFU=";
  };

  vendorHash = "sha256-4aWuf9UTPQseEwDJfWIcQW4uGMffRnWlHhiu0yMz4vk=";
=======
{ lib, stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, nixosTests, Security }:

rustPlatform.buildRustPackage rec {
  pname = "unbound-telemetry";
  version = "unstable-2021-09-18";

  src = fetchFromGitHub {
    owner = "svartalf";
    repo = pname;
    rev = "19e53b05828a43b7062b67a9cc6c84836ca26439";
    sha256 = "sha256-wkr9T6GlJP/PSv17z3MC7vC0cXg/Z6rGlhlCUHH3Ua4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "native-tls-0.2.3" = "sha256-I1+ZNLDVGS1x9Iu81RD2//xnqhKhNGBmlrT0ryNFSlE=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) unbound;
  };

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/letsencrypt/unbound_exporter/releases/tag/v${version}";
    description = "Prometheus exporter for Unbound DNS resolver";
    homepage = "https://github.com/letsencrypt/unbound_exporter/tree/main";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
=======
    description = "Prometheus exporter for Unbound DNS resolver";
    homepage = "https://github.com/svartalf/unbound-telemetry";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

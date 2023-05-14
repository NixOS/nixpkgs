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

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) unbound;
  };

  meta = with lib; {
    description = "Prometheus exporter for Unbound DNS resolver";
    homepage = "https://github.com/svartalf/unbound-telemetry";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

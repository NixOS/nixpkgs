{ lib, stdenv, rustPlatform, fetchFromGitHub, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
    sha256 = "sha256-C2wIkneOh6t8gjoHRYMRorAKEVvM3R+NRZbG9hhCE5A=";
  };

  cargoSha256 = "sha256-Ej2/X1aQ8uRdZKpVRT4+AzhDWMv/sT8GrCitUmkrHmI=";

  buildInputs =
    lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description =
      "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

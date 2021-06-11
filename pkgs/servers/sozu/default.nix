{ lib, stdenv, rustPlatform, fetchFromGitHub, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "0.11.56";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
    sha256 = "sha256-/XyBzhZCsX9sGk+iTFlDnblWfDCZdI4b9yfo4Z+Wp1U=";
  };

  cargoSha256 = "sha256-xnps3/i6BpzdwUAQmb8aoOPc39L2P52y/ZDAeLoEIU8=";

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

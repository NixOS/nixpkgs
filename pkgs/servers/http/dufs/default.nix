<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dufs";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "dufs";
    rev = "v${version}";
    hash = "sha256-WZ+tyrx4ayFyPmDJq6dGaTRiR6bSQq5k5iOfb+ETe/I=";
  };

  cargoHash = "sha256-HZiWmqIh21b12DP+hnx1pWBWgSa5j71kp6GCRKGMHv0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
=======
{ stdenv, lib, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "dufs";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZcKNpKlyGMFPNiWA28zG5gh0gWxI4IKGP6vs9OBhxQU=";
  };

  cargoHash = "sha256-Ihq00dfjsJX2rNclfyYKp8a0U120+0YLZyvMO1yvBYw=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # FIXME: checkPhase on darwin will leave some zombie spawn processes
  # see https://github.com/NixOS/nixpkgs/issues/205620
  doCheck = !stdenv.isDarwin;
  checkFlags = [
    # tests depend on network interface, may fail with virtual IPs.
    "--skip=validate_printed_urls"
  ];

  meta = with lib; {
    description = "A file server that supports static serving, uploading, searching, accessing control, webdav";
    homepage = "https://github.com/sigoden/dufs";
<<<<<<< HEAD
    changelog = "https://github.com/sigoden/dufs/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda holymonson ];
=======
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.holymonson ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

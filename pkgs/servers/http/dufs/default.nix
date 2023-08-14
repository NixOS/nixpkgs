{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dufs";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FrLvwXEnNEKi8FvPIs6A52WpSUT+pUCc61JBi9M/PPw=";
  };

  cargoHash = "sha256-YHFEjs8a1QJHWYVjAQxmpMIQ2aDbu6mxeuNqcvReYR0=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
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
    changelog = "https://github.com/sigoden/dufs/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda holymonson ];
  };
}

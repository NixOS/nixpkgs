{ lib, rustPlatform, fetchFromGitHub, fetchpatch, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.43";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    sha256 = "sha256-7Ujm5xqgyw4/P/XBZKh9yE9sWz9n+WmZbGdmif9oK+w=";
  };

  patches = [
    # Update uuid version in fixtures to match nextest
    (fetchpatch {
      name = "update-uuid-version-nextest-tests.patch";
      url = "https://github.com/nextest-rs/nextest/commit/c5d9c527b84f69555bb8e1d036e5bbb41424cd9f.diff";
      hash = "sha256-Z/wkK3wPJW+uNwGVtVAxTzK/fuvJ+N0Ch/ov1sndXO8=";
    })
    # Remove a warning about double license declaration
    (fetchpatch {
      name = "remove-warning-license.patch";
      url = "https://github.com/nextest-rs/nextest/commit/126ad4d2590400e5dcb752d7994202d9642b1648.diff";
      hash = "sha256-jo7KYNfsXqYIoUuOx/1M1IjVfNuWrOnRgsLJbhY3dUw=";
    })
  ];

  cargoSha256 = "sha256-S46W+6+FyjI8BrdedDCzHHK+j3EyofQ9u8Ut1yr1/TI=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  checkFlags = [
    "--skip=test_run_from_archive"
  ];

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog figsoda ];
  };
}

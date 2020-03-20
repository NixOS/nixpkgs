{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g91cfja4h9qhpxgnimczjna528ml645iz7hgpwl6yp0742qcal4";
  };

  # Can be removed when updating to the next release.
  cargoPatches = [ ./0001-Fix-outdated-Cargo.lock.patch ];

  cargoSha256 = "0pr57g41lnn8srcbc11sb15qchf01zwqcb1802xdayj6wlc3g3dy";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    libiconv
    curl
  ];

  meta = with stdenv.lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = https://github.com/kbknapp/cargo-outdated;
    license = with licenses; [ asl20 /* or */ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ sondr3 ivan ];
  };
}

{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libusb1
, openssl
, pkg-config
, rustfmt
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aQ5647woODs/A4fcxSsQoQHL6YQ0TpfQFegtXETqlHk=";
  };

  cargoSha256 = "sha256-P7xyg9I1MhmiKlyAI9cvABcYKNxB6TSvTgMsMk5KxAQ=";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "https://probe.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}

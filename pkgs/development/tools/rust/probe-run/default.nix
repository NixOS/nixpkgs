{ lib, rustPlatform, fetchFromGitHub, pkg-config, libusb1 }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "QEUsigoSqVczrsSSDnOhTXm94JTXHgxeNY0tGsOaRyg=";
  };

  cargoSha256 = "Fr5XWIUHXyfesouHi0Uryf/ZgB/rDDJ4G1BYGHw0QeQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "Run embedded programs just like native ones.";
    homepage = "https://github.com/knurling-rs/probe-run";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}

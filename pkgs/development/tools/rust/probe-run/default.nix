{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jvyqynhg2fva29bzj4wrg3f22xpvl1hdf9kqws2c3wdiz9lc8l4";
  };

  cargoSha256 = "1jijpm4k3py09k9w9a2zj1795r02wsa53r4sxa4ws96d4gkv4x5b";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit IOKit ];

  meta = with lib; {
    description = "Run embedded programs just like native ones.";
    homepage = "https://github.com/knurling-rs/probe-run";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}

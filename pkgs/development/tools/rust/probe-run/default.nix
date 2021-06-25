{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "069f4vai1cw69xw3q7xyd81k3rklyb0bs77jfsrwq97vy7b78i92";
  };

  cargoSha256 = "0j5bl1sh3hcx38qckrjlfggsfsczzw2vbb3ks5x59dqakqh5fb7v";

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

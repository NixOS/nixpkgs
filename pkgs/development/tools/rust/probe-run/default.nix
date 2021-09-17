{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bj5arngc49mdz1i7bbg4l7rb741x7dhalpdxrn55vzlvgbig8fv";
  };

  cargoSha256 = "1kqgl1f91aa7kz1yprpyf9pl1vp4ahhw8ka5hrvfvk5i5i54pigz";

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

{ lib
, rustPlatform
, fetchCrate
, pkg-config
, udev
}:

rustPlatform.buildRustPackage rec {
  pname = "ravedude";
  version = "0.1.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wcY9fvfIn1pWMAh5FI/QFl18CV2xjmRGSwwoRfGvujo=";
  };

  cargoHash = "sha256-AOIrB0FRagbA2+JEURF41d+th0AbR++U5WKCcZmh4Os=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ udev ];

  meta = with lib; {
    description = "Tool to easily flash code onto an AVR microcontroller with avrdude";
    homepage = "https://crates.io/crates/ravedude";
    license = with licenses; [ mit /* or */ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvarago ];
  };
}

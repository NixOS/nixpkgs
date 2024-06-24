{ lib
, stdenv
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-apk";
  version = "0.9.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1vCrM+0SNefd7FrRXnSjLhM3/MSVJfcL4k1qAstX+/A=";
  };

  cargoSha256 = "sha256-rGn3MKbqIRWayarsgedIOhuTTl8lyRsRxn7BN5Id97w=";

  meta = with lib; {
    description = "Tool for creating Android packages";
    mainProgram = "cargo-apk";
    homepage = "https://github.com/rust-windowing/android-ndk-rs";
    license = with licenses;[ mit asl20 ];
    maintainers = with maintainers; [ nickcao ];
  };
}

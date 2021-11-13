{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "unstable-2021-06-16";

  src = fetchFromGitHub {
    owner = "unrelentingtech";
    repo = pname;
    rev = "25912c0b6446f31b0f64485af3fa4aa8a93b33df";
    sha256 = "sha256-apq3kHipEX6zOTNwqpIQR46JqmeE7EKVSOGrNNSkyu8=";
  };

  cargoSha256 = "sha256-1aR9/fhJQ+keRIxSG2cpY1HTalE6nM+MTb1Za3Tot28=";

  meta = with lib; {
    homepage = "https://github.com/unrelentingtech/evscript";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}

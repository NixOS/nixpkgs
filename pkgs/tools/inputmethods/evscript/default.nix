{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "unstable-2021-06-16";

  src = fetchFromGitHub {
    owner = "unrelentingtech";
    repo = pname;
    rev = "410603abf4810320bf79bde90cc85367b71a8b12";
    sha256 = "sha256-apq3kHipEX6zOTNwqpIQR46JqmeE7EKVSOGrNNSkyu8=";
  };

  cargoHash = "sha256-1aR9/fhJQ+keRIxSG2cpY1HTalE6nM+MTb1Za3Tot28=";

  meta = with lib; {
    homepage = "https://github.com/unrelentingtech/evscript";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}

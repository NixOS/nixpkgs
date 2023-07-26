{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f4iJ9Fp6Rd1jv2ywRCjvFHjbdCGb116NiQ42fvQUE8A=";
  };

  cargoHash = "sha256-dt8OMlqNxd78sDxMPHG6jHEmF4LuFIMSo0BuQDWOM6o=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}

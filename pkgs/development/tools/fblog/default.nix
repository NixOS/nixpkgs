{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Leg0pd+dy4sWHprjwV61qZvV6t8MnfKifWBGF+Ne0+4=";
  };

  cargoHash = "sha256-JRy4UnTlBV8FcxxJyPJ1lXagnLdUQIIA/CBnVM24Yuk=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}

{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yNl+A0nwzCO4vJMNJTSTIpXK1zgfaK+ROMQ41gB+H1Y=";
  };

  cargoHash = "sha256-r+6kTNUn97SVCgZj7vCjksS2s/74OzeZgXOx7XOgMdY=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}

{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7+LoCYFI75268Qg2b64I1OOEMZuuxSI9S9Z0/XRLc70=";
  };

  cargoSha256 = "sha256-VMuCSX+FSssha472Lxij2DAYmfmTxLbDWFiRuN9488Q=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}

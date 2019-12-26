{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = pname;
    rev = "v${version}";
    sha256 = "02v5ra8qa75k00wg33xz072i1vi39yw8dmdbji84m57c3k7chfyf";
  };

  cargoSha256 = "1b53b4k8ni6iikj444f4612wb73vrkmfyxk7k4akhhhrr1kjvzhx";

  meta = with lib; {
    description = "Generate regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}

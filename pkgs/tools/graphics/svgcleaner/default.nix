{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "svgcleaner";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "svgcleaner";
    rev = "v${version}";
    sha256 = "1jpnqsln37kkxz98vj7gly3c2170v6zamd876nc9nfl9vns41s0f";
  };

  cargoSha256 = "172kdnd11xb2qkklqdkdcwi3g55k0d67p8g8qj7iq34bsnfb5bnr";

  meta = with lib; {
    description = "A tool for tidying and optimizing SVGs";
    homepage = "https://github.com/RazrFalcon/svgcleaner";
    license = licenses.gpl2;
    maintainers = [ maintainers.mehandes ];
  };
}

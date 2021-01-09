{ stdenv, fetchFromGitHub, rustPlatform, cmake }:
rustPlatform.buildRustPackage rec {
  pname = "unused";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "unused-code";
    repo = pname;
    rev = version;
    sha256 = "06r6m7k570rdm9szghnp3g4r6ij0vp8apfanqzzxv2hd7gf8v62b";
  };

  nativeBuildInputs = [ cmake ];

  cargoSha256 = "1c0gj2wp0nydv0binxj3ikm5sm6y5z3pklp5b06dgvq02licz57a";

  meta = with stdenv.lib; {
    description = "A tool to identify potentially unused code";
    homepage = "https://unused.codes";
    license = licenses.mit;
    maintainers = [ maintainers.lrworth ];
  };
}

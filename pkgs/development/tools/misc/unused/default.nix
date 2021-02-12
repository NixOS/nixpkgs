{ lib, fetchFromGitHub, rustPlatform, cmake }:
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

  cargoSha256 = "0m48vbx2n2ld8jbw7b6fbw6y49j6i44y95qwcqg27fin31bjn8q5";

  meta = with lib; {
    description = "A tool to identify potentially unused code";
    homepage = "https://unused.codes";
    license = licenses.mit;
    maintainers = [ maintainers.lrworth ];
  };
}

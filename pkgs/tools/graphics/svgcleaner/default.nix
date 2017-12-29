{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "svgcleaner-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "svgcleaner";
    rev = "v${version}";
    sha256 = "0l75a2kqh2syl14pmywrkxhr19fcnfpzjj9gj3503aw0r800g16m";
  };

  cargoSha256 = "1hl04wqdgspajf2w664i00vgp13yi0sxvjjpfs5vfhm641z3j69y";

  meta = with stdenv.lib; {
    description = "A tool for tidying and optimizing SVGs";
    homepage = "https://github.com/RazrFalcon/svgcleaner";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainer = [ maintainers.mehandes ];
  };
}

{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "svgcleaner-${version}";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "svgcleaner";
    rev = "v${version}";
    sha256 = "1jpnqsln37kkxz98vj7gly3c2170v6zamd876nc9nfl9vns41s0f";
  };

  cargoSha256 = "0d5jlq301s55xgdg9mv26hbj75pkjkyxfny7vbiqp9igj128lza3";

  meta = with stdenv.lib; {
    description = "A tool for tidying and optimizing SVGs";
    homepage = https://github.com/RazrFalcon/svgcleaner;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.mehandes ];
  };
}

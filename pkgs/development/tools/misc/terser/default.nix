{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.31.1";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-yKJPV6JGZTNCMjHh8v+MgnhaMuGF5cVHGEIJei896Hg=";
  };

  npmDepsHash = "sha256-E50RrEllhmluWe726KRmD2pcXbD2bSkWz8x6FeF+kOU=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}

{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "svgcleaner";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "svgcleaner";
    rev = "v${version}";
    sha256 = "1jpnqsln37kkxz98vj7gly3c2170v6zamd876nc9nfl9vns41s0f";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0kzrklw5nrzgvrfzq1mlnri06s19p4f3w38v39247baz2xd6j1n2";

  meta = with stdenv.lib; {
    description = "A tool for tidying and optimizing SVGs";
    homepage = "https://github.com/RazrFalcon/svgcleaner";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.mehandes ];
  };
}

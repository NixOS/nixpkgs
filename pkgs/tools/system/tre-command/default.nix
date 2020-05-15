{ rustPlatform, fetchFromGitHub, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "tre";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "1fazw2wn738iknbv54gv7qll7d4q2gy9bq1s3f3cv21cdv6bqral";
  };

  cargoSha256 = "16bvnwgjf3kj99d77j1pkldbasxfwy55sj9sv9vf2z6llfmzfabd";

  meta = with stdenv.lib; {
    description = "Tree command, improved";
    homepage = "https://github.com/dduan/tre";
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
    platforms = platforms.all;
  };
}

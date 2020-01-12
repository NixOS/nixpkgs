{ rustPlatform, fetchFromGitHub, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "tre";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "1fazw2wn738iknbv54gv7qll7d4q2gy9bq1s3f3cv21cdv6bqral";
  };

  cargoSha256 = "1k85xmmc3mdw6xipaww3ns7zndyg64dnb3w2q1hp9c3zas3nwmjn";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Tree command, improved";
    homepage = "https://github.com/dduan/tre";
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
    platforms = platforms.all;
  };
}

with import <nixpkgs> {};

rustPlatform.buildRustPackage rec {
  name = "tre-${version}";
  version = "v0.2.2";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "${version}";
    sha256 = "1fazw2wn738iknbv54gv7qll7d4q2gy9bq1s3f3cv21cdv6bqral";
  };

  cargoSha256 = "1lf7g96jh7apw537a0sm3a1ivf36bbxqbzllldjkbrh0x0fb4wpb";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Tree command, improved";
    homepage = https://github.com/dduan/tre;
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
    platforms = platforms.all;
  };
}

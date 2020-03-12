{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "0y71qr3ss3hgc8c7nmvpwk946xy1jc5d8whsv6y77wb24ncla7n0";
  };

  modSha256 = "1dgs643pmcw68yc003zss52hbvsy6hxzwkrhr0qmsqkmzxryb3bn";

  meta = with stdenv.lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}

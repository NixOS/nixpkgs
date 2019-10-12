{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "1d4sbvk9wqzl3g3da8inqdkvd43rkwvmq969jlgl1k1agv5xjxqv";
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

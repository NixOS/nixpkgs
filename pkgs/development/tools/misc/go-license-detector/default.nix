{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-license-detector";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "src-d";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gp7na2hqn5crr5x4khllsq7ka9h7rx8b4y10yzxmi0wpmxr53sw";
  };

  modSha256 = "163f1kiy7kqrnaazb8ydaaiz57lv30jyjkvv6i7pczvcg9yfhmdb";

  meta = with lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/src-d/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}

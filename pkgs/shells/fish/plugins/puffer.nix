{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "puffer";
  version = "unstable-2021-05-21";

  src = fetchFromGitHub {
    owner = "nickeb96";
    repo = "puffer-fish";
    rev = "df333fff5130ef8bf153c9bafbf0661534f81d9c";
    sha256 = "sha256-VtFrRzI476Hkutwwgkkc9hoiCma6Xyknm7xHeghrLxo=";
  };

  meta = with lib; {
    description = "Text Expansions for Fish";
    homepage = "https://github.com/nickeb96/puffer-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ kidonng ];
  };
}

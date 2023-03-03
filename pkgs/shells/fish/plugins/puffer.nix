{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "puffer";
  version = "unstable-2022-10-07";

  src = fetchFromGitHub {
    owner = "nickeb96";
    repo = "puffer-fish";
    rev = "fd0a9c95da59512beffddb3df95e64221f894631";
    hash = "sha256-aij48yQHeAKCoAD43rGhqW8X/qmEGGkg8B4jSeqjVU0=";
  };

  meta = with lib; {
    description = "Text Expansions for Fish";
    homepage = "https://github.com/nickeb96/puffer-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ quantenzitrone ];
  };
}

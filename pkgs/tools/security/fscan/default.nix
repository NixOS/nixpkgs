{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fscan";
  version = "1.8.3-build3";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = version;
    hash = "sha256-GtOCd8JaR6tx8hoB+P9QXrEnN7Wvmv7jddhc2/8hjvQ=";
  };

  vendorHash = "sha256-hvb2IfypwYauF3ubE36u0bTU+l/FWP/CZt6dFd9zc6s=";

  meta = with lib; {
    description = "An intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = licenses.mit;
    maintainers = with maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
}

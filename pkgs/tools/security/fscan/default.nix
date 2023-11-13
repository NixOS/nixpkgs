{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fscan";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = version;
    hash = "sha256-uoM/nMtgIqyzpOoSQKD5k4LXAXoA8G5N4In8tZlngqs=";
  };

  vendorHash = "sha256-hvb2IfypwYauF3ubE36u0bTU+l/FWP/CZt6dFd9zc6s=";

  meta = with lib; {
    description = "An intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = licenses.mit;
    maintainers = with maintainers; [ Misaka13514 ];
    platforms = with platforms; unix ++ windows;
  };
}

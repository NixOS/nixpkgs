{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fscan";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = version;
    hash = "sha256-PbhCKIr7qy4/hzx3TC7lnrQQw8rlUlprAbHdKdxgVuY=";
  };

  vendorHash = "sha256-pzcZgBcjGU5AyZfh+mHnphEboDDvQqseiuouwgb8rN8=";

  meta = with lib; {
    description = "An intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = licenses.mit;
    maintainers = with maintainers; [ Misaka13514 ];
    platforms = with platforms; unix ++ windows;
  };
}

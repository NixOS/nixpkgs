{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "2019-07-29";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "96300e3d49fbb3b7bc9c6dc74f8a5cc0ef46f84b";
    sha256 = "169hwggbhlr6ga045d6sa7xsan3mnj19qbh63i3h4rynqlppzvpf";
  };

  modSha256 = "1g7dkl60zwlk4q2gwx2780xys8rf2c4kqyy8gr99s5y342wsbx2g";

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = https://github.com/mvdan/gofumpt;
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}

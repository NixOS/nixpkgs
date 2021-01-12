{ lib, stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "babelfish";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "babelfish";
    rev = "v${version}";
    sha256 = "08i4y4fw60ynamr1jz8nkfkidxj06vcyhi1v4wxpl2macn6n4skk";
  };

  vendorSha256 = "0xjy50wciw329kq1nkd7hhaipcp4fy28hhk6cdq21qwid6g21gag";

  meta = with lib; {
    description = "Translate bash scripts to fish";
    homepage = "https://github.com/bouk/babelfish";
    license = licenses.mit;
    maintainers = with maintainers; [ bouk kevingriffin ];
  };
}

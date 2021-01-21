{ lib, stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "babelfish";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "babelfish";
    rev = "v${version}";
    sha256 = "1sr6y79igyfc9ia33nyrjjm4my1jrpcw27iks37kygh93npsb3r1";
  };

  vendorSha256 = "0xjy50wciw329kq1nkd7hhaipcp4fy28hhk6cdq21qwid6g21gag";

  meta = with lib; {
    description = "Translate bash scripts to fish";
    homepage = "https://github.com/bouk/babelfish";
    license = licenses.mit;
    maintainers = with maintainers; [ bouk kevingriffin ];
  };
}

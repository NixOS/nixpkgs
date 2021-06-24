{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mmake";
  version = "1.2.0";

  goPackagePath = "github.com/tj/mmake";

  src = fetchFromGitHub {
    owner = "tj";
    repo = "mmake";
    rev = "v${version}";
    sha256 = "1pyqgk04v0f7a28cwq9c40bd2cgrkrv4wqcijdzpgn4bqhrqab4f";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/tj/mmake";
    description = "A small program  which wraps make to provide additional functionality";
    longDescription = ''
      Mmake is a small program  which wraps make to provide additional
      functionality,  such   as  user-friendly  help   output,  remote
      includes,  and   eventually  more.   It  otherwise  acts   as  a
      pass-through to standard make.
      '';
    license = licenses.mit;
    maintainers = [ maintainers.gabesoft ];
  };
}

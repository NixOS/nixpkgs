{ buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {
  pname = "modd";
  version = "0.8";
  src = fetchFromGitHub {
    owner = "cortesi";
    repo = "modd";
    rev = "v${version}";
    sha256 = "1dmfpbpcvbx4sl4q1hwbfpalq1ml03w1cca7x40y18g570qk7aq5";
  };
  goPackagePath = "github.com/cortesi/modd";
  subPackages = [ "cmd/modd" ];
  goDeps = ./deps.nix;
  meta = with stdenv.lib; {
    description = "A flexible developer tool that runs processes and responds to filesystem changes";
    homepage = https://github.com/cortesi/modd;
    license = licenses.mit;
    maintainers = with maintainers; [ kierdavis ];
    platforms = platforms.all;
  };
}

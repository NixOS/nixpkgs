{ buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {
  pname = "devd";
  version = "0.9";
  src = fetchFromGitHub {
    owner = "cortesi";
    repo = "devd";
    rev = "v${version}";
    sha256 = "1b02fj821k68q7xl48wc194iinqw9jiavzfl136hlzvg4m07p1wf";
  };
  goPackagePath = "github.com/cortesi/devd";
  subPackages = [ "cmd/devd" ];
  goDeps = ./deps.nix;
  meta = with stdenv.lib; {
    description = "A local webserver for developers";
    homepage = https://github.com/cortesi/devd;
    license = licenses.mit;
    maintainers = with maintainers; [ brianhicks ];
    platforms = platforms.all;
  };
}

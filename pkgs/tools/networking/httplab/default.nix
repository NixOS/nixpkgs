{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "httplab-${version}";
  version = "0.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/gchaincl/httplab";

  src = fetchFromGitHub {
    owner = "gchaincl";
    repo = "httplab";
    inherit rev;
    sha256 = "19d0aasaxayvw25m9n2gahyq590dwym7k0fng8pqvrgc2mpl0ncw";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/gchaincl/httplab;
    description = "Interactive WebServer";
    license = licenses.mit;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}

{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "httplab";
  version = "0.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/gchaincl/httplab";

  src = fetchFromGitHub {
    owner = "gchaincl";
    repo = "httplab";
    inherit rev;
    sha256 = "0442nnpxyfl2gi9pilv7q6cxs2cd98wblg8d4nw6dx98yh4h99zs";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/gchaincl/httplab";
    description = "Interactive WebServer";
    license = licenses.mit;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}

{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "httplab-${version}";
  version = "0.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/gchaincl/httplab";

  src = fetchFromGitHub {
    owner = "gchaincl";
    repo = "httplab";
    inherit rev;
    sha256 = "1q9rp43z59nryfm79gci5a1gmqw552rqd4cki81rymbj3f6xvrf9";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/gchaincl/httplab;
    description = "Interactive WebServer";
    license = licenses.mit;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}

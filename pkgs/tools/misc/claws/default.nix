{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "claws";
  version = "0.3.2";

  goPackagePath = "github.com/thehowl/${pname}";

  src = fetchFromGitHub {
    rev = version;
    owner = "thehowl";
    repo = pname;
    sha256 = "0nl7xvdivnabqr98mh3m1pwqznprsaqpagny6zcwwmz480x4pmfz";
  };

  meta = with lib; {
    homepage = "https://github.com/thehowl/claws";
    description = "Interactive command line client for testing websocket servers";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}

{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "dapper";
  version = "0.5.1";

  goPackagePath = "github.com/rancher/dapper";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "dapper";
    rev = "v${version}";
    sha256 = "0sf56ii4sn2wdq5kiyl02sgvq0lvynzgiq8v5wrkkabj5107fiqw";
  };
   patchPhase = ''
     substituteInPlace main.go --replace 0.0.0 ${version}
   '';

  meta = with lib; {
    description = "Docker Build Wrapper";
    homepage = "https://github.com/rancher/dapper";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero ];
  };
}


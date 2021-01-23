{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "dapper";
  version = "0.5.4";

  goPackagePath = "github.com/rancher/dapper";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "dapper";
    rev = "v${version}";
    sha256 = "sha256-2KyDFiCxqoQt/m12vyHH8/L88+dOQGGsnI3l1G82NxQ=";
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


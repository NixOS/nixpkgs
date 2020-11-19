{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "dapper";
  version = "0.5.3";

  goPackagePath = "github.com/rancher/dapper";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "dapper";
    rev = "v${version}";
    sha256 = "1h62jahrxpmqx6r3mlakzap8gisrymgkp5syyarpab05qm1inngd";
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


{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gokart";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HsjLNY5Z5UidsLDWSP+1bu3jrfn3oAERPrPV/AkTH8I=";
  };

  vendorSha256 = "sha256-S3RukCKAJnPH1KGVdnkgAJQKEDTZYpcMMdoQ4OnHZVg=";

  # Would need files to scan which are not shipped by the project
  doCheck = false;

  meta = with lib; {
    description = "Static analysis tool for securing Go code";
    homepage = "https://github.com/praetorian-inc/gokart";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-junit-report-unstable";
  version = "2018-06-14";
  rev = "385fac0ced9acaae6dc5b39144194008ded00697";

  goPackagePath = "github.com/jstemmer/go-junit-report";

  src = fetchFromGitHub {
    inherit rev;
    owner = "jstemmer";
    repo = "go-junit-report";
    sha256 = "109zs8wpdmc2ijc2khyqija8imay88ka6v50xvrpnnwnd3ywckxi";
  };

  meta = with stdenv.lib; {
    description = "Converts go test output to an xml report, suitable for applications that expect junit xml reports (e.g. Jenkins)";
    homepage    = "https://${goPackagePath}";
    maintainers = with maintainers; [ cryptix ];
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}

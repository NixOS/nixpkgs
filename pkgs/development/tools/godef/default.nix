{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "godef";
  version = "1.1.2";
  rev = "v${version}";

  goPackagePath = "github.com/rogpeppe/godef";
  subPackages = [ "." ];

  vendorSha256 = null;

  src = fetchFromGitHub {
    inherit rev;
    owner = "rogpeppe";
    repo = "godef";
    sha256 = "0rhhg73kzai6qzhw31yxw3nhpsijn849qai2v9am955svmnckvf4";
  };

  meta = {
    description = "Print where symbols are defined in Go source code";
    homepage = "https://github.com/rogpeppe/godef/";
    maintainers = with stdenv.lib.maintainers; [ vdemeester rvolosatovs ];
    license = stdenv.lib.licenses.bsd3;
  };
}

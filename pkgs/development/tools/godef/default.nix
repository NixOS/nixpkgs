{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "godef-${version}";
  version = "1.1.1";
  rev = "v${version}";

  goPackagePath = "github.com/rogpeppe/godef";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "rogpeppe";
    repo = "godef";
    sha256 = "1bpzqnb9fsk1pjjap3gm94pqch1jz02rfah9hg8iqbfm0dzpy31b";
  };

  meta = {
    description = "Print where symbols are defined in Go source code";
    homepage = https://github.com/rogpeppe/godef/;
    maintainers = with stdenv.lib.maintainers; [ vdemeester rvolosatovs ];
    license = stdenv.lib.licenses.bsd3;
  };
}

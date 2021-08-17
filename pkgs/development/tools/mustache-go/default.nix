{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mustache-go";
  version = "1.2.2";

  goPackagePath = "github.com/cbroglie/mustache";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    rev = "v${version}";
    sha256 = "sha256-ziWfkRUHYYyo1FqVVXFFDlTsBbsn59Ur9YQi2ZnTSRg=";
  };

  meta = with lib; {
    homepage = "https://github.com/cbroglie/mustache";
    description = "The mustache template language in Go";
    license = [ licenses.mit ];
    maintainers = [ maintainers.Zimmi48 ];
  };
}

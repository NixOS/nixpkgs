{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "iamy-${version}";
  version = "2.1.1";

  goPackagePath = "github.com/99designs/iamy";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = "iamy";
    rev = "v${version}";
    sha256 = "0b55hxcvgil8rl6zh2kyndfi7s5nzclawjb0sby14wpys3v08bjf";
  };

  meta = with stdenv.lib; {
    description = "A cli tool for importing and exporting AWS IAM configuration to YAML files";
    homepage = https://github.com/99designs/iamy;
    license = licenses.mit;
    maintainers = with maintainers; [ suvash ];
  };
}

{ buildGoPackage, lib, fetchFromGitHub }:
buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "aws-vault";
  version = "4.5.1";

  goPackagePath = "github.com/99designs/${pname}";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y64fx15p9ls829lif7c0jaxyclzpnr8l5cyw25q545878dzmcs5";
  };

  # set the version. see: aws-vault's Makefile
  buildFlagsArray = ''
    -ldflags=
    -X main.Version=v${version}
  '';

  meta = with lib; {
    description = "A vault for securely storing and accessing AWS credentials in development environments";
    homepage = "https://github.com/99designs/aws-vault";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };

}

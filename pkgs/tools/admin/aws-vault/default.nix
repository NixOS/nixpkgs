{ buildGoPackage, lib, fetchFromGitHub }:
buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "aws-vault";
  version = "4.3.0";

  goPackagePath = "github.com/99designs/${pname}";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cwzvw1rcvg7y3m8dahr9r05s4i9apnfw5xhiaf0rlkdh3vy33wp";
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

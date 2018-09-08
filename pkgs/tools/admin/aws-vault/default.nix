{ buildGoPackage, lib, fetchFromGitHub }:
buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "aws-vault";
  version = "4.1.0";

  goPackagePath = "github.com/99designs/${pname}";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    sha256 = "04cdynqmkbs7bkl2aay4sjxq49i90fg048lw0ssw1fpwldbvnl6j";
  };

  meta = with lib; {
    description = "A vault for securely storing and accessing AWS credentials in development environments";
    homepage = https://github.com/99designs/aws-vault;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };

}

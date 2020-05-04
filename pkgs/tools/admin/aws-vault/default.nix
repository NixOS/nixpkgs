{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "aws-vault";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    sha256 = "04dyibcaijv5011laycf39m4gvprvvsn5zkxslyih1kqd170w3wg";
  };

  modSha256 = "1d3hjfmfmlpw2scfyn597zkzz864w97p0wrsxjp49m9mi0pgmhq9";
  subPackages = [ "." ];

  # set the version. see: aws-vault's Makefile
  buildFlagsArray = ''
    -ldflags=
    -X main.Version=v${version}
  '';

  meta = with lib; {
    description =
      "A vault for securely storing and accessing AWS credentials in development environments";
    homepage = "https://github.com/99designs/aws-vault";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}

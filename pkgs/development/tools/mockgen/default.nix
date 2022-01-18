{ buildGoModule, lib, fetchFromGitHub }:
buildGoModule rec {
  pname = "mockgen";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "golang";
    repo = "mock";
    rev = "v${version}";
    sha256 = "sha256-5Kp7oTmd8kqUN+rzm9cLqp9nb3jZdQyltGGQDiRSWcE=";
  };
  vendorSha256 = "sha256-5gkrn+OxbNN8J1lbgbxM8jACtKA7t07sbfJ7gVJWpJM=";

  doCheck = false;

  subPackages = [ "mockgen" ];

  meta = with lib; {
    description = "GoMock is a mocking framework for the Go programming language";
    homepage = "https://github.com/golang/mock";
    license = licenses.asl20;
    maintainers = with maintainers; [ bouk ];
  };
}

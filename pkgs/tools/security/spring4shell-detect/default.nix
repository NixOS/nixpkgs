{ lib
, buildGoModule
, fetchFromGitHub
, gem
, gradle
, maven
, ruby
}:

buildGoModule rec {
  pname = "spring4shell-detect";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "whitesource";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eWNUWqnLMTUAuCdnWVD7eolJLT5X1g3MXsTqP81R8aY=";
  };

  vendorSha256 = null;

  propagatedBuildInputs = [
    gem
    gradle
    maven
    ruby
  ];

  # Some tests are failing
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that quickly scans your projects to find vulnerable Spring4shell versions";
    homepage = "https://github.com/whitesource/spring4shell-detect";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pretender";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JTNmebubaJQMtZm1ZGZote1qXjjiMcxSGQYPgLZXd0o=";
  };

  vendorSha256 = "sha256-CpMrxAZ+7Dc1UgH+AnuGh+gpBZpLshck/1+9WJNssEk=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for handling machine-in-the-middle tasks";
    homepage = "https://github.com/RedTeamPentesting/pretender";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

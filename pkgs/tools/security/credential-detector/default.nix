{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "credential-detector";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ynori7";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g5ja32rsf1b7y9gvmy29qz2ymyyvgh53wzd6vvknfla1df0slab";
  };

  vendorSha256 = "1mn3sysvdz4b94804gns1yssk2q08djq3kq3cd1h7gm942zwrnq4";

  meta = with lib; {
    description = "Tool to detect potentially hard-coded credentials";
    homepage = "https://github.com/ynori7/credential-detector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-audit";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iJm33IZ3kGWnGVDVbQCTvoo+dXBU5092YYXZG+Z7vi0=";
  };

  vendorSha256 = "sha256-sQBnnBZm7kM8IAfsFhSIBLo2LLdTimVAQw1ogWo/a4Y=";

  # Tests need network access
  doCheck = false;

  meta = with lib; {
    description = "An alternative to the auditd daemon";
    homepage = "https://github.com/slackhq/go-audit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}

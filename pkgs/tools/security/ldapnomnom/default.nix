{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ldapnomnom";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eGCg6s3bg7ixXmdwFsugRMLvL/nTE2p53otkfc8OgQU=";
  };

  vendorSha256 = "sha256-3ucnLD+qhBSWY2wLtBcsOcuEf1woqHP17qQg7LlERA8=";

  meta = with lib; {
    description = "Tool to anonymously bruteforce usernames from Domain controllers";
    homepage = "https://github.com/lkarlslund/ldapnomnom";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

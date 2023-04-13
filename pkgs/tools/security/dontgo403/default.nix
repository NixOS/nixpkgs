{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dontgo403";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Gpr2L7iSdMBqwMzdYDtdzyZYu+Uwjn1wZvw4LTr8xWI=";
  };

  vendorHash = "sha256-he/+M8NffvMLTdFQy5E2EnqLXkS/tK6eUGXTBKZSZCw=";

  meta = with lib; {
    description = "Tool to bypass 40X response codes";
    homepage = "https://github.com/devploit/dontgo403";
    changelog = "https://github.com/devploit/dontgo403/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

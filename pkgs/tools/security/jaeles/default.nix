{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jaeles";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = pname;
    rev = "beta-v${version}";
    hash = "sha256-IGB+TYMOOO7fvRfDe9y+JSXuDSMDVJK+N4hS+kezG48=";
  };

  vendorSha256 = "sha256-3CKDkxvr7egHui6d8+25t9Zq2ePMUOULr+1NjEm4GXA=";

  runVend = true;

  # Tests want to download signatures
  doCheck = false;

  meta = with lib; {
    description = "Tool for automated Web application testing";
    homepage = "https://github.com/jaeles-project/jaeles";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

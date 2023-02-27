{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule
rec {
  pname = "eclint";
  version = "0.3.8";

  src = fetchFromGitLab {
    owner = "greut";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wAT+lc8cFf9zOZ72EwIeE2z5mCjGN8vpRoS1k15X738=";
  };

  vendorHash = "sha256-6aIE6MyNDOLRxn+CYSCVNj4Q50HywSh/Q0WxnxCEtg8=";

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://gitlab.com/greut/eclint";
    description = "EditorConfig linter written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}

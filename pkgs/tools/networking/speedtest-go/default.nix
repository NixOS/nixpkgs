{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "speedtest-go";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "showwin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9jLreb3tEw5bCVka6/BzGbsd5V3+9OHNzENe/IxL1YM=";
  };

  vendorHash = "sha256-A54G3fvs1bXSwPHVUNFC9VJqydqYR5t4I2fIBvrVoRE=";

  subPackages = [ "speedtest.go" ];

  # test suite requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI and Go API to Test Internet Speed using speedtest.net";
    homepage = "https://github.com/showwin/speedtest-go";
    changelog = "https://github.com/showwin/speedtest-go/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "speedtest";
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "speedtest-go";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "showwin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xZq7wiD0H6W7BeOQoTkWVmFM1dV24clJUibNaW0lLwk=";
  };

  vendorHash = "sha256-wQqAX7YuxxTiMWmV9LRoXunGMMzs12UyHbf4VvbQF1E=";

  excludedPackages = [ "example" ];

  # test suite requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI and Go API to Test Internet Speed using speedtest.net";
    homepage = "https://github.com/showwin/speedtest-go";
    changelog = "https://github.com/showwin/speedtest-go/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}

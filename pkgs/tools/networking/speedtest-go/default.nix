{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "speedtest-go";
  version = "1.6.10";

  src = fetchFromGitHub {
    owner = "showwin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Uk7ZKGxyK4b7P87qN7rGgj4oXJgYhH4NzZa+4fOkh14=";
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

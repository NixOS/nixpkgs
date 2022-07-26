{ lib
, buildGoModule
, gitls
, fetchFromGitHub
, testers
}:

buildGoModule rec {
  pname = "gitls";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-snoWnq+xmaxWzFthhO/gOYQDUMbpIZR9VkqcPaHzS6g=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  passthru.tests.version = testers.testVersion {
    package = gitls;
    command = "gitls -version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Tools to enumerate git repository URL";
    homepage = "https://github.com/hahwul/gitls";
    changelog = "https://github.com/hahwul/gitls/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

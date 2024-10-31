{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "speedtest-go";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "showwin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SFdUl06lCf+ObPZanEwvD2rSzPM0ia2J/XSuel5XGqg=";
  };

  vendorHash = "sha256-wQqAX7YuxxTiMWmV9LRoXunGMMzs12UyHbf4VvbQF1E=";

  excludedPackages = [ "example" ];

  # test suite requires network
  doCheck = false;

  meta = {
    description = "CLI and Go API to Test Internet Speed using speedtest.net";
    homepage = "https://github.com/showwin/speedtest-go";
    changelog = "https://github.com/showwin/speedtest-go/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aleksana
      luftmensch-luftmensch
    ];
    mainProgram = "speedtest-go";
  };
}

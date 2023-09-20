{ buildGoModule, fetchFromGitHub, lib, curlie, testers }:

buildGoModule rec {
  pname = "curlie";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EHSFr05VXJuOjUnweEJngdnfSUZUF1HsO28ZBSLGlvE=";
  };

  patches = [
    ./bump-golang-x-sys.patch
  ];

  vendorHash = "sha256-VsPdMUfS4UVem6uJgFISfFHQEKtIumDQktHQFPC1muc=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = curlie;
    command = "curlie version";
  };

  meta = with lib; {
    description = "Frontend to curl that adds the ease of use of httpie, without compromising on features and performance";
    homepage = "https://curlie.io/";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
  };
}

{ buildGoModule, fetchFromGitHub, lib, curlie, testers, updateGolangSysHook }:

buildGoModule rec {
  pname = "curlie";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3EKxuEpFm+lp2myMfymYYY9boSXGOF2iAdjtGKnjJK0=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-sumBuj0gI97gDM+kYsrpyzY2xpfUHUnJSgZtvwLXbAg=";

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

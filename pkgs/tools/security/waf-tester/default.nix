{ lib
, buildGoModule
, fetchFromGitHub
, testers
, waf-tester
}:

buildGoModule rec {
  pname = "waf-tester";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-baj9JuC4PF5c50K2aY+xwdE9t4aTzOu+isqJ6r1pWuc=";
  };

  vendorSha256 = "sha256-qVzgZX4HVXZ3qgYAu3a46vcGl4Pk2D1Zx/giEmPEG88=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = waf-tester;
    command = "waf-tester -version";
    version = "waf-tester ${version}, commit none, built at unknown by unknown";
  };

  meta = with lib; {
    description = "Tool to test Web Application Firewalls (WAFs)";
    homepage = "https://github.com/jreisinger/waf-tester";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}

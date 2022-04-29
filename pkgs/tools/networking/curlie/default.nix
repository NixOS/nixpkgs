{ buildGoModule, fetchFromGitHub, lib, curlie, testers }:

buildGoModule rec {
  pname = "curlie";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3EKxuEpFm+lp2myMfymYYY9boSXGOF2iAdjtGKnjJK0=";
  };

  vendorSha256 = "sha256-tYZtnD7RUurhl8yccXlTIvOxybBJITM+it1ollYJ1OI=";

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

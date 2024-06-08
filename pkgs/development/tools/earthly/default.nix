{ lib, buildGoModule, fetchFromGitHub, stdenv, testers, earthly }:

buildGoModule rec {
  pname = "earthly";
  version = "0.8.13";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    hash = "sha256-CldKyw9VEXMxfrQAUZozjhWZaF5QKIpRQ7l5Scus588=";
  };

  vendorHash = "sha256-jbzNzwa69qgySOYOSmzVC70Beqy7SGOo9I1xSBLAdfc=";
  subPackages = [ "cmd/earthly" "cmd/debugger" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
    "-X main.DefaultBuildkitdImage=docker.io/earthly/buildkitd:v${version}"
    "-X main.GitSha=v${version}"
    "-X main.DefaultInstallationName=earthly"
  ] ++ lib.optionals stdenv.isLinux [
    "-extldflags '-static'"
  ];

  tags = [
    "dfrunmount"
    "dfrunnetwork"
    "dfrunsecurity"
    "dfsecrets"
    "dfssh"
  ];

  postInstall = ''
    mv $out/bin/debugger $out/bin/earthly-debugger
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = earthly;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Build automation for the container era";
    homepage = "https://earthly.dev/";
    changelog = "https://github.com/earthly/earthly/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ zoedsoupe konradmalik ];
  };
}

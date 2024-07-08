{ lib, buildGoModule, fetchFromGitHub, stdenv, testers, earthly }:

buildGoModule rec {
  pname = "earthly";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    hash = "sha256-G9AvJMrgb71KxOaYScYOVuYSwubLlSd6a9KhzA8DKlA=";
  };

  vendorHash = "sha256-Uy/h6TBmDYHSewq3TbchLe+AtdvO2xNSp9pVDglRKVc=";
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

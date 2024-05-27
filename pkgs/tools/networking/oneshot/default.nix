{ lib, fetchFromGitHub, buildGoModule, testers, oneshot }:

buildGoModule rec {
  pname = "oneshot";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "forestnode-io";
    repo = "oneshot";
    rev = "v${version}";
    hash = "sha256-zGeXc/dzll5fYURufljVBbTyVhrI9pkqLufOB8ZdV0E=";
  };

  vendorHash = "sha256-TktSQMIHYXF9eyY6jyfE31WLXEq7VZU3qnVIMGjMMcA=";

  subPackages = [ "cmd" ];

  env.GOWORK = "off";

  modRoot = "v2";

  ldflags = [
    "-s"
    "-w"
    "-extldflags=-static"
    "-X github.com/forestnode-io/oneshot/v2/pkg/version.Version=${version}"
    "-X github.com/forestnode-io/oneshot/v2/pkg/version.APIVersion=v1.0.0"
  ];

  installPhase = ''
    runHook preInstall

    install -D -m 555 -T $GOPATH/bin/cmd $out/bin/oneshot

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = oneshot;
    command = "oneshot version";
  };

  meta = with lib; {
    description = "A first-come first-served single-fire HTTP server";
    homepage = "https://www.oneshot.uno/";
    license = licenses.mit;
    maintainers = with maintainers; [ milibopp ];
    mainProgram = "oneshot";
  };
}

{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  lib,
  testers,
  github-release,
}:

buildGoModule rec {
  pname = "github-release";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "github-release";
    repo = "github-release";
    rev = "v${version}";
    hash = "sha256-J5Y0Kvon7DstTueCsoYvw6x4cOH/C1IaVArE0bXtZts=";
  };

  vendorHash = null;

  patches = [
    # Update version info
    (fetchpatch {
      url = "https://github.com/github-release/github-release/commit/ee13bb17b74135bfe646d9be1807a6bc577ba7c6.patch";
      hash = "sha256-9ZcHwai0HOgapDcpvn3xssrVP9cuNAz9rTgrR4Jfdfg=";
    })

    # Add Go Modules support.
    # See https://github.com/Homebrew/homebrew-core/pull/162414.
    (fetchpatch {
      url = "https://github.com/github-release/github-release/pull/129/commits/074f4e8e1688642f50a7a3cc92b5777c7b484139.patch";
      hash = "sha256-OBFbOvNhqcNiuSCP0AfClntj7y5habn+r2eBkmClsgI=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = github-release;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Commandline app to create and edit releases on Github (and upload artifacts)";
    mainProgram = "github-release";
    longDescription = ''
      A small commandline app written in Go that allows you to easily create and
      delete releases of your projects on Github.
      In addition it allows you to attach files to those releases.
    '';

    license = licenses.mit;
    homepage = "https://github.com/github-release/github-release";
    maintainers = with maintainers; [
      ardumont
      j03
    ];
    platforms = with platforms; unix;
  };
}

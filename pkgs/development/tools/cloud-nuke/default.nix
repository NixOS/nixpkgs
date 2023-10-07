{ lib
, buildGoModule
, fetchFromGitHub
, makeBinaryWrapper
}:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jxhFBfz5CWycEXx86jL9inlP8nxNK7vbVn2U8EzQ7QA=";
  };

  vendorHash = "sha256-C2YXjfn3Pk0kL4G/cHsmr2VHUYGO+3s3eSiWVJZ2dX8=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${version}"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/cloud-nuke --set-default DISABLE_TELEMETRY true
  '';

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}

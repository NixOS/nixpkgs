{ stdenv
, lib
, fetchFromGitHub
, curl
, python3
}:
stdenv.mkDerivation rec {
  pname = "amazon-ec2-utils";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-utils";
    rev = version;
    hash = "sha256:04dpxaaca144a74r6d93q4lp0d5l32v07rldj7v2v1c6s9nsf4mv";
  };

  buildInputs = [
    python3
  ];

  propagatedBuildInputs = [
    curl
  ];

  installPhase = ''
    mkdir -p $out/bin/

    cp ebsnvme-id $out/bin/
    cp ec2-metadata $out/bin/
    cp ec2udev-vbd $out/bin/
    cp ec2udev-vcpu $out/bin/

    chmod +x $out/bin/*
  '';

  doInstallCheck = true;

  # We cannot run
  #     ec2-metadata --help
  # because it actually checks EC2 metadata even if --help is given
  # so it won't work in the test sandbox.
  installCheckPhase = ''
    $out/bin/ebsnvme-id --help
  '';

  meta = with lib; {
    homepage = "https://github.com/aws/amazon-ec2-utils";
    description = "Contains a set of utilities and settings for Linux deployments in EC2";
    license = licenses.mit;
    maintainers = with maintainers; [ ketzacoatl ];
  };
}

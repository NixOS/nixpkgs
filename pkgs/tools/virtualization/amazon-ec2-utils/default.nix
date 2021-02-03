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

  # The target installation directories are taken from `amazon-ec2-utils.spec`
  # of the source.
  installPhase = ''
    install -Dm755 ec2-metadata --target-directory $out/bin/

    install -Dm755 --target-directory $out/sbin/ ebsnvme-id
    install -Dm755 --target-directory $out/sbin/ ec2udev-vbd
    install -Dm755 --target-directory $out/sbin/ ec2udev-vcpu

    install -Dm755 --target-directory $out/lib/udev/ ec2nvme-nsid

    install -Dm644 --target-directory $out/etc/udev/rules.d/ 51-ec2-hvm-devices.rules
    install -Dm645 --target-directory $out/etc/udev/rules.d/ 52-ec2-vcpu.rules
    install -Dm644 --target-directory $out/etc/udev/rules.d/ 60-cdrom_id.rules
    install -Dm644 --target-directory $out/etc/udev/rules.d/ 70-ec2-nvme-devices.rules
  '';

  postFixup = ''
    for i in $out/etc/udev/rules.d/*.rules; do
      substituteInPlace "$i" \
        --replace '/sbin' "$out/bin"
    done

    substituteInPlace "$out/etc/udev/rules.d/70-ec2-nvme-devices.rules" \
      --replace 'ec2nvme-nsid' "$out/lib/udev/ec2nvme-nsid"
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
    maintainers = with maintainers; [ thefloweringash ketzacoatl ];
  };
}

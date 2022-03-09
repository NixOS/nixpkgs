{ stdenv
, lib
, fetchFromGitHub
, curl
, gawk
, python3
, installShellFiles
}:
stdenv.mkDerivation rec {
  pname = "amazon-ec2-utils";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-utils";
    rev = "v${version}";
    hash = "sha256-u1rHBV8uVcCywvQNYagtDleYB12tmhyqDbXTBzt45dk=";
  };

  outputs = [ "out" "man" ];

  strictDeps = true;
  buildInputs = [
    python3
  ];
  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    install -Dm755 -t $out/bin/ ebsnvme-id
    install -Dm755 -t $out/bin/ ec2-metadata
    install -Dm755 -t $out/bin/ ec2nvme-nsid
    install -Dm755 -t $out/bin/ ec2udev-vbd

    install -Dm644 -t $out/lib/udev/rules.d/ 51-ec2-hvm-devices.rules
    install -Dm644 -t $out/lib/udev/rules.d/ 51-ec2-xen-vbd-devices.rules
    install -Dm644 -t $out/lib/udev/rules.d/ 53-ec2-read-ahead-kb.rules
    install -Dm644 -t $out/lib/udev/rules.d/ 70-ec2-nvme-devices.rules
    install -Dm644 -t $out/lib/udev/rules.d/ 60-cdrom_id.rules

    installManPage doc/*.8
  '';

  postFixup = ''
    for i in $out/etc/udev/rules.d/*.rules $out/lib/udev/rules.d/*.rules ; do
      substituteInPlace "$i" \
        --replace '/usr/sbin' "$out/bin" \
        --replace '/bin/awk' '${gawk}/bin/awk'
    done

    substituteInPlace "$out/bin/ec2-metadata" \
      --replace 'curl' '${curl}/bin/curl'
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
    maintainers = with maintainers; [ ketzacoatl thefloweringash ];
  };
}

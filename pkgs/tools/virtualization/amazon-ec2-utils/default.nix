{ stdenv, lib, fetchFromGitHub, python3, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "amazon-ec2-utils";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-utils";
    rev = version;
    sha256 = "sha256-uxKnbdKGhS32kY3mA7YYtDRwKcEjNZPJUYQExZTqtxE=";
  };

  buildInputs = [ python3 ];
  # TODO next version will have manpages
  #nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    # https://github.com/aws/amazon-ec2-utils/blob/8eb2effb1aea2280264d66ae58b3e156e6d429f9/amazon-ec2-utils.spec#L74
    install -D --target $out/etc/udev/rules.d *.rules
    install -D --target $out/bin ec2-metadata ebsnvme-id ec2udev-vbd ec2udev-vcpu
    install -D --target $out/lib/udev/ ec2nvme-nsid
    # TODO next version will have manpages
    #installManPage doc/*
  '';

  postFixup = ''
    for i in $out/etc/udev/rules.d/*.rules; do
      substituteInPlace "$i" \
        --replace '/sbin' "$out/bin"
    done
    substituteInPlace "$out/etc/udev/rules.d/70-ec2-nvme-devices.rules" \
      --replace 'ec2nvme-nsid' "$out/lib/udev/ec2nvme-nsid"
  '';

  meta = {
    description = "A set of tools for running in EC2";
    homepage = "https://aws.amazon.com/amazon-linux-ami/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thefloweringash ];
  };
}

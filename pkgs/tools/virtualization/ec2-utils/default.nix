{ stdenv, lib, rpmextract, fetchurl, python2, tree }:

stdenv.mkDerivation {
  name = "ec2-utils";
  version = "0.5.1";

  # The url can be determined by booting an "Amazon Linux 2" and running:
  # > yumdownloader --urls ec2-utils
  src = fetchurl {
    url = "http://amazonlinux.ap-northeast-1.amazonaws.com/blobstore/a3b4d2c35c2300518fe10381a05b3bd7936ff5cdd3d351143a11bf84073d9e00/ec2-utils-0.5-1.amzn2.0.1.noarch.rpm";
    sha256 = "004y7l3q9gqi78a53lykrpsnz4yp7dds1083w67m2013bk1x5d53";
  };

  nativeBuildInputs = [ rpmextract ];

  buildInputs = [ python2 ];

  unpackPhase = ''
    mkdir source
    cd source
    rpmextract "$src"
  '';

  installPhase = ''
    mkdir $out

    mv --target-directory $out \
      etc sbin usr/bin usr/lib
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

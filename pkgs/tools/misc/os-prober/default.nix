{ stdenv, fetchurl, makeWrapper,
# optional dependencies, the command(s) they provide
coreutils,  # mktemp
grub2,      # grub-mount and grub-probe
cryptsetup, # cryptsetup
libuuid,    # blkid and blockdev
udev,    # udevadm udevinfo
ntfs3g      # ntfs3g
}:

stdenv.mkDerivation rec {
  version = "1.76";
  name = "os-prober-${version}";
  src = fetchurl {
    url = "https://salsa.debian.org/philh/os-prober/-/archive/${version}/os-prober-${version}.tar.bz2";
    sha256 = "07rw3092pckh21vx6y4hzqcn3wn4cqmwxaaiq100lncnhmszg11g";
  };

  buildInputs = [ makeWrapper ];
  installPhase = ''
    # executables
    install -Dt $out/bin os-prober linux-boot-prober
    install -Dt $out/lib newns
    install -Dt $out/share common.sh

    # probes
    case "${stdenv.hostPlatform.system}" in
        i686*|x86_64*) ARCH=x86;;
        powerpc*) ARCH=powerpc;;
        arm*) ARCH=arm;;
        *) ARCH=other;;
    esac;
    for probes in os-probes os-probes/mounted os-probes/init linux-boot-probes linux-boot-probes/mounted; do
      install -Dt $out/lib/$probes $probes/common/*;
      if [ -e "$probes/$ARCH" ]; then
        mkdir -p $out/lib/$probes
        cp -r $probes/$ARCH/* $out/lib/$probes;
      fi;
    done
    if [ $ARCH = "x86" ]; then
        cp -r os-probes/mounted/powerpc/20macosx $out/lib/os-probes/mounted;
    fi;
  '';
  postFixup = ''
    for file in $(find $out  -type f ! -name newns) ; do
      substituteInPlace $file \
        --replace /usr/share/os-prober/ $out/share/ \
        --replace /usr/lib/os-probes/ $out/lib/os-probes/ \
        --replace /usr/lib/linux-boot-probes/ $out/lib/linux-boot-probes/ \
        --replace /usr/lib/os-prober/ $out/lib/
    done;
    for file in $out/bin/*; do
      wrapProgram $file \
        --suffix PATH : ${stdenv.lib.makeBinPath [ grub2 udev coreutils cryptsetup libuuid ntfs3g ]} \
        --run "[ -d /var/lib/os-prober ] || mkdir /var/lib/os-prober"
    done;
  '';

  meta = with stdenv.lib; {
    description = "Utility to detect other OSs on a set of drives";
    homepage = http://packages.debian.org/source/sid/os-prober;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ symphorien ];
  };
}

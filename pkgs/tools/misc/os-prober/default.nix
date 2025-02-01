{ lib, stdenv, fetchFromGitLab, makeWrapper, nixosTests,
# optional dependencies, the command(s) they provide
coreutils,  # mktemp
grub2,      # grub-mount and grub-probe
cryptsetup, # cryptsetup
libuuid,    # blkid and blockdev
systemd,    # udevadm
ntfs3g,     # ntfs3g
dmraid,     # dmraid
lvm2        # lvs
}:

stdenv.mkDerivation rec {
  version = "1.81";
  pname = "os-prober";
  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "installer-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-3FXfGadIcmKp4qn6ZDcOSQHYsUNP2ObL1cJesNle+8A=";
  };

  nativeBuildInputs = [ makeWrapper ];
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
        --suffix PATH : ${lib.makeBinPath [ grub2 systemd coreutils cryptsetup libuuid ntfs3g lvm2 dmraid ]} \
        --run "[ -d /var/lib/os-prober ] || mkdir /var/lib/os-prober"
    done;
  '';

  passthru.tests = {
    os-prober = nixosTests.os-prober;
  };
  meta = with lib; {
    description = "Utility to detect other OSs on a set of drives";
    homepage = "http://packages.debian.org/source/sid/os-prober";
    license = licenses.gpl2Plus;
    mainProgram = "os-prober";
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.linux;
  };
}

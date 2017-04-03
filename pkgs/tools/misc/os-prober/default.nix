{ stdenv, fetchurl, makeWrapper,
systemd, # udevadm
busybox,
coreutils, # os-prober desn't seem to work with pure busybox
devicemapper, # lvs
# optional dependencies
cryptsetup ? null,
libuuid ? null, # blkid and blockdev
dmraid ? null,
ntfs3g ? null
}:

stdenv.mkDerivation rec {
  version = "1.73";
  name = "os-prober-${version}";
  src = fetchurl {
    url = "mirror://debian/pool/main/o/os-prober/os-prober_${version}.tar.xz";
    sha256 = "1prssbwdgj5c33zhl3ldgaxk7lab9qvs4zhyrhag88wiivirb0sq";
  };

  buildInputs = [ makeWrapper ];
  installPhase = ''
    # executables
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share
    cp os-prober linux-boot-prober $out/bin
    cp newns $out/lib
    cp common.sh $out/share

    # probes
    case "${stdenv.system}" in
        i686*|x86_64*) ARCH=x86;;
        powerpc*) ARCH=powerpc;;
        arm*) ARCH=arm;;
        *) ARCH=other;;
    esac;
    for probes in os-probes os-probes/mounted os-probes/init linux-boot-probes linux-boot-probes/mounted; do
      mkdir -p $out/lib/$probes;
      cp $probes/common/* $out/lib/$probes;
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
        --set LVM_SYSTEM_DIR ${devicemapper} \
        --suffix PATH : "$out/bin${builtins.foldl' (x: y: x + ":" + y) "" (
          map (x: (toString x) + "/bin") (
            builtins.filter (x: x!=null)
              [ devicemapper systemd coreutils cryptsetup libuuid dmraid ntfs3g busybox ]
            )
          )
        }" \
        --run "[ -d /var/lib/os-prober ] || mkdir /var/lib/os-prober"
    done;
  '';

  meta = {
    description = "Utility to detect other OSs on a set of drives";
    homepage = http://packages.debian.org/source/sid/os-prober;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

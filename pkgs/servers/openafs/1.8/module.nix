{ lib
, stdenv
, fetchurl
, which
, autoconf
, automake
, flex
, bison
, kernel
, glibc
, perl
, libtool_2
, libkrb5
, fetchpatch
}:

with (import ./srcs.nix {
  inherit fetchurl;
});

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  fetchBase64Patch = args: (fetchpatch args).overrideAttrs (o: {
    postFetch = "mv $out p; base64 -d p > $out; " + o.postFetch;
  });

in
stdenv.mkDerivation {
  pname = "openafs";
  version = "${version}-${kernel.modDirVersion}";
  inherit src;

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which bison ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [ libkrb5 ];

  patches = [
    # Add autoconf-archive to src/external
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14942/revisions/006616bd8e88b2d386a5ddc23973cf3e625cb80d/patch";
      hash = "sha256-55sc2sKy5XkQHAv6ysVxi69+0xVsHnN2TS144UTeLHU=";
    })
    # Import of code from autoconf-archive
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14943/revisions/d3782b1d4e6fd81c5432e95112eb44305f07f272/patch";
      hash = "sha256-ohkjSux+S3+6slh6uZIw5UJXlvhy9UUDpDlP0YFRwmw=";
    })
    # Use autoconf-archive m4 from src/external
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14944/revisions/ea2a0e128d71802f61b8da2e44de3c6325c5f328/patch";
      hash = "sha256-PAUk/MXL5p8xwhn40/UGmo3UIhvl1PB2FwgqhmqsjJ4=";
    })
    # Linux-5.17: kernel func complete_and_exit renamed
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14945/revisions/a714e865efe41aa1112f6f9c8479112660dacd6f/patch";
      hash = "sha256-zvyR/GOPJeAbG6ySRRMp44oT5tPujUwybyU0XR/5Xyc=";
    })
    # Linux-5.17: Kernel build uses -Wcast-function-type
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/14946/revisions/449d1faf87e2841e80be38cf2b4a5cf5ff4df2d8/patch";
      hash = "sha256-3bRTHYeMRIleLhob56m2Xt0dWzIMDo3QrytY0K1/q7c=";
    })
  ];

  hardeningDisable = [ "pic" ];

  configureFlags = [
    "--with-linux-kernel-build=${kernelBuildDir}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gssapi"
    "--disable-linux-d_splice-alias-extra-iput"
  ];

  preConfigure = ''
    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc.dev}/include" \
        --replace "/usr/src" "${kernelBuildDir}"
    done

    ./regen.sh -q
  '';

  buildPhase = ''
    make V=1 only_libafs
  '';

  installPhase = ''
    mkdir -p ${modDestDir}
    cp src/libafs/MODLOAD-*/libafs-${kernel.modDirVersion}.* ${modDestDir}/libafs.ko
    xz -f ${modDestDir}/libafs.ko
  '';

  meta = with lib; {
    description = "Open AFS client kernel module";
    homepage = "https://www.openafs.org";
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = with maintainers; [ maggesi spacefrogg ];
    broken = kernel.isHardened || kernel.kernelAtLeast "5.18";
  };
}

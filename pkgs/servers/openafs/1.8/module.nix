{ stdenv, fetchurl, which, autoconf, automake, flex, yacc
, kernel, glibc, perl, libtool_2, kerberos, fetchpatch }:

with (import ./srcs.nix {
  inherit fetchurl;
});

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in stdenv.mkDerivation {
  name = "openafs-${version}-${kernel.modDirVersion}";
  inherit version src;

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which yacc ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [ kerberos ];

  patches = [
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/d7fc5bf9bf031089d80703c48daf30d5b15a80ca.patch";
      sha256 = "0469ydzgvyvrl1b2s1qbl9cd8c5c1nb99c3z52z5i685da5z6pab";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/335f37be13d2ff954e4aeea617ee66502170805e.patch";
      sha256 = "0jr6cgplnip61cjlcd3fvgsc6n3jhfk93mm9m7ak04w1vc26dk9x";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/facff58b840a47853592510617ba7a1da2e3eaa9.patch";
      sha256 = "0izafg6bi5iaigq3jjx0zlg1cxwaddz3238hk0s08fcb6nyhkvx1";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/e7902252f15acfc28453c531f6fa3b29c9c91b92.patch";
      sha256 = "1jy4v8yx8p6mhma6b3h3g94mb38bw7hg7q6lnyc8bijkbnl0d1rl";
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

  meta = with stdenv.lib; {
    description = "Open AFS client kernel module";
    homepage = "https://www.openafs.org";
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.maggesi maintainers.spacefrogg ];
    broken = with kernel; kernelOlder "3.18" || kernelAtLeast "5.10" || isHardened;
  };

}

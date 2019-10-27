{ stdenv, fetchurl, fetchpatch, which, autoconf, automake, flex, bison
, kernel, glibc, perl }:

with (import ./srcs.nix { inherit fetchurl; });

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in stdenv.mkDerivation {
  name = "openafs-${version}-${kernel.modDirVersion}";
  inherit version src;

  patches = [
    # Linux 4.20
    (fetchpatch {
      name = "openafs_1_6-current_kernel_time.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=b9936e944a2b4f5773d66864cbb297993b050e65";
      sha256 = "16fl9kp0l95dqm166jx3x4ijbzhf2bc9ilnipn3k1j00mfy4lnia";
    })
    (fetchpatch {
      name = "openafs_1_6-do_settimeofday.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=fe6fb38b3d4095351955b9872d0fd6cba64f8784";
      sha256 = "0k6kgk1ybhm9xx2l0wbcyv7jimkr9mfs2ywvxy8hpyhcm7rbwjkp";
    })
    # Linux 5.0
    (fetchpatch {
      name = "openafs_1_6-super_block.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=61db15f1badabd83e289efd622e274c47f0aefda";
      sha256 = "0cdd76s1h1bhxj0hl7r6mcha1jcy5vhlvc5dc8m2i83a6281yjsa";
    })
  ];
  nativeBuildInputs = [ autoconf automake flex perl bison which ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  configureFlags = [
    "--with-linux-kernel-build=${kernelBuildDir}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
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
    homepage = https://www.openafs.org;
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.z77z maintainers.spacefrogg ];
    broken = versionOlder kernel.version "3.18" || builtins.compareVersions kernel.version "5.0" >= 0
             || stdenv.targetPlatform.isAarch64;
  };

}

{ stdenv, fetchurl, fetchpatch, which, autoconf, automake, flex, yacc
, kernel, glibc, perl, libtool_2, kerberos }:

with (import ./srcs.nix { inherit fetchurl; });

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in stdenv.mkDerivation rec {
  name = "openafs-${version}-${kernel.modDirVersion}";
  inherit version src;

  patches = [
    # Linux 4.20
    (fetchpatch {
      name = "openafs_1_8-do_settimeofday.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=aa80f892ec39e2984818090a6bb2047430836ee2";
      sha256 = "11zw676zqi9sj3vhp7n7ndxcxhp17cq9g2g41n030mcd3ap4g53h";
    })
    (fetchpatch {
      name = "openafs_1_8-current_kernel_time.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=3c454b39d04f4886536267c211171dae30dc0344";
      sha256 = "16fl9kp0l95dqm166jx3x4ijbzhf2bc9ilnipn3k1j00mfy4lnia";
    })
    # Linux 5.0
    (fetchpatch {
      name = "openafs_1_8-ktime_get_coarse_real_ts64.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=21ad6a0c826c150c4227ece50554101641ab4626";
      sha256 = "0cd2bzfn4gkb68qf27wpgcg9kvaky7kll22b8p2vmw5x4xkckq2y";
    })
    (fetchpatch {
      name = "openafs_1_8-ktime_get_real_ts64.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=b892fb127815bdf72103ae41ee70aadd87931b0c";
      sha256 = "1xmf2l4g5nb9rhca7zn0swynvq8f9pd0k9drsx9bpnwp662y9l8m";
    })
    (fetchpatch {
      name = "openafs_1_8-super_block.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=3969bbca6017eb0ce6e1c3099b135f210403f661";
      sha256 = "0cdd76s1h1bhxj0hl7r6mcha1jcy5vhlvc5dc8m2i83a6281yjsa";
    })
  ];

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which yacc ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [ kerberos ];

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
    homepage = https://www.openafs.org;
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.z77z maintainers.spacefrogg ];
    broken = versionOlder kernel.version "3.18";
  };

}

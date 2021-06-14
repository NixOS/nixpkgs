{ lib, stdenv, fetchurl, which, autoconf, automake, flex, bison
, kernel, glibc, perl, libtool_2, libkrb5, fetchpatch }:

with (import ./srcs.nix {
  inherit fetchurl;
});

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in stdenv.mkDerivation {
  name = "openafs-${version}-${kernel.modDirVersion}";
  inherit version src;

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which bison ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [ libkrb5 ];

  patches = [
    # LINUX 5.8: Replace kernel_setsockopt with new funcs
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/d7fc5bf9bf031089d80703c48daf30d5b15a80ca.patch";
      sha256 = "0469ydzgvyvrl1b2s1qbl9cd8c5c1nb99c3z52z5i685da5z6pab";
    })
    # LINUX 5.8: do not set name field in backing_dev_info
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/335f37be13d2ff954e4aeea617ee66502170805e.patch";
      sha256 = "0jr6cgplnip61cjlcd3fvgsc6n3jhfk93mm9m7ak04w1vc26dk9x";
    })
    # LINUX 5.8: use lru_cache_add
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/facff58b840a47853592510617ba7a1da2e3eaa9.patch";
      sha256 = "0izafg6bi5iaigq3jjx0zlg1cxwaddz3238hk0s08fcb6nyhkvx1";
    })
    # LINUX 5.9: Remove HAVE_UNLOCKED_IOCTL/COMPAT_IOCTL
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/e7902252f15acfc28453c531f6fa3b29c9c91b92.patch";
      sha256 = "1jy4v8yx8p6mhma6b3h3g94mb38bw7hg7q6lnyc8bijkbnl0d1rl";
    })
    # Linux: Refactor test for 32bit compat
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/4ad1057ab8fd206c9fa8d5e3bdde4f1a8417afdb.patch";
      sha256 = "0v2537wkav78yi8lv6fkd1n6rf2g17igf44rpa3kd0kkidxv5lqr";
    })
    # Linux 5.11: Test 32bit compat with in_compat_syscall
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/ee53dd3bc087a05e22fc4111297a51ddb30013f0.patch";
      sha256 = "0dfab3zk0dmf6iksna5n09lf5dn4f8w43q4irl2yf5dgqm35shkr";
    })
    # Linux: Create wrapper for setattr_prepare
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/5a5d358b02b88d6d2c7a27a75149e35b1de7db38.patch";
      sha256 = "07gywsg41cz5h6iafr4pb0gb9jnsb58xkwn479lw46b3y5jgz7ki";
    })
    # Linux 5.12: Add user_namespace param to inode ops
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/c747b15dd2877e6d17e3e6b940ae78c1e1ccd3ea.patch";
      sha256 = "0bbqmx4nkmfkapk25zrv9ivhhs91rn9dizb1lkfs7a6937q1kaqh";
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
    maintainers = [ maintainers.maggesi maintainers.spacefrogg ];
    broken = versionOlder kernel.version "3.18" || kernel.isHardened;
  };
}

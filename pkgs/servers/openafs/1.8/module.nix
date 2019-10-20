{ stdenv, fetchurl, which, autoconf, automake, flex, yacc
, kernel, glibc, perl, libtool_2, kerberos, fetchpatch }:

with (import ./srcs.nix { inherit fetchurl; });

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in stdenv.mkDerivation {
  name = "openafs-${version}-${kernel.modDirVersion}";
  inherit version src;

  patches = [
    # Linux 5.3
    (fetchpatch {
      name = "openafs_1_8-recurse-keyring_search.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=02d82275c17284d04629282aa374bb39f511c989";
      sha256 = "03pkldwf6i67yf6i1705qp18rx5b0b342ryda8vfjw9lnvpinygs";
    })
    (fetchpatch {
      name = "openafs_1_8-send-sig.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=2b7af1243f46496c0b5973b3fa2a6396243f7613";
      sha256 = "13gyh5ncpp15dl7056gdzl5xhp2bmafc557bd2a4bwx9nyj53bag";
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

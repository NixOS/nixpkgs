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
    # patches for Linux kernel 5.6 and 5.7, included in the next release
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/5679fdb720525ec5289e80927fdd8b25cf2ae62f.patch";
      sha256 = "16dbdindj6vy1y9jq56gy5zbwzh2a16ymq7zba5fl8pgxmp1krdr";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/34f1689b7288688550119638ee9959e453fde414.patch";
      sha256 = "0rxjqzr8c5ajlk8wrhgjc1qp1934qiriqdi0qxsnk4gj5ibbk4d5";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/355ea43f0d1b7feae1b3af58bc33af12838db7c3.patch";
      sha256 = "1f9xn8ql6vnxglpj3dvi30sj8vkncazjab2rc13hbw48nvsvcnhm";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/17d38e31e6f2e237a7fb4dfb46841060296310b6.patch";
      sha256 = "14dydxfm0f5fvnj0kmvgm3bgh0ajhh04i3l7l0hr9cpmwl7vrlcg";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/8db1ef3eee67e40643eaf017a62d7f2c23473e9b.patch";
      sha256 = "0sxgiz3s6y89ca3rzbjc4c7jll1mzxzdaf3lb0kzx4mvg8rmhnfr";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/81581b362af86b4f636d8e411e9cb8f1cf86f723.patch";
      sha256 = "1d8jv4wrf7s4aqbpnn2g15qbn2jbzndlvf3fqjmblx757bymsv17";
    })
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/b7c5502516333d41aa1fa046c918dfece722f77c.patch";
      sha256 = "0nrk9pnk41s5a1xbikkk0x5glljiscgbka1plqzp3spbyjk0f4cz";
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
    broken = versionOlder kernel.version "3.18";
  };

}

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

let
  inherit (import ./srcs.nix { inherit fetchurl; }) src version;

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

  patches = [
    # afs: Make afs_AllocDCache static
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/fca6fd911e493a344c040a95ea4ab820e2828802.patch";
      hash = "sha256-XJAiZ7XL+QFk3l0CUSzudUSGC+oC7v4Kew9TWmEKvNg=";
    })
    # LINUX: Minor osi_vfsop.c cleanup
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/1e1bf8ebcd3c18b05326cd7b26a471db804aeaeb.patch";
      hash = "sha256-kw8CQrpK9caq8eXrCEbk2zTSb727d8NmaSQg0Bg/TAM=";
    })
    # afs: Remove SRXAFSCB_GetDE
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/9f052c137d1184a783c8ac3182c3544b275484f5.patch";
      hash = "sha256-3AMq5fAUt/HAIRuh/GAWPov3gwvMzVAqzmvpIKZLbBo=";
    })
    # afs: remove dead ICL (fstrace) code
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/05ac6149f2f7998b6110c403d26757151b8e8ffe.patch";
      hash = "sha256-wXbM1hFnaAKJEMMoOdHd9xIjFY2Jk02/Frv8IvrnrGc=";
    })
    # cf: Add function prototypes for linux conftest
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/ef7b8c578790d84c89f09c3236f1718725770e75.patch";
      hash = "sha256-6tceVLqrhdo5QWjOCvutvZmetopz+tyP5AtJUh7Kkkc=";
    })
    # afs: Remove afs_MemExtendEntry()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/4881af8e3cf3f7d09670ba4b5bb9b644a329530d.patch";
      hash = "sha256-9CA0lwiNjzeteAPXh/Yyu3gqZBSi2b9XBrl43w2VzSs=";
    })
    # afs: Remove afs_osi_UnmaskUserLoop()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/cc8053e86eef75bff308e7606f2618e9fdc4ec5d.patch";
      hash = "sha256-jBwd0zFidIfNx6csPSNp1RGCq1JKmXNXWbQnG2pIgvM=";
    })
    # afs: Remove dummy_PSetAcl()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/bd2828f1ab4c88b95a5d075e29a942922aa86dba.patch";
      hash = "sha256-ExvIzyyqPijf5c1T3mpSqFefvbd42FpLIFYUpcc5fyk=";
    })
    # afs: Remove DFlushDCache()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/bb7eaafb2e87d313eeb0a7bedebe2aa7a797b005.patch";
      hash = "sha256-/S4uZj+cScPFihvJDW49dQ2awrt7Thx7tIpoImIl/kg=";
    })
    # afs: Remove SRXAFSCB_FetchData/StoreData
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/be8001f1d64a2d9da4fdaeff59fdc40e205d4526.patch";
      hash = "sha256-xpnyHLSybr3CFSE7BeyVLqDWbH44gfC2a9ygHojD4NI=";
    })
    # afs: Remove afs_DbgDisconFiles()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/73844a4939a7b8198bf11d4dcbce9e28b621bd11.patch";
      hash = "sha256-m0/jd8DBIht6M+Wzns8qN6APyYUgyN4+zlHs09NoFVE=";
    })
    # afs: Add declaration for RXAFS_ResidencyCmd()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/5d2c4a0a8ada4a87d7f39dc21dbce14b3b2a978f.patch";
      hash = "sha256-jzZG7w0tOxkrcphiITHrfodCZ6wyGp1NVARLI/tfN3c=";
    })
    # roken: Declare ct_memcmp in hcrypto kernel roken.h
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/15357006d9e8e45ac0be9e0c7e87456ee3857d90.patch";
      hash = "sha256-OrkUiybGI2jOsEqQFeGXTQqWvgp1NwttuPvokNkwxHw=";
    })
    # Linux 6.8: Add function prototypes for krb5
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/b1c93f13870e24795b857cb483320871703d00e8.patch";
      hash = "sha256-PMnW4H/s2uKda3xbka2+2nz422pksttrYvsTf+omzrc=";
    })
    # afs: Declare init_hckernel_mutex()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/25e17fe7196fd4a46e6a9408d135812ca53ddf80.patch";
      hash = "sha256-73zpSSF2yfbA7wxZVdKWnOqkMtdi/EkT8IjpXIMNUnc=";
    })
    # afs: Add includes to pick up function prototypes
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/8b516820abf1edace60276152e9ed18a0b30fc13.patch";
      hash = "sha256-V+cMQw+l78amvjzMI0cgVzwtHNCVoSAfwwgSOhv3zNU=";
    })
    # afs: Move function prototypes into headers
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/c04c2d07226583846c3949a4855c7db4316438da.patch";
      hash = "sha256-WrfPZvNNVN3VuuBGH4sshpJOoPP2hwVitQW8PqQCBRA=";
    })
    # afs: Add afs_xioctl prototyes to afs_prototypes.h
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/96932160fa8ef1cf4422e9e1d1ca2a449f8ffe93.patch";
      hash = "sha256-HJzTJlKNGjuXALXoaUjuQEr5Us2KLM9Exuj7jGqvHyg=";
    })
    # afs: Remove SRXAFSCB* protos from afs_prototypes.h
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/53752b01bc734f4bd5f5da24ac116c7fcb2ac07f.patch";
      hash = "sha256-OfiubrKbHoHS1J/WjMOaZ9njMHELnQAegLxiVfPFBX8=";
    })
    # rx: Add function prototypes to rx_prototypes.h
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/09f9660fbbb4f3c20ba9f2283169818372c3f474.patch";
      hash = "sha256-KYGehW48hw71dAIdd5Z5U5Kvp72Gk4Tu2q+VA50LL7A=";
    })
    # afs: fix 'ops' variable may be used uninitialized
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/90b8dcff36e9b03ec01550ad1a070a0ab7db8c46.patch";
      hash = "sha256-IIjuY9LL2BjnUh8W8n5ohUVY7RNk5qoH58JpimXqrNo=";
    })
    # afs: Add static attribute to internal functions
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/195f154aaf2d8aff1f6debdb47c0db8f07cb5c5e.patch";
      hash = "sha256-LKBYqorko5HmaigKWFiIiYHgVnyc03UcQX6p8CjfYrs=";
    })
    # rx: Add static attribute to internal functions
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/4c92936aefede187e57a9a433c0c192af2fc5e84.patch";
      hash = "sha256-+Oq8CFI3+29WdCabrHV4+AU3U3fuyIUO+wYzy/QJ/24=";
    })
    # rxgen: Declare generated PKG_TranslateOpCode()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/57e0192a690942c2a0f4f1f685cfadf2106b763a.patch";
      hash = "sha256-iErcC/J9L7TrjnbkJw9yHXR4wHCM+KHai0vzs+KEgfo=";
    })
    # rxgen: Declare generated PKG_OpCodeStats()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/fef1fc6f740c6f7395cf51ce99ed296652579c7d.patch";
      hash = "sha256-copfhVvIa6zScehQm6gZ5FaIT42wr+YoFdhPCN50xn4=";
    })
    # Linux 6.8: use hlist iteration for dentry children
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/18a2a932df9c1b6b3c7513a6c161d4259f052ca9.patch";
      hash = "sha256-NwF1CvdI9ZjISc1A/nJP4Ea1LJY4lBnsbkRqvQFo5Wc=";
    })
    # Linux 6.8: Remove ctl_table sentinels
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/6333fae573f8a7b7656e9c1b05d445a37b951b88.patch";
      hash = "sha256-g8acwb7bGF+LjQN8tVKFLXvATddN+8gSepVoM28AehA=";
    })
    # Linux 6.8: Use roken's strlcpy() in kernel module
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/7b4802efaf29ef76969c8b931a31e93dd4fbb000.patch";
      hash = "sha256-4P+9VkDhMezPHa47a5L92Rh+6PMGxF54Agdx4uAU63Y=";
    })
    # Linux: Remove weak attribute for key_type_keyring
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/d1a42401fddc51bd2f16da39dfebe0f60fc670ad.patch";
      hash = "sha256-hg9UTc/gKfo7OcklxkEHwCjabHdwd6XOKEvtn/azQys=";
    })
    # Linux: Define afs_thread_wrapper() as static
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/dfb6b53a6802e90f6bc2cd3cd39da467ce8e4488.patch";
      hash = "sha256-xhkBWA6WxpJ9VOqvy5vjFUoLM2N2Ap2gdLva2o+q6n4=";
    })
    # rxperf: Add -o option to rxperf client
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/4fc27548be88947ef58e2a3a3654a08ec6c334d9.patch";
      hash = "sha256-mteEhVU49aEeUAj77T7Mo4qmZNBwRZY13VOwXzht5kQ=";
    })
    # Linux-6.9: file_lock mbrs moved to file_lock_core
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/de7bc4890e4368b88f20e15a7d795fc1c54cef29.patch";
      hash = "sha256-SXCf2fyN/Xa37O/CTe+Hjy7EY7VnEYV0QhXJx3zCws8=";
    })
    # afs: Reintroduce and use DFlushDCache()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/3ff310182926ab783f0f07fa8667d1ebaabbc5de.patch";
      hash = "sha256-+76X25+TLgqDuam4wAKa78QkvANs8NCnOi2EeA7tzs4=";
    })
    # dir: check afs_dir_Create return code in afs_dir_MakeDir
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/db39f77f0ec931816ba5cc265e87954173b435e2.patch";
      hash = "sha256-7gX9f2cvrw0mO36T492B1WvInXtp1lNYoDUsGIQ9+Ag=";
    })
    # dir: check DNew return code
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/837e6a4ad28588f22b4e9ace9bfa4bb4f412485c.patch";
      hash = "sha256-1NpJq4F5z9csdpfBNc0k439J7toIFMm2a576lrhC4so=";
    })
    # afs: avoid panic in DNew when afs_WriteDCache fails
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/4022359253fb6a645b01f99b820b7331c019115a.patch";
      hash = "sha256-2sxgmk5Y4Ai5xlUwlEARQXL+z/05r7heYfBC+WV+8xo=";
    })
    # afs: Correct comment typo in DNew()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/308ee38a30549afd38ad1f83bb537fd6b43513a8.patch";
      hash = "sha256-qePB+/9uelKAyjbfaK5tUzDcIbrSIYVrOBF7kimKPrE=";
    })
    # Linux-6.10: Use filemap_alloc_folio when avail
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/0f6a3a402f4a66114da9231032bd68cdc4dee7bc.patch";
      hash = "sha256-1D0mijyF4hbd+xCONT50cd6T9eCpeM8Li3nCI7HgLPA=";
    })
    # Linux-6.10: define a wrapper for vmalloc
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/658942f2791fad5e33ec7542158c16dfc66eed39.patch";
      hash = "sha256-MhfAUX/eNOEkjO0cGVbnIdObMlGtLdCnnGfJECDwO+A=";
    })
    # Linux-6.10: remove includes for asm/ia32_unistd.h
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/03b280649f5e22ed74c217d7c98c3416a2fa9052.patch";
      hash = "sha256-ZdXz2ziuflqz7zNzjepuGvwDAPM31FIzsoEa4iNdLmo=";
    })
    # afs: avoid empty-body warning
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/d8b56f21994ce66d8daebb7d69e792f34c1a19ed.patch";
      hash = "sha256-10VUfZdZiOC8xSPM0nq8onqiv7X/Vv4/WwGlkqWkNkQ=";
    })
    # Linux 6.10: Move 'inline' before func return type
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/7097eec17bc01bcfc12c4d299136b2d3b94ec3d7.patch";
      hash = "sha256-PZmqeXWJL3EQFD9250YfDwCY1rvSGVCbAhzyHP1pE0Q=";
    })
  ];

  nativeBuildInputs = [ autoconf automake flex libtool_2 perl which bison ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [ libkrb5 ];

  hardeningDisable = [ "pic" ];

  configureFlags = [
    "--with-linux-kernel-build=${kernelBuildDir}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gssapi"
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
    maintainers = with maintainers; [ andersk maggesi spacefrogg ];
    broken = kernel.isHardened;
  };
}

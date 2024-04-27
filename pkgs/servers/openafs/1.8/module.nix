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
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15679/revisions/889d335497aa9f5ee38789fb50fc15694b8e17f8/patch";
      hash = "sha256-XJAiZ7XL+QFk3l0CUSzudUSGC+oC7v4Kew9TWmEKvNg=";
    })
    # LINUX: Minor osi_vfsop.c cleanup
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15680/revisions/342e9cbad84c762934787106a4a8baab7cd7f5aa/patch";
      hash = "sha256-kw8CQrpK9caq8eXrCEbk2zTSb727d8NmaSQg0Bg/TAM=";
    })
    # afs: Remove SRXAFSCB_GetDE
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15681/revisions/27e7adf192a1dd07505e0b3d0c89426910f7daa4/patch";
      hash = "sha256-3AMq5fAUt/HAIRuh/GAWPov3gwvMzVAqzmvpIKZLbBo=";
    })
    # afs: remove dead ICL (fstrace) code
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15682/revisions/61d3bef0ded0999366e6487d39ab6aabaaceeb71/patch";
      hash = "sha256-4LnNwJ7xZAoPqHnyKai4kCEGiG037rlZwkEjmD6xBeM=";
    })
    # cf: Add function prototypes for linux conftest
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15683/revisions/f7f37de075700bda5f75c405f0f775ea4e118089/patch";
      hash = "sha256-6tceVLqrhdo5QWjOCvutvZmetopz+tyP5AtJUh7Kkkc=";
    })
    # afs: Remove DFlushDCache()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15684/revisions/e0f425a3d8bccb48a69f27dff209e32cf05f4305/patch";
      hash = "sha256-/S4uZj+cScPFihvJDW49dQ2awrt7Thx7tIpoImIl/kg=";
    })
    # afs: Remove afs_MemExtendEntry()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15685/revisions/aae8b00d97585b60702151c6f28ff7ec4d65c2d9/patch";
      hash = "sha256-9CA0lwiNjzeteAPXh/Yyu3gqZBSi2b9XBrl43w2VzSs=";
    })
    # afs: Remove afs_osi_UnmaskUserLoop()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15686/revisions/5312d069bc57d200ff65bf968c9bdff0f38fe653/patch";
      hash = "sha256-jBwd0zFidIfNx6csPSNp1RGCq1JKmXNXWbQnG2pIgvM=";
    })
    # afs: Remove dummy_PSetAcl()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15687/revisions/056a7a8005a68cf2fb8be80668b139aa87a0de0b/patch";
      hash = "sha256-ExvIzyyqPijf5c1T3mpSqFefvbd42FpLIFYUpcc5fyk=";
    })
    # afs: Remove SRXAFSCB_FetchData/StoreData
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15688/revisions/073adec17a9b7b55d3672b17f7faa4a122ce6e9d/patch";
      hash = "sha256-dMVeHTdLde22cxtRzSJLI0MUKgZRYzVRjAeuKgMKFtQ=";
    })
    # afs: Remove afs_DbgDisconFiles()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15689/revisions/db913849047d0ec77e735f14dbbce63652209cc1/patch";
      hash = "sha256-v0kWFBEFdfpNQWzs4vA0Pu25ZR/nC36x6mqP3rOujxY=";
    })
    # afs: Add declaration for RXAFS_ResidencyCmd()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15690/revisions/67e48c84b9971e6b865274408080fbf5ec7ba1ac/patch";
      hash = "sha256-jzZG7w0tOxkrcphiITHrfodCZ6wyGp1NVARLI/tfN3c=";
    })
    # roken: Declare ct_memcmp in hcrypto kernel roken.h
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15691/revisions/d1c89acf70a794b78c5daaff206d734e36bbec6d/patch";
      hash = "sha256-OrkUiybGI2jOsEqQFeGXTQqWvgp1NwttuPvokNkwxHw=";
    })
    # Linux 6.8: Add function prototypes for krb5
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15692/revisions/a14a9add73341bc3c355250bc43282e022bff95c/patch";
      hash = "sha256-PMnW4H/s2uKda3xbka2+2nz422pksttrYvsTf+omzrc=";
    })
    # afs: Declare init_hckernel_mutex()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15693/revisions/112fb94a608a9a810cc9b43fdf762f15277d9eaa/patch";
      hash = "sha256-73zpSSF2yfbA7wxZVdKWnOqkMtdi/EkT8IjpXIMNUnc=";
    })
    # afs: Add includes to pick up function prototypes
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15694/revisions/87ab04acc921794f49084548cf5fc94f6f37f10e/patch";
      hash = "sha256-KCBjBLBH530+vr5hmA/r6RK7VYpoiJYgkks1pQplYXU=";
    })
    # afs: Move function prototypes into headers
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15695/revisions/0d9f6cf121e49cfe1a2047b98d4c30b82a1898bd/patch";
      hash = "sha256-WrfPZvNNVN3VuuBGH4sshpJOoPP2hwVitQW8PqQCBRA=";
    })
    # afs: Add afs_xioctl prototyes to afs_prototypes.h
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15696/revisions/dffd0e1475f9fb346a146607335c9f9d847d4429/patch";
      hash = "sha256-HJzTJlKNGjuXALXoaUjuQEr5Us2KLM9Exuj7jGqvHyg=";
    })
    # afs: Remove SRXAFSCB* protos from afs_prototypes.h
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15697/revisions/a87845d40aac04ff12dde369753c9472a8e4808d/patch";
      hash = "sha256-XO8+aL/yTkMdUT4sDRTFO3CspvO6nmF8M4Y/V0Y+dww=";
    })
    # rx: Add function prototypes to rx_prototypes.h
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15698/revisions/f5bafb0680a063d710b6e5e8ccf833f1dd371896/patch";
      hash = "sha256-KYGehW48hw71dAIdd5Z5U5Kvp72Gk4Tu2q+VA50LL7A=";
    })
    # afs: fix 'ops' variable may be used uninitialized
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15699/revisions/6b207567af7244a4fc6c314fdc815aa14c4eae09/patch";
      hash = "sha256-IIjuY9LL2BjnUh8W8n5ohUVY7RNk5qoH58JpimXqrNo=";
    })
    # afs: Add static attribute to internal functions
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15700/revisions/e157f8f39bd367151f5a9264c7d4ce8bcbed08fb/patch";
      hash = "sha256-LKBYqorko5HmaigKWFiIiYHgVnyc03UcQX6p8CjfYrs=";
    })
    # rx: Add static attribute to internal functions
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15701/revisions/2056ce8ae0d617d663e6181573c982994a1836db/patch";
      hash = "sha256-+Oq8CFI3+29WdCabrHV4+AU3U3fuyIUO+wYzy/QJ/24=";
    })
    # rxgen: Declare generated PKG_TranslateOpCode()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15702/revisions/b77b304bb58f472e8a9d2f3b6d47fffd38d0c905/patch";
      hash = "sha256-iErcC/J9L7TrjnbkJw9yHXR4wHCM+KHai0vzs+KEgfo=";
    })
    # rxgen: Declare generated PKG_OpCodeStats()
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15703/revisions/e428053b5bc1250fdcc3ed8ac52ee798d96ad284/patch";
      hash = "sha256-copfhVvIa6zScehQm6gZ5FaIT42wr+YoFdhPCN50xn4=";
    })
    # Linux 6.8: use hlist iteration for dentry children
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15704/revisions/7cae97b86fbcc4a53967927d6c2cae9dcbc6ac4d/patch";
      hash = "sha256-NwF1CvdI9ZjISc1A/nJP4Ea1LJY4lBnsbkRqvQFo5Wc=";
    })
    # Linux 6.8: Remove ctl_table sentinels
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15705/revisions/81b910ab4a0ef0d0b6cd3a1a636fcbcd050c0245/patch";
      hash = "sha256-g8acwb7bGF+LjQN8tVKFLXvATddN+8gSepVoM28AehA=";
    })
    # Linux 6.8: Use roken's strlcpy() in kernel module
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15706/revisions/d9f3a2c6639e694c8d6fc4ad00d6a37d6e1f9bf6/patch";
      hash = "sha256-4P+9VkDhMezPHa47a5L92Rh+6PMGxF54Agdx4uAU63Y=";
    })
    # afs: Drop GLOCK for various Rx calls
    (fetchBase64Patch {
      url = "https://gerrit.openafs.org/changes/15707/revisions/0e983a9a7e010a4e7c8a4c60cf313e566323bbf1/patch";
      hash = "sha256-uHYuCxC0xAd8BQmNbTFGfVstq8LC2PM2aZ0EcWfRIJM=";
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

{
  lib,
  stdenv,
  fetchurl,
  gnu-efi,
  nixosTests,
  efibootmgr,
  openssl,
  withSbsigntool ? false, # currently, cross compiling sbsigntool is broken, so default to false
  sbsigntool,
  makeWrapper,
}:

let
  archids = {
    x86_64-linux = {
      hostarch = "x86_64";
      efiPlatform = "x64";
    };
    i686-linux = rec {
      hostarch = "ia32";
      efiPlatform = hostarch;
    };
    aarch64-linux = {
      hostarch = "aarch64";
      efiPlatform = "aa64";
    };
  };

  inherit
    (archids.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}")
    )
    hostarch
    efiPlatform
    ;
in

stdenv.mkDerivation rec {
  pname = "refind";
  version = "0.14.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/refind/${version}/refind-src-${version}.tar.gz";
    hash = "sha256-99k86A2na4bFZygeoiW2qHkHzob/dyM8k1elIsEVyPA=";
  };

  patches = [
    # Removes hardcoded toolchain for aarch64, allowing successful aarch64 builds.
    ./0001-toolchain.patch
    # Avoid leaking the build timestamp
    # https://sourceforge.net/p/refind/code/merge-requests/53/
    ./reproducible.patch
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ gnu-efi ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags =
    [
      "prefix="
      "EFIINC=${gnu-efi}/include/efi"
      "EFILIB=${gnu-efi}/lib"
      "GNUEFILIB=${gnu-efi}/lib"
      "EFICRT0=${gnu-efi}/lib"
      "HOSTARCH=${hostarch}"
      "ARCH=${hostarch}"
    ]
    ++ lib.optional stdenv.isAarch64 [
      # aarch64 is special for GNU-EFI, see BUILDING.txt
      "GNUEFI_ARM64_TARGET_SUPPORT=y"
    ];

  buildFlags = [
    "gnuefi"
    "fs_gnuefi"
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/bin/
    install -d $out/share/refind/drivers_${efiPlatform}/
    install -d $out/share/refind/tools_${efiPlatform}/
    install -d $out/share/refind/docs/html/
    install -d $out/share/refind/docs/Styles/
    install -d $out/share/refind/fonts/
    install -d $out/share/refind/icons/
    install -d $out/share/refind/images/
    install -d $out/share/refind/keys/

    # refind uefi app
    install -D -m0644 refind/refind_${efiPlatform}.efi $out/share/refind/refind_${efiPlatform}.efi

    # uefi drivers
    install -D -m0644 drivers_${efiPlatform}/*.efi $out/share/refind/drivers_${efiPlatform}/

    # uefi apps
    install -D -m0644 gptsync/gptsync_${efiPlatform}.efi $out/share/refind/tools_${efiPlatform}/gptsync_${efiPlatform}.efi

    # helper scripts
    install -D -m0755 refind-install $out/bin/refind-install
    install -D -m0755 mkrlconf $out/bin/refind-mkrlconf
    install -D -m0755 mvrefind $out/bin/refind-mvrefind
    install -D -m0755 fonts/mkfont.sh $out/bin/refind-mkfont

    # sample config files
    install -D -m0644 refind.conf-sample $out/share/refind/refind.conf-sample

    # docs
    install -D -m0644 docs/refind/* $out/share/refind/docs/html/
    install -D -m0644 docs/Styles/* $out/share/refind/docs/Styles/
    install -D -m0644 README.txt $out/share/refind/docs/README.txt
    install -D -m0644 NEWS.txt $out/share/refind/docs/NEWS.txt
    install -D -m0644 BUILDING.txt $out/share/refind/docs/BUILDING.txt
    install -D -m0644 CREDITS.txt $out/share/refind/docs/CREDITS.txt

    # fonts
    install -D -m0644 fonts/* $out/share/refind/fonts/
    rm -f $out/share/refind/fonts/mkfont.sh

    # icons
    install -D -m0644 icons/*.png $out/share/refind/icons/

    # images
    install -D -m0644 images/*.{png,bmp} $out/share/refind/images/

    # keys
    install -D -m0644 keys/* $out/share/refind/keys/

    # Fix variable definition of 'RefindDir' which is used to locate ressource files.
    sed -i "s,\bRefindDir=\"\$This.*,RefindDir=$out/share/refind,g" $out/bin/refind-install

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/refind-install \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            efibootmgr
            openssl
          ]
          ++ lib.optional withSbsigntool sbsigntool
        )
      }
    wrapProgram $out/bin/refind-mvrefind \
      --prefix PATH : ${lib.makeBinPath [ efibootmgr ]}
  '';

  passthru.tests = {
    uefiCdrom = nixosTests.boot.uefiCdrom;
  };

  meta = with lib; {
    description = "A graphical {,U}EFI boot manager";
    longDescription = ''
      rEFInd is a graphical boot manager for EFI- and UEFI-based
      computers, such as all Intel-based Macs and recent (most 2011
      and later) PCs. rEFInd presents a boot menu showing all the EFI
      boot loaders on the EFI-accessible partitions, and optionally
      BIOS-bootable partitions on Macs. EFI-compatible OSes, including
      Linux, provide boot loaders that rEFInd can detect and
      launch. rEFInd can launch Linux EFI boot loaders such as ELILO,
      GRUB Legacy, GRUB 2, and 3.3.0 and later kernels with EFI stub
      support. EFI filesystem drivers for ext2/3/4fs, ReiserFS, HFS+,
      and ISO-9660 enable rEFInd to read boot loaders from these
      filesystems, too. rEFInd's ability to detect boot loaders at
      runtime makes it very easy to use, particularly when paired with
      Linux kernels that provide EFI stub support.
    '';
    homepage = "http://refind.sourceforge.net/";
    maintainers = with maintainers; [
      AndersonTorres
      samueldr
      chewblacka
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = licenses.gpl3Plus;
  };

}

{ stdenv, fetchurl, gnu-efi }:

let
  archids = {
    "x86_64-linux" = { hostarch = "x86_64"; efiPlatform = "x64"; };
    "i686-linux" = rec { hostarch = "ia32"; efiPlatform = hostarch; };
  };

  inherit
    (archids.${stdenv.system} or (throw "unsupported system: ${stdenv.system}"))
    hostarch efiPlatform;
in

stdenv.mkDerivation rec {
  name = "refind-${version}";
  version = "0.11.3";
  srcName = "refind-src-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/refind/${version}/${srcName}.tar.gz";
    sha256 = "13q1yap9r4lzm5xjx1zi434gckd3gk5p8n4vh6jav0h3r3ayp633";
  };

  buildInputs = [ gnu-efi ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags =
    [ "prefix="
      "EFIINC=${gnu-efi}/include/efi"
      "EFILIB=${gnu-efi}/lib"
      "GNUEFILIB=${gnu-efi}/lib"
      "EFICRT0=${gnu-efi}/lib"
      "HOSTARCH=${hostarch}"
    ];

  buildFlags = [ "gnuefi" "fs_gnuefi" ];

  installPhase = ''
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
    sed -i "s,\bRefindDir=.*,RefindDir=$out/share/refind,g" $out/bin/refind-install

    # Patch uses of `which`.  We could patch in calls to efibootmgr,
    # openssl, convert, and openssl, but that would greatly enlarge
    # refind's closure (from ca 28MB to over 400MB).
    sed -i 's,`which \(.*\)`,`type -p \1`,g' $out/bin/refind-install
    sed -i 's,`which \(.*\)`,`type -p \1`,g' $out/bin/refind-mvrefind
    sed -i 's,`which \(.*\)`,`type -p \1`,g' $out/bin/refind-mkfont
  '';

  meta = with stdenv.lib; {
    description = "A graphical {,U}EFI boot manager";
    longDescription = ''
      rEFInd is a graphical boot manager for EFI- and UEFI-based
      computers, such as all Intel-based Macs and recent (most 2011
      and later) PCs. rEFInd presents a boot menu showing all the EFI
      boot loaders on the EFI-accessible partitions, and optionally
      BIOS-bootable partitions on Macs. EFI-compatbile OSes, including
      Linux, provide boot loaders that rEFInd can detect and
      launch. rEFInd can launch Linux EFI boot loaders such as ELILO,
      GRUB Legacy, GRUB 2, and 3.3.0 and later kernels with EFI stub
      support. EFI filesystem drivers for ext2/3/4fs, ReiserFS, HFS+,
      and ISO-9660 enable rEFInd to read boot loaders from these
      filesystems, too. rEFInd's ability to detect boot loaders at
      runtime makes it very easy to use, particularly when paired with
      Linux kernels that provide EFI stub support.
    '';
    homepage = http://refind.sourceforge.net/;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.gpl3Plus;
  };

}

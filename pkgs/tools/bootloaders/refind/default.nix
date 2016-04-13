{ stdenv, fetchurl
, unzip, gnu-efi, efibootmgr, dosfstools, imagemagick }:

assert (stdenv.system == "x86_64-linux" ||stdenv.system == "i686-linux");

stdenv.mkDerivation rec {

  name = "refind-${meta.version}";
  srcName = "refind-src-${meta.version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/refind/${meta.version}/${srcName}.zip";
    sha256 = "0ai150rzx20sfl92j6y1p6qnyy0wbmazrlp2fg19acs98qyxl8lh";
  };

  buildInputs = [ unzip gnu-efi efibootmgr dosfstools imagemagick ];

  HOSTARCH =
    if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "ia32"
    else "null";

  patchPhase = ''
    sed -e 's|-DEFI_FUNCTION_WRAPPER|-DEFI_FUNCTION_WRAPPER -maccumulate-outgoing-args|g' -i Make.common
    sed -e 's|-DEFIX64|-DEFIX64 -maccumulate-outgoing-args|g' -i Make.common
    sed -e 's|-m64|-maccumulate-outgoing-args -m64|g' -i filesystems/Make.gnuefi
  '';

  buildPhase =
    let ldScript =
      if stdenv.system == "x86_64-linux" then "elf_x86_64_efi.lds"
      else if stdenv.system == "i686-linux" then "elf_ia32_efi.lds" else "null";
    in ''
      make prefix= EFIINC=${gnu-efi}/include/efi EFILIB=${gnu-efi}/lib GNUEFILIB=${gnu-efi}/lib EFICRT0=${gnu-efi}/lib LDSCRIPT=${gnu-efi}/lib/${ldScript} gnuefi fs_gnuefi
    '';

  installPhase = ''
    install -d $out/bin/
    install -d $out/share/refind/drivers_${HOSTARCH}/
    install -d $out/share/refind/tools_${HOSTARCH}/
    install -d $out/share/refind/docs/html/
    install -d $out/share/refind/docs/Styles/
    install -d $out/share/refind/fonts/
    install -d $out/share/refind/icons/
    install -d $out/share/refind/images/
    install -d $out/share/refind/keys/

    # refind uefi app
    install -D -m0644 refind/refind_${HOSTARCH}.efi $out/share/refind/refind_${HOSTARCH}.efi

    # uefi drivers
    install -D -m0644 drivers_${HOSTARCH}/*.efi $out/share/refind/drivers_${HOSTARCH}/

    # uefi apps
    install -D -m0644 gptsync/gptsync_${HOSTARCH}.efi $out/share/refind/tools_${HOSTARCH}/gptsync_${HOSTARCH}.efi

    # helper scripts
    install -D -m0755 install.sh $out/bin/refind-install
    install -D -m0755 mkrlconf.sh $out/bin/refind-mkrlconf
    install -D -m0755 mvrefind.sh $out/bin/refind-mvrefind
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
    install -D -m0644 icons/* $out/share/refind/icons/

    # images
    install -D -m0644 images/*.{png,bmp} $out/share/refind/images/

    # keys
    install -D -m0644 keys/* $out/share/refind/keys/

    # fix sharp-bang paths
    patchShebangs $out/bin/refind-*

    # Post-install fixes
    sed -e "s|^ThisDir=.*|ThisDir=$out/share/refind/|g" -i $out/bin/refind-install
    sed -e "s|^RefindDir=.*|RefindDir=$out/share/refind/|g" -i $out/bin/refind-install
    sed -e "s|^ThisScript=.*|ThisScript=$out/bin/refind-install|g" -i $out/bin/refind-install
  '';

  meta = with stdenv.lib; {
    version = "0.9.2";
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
  };

}

{ stdenv
, lib
, fetchurl
, makeWrapper
, pkg-config
, kmod
, asciidoc
, libxslt
, docbook5
, docbook_xsl
, docbook_xsl_ns
, coreutils
, utillinux
, gnused
, gnugrep
, squashfsTools
, cpio
, binutils
, gzip
, bzip2
, lz4
, lzop
, zstd
, xz
}:

stdenv.mkDerivation rec {
  name = "dracut";
  version = "049";
  src = fetchurl {
    url = "https://github.com/dracutdevs/dracut/archive/${version}.tar.gz";
    sha256 = "07jz3qlby4npgqgmzxjrp9977r8vhy1igyr3hgvxy0nqj5cx0lvw";
  };
  nativeBuildInputs = [
    makeWrapper
    pkg-config
    kmod
    asciidoc
    libxslt
    docbook5
    docbook_xsl
    docbook_xsl_ns
  ];
  preConfigure = ''
    patchShebangs ./configure
  '';
  postPatch = ''
    substituteInPlace dracut.sh \
      --replace 'dracutbasedir=/usr/lib/dracut' "dracutbasedir=$out/lib/dracut"
    substituteInPlace lsinitrd.sh \
      --replace 'dracutbasedir=/usr/lib/dracut' "dracutbasedir=$out/lib/dracut"
  '';
  postFixup = ''
    wrapProgram $out/bin/dracut --set PATH ${lib.makeBinPath [
      coreutils
      utillinux
      gnugrep
      squashfsTools
      cpio
      binutils
      gzip
      bzip2
      lz4
      lzop
      zstd
      xz
    ]}
    wrapProgram $out/bin/dracut-catimages --set PATH ${lib.makeBinPath [
      coreutils
      cpio
      gzip
    ]}
    wrapProgram $out/bin/lsinitrd --set PATH ${lib.makeBinPath [
      coreutils
      utillinux
      gnused
      squashfsTools
      cpio
      binutils
      gzip
      bzip2
      lz4
      lzop
      zstd
      xz
    ]}
    wrapProgram $out/bin/mkinitrd --set PATH ${lib.makeBinPath [
      coreutils
      gnused
      gnugrep
    ]}
  '';
  meta = with lib; {
    description = "dracut is an event driven initramfs infrastructure";
    homepage = "https://dracut.wiki.kernel.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ cmcdragonkai ];
    platforms = platforms.linux;
  };
}

{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, makeBinaryWrapper
, pkg-config
, asciidoc
, libxslt
, docbook_xsl
, bash
, kmod
, binutils
, bzip2
, coreutils
, cpio
, findutils
, gnugrep
, gnused
, gnutar
, gzip
, lz4
, lzop
, squashfsTools
, util-linux
, xz
, zstd
}:

stdenv.mkDerivation rec {
  pname = "dracut";
  version = "059";

  src = fetchFromGitHub {
    owner = "dracutdevs";
    repo = "dracut";
    rev = version;
    hash = "sha256-zSyC2SnSQkmS/mDpBXG2DtVVanRRI9COKQJqYZZCPJM=";
  };

  strictDeps = true;

  buildInputs = [
    bash
    kmod
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    asciidoc
    libxslt
    docbook_xsl
  ];

  postPatch = ''
    substituteInPlace dracut.sh \
      --replace 'dracutbasedir="$dracutsysrootdir"/usr/lib/dracut' 'dracutbasedir="$dracutsysrootdir"'"$out/lib/dracut"
    substituteInPlace lsinitrd.sh \
      --replace 'dracutbasedir=/usr/lib/dracut' "dracutbasedir=$out/lib/dracut"

    echo 'DRACUT_VERSION=${version}' >dracut-version.sh
  '';

  preConfigure = ''
    patchShebangs ./configure
  '';

  postFixup = ''
    wrapProgram $out/bin/dracut --prefix PATH : ${lib.makeBinPath [
      coreutils
      util-linux
    ]} --suffix DRACUT_PATH : ${lib.makeBinPath [
      bash
      binutils
      coreutils
      findutils
      gnugrep
      gnused
      gnutar
      stdenv.cc.libc  # for ldd command
      util-linux
    ]}
    wrapProgram $out/bin/dracut-catimages --set PATH ${lib.makeBinPath [
      coreutils
      cpio
      findutils
      gzip
    ]}
    wrapProgram $out/bin/lsinitrd --set PATH ${lib.makeBinPath [
      binutils
      bzip2
      coreutils
      cpio
      gnused
      gzip
      lz4
      lzop
      squashfsTools
      util-linux
      xz
      zstd
    ]}
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/dracutdevs/dracut/wiki";
    description = "An event driven initramfs infrastructure";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.linux;
  };
}

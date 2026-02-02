{
  stdenv,
  lib,
  fetchzip,
  fetchpatch,
  autoconf,
  automake,
  docbook_xml_dtd_42,
  docbook_xml_dtd_43,
  docbook_xsl,
  gtk-doc,
  libtool,
  pkg-config,
  libxslt,
  xz,
  zstd,
  elf-header,
  withDevdoc ? stdenv.hostPlatform == stdenv.buildPlatform,
  withStatic ? stdenv.hostPlatform.isStatic,
  gitUpdater,
}:

let
  systems = [
    "/run/booted-system/kernel-modules"
    "/run/current-system/kernel-modules"
    ""
  ];
  modulesDirs = lib.concatMapStringsSep ":" (x: "${x}/lib/modules") systems;

in
stdenv.mkDerivation rec {
  pname = "kmod";
  version = "34";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/snapshot/kmod-${version}.tar.gz";
    hash = "sha256-5iIk3b2QnRz/VbJlSHhp4D10KXwQXpkWZClTA1Pgddw=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ]
  ++ lib.optional withDevdoc "devdoc";

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    docbook_xsl
    libtool
    libxslt
    pkg-config

    docbook_xml_dtd_42 # for the man pages
  ]
  ++ lib.optionals withDevdoc [
    docbook_xml_dtd_43
    gtk-doc
  ];
  buildInputs = [
    xz
    zstd
  ]
  # gtk-doc is looked for with pkg-config
  ++ lib.optionals withDevdoc [ gtk-doc ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-xz"
    "--with-zstd"
    "--disable-manpages"
    (lib.enableFeature withDevdoc "gtk-doc")
  ]
  ++ lib.optional withStatic "--enable-static";

  patches = lib.optional withStatic ./enable-static.patch;

  postInstall = ''
    for prog in rmmod insmod lsmod modinfo modprobe depmod; do
      ln -sv $out/bin/kmod $out/bin/$prog
    done
  '';

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git";
    rev-prefix = "v";
  };

  meta = {
    description = "Tools for loading and managing Linux kernel modules";
    longDescription = ''
      kmod is a set of tools to handle common tasks with Linux kernel modules
      like insert, remove, list, check properties, resolve dependencies and
      aliases. These tools are designed on top of libkmod, a library that is
      shipped with kmod.
    '';
    homepage = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/";
    downloadPage = "https://www.kernel.org/pub/linux/utils/kernel/kmod/";
    changelog = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/plain/NEWS?h=v${version}";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ]; # GPLv2+ for tools
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ artturin ];
  };
}

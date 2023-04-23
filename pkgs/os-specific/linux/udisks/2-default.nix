{ lib, stdenv, fetchFromGitHub, substituteAll, fetchpatch, pkg-config, gnused, autoreconfHook
, gtk-doc, acl, systemd, glib, libatasmart, polkit, coreutils, bash, which
, expat, libxslt, docbook_xsl, util-linux, mdadm, libgudev, libblockdev, parted
, gobject-introspection, docbook_xml_dtd_412, docbook_xml_dtd_43
, xfsprogs, f2fs-tools, dosfstools, e2fsprogs, btrfs-progs, exfat, nilfs-utils, ntfs3g
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "udisks";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "udisks";
    rev = "${pname}-${version}";
    sha256 = "sha256-MYQztzIyp5kh9t1bCIlj08/gaOmZfuu/ZOwo3F+rZiw=";
  };

  outputs = [ "out" "man" "dev" ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "devdoc";

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      bash = "${bash}/bin/bash";
      blkid = "${util-linux}/bin/blkid";
      false = "${coreutils}/bin/false";
      mdadm = "${mdadm}/bin/mdadm";
      mkswap = "${util-linux}/bin/mkswap";
      sed = "${gnused}/bin/sed";
      sh = "${bash}/bin/sh";
      sleep = "${coreutils}/bin/sleep";
      swapon = "${util-linux}/bin/swapon";
      true = "${coreutils}/bin/true";
    })
    (substituteAll {
      src = ./force-path.patch;
      path = lib.makeBinPath [
        btrfs-progs coreutils dosfstools e2fsprogs exfat f2fs-tools nilfs-utils
        xfsprogs ntfs3g parted util-linux
      ];
    })
    # Fix crash on exit, remove on upgrade to 2.10.
    (fetchpatch {
      url = "https://github.com/storaged-project/udisks/commit/6464e3083c27b9e4d97848b9e69e862f265511d5.patch";
      hash = "sha256-XGprXjJLIL8l4P5MRTHV8GOQR1hpaaFiLgexGnO9Lvg=";
    })
  ];

  strictDeps = true;
  # pkg-config had to be in both to find gtk-doc and gobject-introspection
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    autoreconfHook which gobject-introspection pkg-config
    gtk-doc libxslt docbook_xml_dtd_412 docbook_xml_dtd_43 docbook_xsl
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
      substituteInPlace udisks/udisksclient.c \
        --replace 'defined( __GNUC_PREREQ)' 1 \
        --replace '__GNUC_PREREQ(4,6)' 1
  '';

  buildInputs = [
    expat libgudev libblockdev acl systemd glib libatasmart polkit util-linux
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    (lib.enableFeature (stdenv.buildPlatform == stdenv.hostPlatform) "gtk-doc")
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevdir=$(out)/lib/udev"
    "--with-tmpfilesdir=no"
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(dev)/share/gir-1.0"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru.tests.vm = nixosTests.udisks2;

  meta = with lib; {
    description = "A daemon, tools and libraries to access and manipulate disks, storage devices and technologies";
    homepage = "https://www.freedesktop.org/wiki/Software/udisks/";
    license = with licenses; [ lgpl2Plus gpl2Plus ]; # lgpl2Plus for the library, gpl2Plus for the tools & daemon
    maintainers = teams.freedesktop.members ++ (with maintainers; [ johnazoidberg ]);
    platforms = platforms.linux;
  };
}

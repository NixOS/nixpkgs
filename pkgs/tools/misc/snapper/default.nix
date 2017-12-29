{ stdenv, fetchFromGitHub, fetchpatch
, autoreconfHook, pkgconfig, docbook_xsl, libxslt, docbook_xml_dtd_45
, acl, attr, boost, btrfs-progs, dbus_libs, diffutils, e2fsprogs, libxml2
, lvm2, pam, python, utillinux }:

stdenv.mkDerivation rec {
  name = "snapper-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "snapper";
    rev = "v${version}";
    sha256 = "14hrv23film4iihyclcvc2r2dgxl8w3as50r81xjjc85iyp6yxkm";
  };

  patches = [
    # Fix build with new Boost
    (fetchpatch {
      url = "https://github.com/openSUSE/snapper/commit/2e3812d2c1d1f54861fb79f5c2b0197de96a00a3.patch";
      sha256 = "0yrzss1v7lmcvkajmchz917yqsvlsdfz871szzw790v6pql1322s";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook pkgconfig
    docbook_xsl libxslt docbook_xml_dtd_45
  ];
  buildInputs = [
    acl attr boost btrfs-progs dbus_libs diffutils e2fsprogs libxml2
    lvm2 pam python utillinux
  ];

  postPatch = ''
    # Hard-coded root paths, hard-coded root paths everywhere...
    for file in {client,data,pam,scripts}/Makefile.am; do
      substituteInPlace $file \
        --replace '$(DESTDIR)/usr' "$out" \
        --replace "DESTDIR" "out" \
        --replace "/usr" "$out"
    done
    substituteInPlace pam/Makefile.am \
      --replace '/`basename $(libdir)`' "$out/lib"
  '';

  configureFlags = [
    "--disable-ext4"	# requires patched kernel & e2fsprogs
  ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [
    "-I${libxml2.dev}/include/libxml2"
  ];

  postInstall = ''
    rm -r $out/etc/cron.*
    patchShebangs $out/lib/zypp/plugins/commit/*
    for file in \
      $out/lib/pam_snapper/* \
      $out/lib/systemd/system/* \
      $out/share/dbus-1/system-services/* \
    ; do
      substituteInPlace $file --replace "/usr" "$out"
    done
  '';

  meta = with stdenv.lib; {
    description = "Tool for Linux filesystem snapshot management";
    homepage = http://snapper.io;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx tstrobel ];
  };
}

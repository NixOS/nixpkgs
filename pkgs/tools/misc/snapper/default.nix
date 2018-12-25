{ stdenv, fetchFromGitHub, fetchpatch
, autoreconfHook, pkgconfig, docbook_xsl, libxslt, docbook_xml_dtd_45
, acl, attr, boost, btrfs-progs, dbus, diffutils, e2fsprogs, libxml2
, lvm2, pam, python, utillinux }:

stdenv.mkDerivation rec {
  name = "snapper-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "snapper";
    rev = "v${version}";
    sha256 = "0kl0najv8jpx94v44v68fmqsg2vv6yz3y5dmy0q8la0zyz766dhm";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig
    docbook_xsl libxslt docbook_xml_dtd_45
  ];
  buildInputs = [
    acl attr boost btrfs-progs dbus diffutils e2fsprogs libxml2
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
    maintainers = with maintainers; [ tstrobel ];
  };
}

{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig, docbook_xsl, libxslt, docbook_xml_dtd_45
, acl, attr, boost, btrfs-progs, dbus, diffutils, e2fsprogs, libxml2
, lvm2, pam, python, utillinux, fetchpatch, json_c }:

stdenv.mkDerivation rec {
  pname = "snapper";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "snapper";
    rev = "v${version}";
    sha256 = "0wpf82xf61r9r20whhb83wk3408wac1if8awqm3bb36b9j7ni5jr";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig
    docbook_xsl libxslt docbook_xml_dtd_45
  ];
  buildInputs = [
    acl attr boost btrfs-progs dbus diffutils e2fsprogs libxml2
    lvm2 pam python utillinux json_c
  ];

  patches = [
    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://github.com/openSUSE/snapper/commit/c51708aea22d9436da287cba84424557ad03644b.patch";
      sha256 = "106pf7pv8z3q37c8ckmgwxs1phf2fy7l53a9g5xq5kk2rjj1cx34";
    })
  ];

  postPatch = ''
    # Hard-coded root paths, hard-coded root paths everywhere...
    for file in {client,data,pam,scripts,zypp-plugin}/Makefile.am; do
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

  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

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
    maintainers = with maintainers; [ tstrobel markuskowa ];
  };
}

{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config, docbook_xsl, libxslt, docbook_xml_dtd_45
, acl, attr, boost, btrfs-progs, dbus, diffutils, e2fsprogs, libxml2
, lvm2, pam, util-linux, json_c, nixosTests
, ncurses }:

stdenv.mkDerivation rec {
  pname = "snapper";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "snapper";
    rev = "v${version}";
    sha256 = "sha256-tKxjzJ69wr48QQEgYLp7G6aOqxs9CCUiTHV1kaRCiHM=";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config
    docbook_xsl libxslt docbook_xml_dtd_45
  ];
  buildInputs = [
    acl attr boost btrfs-progs dbus diffutils e2fsprogs libxml2
    lvm2 pam util-linux json_c ncurses
  ];

  passthru.tests.snapper = nixosTests.snapper;

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

  env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

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

  meta = with lib; {
    description = "Tool for Linux filesystem snapshot management";
    homepage = "http://snapper.io";
    license = licenses.gpl2Only;
    mainProgram = "snapper";
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

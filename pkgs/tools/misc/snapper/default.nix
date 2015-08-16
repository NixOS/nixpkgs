{ stdenv, fetchgit, autoconf, automake, boost, pkgconfig, libtool, acl, libxml2, btrfsProgs, dbus_libs, docbook_xsl, libxslt, docbook_xml_dtd_45,  diffutils, pam, utillinux, attr, gettext }:

stdenv.mkDerivation rec {
  name = "snapper-${version}";
  version = "0.2.6";

  src = fetchgit {
    url = "https://github.com/openSUSE/snapper";
    rev = "071c381b356a505dcb59811e917f776592eca89b";
    sha256 = "1n5jxym07a47l0zys2lp1rmzfl7lhkgp0sdg6hxbhzhy192j0v16";
  };

  buildInputs = [ autoconf automake boost pkgconfig libtool acl libxml2 btrfsProgs dbus_libs docbook_xsl libxslt docbook_xml_dtd_45 diffutils pam utillinux attr gettext ];

  patchPhase = ''
    # work around missing btrfs/version.h; otherwise, use "-DHAVE_BTRFS_VERSION_H"
    substituteInPlace snapper/Btrfs.cc --replace "define BTRFS_LIB_VERSION (100)" "define BTRFS_LIB_VERSION (200)";
    # fix strange SuSE boost naming
    substituteInPlace snapper/Makefile.am --replace \
      "libsnapper_la_LIBADD = -lboost_thread-mt -lboost_system-mt -lxml2 -lacl -lz -lm" \
      "libsnapper_la_LIBADD = -lboost_thread -lboost_system -lxml2 -lacl -lz -lm";
    # Install dbus service file to /share instead of /usr/share
    substituteInPlace data/Makefile.am  --replace \
      "usr/share/dbus-1/system-services" "share/dbus-1/system-services"
    '';

  configurePhase = ''
    aclocal
    libtoolize --force --automake --copy
    autoheader
    automake --add-missing --copy
    autoconf

    ./configure --disable-silent-rules --disable-ext4 --disable-btrfs-quota --prefix=$out
    '';

  makeFlags = "DESTDIR=$(out)";

  NIX_CFLAGS_COMPILE = [ "-I${libxml2}/include/libxml2" ];

  # Probably a hack, but using DESTDIR and PREFIX makes everything work!
  postInstall = ''
    cp -r $out/$out/* $out
    rm -r $out/nix
    substituteInPlace $out/share/dbus-1/system-services/* \
        --replace "/usr/sbin" "$out/bin"
    '';

  meta = with stdenv.lib; {
    description = "Tool for Linux filesystem snapshot management";
    homepage = http://snapper.io;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.tstrobel ];
  };
}

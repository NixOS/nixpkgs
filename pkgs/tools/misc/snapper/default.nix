{ stdenv, fetchFromGitHub, autoconf, automake, boost, pkgconfig, libtool, acl, libxml2, btrfs-progs, dbus_libs, docbook_xsl, libxslt, docbook_xml_dtd_45,  diffutils, pam, utillinux, attr, gettext }:

stdenv.mkDerivation rec {
  name = "snapper-${ver}";
  ver = "0.2.8";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "snapper";
    rev = "v${ver}";
    sha256 = "1rj8vy6hq140pbnc7mjjb34mfqdgdah1dmlv2073izdgakh7p38j";
  };

  buildInputs = [ autoconf automake boost pkgconfig libtool acl libxml2 btrfs-progs dbus_libs docbook_xsl libxslt docbook_xml_dtd_45 diffutils pam utillinux attr gettext ];

  patchPhase = ''
    # work around missing btrfs/version.h; otherwise, use "-DHAVE_BTRFS_VERSION_H"
    substituteInPlace snapper/Btrfs.cc --replace "define BTRFS_LIB_VERSION (100)" "define BTRFS_LIB_VERSION (200)";
    # fix strange SuSE boost naming
    substituteInPlace snapper/Makefile.am --replace \
      "libsnapper_la_LIBADD = -lboost_thread-mt -lboost_system-mt -lxml2 -lacl -lz -lm" \
      "libsnapper_la_LIBADD = -lboost_thread -lboost_system -lxml2 -lacl -lz -lm";
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
    '';

  meta = with stdenv.lib; {
    description = "Tool for Linux filesystem snapshot management";
    homepage = http://snapper.io;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.tstrobel ];
  };
}

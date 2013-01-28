{ stdenv, fetchurl, libcap, apparmor, perl, docbook2x, docbook_xml_dtd_45 }:

stdenv.mkDerivation rec {
  name = "lxc-0.8.0";

  src = fetchurl {
    url = "http://lxc.sf.net/download/lxc/${name}.tar.gz";
    sha256 = "0b3912mal1n56i1v5f3aplm7shqnlz24p0znpva27r4l1drk7j7a";
  };

  buildInputs = [ libcap apparmor perl docbook2x ];

  patches = [
   ./dont-run-ldconfig.patch
   ./fix-documentation-build.patch
   ./fix-sgml-documentation.patch
  ];

  preConfigure = "export XML_CATALOG_FILES=${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  configureFlags = "--localstatedir=/var";

  postInstall = ''
    cd "$out/lib"
    lib=liblxc.so.?.*
    ln -s $lib $(echo $lib | sed -re 's/(liblxc[.]so[.].)[.].*/\1/')
  '';

  meta = {
    homepage = "http://lxc.sourceforge.net";
    description = "lightweight virtual system mechanism";
    license = stdenv.lib.licenses.lgpl21Plus;

    longDescription = ''
      LXC is the userspace control package for Linux Containers, a
      lightweight virtual system mechanism sometimes described as
      "chroot on steroids". LXC builds up from chroot to implement
      complete virtual systems, adding resource management and isolation
      mechanisms to Linux’s existing process management infrastructure.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}

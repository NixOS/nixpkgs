{ stdenv, fetchurl, libcap, apparmor, perl, docbook2x, docbook_xml_dtd_45 }:

stdenv.mkDerivation rec {
  name = "lxc-0.9.0";

  src = fetchurl {
    url = "http://lxc.sf.net/download/lxc/${name}.tar.gz";
    sha256 = "0821clxymkgp71n720xj5ngs22s2v8jks68f5j4vypycwvm6f5qy";
  };

  buildInputs = [ libcap apparmor perl docbook2x ];

  patches = [
    ./dont-run-ldconfig.patch
    ./install-localstatedir-in-store.patch
    ./support-db2x.patch
  ];

  preConfigure = "export XML_CATALOG_FILES=${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  configureFlags = [
    "--localstatedir=/var"
    "--enable-doc"
    "--enable-tests"
    "--enable-apparmor"
  ];

  meta = {
    homepage = "http://lxc.sourceforge.net";
    description = "userspace tools for Linux Containers, a lightweight virtualization system";
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

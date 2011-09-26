{ stdenv, fetchurl, libcap, perl, docbook2x, docbook_xml_dtd_45 }:

let
  name = "lxc-0.7.5";
in
stdenv.mkDerivation{
  inherit name;

  src = fetchurl {
    url = "http://lxc.sf.net/download/lxc/${name}.tar.gz";
    sha256 = "019ec63f250c874bf7625b1f1bf555b1a6e3a947937a4fca73100abddf829b1c";
  };

  buildInputs = [ libcap perl docbook2x ];

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

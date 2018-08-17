{ fetchurl, stdenv, config, flex, bash, bison, db, iptables, pkgconfig
, libelf
}:

stdenv.mkDerivation rec {
  name = "iproute2-${version}";
  version = "4.17.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/iproute2/${name}.tar.xz";
    sha256 = "0vmynikcamfhakvwyk5dsffy0ymgi5mdqiwybdvqfn1ijaq93abg";
  };

  preConfigure = ''
    patchShebangs ./configure
    sed -e '/ARPDDIR/d' -i Makefile
    # Don't build netem tools--they're not installed and require HOSTCC
    substituteInPlace Makefile --replace " netem " " "
  '';

  makeFlags = [
    "DESTDIR="
    "LIBDIR=$(out)/lib"
    "SBINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man"
    "BASH_COMPDIR=$(out)/share/bash-completion/completions"
    "DOCDIR=$(TMPDIR)/share/doc/${name}" # Don't install docs
    "HDRDIR=$(TMPDIR)/include/iproute2" # Don't install headers
  ];

  # enable iproute2 module if you want this folder to be created
  buildFlags = [
    "CONFDIR=${config.iproute2.confDir or "/run/iproute2"}"
  ];

  installFlags = [
    "CONFDIR=$(out)/etc/iproute2"
  ];

  buildInputs = [ db iptables libelf ];
  nativeBuildInputs = [ bison flex pkgconfig ];

  enableParallelBuilding = true;

  postInstall = ''
    PATH=${bash}/bin:$PATH patchShebangs $out/sbin
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.linuxfoundation.org/networking/iproute2;
    description = "A collection of utilities for controlling TCP/IP networking and traffic control in Linux";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ eelco wkennington fpletz ];
  };
}

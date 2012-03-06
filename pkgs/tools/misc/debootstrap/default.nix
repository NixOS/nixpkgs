{ stdenv, fetchurl, dpkg, gettext, gawk, perl, wget }:

let

  devices = fetchurl {
    url = mirror://gentoo/distfiles/devices.tar.gz;
    sha256 = "0j4yhajmlgvbksr2ij0dm7jy3q52j3wzhx2fs5lh05i1icygk4qd";
  };
  
in

stdenv.mkDerivation {
  name = "debootstrap-1.0.10lenny";

  src = fetchurl {
    # I'd like to use the source. However it's lacking the lanny script ?
    url = mirror://debian/pool/main/d/debootstrap/debootstrap_1.0.10lenny1_all.deb;
    sha256 = "a70af8e3369408ce9d6314fb5219de73f9523b347b75a3b07ee17ea92c445051";
  };
  
  buildInputs = [ dpkg gettext gawk perl ];

  unpackPhase = ''
    dpkg-deb --extract "$src" .
  '';
  
  buildPhase = ":";

  patches = [
    # replace /usr/* and /sbin/* executables by @executable@ so that they can be replaced by substitute
    # Be careful not to replace code being run in the debian chroot !
    ./subst.patch
  ];

  # from deb 
  installPhase = ''
    cp -r . $out; cd $out
    t=bin/debootstrap
    mkdir -p bin man/man8
    cat >> $t << EOF
    #!/bin/sh
    export DEBOOTSTRAP_DIR=$out/usr/share/debootstrap
    # mount and other tools must be found in chroot. So add default debain paths!
    # TODO only add paths which are required by the scripts!
    export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    $out/usr/sbin/debootstrap "\$@"
    EOF
    chmod +x $t
    mv usr/share/man/man8/debootstrap.8.gz man/man8

    set -x
    for file in usr/share/debootstrap/functions usr/sbin/debootstrap; do
      substituteInPlace "$file" \
        --subst-var-by gunzip "$(type -p gunzip)" \
        --subst-var-by bunzip "$(type -p bunzip)" \
        --subst-var-by gettext "$(type -p gettext)" \
        --subst-var-by dpkg "$(type -p dpkg)" \
        --subst-var-by udpkg "$(type -p udpkg)" \
        --subst-var-by id "$(type -p id)" \
        --subst-var-by perl "$(type -p perl)" \
        --subst-var-by uname "$(type -p uname)" \
        --subst-var-by wget "${wget}/bin/wget"
    done
  '';

  /* build from source:
  installPhase = ''
    cp ${devices} devices.tar.gz
    mkdir -p $out/{bin,man/man8};
    cp debootstrap.8 $out/man/man8
    sed -i  \
      -e 's@-o root@@'   \
      -e 's@-g root@@'   \
      -e 's@chown@true@' \
      Makefile
    make pkgdetails debootstrap-arch
    make DESTDIR="''\${out}" install-arch
    t=$out/bin/debootstrap
    cat >> $t << EOF
    #!/bin/sh
    DEBOOTSTRAP_DIR=$out/usr/share/debootstrap $out/usr/sbin/debootstrap "\$@"
    EOF
    chmod +x $t
  '';
  */

  meta = { 
    description = "Tool to create a Debian system in a chroot";
    homepage = http://packages.debian.org/de/lenny/debootstrap; # http://code.erisian.com.au/Wiki/debootstrap
    license = "GPL-2"; # gentoo says so.. ?
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}

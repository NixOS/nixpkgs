{ stdenv, fetchurl, dpkg, gettext, gawk, perl, wget, coreutils }:

# USAGE like this: debootstrap sid /tmp/target-chroot-directory
# There is also cdebootstrap now. Is that easier to maintain?
stdenv.mkDerivation rec {
  name = "debootstrap-${version}";
  version = "1.0.107";

  src = fetchurl {
    # git clone git://git.debian.org/d-i/debootstrap.git
    # I'd like to use the source. However it's lacking the lanny script ? (still true?)
    url = "mirror://debian/pool/main/d/debootstrap/debootstrap_${version}.tar.gz";
    sha256 = "1gq5r4fa0hrq4c69l2s0ygnfyvr90k2wqaq15s869hayhnssx4g1";
  };

  buildInputs = [ dpkg gettext gawk perl wget ];

  dontBuild = true;

  # If you have to update the patch for functions a vim regex like this
  # can help you identify which lines are used to write scripts on TARGET and
  # which should /bin/ paths should be replaced:
  # \<echo\>\|\/bin\/\|^\s*\<cat\>\|EOF\|END
  installPhase = ''
    sed -i \
      -e 's@/usr/bin/id@id@' \
      -e 's@/usr/bin/dpkg@${dpkg}/bin/dpkg@' \
      -e 's@/usr/bin/sha@${coreutils}/bin/sha@' \
      -e 's@/bin/sha@${coreutils}/bin/sha@' \
      debootstrap

    for file in functions debootstrap; do
      substituteInPlace "$file" \
        --subst-var-by gunzip "$(type -p gunzip)" \
        --subst-var-by bunzip "$(type -p bunzip)" \
        --subst-var-by gettext "$(type -p gettext)" \
        --subst-var-by dpkg "$(type -p dpkg)" \
        --subst-var-by udpkg "$(type -p udpkg)" \
        --subst-var-by id "$(type -p id)" \
        --subst-var-by perl "$(type -p perl)" \
        --subst-var-by uname "$(type -p uname)" \
        --subst-var-by wget "$(type -p wget)"
    done


    sed -i  \
      -e 's@\<wget\>@${wget}/bin/wget@' \
      functions

    d=$out/share/debootstrap
    mkdir -p $out/{share/debootstrap,bin}

    cp -r . $d

    cat >> $out/bin/debootstrap << EOF
    #!/bin/sh
    export DEBOOTSTRAP_DIR="''${DEBOOTSTRAP_DIR:-$d}"
    # mount and other tools must be found in chroot. So add default debain paths!
    # TODO only add paths which are required by the scripts!
    export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    exec $d/debootstrap "\$@"
    EOF
    chmod +x $out/bin/debootstrap

    mkdir -p $out/man/man8
    mv debootstrap.8 $out/man/man8
  '';

  meta = {
    description = "Tool to create a Debian system in a chroot";
    homepage = http://packages.debian.org/de/lenny/debootstrap; # http://code.erisian.com.au/Wiki/debootstrap
    license = stdenv.lib.licenses.gpl2; # gentoo says so.. ?
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}

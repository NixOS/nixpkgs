{ lib, stdenv, fetchurl, bzip2, lzo, zlib, xz, bash, python2, gnutar, gnused, gnugrep, which }:

stdenv.mkDerivation (rec {
  pname = "xe-guest-utilities";
  version = "6.2.0";
  meta = {
    description = "Citrix XenServer Tools";
    homepage = "http://citrix.com/English/ps2/products/product.asp?contentID=683148&ntref=hp_nav_US";
    maintainers = with lib.maintainers; [ benwbooth ];
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl2 lib.licenses.lgpl21 ];
  };
  src = fetchurl {
    url = "https://sources.archlinux.org/other/community/xe-guest-utilities/xe-guest-utilities_${version}-1120.tar.gz";
    sha256 = "f9593cd9588188f80253e736f48d8dd94c5b517abb18316085f86acffab48794";
  };
  buildInputs = [ bzip2 gnutar gnused python2 lzo zlib xz stdenv gnugrep which ];
  patches = [ ./ip-address.patch ];
  postPatch = ''
    tar xf "$NIX_BUILD_TOP/$name/xenstore-sources.tar.bz2"
  '';

  buildPhase = ''
    export CC=gcc
    export CFLAGS='-Wall -Wstrict-prototypes -Wno-unused-local-typedefs -Wno-sizeof-pointer-memaccess'
    export PYTHON=python2
    cd "$NIX_BUILD_TOP/$name/uclibc-sources"
    for file in Config.mk tools/libxc/Makefile tools/misc/Makefile tools/misc/lomount/Makefile tools/xenstore/Makefile; do
      substituteInPlace "$file" --replace -Werror ""
    done
    make -C tools/include
    make -C tools/libxc
    make -C tools/xenstore
  '';

  installPhase = ''
    export CFLAGS+='-Wall -Wstrict-prototypes -Wno-unused-local-typedefs -Wno-sizeof-pointer-memaccess'
    if [[ $CARCH == x86_64 ]]; then
      export LIBLEAFDIR_x86_64=lib
    fi
    for f in include libxc xenstore; do
      [[ ! -d $NIX_BUILD_TOP/$name/uclibc-sources/tools/$f ]] && continue
      make -C "$NIX_BUILD_TOP/$name/uclibc-sources/tools/$f" DESTDIR="$out" BINDIR=/bin SBINDIR=/bin INCLUDEDIR=/include LIBDIR=/lib install
    done
    rm -r "$out"/var

    cd "$NIX_BUILD_TOP/$name"
    install -Dm755 xe-update-guest-attrs "$out/bin/xe-update-guest-attrs"
    install -Dm755 xe-daemon "$out/bin/xe-daemon"
    install -Dm644 xen-vcpu-hotplug.rules "$out/lib/udev/rules.d/10-xen-vcpu-hotplug.rules"
    substituteInPlace "$out/bin/xe-daemon" --replace sbin bin
    substituteInPlace "$out/bin/xe-daemon" --replace /usr/ "$out/"
    substituteInPlace "$out/bin/xe-update-guest-attrs" --replace /usr/ "$out/"
    substituteInPlace "$out/bin/xe-update-guest-attrs" --replace 'export PATH=' 'export PATH=$PATH:'
    substituteInPlace "$out/lib/udev/rules.d/10-xen-vcpu-hotplug.rules" --replace /bin/sh '${bash}/bin/sh'

    cat <<'EOS' >"$out/bin/xe-linux-distribution"
    #!${bash}/bin/bash -eu
    . /etc/os-release
    if [[ $# -gt 0 ]]; then
      mkdir -p "$(dirname "$1")"
      exec 1>"$1"
    fi
    cat <<EOF
    os_distro="$ID"
    os_majorver="''${VERSION_ID%%.*}"
    os_minorver="''${VERSION_ID#*.}"
    os_uname="$(uname -r)"
    os_name="$PRETTY_NAME"
    EOF
    EOS
    chmod 0755 "$out/bin/xe-linux-distribution"
  '';

})

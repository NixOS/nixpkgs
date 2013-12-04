{ stdenv, fetchurl, which, autoconf, automake, flex, yacc,
  kernelDev, glibc, ncurses, perl, krb5 }:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "openafs-1.6.1-${kernelDev.version}";

  src = fetchurl {
    url = http://www.openafs.org/dl/openafs/1.6.1/openafs-1.6.1-src.tar.bz2;
    sha256 = "1c7mid0dwl2x0sikr70bi5cs881y6pa4dfwkdmr3jscvx3wgfpnh";
  };

  buildInputs = [ autoconf automake flex yacc ncurses perl which ];

  preConfigure = ''
    ln -s ${kernelDev}/lib/modules/*/build $TMP/linux

    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc}/include" \
        --replace "/usr/src" "$TMP"
    done

    ./regen.sh

    export KRB5_CONFIG=${krb5}/bin/krb5-config

    configureFlagsArray=(
      "--with-linux-kernel-build=$TMP/linux"
      "--with-krb5"
      "--sysconfdir=/etc/static"
    )
  '';

  meta = {
    description = "Open AFS client";
    homepage = http://www.openafs.org;
    license = stdenv.lib.licenses.ipl10;
    platforms = stdenv.lib.platforms.linux;
    maintainers = stdenv.lib.maintainers.z77z;
    broken = true;
  };
}

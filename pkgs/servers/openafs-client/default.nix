{ stdenv, fetchurl, which, autoconf, automake, flex, yacc,
  kernel, glibc, ncurses, perl, kerberos }:

stdenv.mkDerivation {
  name = "openafs-1.6.14-${kernel.version}";

  src = fetchurl {
    url = http://www.openafs.org/dl/openafs/1.6.14/openafs-1.6.14-src.tar.bz2;
    sha256 = "3e62c798a7f982c4f88d85d32e46bee6a47848d207b1e318fe661ce44ae4e01f";
  };

  buildInputs = [ autoconf automake flex yacc ncurses perl which ];

  preConfigure = ''
    ln -s "${kernel.dev}/lib/modules/"*/build $TMP/linux

    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc}/include" \
        --replace "/usr/src" "$TMP"
    done

    ./regen.sh

    ${stdenv.lib.optionalString (kerberos != null)
      "export KRB5_CONFIG=${kerberos}/bin/krb5-config"}

    configureFlagsArray=(
      "--with-linux-kernel-build=$TMP/linux"
      ${stdenv.lib.optionalString (kerberos != null) "--with-krb5"}
      "--sysconfdir=/etc/static"
      "--disable-linux-d_splice-alias-extra-iput"
    )
  '';

  meta = {
    description = "Open AFS client";
    homepage = http://www.openafs.org;
    license = stdenv.lib.licenses.ipl10;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.z77z ];
  };
}

{ stdenv, fetchurl, fetchgit, which, autoconf, automake, flex, yacc,
  kernel, glibc, ncurses, perl, kerberos }:

stdenv.mkDerivation rec {
  name = "openafs-${version}-${kernel.version}";
  version = "1.6.17";

  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "16532f4951piv1g2i539233868xfs1damrnxql61gjgxpwnklhcn";
  };

  nativeBuildInputs = [ autoconf automake flex yacc perl which ];

  buildInputs = [ ncurses ];

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

  meta = with stdenv.lib; {
    description = "Open AFS client";
    homepage = https://www.openafs.org;
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.z77z ];
    broken =
      (builtins.compareVersions kernel.version  "3.18" == -1) ||
      (builtins.compareVersions kernel.version "4.4" != -1) ||
      (kernel.features.grsecurity or false);
  };
}

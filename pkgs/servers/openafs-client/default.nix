{ stdenv, fetchurl, fetchgit, which, autoconf, automake, flex, yacc,
  kernel, glibc, ncurses, perl, kerberos }:

stdenv.mkDerivation rec {
  name = "openafs-${version}-${kernel.version}";
  version = "1.6.21";

  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "ba9c1f615edd53b64fc271ad369c49a816acedca70cdd090975033469a84118f";
  };

  nativeBuildInputs = [ autoconf automake flex yacc perl which ];

  buildInputs = [ ncurses ];

  hardeningDisable = [ "pic" ];

  preConfigure = ''
    ln -s "${kernel.dev}/lib/modules/"*/build $TMP/linux

    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc.dev}/include" \
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
      (builtins.compareVersions kernel.version "4.13" == 0);
  };
}

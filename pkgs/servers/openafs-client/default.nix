{ stdenv, fetchurl, fetchgit, which, autoconf, automake, flex, yacc,
  kernel, glibc, ncurses, perl, kerberos, fetchpatch }:

stdenv.mkDerivation rec {
  name = "openafs-${version}-${kernel.version}";
  version = "1.6.21.1";

  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "0nisxnfl8nllcfmi7mxj1gngkpxd4jp1wapbkhz07qwqynq9dn5f";
  };

  nativeBuildInputs = [ autoconf automake flex yacc perl which ];

  buildInputs = [ ncurses ];

  hardeningDisable = [ "pic" ];

  patches = [
   (fetchpatch {
      name = "fix-stdint-include.patch";
      url = "http://git.openafs.org/?p=openafs.git;a=patch;h=c193e5cba18273a062d4162118c7055b54f7eb5e";
      sha256 = "1yc4gygcazwsslf6mzk1ai92as5jbsjv7212jcbb2dw83jydhc09";
    })
  ];

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
    broken = versionOlder kernel.version "3.18";
  };
}

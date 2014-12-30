{ stdenv, fetchurl, which, autoconf, automake, flex, yacc,
  kernel, glibc, ncurses, perl, kerberos }:

assert stdenv.isLinux;
assert builtins.substring 0 4 kernel.version != "3.18";

stdenv.mkDerivation {
  name = "openafs-1.6.9-${kernel.version}";

  src = fetchurl {
    url = http://www.openafs.org/dl/openafs/1.6.9/openafs-1.6.9-src.tar.bz2;
    sha256 = "1isgw7znp10w0mr3sicnjzbc12bd1gdwfqqr667w6p3syyhs6bkv";
  };
 
  patches = [ 
   ./f3c0f74186f4a323ffc5f125d961fe384d396cac.patch
   ./ae86b07f827d6f3e2032a412f5f6cb3951a27d2d.patch
   ./I5558c64760e4cad2bd3dc648067d81020afc69b6.patch
   ./If1fd9d27f795dee4b5aa2152dd09e0540d643a69.patch
  ];

  buildInputs = [ autoconf automake flex yacc ncurses perl which ];

  preConfigure = ''
    ln -s ${kernel.dev}/lib/modules/*/build $TMP/linux

    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc}/include" \
        --replace "/usr/src" "$TMP"
    done

    ./regen.sh

    export KRB5_CONFIG=${kerberos}/bin/krb5-config

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
    maintainers = [ stdenv.lib.maintainers.z77z ];
  };
}

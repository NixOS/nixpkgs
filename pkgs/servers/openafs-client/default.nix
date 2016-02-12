{ stdenv, fetchurl, fetchgit, which, autoconf, automake, flex, yacc,
  kernel, glibc, ncurses, perl, kerberos }:

let
  version = if stdenv.lib.versionAtLeast kernel.version "4.2"
    then "1.6.14-1-602130"
    else "1.6.14";
in
stdenv.mkDerivation {
  name = "openafs-${version}-${kernel.version}";

  src = if version == "1.6.14-1-602130"
    # 1.6.14 + patches to run on linux 4.2 that will get into 1.6.15
    then fetchgit {
      url = "git://git.openafs.org/openafs.git";
      rev = "feab09080ec050b3026eff966352b058e2c2295b";
      sha256 = "03j71c7y487jbjmm6ydr1hw38pf43j2dz153xknndf4x4v21nnp2";
    }
    else fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
      sha256 = "3e62c798a7f982c4f88d85d32e46bee6a47848d207b1e318fe661ce44ae4e01f";
    };

  buildInputs = [ autoconf automake flex yacc ncurses perl which ];

  hardening_pic = false;

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

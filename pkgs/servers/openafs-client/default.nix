{ stdenv, fetchurl, autoconf, automake, flex, yacc,
  kernel, glibc, ncurses, perl, krb5 }:

assert stdenv.isLinux;

let
  pname = "openafs";
  version = "1.4.11";
  name = "${pname}-${version}-${kernel.version}";
  webpage = http://www.openafs.org;
in

stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}/dl/${pname}/${version}/${pname}-${version}-src.tar.gz";
    sha256 = "ea5377119fd7b5317428644fa427066b9edbde395d997943a448426742d2c5c9";
  };

  buildInputs = [ autoconf automake flex yacc ncurses perl ];

  replace_usrbinenv = ./replace-usrbinenv;
  replace_usrinclude = ./replace-usrinclude;
  replace_usrbinperl = ./replace-usrbinperl;
  replace_usrsrc = ./replace-usrsrc;

  configurePhase = ''
    ln -s ${kernel}/lib/modules/*/build $TMP/linux

    echo "Replace ..."
    for i in `cat ${replace_usrbinenv}`; do
      substituteInPlace $i --replace "/usr/bin/env" $(type -tp env)
    done
    for i in `cat ${replace_usrinclude}`; do
      substituteInPlace $i --replace "/usr/include" "${glibc}/include"
    done
    for i in `cat ${replace_usrbinperl}`; do
      substituteInPlace $i --replace "/usr/bin/perl" $(type -tp perl)
    done
    for i in `cat ${replace_usrsrc}`; do
      substituteInPlace $i --replace "/usr/src" "$TMP"
    done
    echo "... done"

    ./regen.sh

    ./configure \
       --prefix=$out \
       --with-linux-kernel-build=$TMP/linux \
       --with-krb5-conf=${krb5}/bin/krb5-config \
       --sysconfdir=/etc/static
       #--with-afs-sysname=amd64_linux26 \

    substituteInPlace src/pinstall/install.c --replace "/bin/cp" $(type -tp cp)
  '';

  meta = {
      description = "Open AFS client for Linux";
      homepage = webpage;
      license = "IPL";
  };
}

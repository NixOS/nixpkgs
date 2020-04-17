{ stdenv, fetchurl, bison, flex, autoreconfHook
, openssl, db, attr, perl, tcsh
} :

stdenv.mkDerivation rec {
  pname = "orangefs";
  version = "2.9.7";

  src = fetchurl {
    url = "http://download.orangefs.org/current/source/orangefs-${version}.tar.gz";
    sha256 = "15669f5rcvn44wkas0mld0qmyclrmhbrw4bbbp66sw3a12vgn4sm";
  };

  nativeBuildInputs = [ bison flex perl autoreconfHook ];
  buildInputs = [ openssl db attr tcsh ];

  postPatch = ''
    # Issue introduced by attr-2.4.48
    substituteInPlace src/apps/user/ofs_setdirhint.c --replace attr/xattr.h sys/xattr.h

    # Do not try to install empty sysconfdir
    substituteInPlace Makefile.in --replace 'install -d $(sysconfdir)' ""

    # perl interpreter needs to be fixed or build fails
    patchShebangs ./src/apps/admin/pvfs2-genconfig

    # symlink points to a location in /usr
    rm ./src/client/webpack/ltmain.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc/orangefs"
    "--enable-shared"
    "--enable-fast"
    "--with-ssl=${stdenv.lib.getDev openssl}"
  ];


  enableParallelBuilding = true;

  postInstall = ''
    # install useful helper scripts
    install examples/keys/pvfs2-gen-keys.sh $out/bin
  '';

  postFixup = ''
    for f in pvfs2-getmattr pvfs2-setmattr; do
      substituteInPlace $out/bin/$f --replace '#!/bin/csh' '#!${tcsh}/bin/tcsh'
    done

    sed -i 's:openssl:${openssl}/bin/openssl:' $out/bin/pvfs2-gen-keys.sh
  '';

  meta = with stdenv.lib; {
    description = "Scale-out network file system for use on high-end computing systems";
    homepage = "http://www.orangefs.org/";
    license = with licenses;  [ asl20 bsd3 gpl2 lgpl21 lgpl21Plus openldap ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markuskowa ];
    broken = true;
  };
}

{ stdenv, fetchurl, bison, flex, autoreconfHook
, openssl, db, attr, perl, tcsh, fetchpatch
, enableLmdb ? false
} :

stdenv.mkDerivation rec {
  pname = "orangefs";
  version = "2.9.7";

  src = fetchurl {
    url = "http://download.orangefs.org/current/source/orangefs-${version}.tar.gz";
    sha256 = "15669f5rcvn44wkas0mld0qmyclrmhbrw4bbbp66sw3a12vgn4sm";
  };

  patches = let
    urlBase = "https://github.com/waltligon/orangefs/commit/";
  in [
    (fetchpatch {
      name = "glib-2.28-1";
      url = "${urlBase}560f1e624687781d92561507295d1e7833187fc4.patch";
      sha256 = "0bp4znzrzhfwfwpkpffacxdg0511wxv5zff7754k94r467rq9nx5";
    })
    (fetchpatch {
      name = "glib-2.28-2";
      url = "${urlBase}63ba2f50483339c195d1def845befe6adab16f35.patch";
      sha256 = "0239blp0yzsc02cjrnsyllz48wkqcc22g4h48rff08wadi56cfnc";
    })
    (fetchpatch {
      name = "glib-2.30";
      url = "${urlBase}ce93eeeeb26ba555f1cc6f8d48f7dd4ccecc5851.patch";
      sha256 = "15hff3nb9sp85k243k4ij5jhk6hpb63nq8ipil6fn76k41hv4ciz";
    })
  ];

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
    "--enable-racache"
    "--with-ssl=${stdenv.lib.getDev openssl}"
  ] ++ stdenv.lib.optional enableLmdb "--with-db-backend=lmdb";


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
  };
}

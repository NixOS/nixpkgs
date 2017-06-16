{ stdenv, fetchurl, openssl, flex, bison, pkgconfig, groff, libxml2, utillinux
, file, libtool, which }:

stdenv.mkDerivation rec {
  name = "torque-4.2.10";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.adaptivecomputing.com/index.php?wpfb_dl=2880";
    sha256 = "1qpsk3bla6b6m7m0i1xpr183yj79liy3p34xhnz1grgq0776wg5l";
  };

  buildInputs = [ openssl flex bison pkgconfig groff libxml2 utillinux libtool
                  which ];

  enableParallelBuilding = true;

  preConfigure = ''
   substituteInPlace ./configure \
     --replace '/usr/bin/file' '${file}/bin/file'

   # fix broken libxml2 detection
   sed -i '/xmlLib\=/c\xmlLib=xml2' ./configure

   for s in fifo cray_t3e dec_cluster msic_cluster sgi_origin umn_cluster; do
     substituteInPlace src/scheduler.cc/samples/$s/Makefile.in \
       --replace "schedprivdir = " "schedprivdir = $out/"
   done

   for f in $(find ./ -name Makefile.in); do
     echo patching $f...
     sed -i $f -e '/PBS_MKDIRS/d' -e '/chmod u+s/d'
   done

  '';

  postInstall = ''
    mv $out/sbin/* $out/bin/
    rmdir $out/sbin
    cp -v buildutils/pbs_mkdirs $out/bin/
    cp -v torque.setup $out/bin/
    chmod +x $out/bin/pbs_mkdirs $out/bin/torque.setup
  '';

  meta = with stdenv.lib; {
    homepage = http://www.adaptivecomputing.com/products/open-source/torque;
    description = "Resource management system for submitting and controlling jobs on supercomputers, clusters, and grids";
    platforms = platforms.linux;
  };
}

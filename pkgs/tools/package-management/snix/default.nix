{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null

, ext3cowtools, e3cfsprogs, rsync
, libtool, automake, autoconf
, flex, bison

, docbook5, docbook5_xsl, libxslt, docbook_xml_dtd_43, w3m

, ext3cow_kernel

, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, nixStoreStateDir ? "/nix/state"
}:

stdenv.mkDerivation {
  name = "snix-0.12rev10946";
  
  src = fetchurl {
    url = http://www.denbreejen.net/public/nix/snix-20080304-rev10948.tar.gz;
    sha256 = "6973f080be8a32f1fc9b109f7f180b2bbd4e9e246721de9247378e49c6a70ef4";
  };
  
  buildInputs = [perl curl openssl rsync libtool automake autoconf flex bison
                 docbook5 docbook5_xsl libxslt docbook_xml_dtd_43 w3m ];

  preConfigure = "
    ./bootstrap.sh
  ";

  configureFlags = "
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state
    --with-store-state-dir=${nixStoreStateDir}
    --with-ext3cow-header=${ext3cow_kernel}/lib/modules/2.*/build/include/linux/ext3cow_fs.h
    --with-rsync=${rsync}/bin/rsync";

  meta = {
    description = "The SNix Deployment System (Nix extended to handle state)";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}

{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null

, ext3cowtools, e3cfsprogs, rsync
#, libtool, docbook5, docbook5-xsl, flex, bison

, ext3cow_kernel

, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, nixStoreStateDir ? "/nix/state"
}:

stdenv.mkDerivation {
  name = "snix-0.12rev9419";
  
  src = fetchurl {
    url = http://www.denbreejen.net/public/nix/snix-0.12rev9419.tar.gz;
    sha256 = "fe7c06a8c41f6c9c94898a5fd690ed76da397012ea4c624adac9029b23c88a1c";
  };
  
  buildInputs = [perl curl openssl rsync];

  configureFlags = "
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state
    --with-store-state-dir=${nixStoreStateDir}
    --with-ext3cow-header=${ext3cow_kernel}/lib/modules/2.*/build/include/linux/ext3cow_fs.h
    --with-rsync=${rsync}/bin/rsync";

  meta = {
    description = "The SNix Deployment System (Nix extended to handle state)";
    homepage = http://nix.cs.uu.nl/;
    license = "LGPL";
  };
}

{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e3cfsprogs-1.39";
  builder = ./builder.sh;

  patches = [ ./e3cfsprogs-1.39_bin_links.patch ./e3cfsprogs-1.39_etc.patch ];

  src = fetchurl {
    url = http://ext3cow.com/e3cfsprogs/e3cfsprogs-1.39.tgz;
    sha256 = "8dd3de546aeb1ae42fb05409aeb724a145fe9aa1dbe1115441c2297c9d48cf31";
  };

  configureFlags ="--enable-dynamic-e2fsck --enable-elf-shlibs";
  buildInputs = [gettext];
  preInstall = "installFlagsArray=('LN=ln -s')";
  postInstall = "make install-libs";
}

#note that ext3cow requires the ext3cow kernel patch !!!!

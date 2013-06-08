{ stdenv, fetchurl, gnused, perl, libgcrypt, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "munge-0.5.10";

  src = fetchurl {
    url = "http://munge.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1imbmpd70vkcpca8d9yd9ajkhf6ik057nr3jb1app1wm51f15q00";
  };

  buildInputs = [ gnused perl libgcrypt zlib bzip2 ];

  preConfigure = ''
    # Remove the install-data stuff, since it tries to write to /var
    sed -i '434,465d' src/etc/Makefile.in
  '';

  configureFlags = [
    "--localstatedir=/var"
  ];

  meta = {
    homepage = http://code.google.com/p/munge/;
    description = ''
      An authentication service for creating and validating credentials
    '';
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
  };
}

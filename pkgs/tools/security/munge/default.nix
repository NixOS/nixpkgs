{ stdenv, fetchurl, gnused, perl, libgcrypt, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "munge-0.5.11";

  src = fetchurl {
    url = "http://munge.googlecode.com/files/${name}.tar.bz2";
    sha256 = "19aijdrjij2g0xpqgl198jh131j94p4gvam047gsdc0wz0a5c1wf";
  };

  buildInputs = [ gnused perl libgcrypt zlib bzip2 ];

  preConfigure = ''
    # Remove the install-data stuff, since it tries to write to /var
    sed -i '505,511d' src/etc/Makefile.in
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

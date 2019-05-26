{ stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux, pcre }:

stdenv.mkDerivation rec {
  name = "aide-${version}";
  version = "0.16.1";

  src = fetchurl {
    url = "https://github.com/aide/aide/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1dqhc0c24wa4zid06pfy61k357yvzh28ij86bk9jf6hcqzn7qaqg";
  };

  buildInputs = [ flex bison libmhash zlib acl attr libselinux pcre ];


  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    ];

  meta = with stdenv.lib; {
    homepage = http://aide.sourceforge.net/;
    description = "A file and directory integrity checker";
    license = licenses.free;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}

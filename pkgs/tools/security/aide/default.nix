{ stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux, pcre }:

stdenv.mkDerivation rec {
  pname = "aide";
  version = "0.16.2";

  src = fetchurl {
    url = "https://github.com/aide/aide/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "15xp47sz7kk1ciffw3f5xw2jg2mb2lqrbr3q6p4bkbz5dap9iy8p";
  };

  buildInputs = [ flex bison libmhash zlib acl attr libselinux pcre ];


  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    ];

  meta = with stdenv.lib; {
    homepage = "http://aide.sourceforge.net/";
    description = "A file and directory integrity checker";
    license = licenses.free;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}

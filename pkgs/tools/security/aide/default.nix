{ stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux, pcre }:

stdenv.mkDerivation rec {
  name = "aide-${version}";
  version = "0.16";

  src = fetchurl {
    url = "mirror://sourceforge/aide/${version}/aide-${version}.tar.gz";
    sha256 = "0ibkv4z2gk14fn014kq13rp2ysiq6nn2cflv2q5i7zf466hm6758";
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

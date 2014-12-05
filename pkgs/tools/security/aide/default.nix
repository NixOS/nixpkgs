{ stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux }:
stdenv.mkDerivation rec {
  name = "aide-${version}";
  version = "0.16a2";

  src = fetchurl {
    url = "mirror://sourceforge/aide/devel/0.16a2/aide-${version}.tar.gz";
    sha256 = "11qvp6l2x4ajq9485lmg722gfdikh8r2wqfw17m0jm68df0m295m";
  };

  buildInputs = [ flex bison libmhash zlib acl attr libselinux ];


  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    ];

  meta = with stdenv.lib; {
    homepage = "http://aide.sourceforge.net/";
    description = "Advanced Intrusion Detection Environment (AIDE) is a file and directory integrity checker";
    license = licenses.free;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}

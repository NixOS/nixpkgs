{ lib, stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux, pcre }:

stdenv.mkDerivation rec {
  pname = "aide";
  version = "0.17";

  src = fetchurl {
    url = "https://github.com/aide/aide/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-T9iNHV3ccMaYxlGeu8BcjTLD9tgTe7/e/q66r9bbhns=";
  };

  buildInputs = [ flex bison libmhash zlib acl attr libselinux pcre ];


  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    ];

  meta = with lib; {
    homepage = "https://aide.github.io/";
    description = "A file and directory integrity checker";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}

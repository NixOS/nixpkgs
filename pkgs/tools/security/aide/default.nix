{ lib, stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux, pcre }:

stdenv.mkDerivation rec {
  pname = "aide";
  version = "0.17.4";

  src = fetchurl {
    url = "https://github.com/aide/aide/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-yBUFJG8//C52A21Dp3ISroKJW1iB2bniXBNhsam3qEY=";
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
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

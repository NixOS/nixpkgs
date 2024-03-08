{ lib, stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux, pcre2, pkg-config, libgcrypt }:

stdenv.mkDerivation rec {
  pname = "aide";
  version = "0.18.6";

  src = fetchurl {
    url = "https://github.com/aide/aide/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-j/Ns5H030MyYd2LV2WE0bUdd50u6ihgy/QBttu3TwQ4=";
  };

  buildInputs = [ flex bison libmhash zlib acl attr libselinux pcre2 libgcrypt ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    ];

  meta = with lib; {
    homepage = "https://aide.github.io/";
    description = "A file and directory integrity checker";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.linux;
  };
}

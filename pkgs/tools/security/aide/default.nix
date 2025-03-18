{ lib, stdenv, fetchurl, flex, bison, libmhash, zlib, acl, attr, libselinux, pcre2, pkg-config, libgcrypt }:

stdenv.mkDerivation rec {
  pname = "aide";
  version = "0.18.8";

  src = fetchurl {
    url = "https://github.com/aide/aide/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-FmYtxjLRfixWMLgBdS+XkSqOIml8Bl694XXxzDe4OmA=";
  };

  buildInputs = [ flex bison libmhash zlib acl attr libselinux pcre2 libgcrypt ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    "--sysconfdir=/etc"
    ];

  meta = with lib; {
    homepage = "https://aide.github.io/";
    description = "File and directory integrity checker";
    mainProgram = "aide";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.linux;
  };
}

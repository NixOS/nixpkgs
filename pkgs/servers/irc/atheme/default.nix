{ lib, stdenv, fetchgit, libmowgli, pkg-config, git, gettext, pcre, libidn, cracklib, openssl }:

stdenv.mkDerivation rec {
  pname = "atheme";
  version = "7.2.11";

  src = fetchgit {
    url = "https://github.com/atheme/atheme.git";
    rev = "v${version}";
    sha256 = "15fs48cgzxblh2g4abl5v647ndfx9hg8cih2x67v3y7s9wz68wk2";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ pkg-config git gettext ];
  buildInputs = [ libmowgli pcre libidn cracklib openssl ];

  configureFlags = [
    "--with-pcre"
    "--with-libidn"
    "--with-cracklib"
    "--enable-large-net"
    "--enable-contrib"
    "--enable-reproducible-builds"
  ];

  meta = with lib; {
    description = "A set of services for IRC networks";
    homepage = "https://atheme.github.io/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ leo60228 ];
  };
}

{ lib, stdenv, fetchgit, libmowgli, pkg-config, git, gettext, pcre, libidn, libxcrypt, cracklib, openssl }:

stdenv.mkDerivation rec {
  pname = "atheme";
  version = "7.2.12";

  src = fetchgit {
    url = "https://github.com/atheme/atheme.git";
    rev = "v${version}";
    sha256 = "sha256-KAC1ZPNo4TqfVryKOYYef8cRWRgFmyEdvl1bgvpGNiM=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ pkg-config git gettext ];
  buildInputs = [ libmowgli pcre libidn libxcrypt cracklib openssl ];

  configureFlags = [
    "--with-pcre"
    "--with-libidn"
    "--with-cracklib"
    "--enable-large-net"
    "--enable-contrib"
    "--enable-reproducible-builds"
  ];

  meta = with lib; {
    description = "Set of services for IRC networks";
    homepage = "https://atheme.github.io/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ leo60228 ];
  };
}

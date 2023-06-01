{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-auth-ldap";
  version = "unstable-2022-11-30";

  src = fetchFromGitHub {
    owner = "hydrian";
    repo = "TTRSS-Auth-LDAP";
    rev = "582ade49fd433a30b403caa1d0689fca5f3c99e1";
    sha256 = "sha256-favz/2KvWqvv8ehTv3gc7TBbFDjkrOmutChnyKPgces=";
  };

  installPhase = ''
    install -D plugins/auth_ldap/init.php $out/auth_ldap/init.php
  '';

  meta = with lib; {
    description = "Plugin for TT-RSS to authenticate users via ldap";
    license = licenses.asl20;
    homepage = "https://github.com/hydrian/TTRSS-Auth-LDAP";
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}

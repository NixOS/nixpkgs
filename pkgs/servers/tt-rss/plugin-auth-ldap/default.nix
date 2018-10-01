{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  name = "tt-rss-plugin-auth-ldap-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "hydrian";
    repo = "TTRSS-Auth-LDAP";
    rev = version;
    sha256 = "1mg9jff2m0ajxql1vd1g7hsxfbv9smhrmjg4j2gvvjbii45ry0jh";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Mic92/TTRSS-Auth-LDAP/commit/7534fa54babc377a070e05e326a46a252b5e3884.patch";
      sha256 = "1p7zas0n627z0g226dp5m5dg1ai2z3vi69n3xivp517iv3lch70l";
    })
  ];

  installPhase = ''
    install -D plugins/auth_ldap/init.php $out/auth_ldap/init.php
  '';

  meta = with stdenv.lib; {
    description = "Plugin for TT-RSS to authenticate users via ldap";
    license = licenses.gpl3;
    homepage = https://github.com/hydrian/TTRSS-Auth-LDAP;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}

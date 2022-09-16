{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-auth-ldap";
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
    # https://github.com/hydrian/TTRSS-Auth-LDAP/pull/40
    (fetchpatch {
      url = "https://github.com/hydrian/TTRSS-Auth-LDAP/commit/557811efa15bab3b5044c98416f9e37264f11c9a.patch";
      sha256 = "sha256-KtDY0J1OYNTLwK7834lI+2XL1N1FkOk5zhinGY90/4A=";
    })
    # https://github.com/hydrian/TTRSS-Auth-LDAP/pull/34
    (fetchpatch {
      url = "https://github.com/hydrian/TTRSS-Auth-LDAP/commit/b1a873f6a7d18231d2ac804d0146d6e048c8382c.patch";
      sha256 = "sha256-t5bDQM97dGwr7tHSS9cSO7qApf2M8KNaIuIxbAjExrs=";
    })
  ];

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

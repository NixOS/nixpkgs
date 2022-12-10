{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-auth-ldap";
  version = "unstable-2022-10-31";

  src = fetchFromGitHub {
    owner = "hydrian";
    repo = "TTRSS-Auth-LDAP";
    rev = "0cc2a21441f99eef8368cfe0fbdbb78126e28d61";
    sha256 = "sha256-pJWyvRnC38Ov1awVLgFZfp8+haADPniP+/P/C74qpcA=";
  };

  patches = [
    # https://github.com/hydrian/TTRSS-Auth-LDAP/pull/47
    (fetchpatch {
      url = "https://github.com/hydrian/TTRSS-Auth-LDAP/commit/003ca55bbd6e0a87fb729383e51eb269d918313d.patch";
      sha256 = "sha256-0YD33JPNOOPH2dpGwA/RbV3Kg4i2oKazBjP3hBcUIes=";
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

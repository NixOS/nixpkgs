{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  gnustep,
  re2c,
  openldap,
  openssl,
  openvpn,
}:

stdenv.mkDerivation rec {
  pname = "openvpn-auth-ldap";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "threerings";
    repo = "openvpn-auth-ldap";
    rev = "auth-ldap-${version}";
    sha256 = "1j30sygj8nm8wjqxzpb7pfzr3dxqxggswzxd7z5yk7y04c0yp1hb";
  };

  patches = [
    ./auth-ldap-fix-conftest.patch
    (fetchpatch2 {
      name = "fix-cve-2024-28820";
      url = "https://patch-diff.githubusercontent.com/raw/threerings/openvpn-auth-ldap/pull/92.patch";
      hash = "sha256-SXuo1D/WywKO5hCsmoeDdTsR7EelxFxJAKmlAQJ6vuE=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    gnustep.base
    gnustep.libobjc
    gnustep.make
    re2c
  ];

  buildInputs = [
    openldap
    openssl
    openvpn
  ];

  configureFlags = [
    "--with-objc-runtime=GNU"
    "--with-openvpn=${openvpn}/include"
    "--libdir=$(out)/lib/openvpn"
  ];

  doCheck = true;

  preInstall = ''
    mkdir -p $out/lib/openvpn $out/share/doc/openvpn/examples
    cp README.md $out/share/doc/openvpn/
    cp auth-ldap.conf $out/share/doc/openvpn/examples/
  '';

  meta = with lib; {
    description = "LDAP authentication plugin for OpenVPN";
    homepage = "https://github.com/threerings/openvpn-auth-ldap";
    license = [
      licenses.asl20
      licenses.bsd3
    ];
    maintainers = [ maintainers.benley ];
    platforms = platforms.unix;
  };
}

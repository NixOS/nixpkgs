{ stdenv, lib, fetchFromGitHub, fetchpatch,
  autoreconfHook, re2c, openldap, openvpn, gnustep, check
}:

let
  srcName = "openvpn-auth-ldap";
  srcVersion = "2.0.3";
  debianRev = "6.1";

  fetchPatchFromDebian =
    {patch, sha256}:
    fetchpatch {
      inherit sha256;
      url = "http://sources.debian.net/data/main/o/${srcName}/${srcVersion}-${debianRev}/debian/patches/${patch}";
    };
in

stdenv.mkDerivation rec {
  name = "${srcName}-${version}";
  version = "${srcVersion}+deb${debianRev}";

  srcs = fetchFromGitHub {
    owner = "threerings";
    repo = srcName;
    rev = "auth-ldap-${version}";
    sha256 = "1v635ylzf5x3l3lirf3n6173q1w8g0ssjjkf27qqw98c3iqp63sq";
  };

  patches = map fetchPatchFromDebian [
    {patch = "STARTTLS_before_auth.patch";
     sha256 = "14d2vy366rhzggxb1zb3ld00wmaqxi2gq885vxhlldnwpgig0jx0";}
    {patch = "gobjc_4.7_runtime.patch";
     sha256 = "11hpmd4i1cm3m27x8c77d9jrwxpir4cy5d74k2kxq0q77rawnxcm";}
    {patch = "openvpn_ldap_simpler_add_handler_4";
     sha256 = "0qj7v2w921489c18mfrs5bmipzn1mcjj9avyp15x4531ss0lyanb";}
    {patch = "auth-ldap-gnustep.patch";
     sha256 = "0cz3jgyzgzi2p9bavd4lh69pnlnf4s7n9ihwg6zmmh6vqsynqss3";}
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    check
    gnustep.base
    gnustep.libobjc
    gnustep.make
    openldap
    openvpn
    re2c
  ];

  configureFlags = [
    "--with-objc-runtime=modern"
    "--with-openvpn=${openvpn}/include"
    "--libdir=$(out)/lib/openvpn"
  ];

  preInstall = ''
    mkdir -p $out/lib/openvpn $out/share/doc/openvpn/examples
    cp README $out/share/doc/openvpn/
    cp auth-ldap.conf $out/share/doc/openvpn/examples/
  '';

  meta = with lib; {
    description = "LDAP authentication plugin for OpenVPN";
    homepage = https://github.com/threerings/openvpn-auth-ldap;
    license = [
      licenses.asl20
      licenses.bsd3
    ];
    maintainers = [ maintainers.benley ];
    platforms = platforms.unix;
  };
}

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

  src = fetchFromGitHub {
    owner = "threerings";
    repo = srcName;
    rev = "auth-ldap-${srcVersion}";
    sha256 = "1v635ylzf5x3l3lirf3n6173q1w8g0ssjjkf27qqw98c3iqp63sq";
  };

  patches = map fetchPatchFromDebian [
    {patch = "STARTTLS_before_auth.patch";
     sha256 = "02kky73mgx9jf16lpabppl271zyjn4a1160k8b6a0fax5ic8gbwk";}
    {patch = "gobjc_4.7_runtime.patch";
     sha256 = "0ljmdn70g5xp4kjcv59wg2wnqaifjdfdv1wlj356d10a7fzvxc76";}
    {patch = "openvpn_ldap_simpler_add_handler_4";
     sha256 = "0nha9mazp3dywbs1ywj8xi4ahzsjsasyrcic87v8c0x2nwl9kaa0";}
    {patch = "auth-ldap-gnustep.patch";
     sha256 = "053jni1s3pacpi2s43dkmk95j79ifh8rybjly13yy2dqffbasr31";}
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
    homepage = "https://github.com/threerings/openvpn-auth-ldap";
    license = [
      licenses.asl20
      licenses.bsd3
    ];
    maintainers = [ maintainers.benley ];
    platforms = platforms.unix;
  };
}

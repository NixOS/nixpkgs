{ stdenv, fetchurl
, libcap_ng

# Optional Dependencies
, openldap ? null, python ? null, go ? null, krb5 ? null, tcp_wrappers ? null

# Extra arguments
, prefix ? ""
}:

with stdenv;
let
  libOnly = prefix == "lib";

  optOpenldap = if libOnly then null else shouldUsePkg openldap;
  optPython = shouldUsePkg python;
  optGo = shouldUsePkg go;
  optKrb5 = if libOnly then null else shouldUsePkg krb5;
  optTcp_wrappers = if libOnly then null else shouldUsePkg tcp_wrappers;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${prefix}audit-${version}";
  version = "2.4.2";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/audit-${version}.tar.gz";
    sha256 = "08j134s4509rxfi3hwsp8yyxzlqqxl8kqgv2rfv6p3qng5pjd80j";
  };

  buildInputs = [ libcap_ng optOpenldap optPython optGo optKrb5 optTcp_wrappers ];

  # For libs only build and install the lib portion
  preBuild = optionalString libOnly ''
    cd lib
  '';

  configureFlags = [
    (mkWith   (optPython != null)       "python"      null)
    (mkWith   (optGo != null)           "golang"      null)
    (mkEnable (!libOnly)                "listener"    null)
    (mkEnable (optKrb5 != null)         "gssapi-krb5" null)
    (mkEnable false                     "systemd"     null)
    (mkWith   false                     "debug"       null)
    (mkWith   false                     "warn"        null)
    (mkWith   false                     "alpha"       null)  # TODO: Support
    (mkWith   false                     "arm"         null)  # TODO: Support
    (mkWith   false                     "aarch64"     null)  # TODO: Support
    (mkWith   (!libOnly)                "apparmor"    null)
    (mkWith   false                     "prelude"     null)
    (mkWith   (optTcp_wrappers != null) "libwrap"     optTcp_wrappers)
  ];

  meta = {
    description = "Audit Library";
    homepage = "http://people.redhat.com/sgrubb/audit/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fuuzetsu wkennington ];
  };
}

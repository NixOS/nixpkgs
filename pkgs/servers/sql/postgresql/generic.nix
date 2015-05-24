{ stdenv, bison, flex
, gettext

# Optional Dependencies
, kerberos ? null, pam ? null, openldap ? null, openssl ? null, readline ? null
, libossp_uuid ? null, libxml2 ? null, libxslt ? null, zlib ? null

# Extra Arguments
, blockSizeKB ? 8, segmentSizeGB ? 1
, walBlockSizeKB ? 8, walSegmentSizeMB ? 16

# Version specific arguments
, version, src
, ...
}:

with stdenv;
let
  optKerberos = shouldUsePkg kerberos;
  optPam = shouldUsePkg pam;
  optOpenldap = shouldUsePkg openldap;
  optOpenssl = shouldUsePkg openssl;
  optReadline = shouldUsePkg readline;
  optLibossp_uuid = shouldUsePkg libossp_uuid;
  optLibxml2 = shouldUsePkg libxml2;
  optLibxslt = shouldUsePkg libxslt;
  optZlib = shouldUsePkg zlib;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  inherit src;

  patches = [ ./less-is-more.patch ];

  nativeBuildInputs = [ bison flex ];
  buildInputs = [
    gettext optKerberos optPam optOpenldap optOpenssl optReadline
    optLibossp_uuid optLibxml2 optLibxslt optZlib
  ];

  #LC_ALL = "C";

  configureFlags = [
    (mkOther                            "sysconfdir"        "/etc")
    (mkOther                            "localstatedir"     "/var")
    (mkEnable true                      "integer-datetimes" null)
    (mkEnable true                      "nls"               null)
    (mkWith   true                      "pgport"            "5432")
    (mkEnable true                      "shared"            null)
    (mkEnable true                      "rpath"             null)
    (mkEnable true                      "spinlocks"         null)
    (mkEnable false                     "debug"             null)
    (mkEnable false                     "profiling"         null)
    (mkEnable false                     "coverage"          null)
    (mkEnable false                     "dtrace"            null)
    (mkWith   true                      "blocksize"         (toString blockSizeKB))
    (mkWith   true                      "segsize"           (toString segmentSizeGB))
    (mkWith   true                      "wal-blocksize"     (toString walBlockSizeKB))
    (mkWith   true                      "wal-segsize"       (toString walSegmentSizeMB))
    (mkEnable true                      "depend"            null)
    (mkEnable false                     "cassert"           null)
    (mkEnable true                      "thread-safety"     null)
    (mkWith   false                     "tcl"               null)  # Maybe enable some day
    (mkWith   false                     "perl"              null)  # Maybe enable some day
    (mkWith   false                     "python"            null)  # Maybe enable some day
    (mkWith   (optKerberos != null)     "gssapi"            null)
    (mkWith   false                     "krb5"              null)
    (mkWith   (optPam != null)          "pam"               null)
    (mkWith   (optOpenldap != null)     "ldap"              null)
    (mkWith   false                     "bonjour"           null)
    (mkWith   (optOpenssl != null)      "openssl"           null)
    (mkWith   (optReadline != null)     "readline"          null)
    (mkWith   false                     "libedit-preferred" null)
    (mkWith   (optLibossp_uuid != null) "ossp-uuid"         null)
    (mkWith   (optLibxml2 != null)      "libxml"            null)
    (mkWith   (optLibxslt != null)      "libxslt"           null)
    (mkWith   (optZlib != null)         "zlib"              null)
  ];

  meta = with stdenv.lib; {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = licenses.postgresql;
    maintainers = with maintaiers; [ ocharles ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux;
  };

  passthru = { inherit readline; };
}

{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, zlib ? null, openssl ? null, libssh2 ? null, libnghttp2 ? null, c-ares ? null
, gss ? null, rtmpdump ? null, openldap ? null, libidn ? null

# Extra arguments
, suffix ? ""
}:

with stdenv;
with stdenv.lib;
let
  isLight = suffix == "light";
  isFull = suffix == "full";
  nameSuffix = optionalString (suffix != "") "-${suffix}";

  # Normal Depedencies
  optZlib = if isLight then null else shouldUsePkg zlib;
  optOpenssl = if isLight then null else shouldUsePkg openssl;
  optLibssh2 = if isLight then null else shouldUsePkg libssh2;
  optLibnghttp2 = if isLight then null else shouldUsePkg libnghttp2;
  optC-ares = if isLight then null else shouldUsePkg c-ares;

  # Full dependencies
  optGss = if !isFull then null else shouldUsePkg gss;
  optRtmpdump = if !isFull then null else shouldUsePkg rtmpdump;
  optOpenldap = if !isFull then null else shouldUsePkg openldap;
  optLibidn = if !isFull then null else shouldUsePkg libidn;
in
stdenv.mkDerivation rec {
  name = "curl${nameSuffix}-${version}";
  version = "7.42.1";

  src = fetchurl {
    url = "http://curl.haxx.se/download/curl-${version}.tar.bz2";
    sha256 = "11y8racpj6m4j9w7wa9sifmqvdgf22nk901sfkbxzhhy75rmk472";
  };

  # Use pkgconfig only when necessary
  nativeBuildInputs = optional (!isLight) pkgconfig;
  propagatedBuildInputs = [
    optZlib optOpenssl optLibssh2 optLibnghttp2 optC-ares
    optGss optRtmpdump optOpenldap optLibidn
  ];

  # Make curl honor CURL_CA_BUNDLE & SSL_CERT_FILE
  postConfigure = ''
    echo '#define CURL_CA_BUNDLE (getenv("CURL_CA_BUNDLE") ? getenv("CURL_CA_BUNDLE") : getenv("SSL_CERT_FILE"))' >> lib/curl_config.h
  '';

  configureFlags = [
    (mkEnable true                    "http"              null)
    (mkEnable true                    "ftp"               null)
    (mkEnable true                    "file"              null)
    (mkEnable (optOpenldap != null)   "ldap"              null)
    (mkEnable (optOpenldap != null)   "ldaps"             null)
    (mkEnable true                    "rtsp"              null)
    (mkEnable true                    "proxy"             null)
    (mkEnable true                    "dict"              null)
    (mkEnable true                    "telnet"            null)
    (mkEnable true                    "tftp"              null)
    (mkEnable true                    "pop3"              null)
    (mkEnable true                    "imap"              null)
    (mkEnable true                    "smb"               null)
    (mkEnable true                    "smtp"              null)
    (mkEnable true                    "gopher"            null)
    (mkEnable (!isLight)              "manual"            null)
    (mkEnable true                    "libcurl_option"    null)
    (mkEnable false                   "libgcc"            null) # TODO: Enable on gcc
    (mkWith   (optZlib != null)       "zlib"              null)
    (mkEnable true                    "ipv4"              null)
    (mkWith   (optGss != null)        "gssapi"            null)
    (mkWith   false                   "winssl"            null)
    (mkWith   false                   "darwinssl"         null)
    (mkWith   (optOpenssl != null)    "ssl"               null)
    (mkWith   false                   "gnutls"            null)
    (mkWith   false                   "polarssl"          null)
    (mkWith   false                   "cyassl"            null)
    (mkWith   false                   "nss"               null)
    (mkWith   false                   "axtls"             null)
    (mkWith   false                   "libmetalink"       null)
    (mkWith   (optLibssh2 != null)    "libssh2"           null)
    (mkWith   (optRtmpdump!= null)    "librtmp"           null)
    (mkEnable false                   "versioned-symbols" null)
    (mkWith   false                   "winidn"            null)
    (mkWith   (optLibidn != null)     "libidn"            null)
    (mkWith   (optLibnghttp2 != null) "nghttp2"           null)
    (mkEnable false                   "sspi"              null)
    (mkEnable true                    "crypto-auth"       null)
    (mkEnable (optOpenssl != null)    "tls-srp"           null)
    (mkEnable true                    "unix-sockets"      null)
    (mkEnable true                    "cookies"           null)
    (mkEnable (optC-ares != null)     "ares"              null)
  ];

  meta = {
    description = "A command line tool for transferring files with URL syntax";
    homepage    = http://curl.haxx.se/;
    license     = licenses.mit;
    platforms   = platforms.all;
    maintainers = with maintainers; [ lovek323 wkennington ];
  };
}

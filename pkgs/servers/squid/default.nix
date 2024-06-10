{ lib, stdenv, fetchurl, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl, pkg-config, systemd
, cppunit
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squid";
  version = "6.8";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v6/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-EcxWULUYCdmUg8z64kdEouUc0WGZ9f8MkX6E/OaVhw8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    perl openldap db cyrus_sasl expat libxml2 openssl
  ] ++ lib.optionals stdenv.isLinux [ libcap pam systemd ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-ipv6"
    "--disable-strict-error-checking"
    "--disable-arch-native"
    "--with-openssl"
    "--enable-ssl-crtd"
    "--enable-storeio=ufs,aufs,diskd,rock"
    "--enable-removal-policies=lru,heap"
    "--enable-delay-pools"
    "--enable-x-accelerator-vary"
    "--enable-htcp"
  ] ++ lib.optional (stdenv.isLinux && !stdenv.hostPlatform.isMusl)
    "--enable-linux-netfilter";

  doCheck = true;
  nativeCheckInputs = [ cppunit ];
  preCheck = ''
    # tests attempt to copy around "/bin/true" to make some things
    # no-ops but this doesn't work if our "true" is a multi-call
    # binary, so make our own fake "true" which will work when used
    # this way
    echo "#!$SHELL" > fake-true
    chmod +x fake-true
    grep -rlF '/bin/true' test-suite/ | while read -r filename ; do
      substituteInPlace "$filename" \
        --replace "$(type -P true)" "$(realpath fake-true)" \
        --replace "/bin/true" "$(realpath fake-true)"
    done
  '';

  meta = with lib; {
    description = "Caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    knownVulnerabilities = [ "Squid has multiple unresolved security vulnerabilities, for more information see https://megamansec.github.io/Squid-Security-Audit/" ];
  };
})

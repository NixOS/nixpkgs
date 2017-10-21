{stdenv, fetchurl, perl, NetLDAP, makeWrapper, CryptSmbHash, DigestSHA1}:

let
  version = "0.9.11";
in
stdenv.mkDerivation {
  name = "smbldap-tools-${version}";
  src = fetchurl {
    url = "http://download.gna.org/smbldap-tools/sources/${version}/smbldap-tools-${version}.tar.gz";
    sha256 = "1xcxmpz74r82vjp731axyac3cyksfiarz9jk5g5m2bzfdixkq9mz";
  };

  buildInputs = [ perl NetLDAP makeWrapper CryptSmbHash DigestSHA1 ];

  preConfigure = ''
    export configureFlags="$configureFlags --with-perl-libdir=$out/lib/perl5/site_perl"
  '';

  postInstall = ''
    for i in $out/sbin/*; do
      wrapProgram $i \
        --prefix PERL5LIB : $PERL5LIB:$out/lib/perl5/site_perl
    done
  '';

  meta = {
    homepage = http://gna.org/projects/smbldap-tools/;
    description = "SAMBA LDAP tools";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}

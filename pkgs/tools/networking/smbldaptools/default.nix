{stdenv, fetchurl, perl, NetLDAP, makeWrapper, CryptSmbHash, DigestSHA1}:

let
  version = "0.9.7";
in
stdenv.mkDerivation {
  name = "smbldap-tools-${version}";
  src = fetchurl {
    url = "http://download.gna.org/smbldap-tools/sources/${version}/smbldap-tools-${version}.tar.gz";
    sha256 = "0y1k2j5qjxy66yvl36adbp9m1brapiz9ycaisdyy6093xvw1nh7j";
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
    license = "GPLv2+";
  };
}

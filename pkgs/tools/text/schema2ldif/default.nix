{ stdenv, fetchurl, makeWrapper, perlPackages }: stdenv.mkDerivation rec {
  name = "schema2ldif-${version}";
  version = "1.3";

  src = fetchurl {
    url = "https://repos.fusiondirectory.org/sources/schema2ldif/schema2ldif-${version}.tar.gz";
    sha256 = "00cd9xx9g0mnnfn5lvay3vg166z84jla0ya1x34ljdc8bflxsr9a";
  };

  buildInputs = [ perlPackages.perl ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    cp bin/{schema2ldif,ldap-schema-manager} $out/bin
    gzip -c man/schema2ldif.1 > $out/share/man/man1/schema2ldif.1.gz
    gzip -c man/ldap-schema-manager.1 > $out/share/man/man1/ldap-schema-manager.1.gz

    wrapProgram $out/bin/schema2ldif \
       --prefix PERL5PATH : "${perlPackages.makePerlPath [ perlPackages.GetoptLong ]}"
  '';

  meta = with stdenv.lib; {
    description = "Utilities to manage schema in .schema and .ldif format";
    homepage = "https://www.fusiondirectory.org/schema2ldif-project-and-components/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ das_j ];
  };
}

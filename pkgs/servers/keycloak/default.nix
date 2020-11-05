{ stdenv, fetchzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname   = "keycloak";
  version = "11.0.3";

  src = fetchzip {
    url    = "https://downloads.jboss.org/keycloak/${version}/keycloak-${version}.zip";
    sha256 = "15fw49rhnjky108hh71dkdlafd0ajr1n13vhivqcw6c18zvyan35";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    cp -r * $out

    rm -rf $out/bin/*.{ps1,bat}
    rm -rf $out/bin/add-user-keycloak.sh
    rm -rf $out/bin/jconsole.sh

    chmod +x $out/bin/standalone.sh
    wrapProgram $out/bin/standalone.sh \
      --prefix PATH ":" ${jre}/bin ;
  '';

  meta = with stdenv.lib; {
    homepage    = "https://www.keycloak.org/";
    description = "Identity and access management for modern applications and services";
    license     = licenses.asl20;
    platforms   = jre.meta.platforms;
    maintainers = [ maintainers.ngerstle ];
  };

}

{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {

  name = "${pname}-${version}";
  pname = "activator";
  version = "1.3.10";

  src = fetchurl {
    url = "http://downloads.typesafe.com/typesafe-${pname}/${version}/typesafe-${name}.zip";
    sha256 = "43693f041c8422ee06a2a90a805fd7b0e258dc85da31f0a4dca340dfd119b4ce";
  };

  buildInputs = [ unzip jre ];

  installPhase = ''
    mkdir -p $out/{bin,lib,libexec}
    mv repository $out/lib
    sed -i -e "s,declare.*activator_home.*=.*,declare -r activator_home=$out/lib/,g" bin/activator
    mv bin/activator $out/bin
    mv libexec/activator-launch-${version}.jar $out/libexec
  '';

  meta = with stdenv.lib; {
    description = "A scafollding tool for setting up reactive projects";
    homepage = "http://typesafe.com/activator";
    license = licenses.asl20;
    maintainers = with maintainers; [ edwtjo cko ];
    platforms = with platforms; unix;
  };

}

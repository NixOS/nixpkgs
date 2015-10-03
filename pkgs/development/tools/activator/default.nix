{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {

  name = "${pname}-${version}";
  pname = "activator";
  version = "1.3.5";

  src = fetchurl {
    url = "http://downloads.typesafe.com/typesafe-${pname}/${version}/typesafe-${name}.zip";
    sha256 = "19mcrp1ky652wwh3360ia0irc0c2xjcnn9rdal1rmkkzsqn4jx0b";
  };

  buildInputs = [ unzip jre ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    mv repository $out/lib
    sed -i -e "s,declare.*activator_home.*=.*,declare -r activator_home=$out/lib/,g" activator
    mv activator $out/bin
    mv activator-launch-${version}.jar $out/lib
  '';

  meta = with stdenv.lib; {
    description = "A scafollding tool for setting up reactive projects";
    homepage = "http://typesafe.com/activator";
    license = licenses.asl20;
    maintainers = with maintainers; [ edwtjo ];
  };

}

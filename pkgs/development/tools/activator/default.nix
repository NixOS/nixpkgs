{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {

  name = "${pname}-${version}";
  pname = "activator";
  version = "1.3.11";

  src = fetchurl {
    url = "http://downloads.typesafe.com/typesafe-${pname}/${version}/typesafe-${name}.zip";
    sha256 = "1xpdh0mh97jiyh835524whq8n6rkvi1bl9fj9mc9fv73x4y2fg9k";
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

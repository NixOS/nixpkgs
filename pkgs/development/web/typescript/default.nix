{ stdenv, fetchurl, nodejs }:

stdenv.mkDerivation rec {
  version = "0.9.1-1";
  name = "typescript-${version}";

  src = fetchurl {
    url = "http://registry.npmjs.org/typescript/-/${name}.tgz";
    sha256 = "0fgfp58hki0g1255lvv17pdk77m1bf7dbwzb0vdb91mhp2masc6q";
  };

  propagatedBuildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    chmod a+x $out/bin/tsc
  '';

  meta = with stdenv.lib; {
    description = "TypeScript is a language for application scale JavaScript development";
    longDescription = ''
      TypeScript is a language for application scale JavaScript development'';
    homepage = http://nodejs.org;
    license = licenses.asl20;
    maintainers = [ maintainers.joamaki ];
  };
}

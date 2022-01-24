{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "3.0.32";
  pname = "swagger-codegen";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/io/swagger/codegen/v3/${pname}-cli/${version}/${jarfilename}";
    sha256 = "sha256-FPSBnM2MLmYVb0A27UhDp5D3oWJlrjZlMYDEr3qwmDY=";
  };

  dontUnpack = true;

  installPhase = ''
    install -D $src $out/share/java/${jarfilename}

    makeWrapper ${jre}/bin/java $out/bin/${pname}3 \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen/tree/3.0.0";
    license = licenses.asl20;
    maintainers = [ maintainers._1000101 ];
  };
}

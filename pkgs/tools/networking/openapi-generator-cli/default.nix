{ callPackage, lib, stdenv, fetchurl, jre, makeWrapper }:

let this = stdenv.mkDerivation rec {
  version = "5.2.0";
  pname = "openapi-generator-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/org/openapitools/${pname}/${version}/${jarfilename}";
    sha256 = "sha256-mZYGCIR7XOvONnNFDM86qSM7iug48noNgBcHdik81vk=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${jarfilename}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/OpenAPITools/openapi-generator";
    license = licenses.asl20;
    maintainers = [ maintainers.shou ];
  };

  passthru.tests.example = callPackage ./example.nix {
    openapi-generator-cli = this;
  };
};
in this

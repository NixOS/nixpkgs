{ callPackage, lib, stdenv, fetchurl, jre, makeWrapper }:

let this = stdenv.mkDerivation rec {
  version = "6.0.0-2021-01-18";  # Also update the fetchurl link
  pname = "openapi-generator-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://oss.sonatype.org/content/repositories/snapshots/org/openapitools/openapi-generator-cli/6.0.0-SNAPSHOT/openapi-generator-cli-6.0.0-20210118.082537-4.jar";
    sha256 = "1ji3yw9dp4srlgqxvb21vrcp2bzj4himxsmp8l8zid9nxsc1m71x";
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

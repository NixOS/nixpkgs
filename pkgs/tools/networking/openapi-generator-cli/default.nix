{ callPackage, lib, stdenv, fetchurl, jre, makeWrapper }:

let this = stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "6.6.0";
=======
  version = "6.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "openapi-generator-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/org/openapitools/${pname}/${version}/${jarfilename}";
<<<<<<< HEAD
    sha256 = "sha256-lxj/eETolGLHXc2bIKNRNvbbJXv+G4dNseMALpneRgk=";
=======
    sha256 = "sha256-8Y13HpjyxbsWnR0ZYd5PlIZtKQGrweFhd91+kpmDRyE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/OpenAPITools/openapi-generator/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ shou ];
=======
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ maintainers.shou ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.tests.example = callPackage ./example.nix {
    openapi-generator-cli = this;
  };
};
in this

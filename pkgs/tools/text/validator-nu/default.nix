{ fetchFromGitHub
, git
, jdk_headless
, jre_headless
, makeWrapper
, python3
, stdenvNoCC
, lib
}:

let
  pname = "validator-nu";
  version = "22.9.29";

  src = fetchFromGitHub {
    owner = "validator";
    repo = "validator";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-NH/OyaKGITAL2yttB1kmuKVuZuYzhVuS0Oohj1N4icI=";
  };

  deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-deps";
    inherit version src;

    nativeBuildInputs = [ git jdk_headless python3 python3.pkgs.certifi ];

    buildPhase = ''
      python checker.py dldeps
    '';

    installPhase = ''
      mkdir "$out"
      mv dependencies extras "$out"
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-LPtxpUd7LAYZHJL7elgcZOTaTgHqeqquiB9hiuajA6c=";
  };

in
stdenvNoCC.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ git jdk_headless makeWrapper python3 ];

  buildPhase = ''
    ln -s '${deps}/dependencies' '${deps}/extras' .
    JAVA_HOME='${jdk_headless}' python checker.py build
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/java"
    mv build/dist/vnu.jar "$out/share/java/"
    makeWrapper "${jre_headless}/bin/java" "$out/bin/vnu" \
      --add-flags "-jar '$out/share/java/vnu.jar'"
  '';

  meta = with lib; {
    description = "Helps you catch problems in your HTML/CSS/SVG";
    homepage = "https://validator.github.io/validator/";
    license = licenses.mit;
    maintainers = with maintainers; [ andersk ];
    mainProgram = "vnu";
    sourceProvenance = with sourceTypes; [ binaryBytecode fromSource ];
  };
}

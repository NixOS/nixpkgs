{ lib, newScope, fetchFromGitHub, unzip, stdenvNoCC }:
let
  base = {
    version = "unstable-2023-02-02";
    nativeBuildInputs = [ unzip ];
    dontBuild = true;
    meta = with lib; {
      description = "NLTK Data";
      homepage = "https://github.com/nltk/nltk_data";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = with maintainers; [ happysalada ];
    };
  };
  makeNltkDataPackage = {pname, location, hash}:
    let
      src = fetchFromGitHub {
        owner = "nltk";
        repo = "nltk_data";
        rev = "5db857e6f7df11eabb5e5665836db9ec8df07e28";
        inherit hash;
        sparseCheckout = [ "${location}/${pname}.zip" ];
      };
    in
    stdenvNoCC.mkDerivation (base // {
      inherit pname src;
      version = base.version;
      installPhase = ''
        runHook preInstall

        mkdir -p $out
        unzip ${src}/${location}/${pname}.zip
        cp -R ${pname}/ $out/

        runHook postInstall
      '';
    });
in
lib.makeScope newScope (self: {
  punkt = makeNltkDataPackage ({
    pname = "punkt";
    location = "packages/tokenizers";
    hash = "sha256-rMkgn3xzmSJNv8//kqbPF2Xq3Gf16lgA1Wx8FPYbaQo=";
  });
  averaged_perceptron_tagger = makeNltkDataPackage ({
    pname = "averaged_perceptron_tagger";
    location = "packages/taggers";
    hash = "sha256-ilTs4HWPUoHxQb4kWEy3wJ6QsE/98+EQya44gtV2inw=";
  });
})

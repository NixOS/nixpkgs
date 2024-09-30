{ lib, newScope, fetchFromGitHub, unzip, stdenvNoCC }:
let
  base = {
    version = "0-unstable-2024-07-29";
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
        rev = "cfe82914f3c2d24363687f1db3b05e8b9f687e2b";
        inherit hash;
        sparseCheckout = [ "packages/${location}/${pname}.zip" ];
      };
    in
    stdenvNoCC.mkDerivation (base // {
      inherit pname src;
      inherit (base) version;
      installPhase = ''
        runHook preInstall

        mkdir -p $out
        unzip ${src}/packages/${location}/${pname}.zip
        mkdir -p $out/${location}
        cp -R ${pname}/ $out/${location}

        runHook postInstall
      '';
    });
in
lib.makeScope newScope (self: {
  punkt = makeNltkDataPackage {
    pname = "punkt";
    location = "tokenizers";
    hash = "sha256-OzMkruoYbFKqzuimOXIpE5lhHz8tmSqOFoLT+fjdTVg=";
  };
  punkt_tab = makeNltkDataPackage {
    pname = "punkt_tab";
    location = "tokenizers";
    hash = "sha256-OzMkruoYbFKqzuimOXIpE5lhHz8tmSqOFoLT+fjdTVg=";
  };
  averaged_perceptron_tagger = makeNltkDataPackage {
    pname = "averaged_perceptron_tagger";
    location = "taggers";
    hash = "sha256-tl3Cn2okhBkUtTXvAmFRx72Brez6iTGRdmFTwFmpk3M=";
  };
  snowball_data = makeNltkDataPackage {
    pname = "snowball_data";
    location = "stemmers";
    hash = "sha256-mNefwOPVJGz9kXV3LV4DuV7FJpNir/Nwg4ujd0CogEk=";
  };
  stopwords = makeNltkDataPackage {
    pname = "stopwords";
    location = "corpora";
    hash = "sha256-8lMjW5YI8h6dHJ/83HVY2OYGDyKPpgkUAKPISiAKqqk=";
  };
})

{
  lib,
  newScope,
  fetchFromGitHub,
  unzip,
  stdenvNoCC,
}:
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
  makeNltkDataPackage =
    {
      pname,
      location,
      hash,
    }:
    let
      src = fetchFromGitHub {
        owner = "nltk";
        repo = "nltk_data";
        rev = "5db857e6f7df11eabb5e5665836db9ec8df07e28";
        inherit hash;
        sparseCheckout = [ "packages/${location}/${pname}.zip" ];
      };
    in
    stdenvNoCC.mkDerivation (
      base
      // {
        inherit pname src;
        version = base.version;
        installPhase = ''
          runHook preInstall

          mkdir -p $out
          unzip ${src}/packages/${location}/${pname}.zip
          mkdir -p $out/${location}
          cp -R ${pname}/ $out/${location}

          runHook postInstall
        '';
      }
    );
in
lib.makeScope newScope (self: {
  punkt = makeNltkDataPackage ({
    pname = "punkt";
    location = "tokenizers";
    hash = "sha256-rMkgn3xzmSJNv8//kqbPF2Xq3Gf16lgA1Wx8FPYbaQo=";
  });
  averaged_perceptron_tagger = makeNltkDataPackage ({
    pname = "averaged_perceptron_tagger";
    location = "taggers";
    hash = "sha256-ilTs4HWPUoHxQb4kWEy3wJ6QsE/98+EQya44gtV2inw=";
  });
  snowball_data = makeNltkDataPackage ({
    pname = "snowball_data";
    location = "stemmers";
    hash = "sha256-Y6LERPtaRbCtWmJCvMAd2xH02xdrevZBFNYvP9N4+3s=";
  });
  stopwords = makeNltkDataPackage ({
    pname = "stopwords";
    location = "corpora";
    hash = "sha256-Rj1jnt6IDEmBbSIHHueyEvPmdE4EZ6/bJ3qehniebbk=";
  });
})

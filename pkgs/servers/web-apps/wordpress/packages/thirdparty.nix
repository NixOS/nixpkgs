{fetchzip, stdenv, lib}: {
  plugins.civicrm = stdenv.mkDerivation rec {
    pname = "civicrm";
    version = "5.56.0";
    src = fetchzip {
      inherit version;
      name = pname;
      url = "https://storage.googleapis.com/${pname}/${pname}-stable/${version}/${pname}-${version}-wordpress.zip";
      hash = "sha256-XsNFxVL0LF+OHlsqjjTV41x9ERLwMDq9BnKKP3Px2aI=";
    };
    meta.license = lib.licenses.agpl3Only;
  };
  themes = {
    geist = stdenv.mkDerivation rec {
      pname = "geist";
      version = "2.0.3";
      src = fetchzip {
        inherit version;
        name = pname;
        url = "https://github.com/christophery/geist/archive/refs/tags/${version}.zip";
        hash = "sha256-c85oRhqu5E5IJlpgqKJRQITur1W7x40obOvHZbPevzU=";
      };
      meta.license = lib.licenses.gpl2Only;
    };
    proton = stdenv.mkDerivation rec {
      pname = "proton";
      version = "1.0.1";
      src = fetchzip {
        inherit version;
        name = pname;
        url = "https://github.com/christophery/proton/archive/refs/tags/${version}.zip";
        hash = "sha256-JgKyLJ3dRqh1uwlsNuffCOM7LPBigGkLVFqftjFAiP4=";
      };
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r ./* $out/
        runHook postInstall
      '';
      meta.license = lib.licenses.mit;
    };
  };
}


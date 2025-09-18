{
  fetchzip,
  stdenv,
  lib,
}:
{
  plugins.civicrm = stdenv.mkDerivation rec {
    pname = "civicrm";
    version = "6.2.0";
    src = fetchzip {
      inherit version;
      name = pname;
      url = "https://download.civicrm.org/${pname}-${version}-wordpress.zip";
      hash = "sha256-Bx1rixRbqJsiMrIIkzTGeqLIc5raiNoUVTsoxZ6q9uU=";
    };
    installPhase = ''
      runHook preInstall
      cp -r ./ -T $out
      runHook postInstall
    '';
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

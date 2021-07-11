{ lib
, pkgs
, fetchurl
, stdenv
}:

let

  mkWordpressTheme = a@{
    themeName,
    namePrefix ? "wordpresstheme-",
    src,
    unpackPhase ? "",
    configurePhase ? ":",
    buildPhase ? ":",
    addonInfo ? null,
    preInstall ? "",
    postInstall ? "",
    path ? lib.getName themeName,
    ...
  }:
    stdenv.mkDerivation (a // {
      pname = namePrefix + themeName;

      inherit themeName unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

      installPhase = "mkdir -p $out; cp -R * $out/";
    });

in rec {
  inherit mkWordpressTheme;

  geist = mkWordpressTheme {
    themeName = "geist";
    version = "2.0.2";
    src = fetchurl {
      url = "https://github.com/christophery/geist/archive/refs/tags/2.0.2.zip";
      sha256 = "1w1kwas46hcx10n7dy638vr6bjsw0fla4g9wg2d2b3pbpnj0q5mn";
    };
    buildInputs = [ pkgs.unzip ];
  };

}


{ lib, stdenv, fetchurl, writeText, plugins ? [ ], nixosTests }:

let
  version = "4.4";

  versionParts = lib.take 2 (lib.splitVersion version);
  # 4.2 -> 402, 3.11 -> 311
  stableVersion = lib.removePrefix "0" (lib.concatMapStrings
    (p: if (lib.toInt p) < 10 then (lib.concatStrings ["0" p]) else p)
    versionParts);

in stdenv.mkDerivation rec {
  pname = "moodle";
  inherit version;

  src = fetchurl {
    url = "https://download.moodle.org/download.php/direct/stable${stableVersion}/${pname}-${version}.tgz";
    hash = "sha256-IW47IWtdbkBk8gw6eEQb/C9/BRwDbJpirXncGGDy3+s=";
  };

  phpConfig = writeText "config.php" ''
    <?php
      return require(getenv('MOODLE_CONFIG'));
    ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/moodle
    cp -r . $out/share/moodle
    cp ${phpConfig} $out/share/moodle/config.php

    ${lib.concatStringsSep "\n" (map (p:
      let
        dir = if p.pluginType == "mod" then
          "mod"
        else if p.pluginType == "theme" then
          "theme"
        else if p.pluginType == "block" then
          "blocks"
        else if p.pluginType == "question" then
          "question/type"
        else if p.pluginType == "course" then
          "course/format"
        else if p.pluginType == "report" then
          "admin/report"
        else
          throw "unknown moodle plugin type";
        # we have to copy it, because the plugins have refrences to .. inside
      in ''
        mkdir -p $out/share/moodle/${dir}/${p.name}
        cp -r ${p}/* $out/share/moodle/${dir}/${p.name}/
      '') plugins)}

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) moodle;
  };

  meta = with lib; {
    description =
      "Free and open-source learning management system (LMS) written in PHP";
    license = licenses.gpl3Plus;
    homepage = "https://moodle.org/";
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.all;
  };
}

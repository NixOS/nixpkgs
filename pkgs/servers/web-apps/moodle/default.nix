{ lib, stdenv, fetchurl, writeText, plugins ? [ ] }:

let
  version = "3.11.4";
  stableVersion = lib.concatStrings (lib.take 2 (lib.splitVersion version));

in stdenv.mkDerivation rec {
  pname = "moodle";
  inherit version;

  src = fetchurl {
    url = "https://download.moodle.org/stable${stableVersion}/${pname}-${version}.tgz";
    sha256 = "sha256-OPTImFgXuRK7bxK8KCan68/5D43qUOEK+TcC/9VQxu8=";
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

  meta = with lib; {
    description =
      "Free and open-source learning management system (LMS) written in PHP";
    license = licenses.gpl3Plus;
    homepage = "https://moodle.org/";
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.all;
  };
}

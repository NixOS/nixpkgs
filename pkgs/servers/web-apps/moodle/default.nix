{ lib, stdenv, fetchurl, writeText, plugins ? [ ], nixosTests }:

let
  version = "4.4.5";

  versionParts = lib.take 2 (lib.splitVersion version);
  # 4.2 -> 402, 3.11 -> 311
  stableVersion = lib.removePrefix "0" (lib.concatMapStrings
    (p: if (lib.toInt p) < 10 then (lib.concatStrings ["0" p]) else p)
    versionParts);

  # Reference: https://docs.moodle.org/dev/Plugin_types
  pluginDirs = {
    mod = "mod";
    antivirus = "lib/antivirus";
    assignsubmission = "mod/assign/submission";
    assignfeedback = "mod/assign/feedback";
    booktool = "mod/book/tool";
    customfield = "customfield/field";
    datafield = "mod/data/field";
    datapreset = "mod/data/preset";
    ltisource = "mod/lti/source";
    fileconverter = "files/converter";
    ltiservice = "mod/lti/service";
    mlbackend = "lib/mlbackend";
    forumreport = "mod/forum/report";
    quiz = "mod/quiz/report";
    quizaccess = "mod/quiz/accessrule";
    scormreport = "mod/scorm/report";
    workshopform = "mod/workshop/form";
    workshopallocation = "mod/workshop/allocation";
    workshopeval = "mod/workshop/eval";
    block = "blocks";
    qtype = "question/type";
    qbehaviour = "question/behaviour";
    qformat = "question/format";
    filter = "filter";
    editor = "lib/editor";
    atto = "lib/editor/atto/plugins";
    tinymce = "lib/editor/tinymce/plugins";
    enrol = "enrol";
    auth = "auth";
    tool = "admin/tool";
    logstore = "admin/tool/log/store";
    availability = "availability/condition";
    calendartype = "calendar/type";
    message = "message/output";
    format = "course/format";
    dataformat = "dataformat";
    profilefield = "user/profile/field";
    report = "report";
    # coursereport = "course/report"; # Moved to /report
    gradeexport = "grade/export";
    gradeimport = "grade/import";
    gradereport = "grade/report";
    gradingform = "grade/grading/form";
    mnetservice = "mnet/service";
    webservice = "webservice";
    repository = "repository";
    portfolio = "portfolio";
    search = "search/engine";
    media = "media/player";
    plagiarism = "plagiarism";
    cachestore = "cache/stores";
    cachelock = "cache/locks";
    theme = "theme";
    local = "local";
    # assignment = "mod/assignment/type"; # Deprecated
    # report = "admin/report"; # Moved to /report
    contenttype = "contentbank/contenttype";
    h5plib = "h5p/h5plib";
    qbank = "question/bank";
  };

in stdenv.mkDerivation rec {
  pname = "moodle";
  inherit version;

  src = fetchurl {
    url = "https://download.moodle.org/download.php/direct/stable${stableVersion}/${pname}-${version}.tgz";
    hash = "sha256-CronmobN0OFZHhMCmruPae34j1FNrvMLO02q1VlQfgY=";
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
        dir = if (lib.hasAttr p.pluginType pluginDirs) then
          pluginDirs.${p.pluginType}
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

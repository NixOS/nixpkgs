{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-exploretraces-app";
<<<<<<< HEAD
  version = "1.2.2";
  zipHash = "sha256-vQSnjSPiYvgwpbO7VvmG77DfP85+R6fRoGGpr+xslTc=";
  meta = {
    description = "Opinionated traces app";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = lib.platforms.unix;
=======
  version = "1.2.0";
  zipHash = "sha256-QXBOODMgFJvPLgr1Gr6mkpW2YJwYlDO/ZXL3BlEhEJ0=";
  meta = with lib; {
    description = "Opinionated traces app";
    license = licenses.agpl3Only;
    teams = [ lib.teams.fslabs ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

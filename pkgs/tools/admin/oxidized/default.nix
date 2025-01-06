{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

  exes = [
    "oxidized"
    "oxs"
  ];

  passthru.updateScript = bundlerUpdateScript "oxidized";

  meta = {
    description = "Network device configuration backup tool. It's a RANCID replacement";
    homepage = "https://github.com/ytti/oxidized";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ] ++ lib.teams.wdz.members;
    platforms = lib.platforms.linux;
  };
}

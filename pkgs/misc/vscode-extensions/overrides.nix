{ pkgs }:

self: super: {

  WakaTime.vscode-wakatime = pkgs.lib.overrideDerivation super.WakaTime.vscode-wakatime (old: {
    postPatch = ''
      mkdir -p out/wakatime-master
      cp -rt out/wakatime-master --no-preserve=all ${pkgs.wakatime}/lib/python*/site-packages/wakatime
    '';
  });

}

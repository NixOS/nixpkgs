{ pkgs, lib }:
{ applist }:
let
  # Example:
  # applist = [
  #   {mimetypes = ["text/plain" "text/css"]; exec = "${pkgs.sublime3}/bin/sublime";}
  #   {mimetypes = ["text/html"]; exec = "${pkgs.firefox}/bin/firefox";}
  # ];

  zeroArgv = cmd: builtins.head (lib.splitString " " cmd);
  lastInPath = path: lib.last (lib.splitString "/" path);

  mimetypeList = lib.flatten (map (item: (map (m: rec {
    mimetype = m;
    exec = item.exec;
    name = (zeroArgv (lastInPath exec));
    hash = builtins.hashString "md5" (exec+mimetypes);
    desktop = "${name}-${hash}.desktop";
    mimetypes = lib.concatStringsSep ";" item.mimetypes;
    outPath = desktopItem name exec hash mimetypes;
  }) item.mimetypes)) applist);

  desktopItem = name: exec: hash: mimetypes:
    pkgs.makeDesktopItem {
      name = builtins.unsafeDiscardStringContext "${name}-${hash}";
      inherit exec;
      mimeType = mimetypes;
      desktopName = "${name}";
      genericName = "NixOS default";
      noDisplay = "true";
    };

  defaultsListString = lib.concatStringsSep "\n" (
    map (item: item.mimetype+"="+item.desktop+";") mimetypeList
  );

  mimeappsListFile = pkgs.writeTextFile {
    name = "mimeapps.list";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      ${defaultsListString}

      [Added Associations]
      ${defaultsListString}
    '';
  };

  defaultsListFile = pkgs.writeTextFile {
    name = "defaults.list";
    destination = "/share/applications/defaults.list";
    text = ''
      [Default Applications]
      ${defaultsListString}
    '';
  };

  mimeinfoCacheFile = pkgs.writeTextFile {
    name = "mimeinfo.cache";
    destination = "/share/applications/mimeinfo.cache";
    text = ''
      [MIME Cache]
      ${defaultsListString}
    '';
  };

in pkgs.buildEnv {
  name = "defaultapps";
  paths = mimetypeList ++ [ mimeappsListFile defaultsListFile mimeinfoCacheFile ];
  pathsToLink = [ "/share/applications" ];
}

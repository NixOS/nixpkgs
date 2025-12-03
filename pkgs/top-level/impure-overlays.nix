/**
  This file has as its value the list of overlays, as determined from the environment.
  If Nix evaluation is [pure](https://nix.dev/manual/nix/latest/command-ref/conf-file.html?highlight=pure-eval#conf-pure-eval), then the list is empty.
*/
let
  # Return ‘x’ if it evaluates, or ‘def’ if it throws an exception.
  try =
    x: def:
    let
      res = builtins.tryEval x;
    in
    if res.success then res.value else def;
  homeDir = builtins.getEnv "HOME";

  isDir = path: builtins.pathExists (path + "/.");
  pathOverlays = try (toString <nixpkgs-overlays>) "";
  homeOverlaysFile = homeDir + "/.config/nixpkgs/overlays.nix";
  homeOverlaysDir = homeDir + "/.config/nixpkgs/overlays";
  overlays =
    path:
    # check if the path is a directory or a file
    if isDir path then
      # it's a directory, so the set of overlays from the directory, ordered lexicographically
      let
        content = builtins.readDir path;
      in
      map (n: import (path + ("/" + n))) (
        builtins.filter (
          n:
          (
            builtins.match ".*\\.nix" n != null
            &&
              # ignore Emacs lock files (.#foo.nix)
              builtins.match "\\.#.*" n == null
          )
          || builtins.pathExists (path + ("/" + n + "/default.nix"))
        ) (builtins.attrNames content)
      )
    else
      # it's a file, so the result is the contents of the file itself
      [ (import path) ];
in
if pathOverlays != "" && builtins.pathExists pathOverlays then
  overlays pathOverlays
else if builtins.pathExists homeOverlaysFile && builtins.pathExists homeOverlaysDir then
  throw ''
    Nixpkgs overlays can be specified with ${homeOverlaysFile} or ${homeOverlaysDir}, but not both.
    Please remove one of them and try again.
  ''
else if builtins.pathExists homeOverlaysFile then
  if isDir homeOverlaysFile then
    throw (homeOverlaysFile + " should be a file")
  else
    overlays homeOverlaysFile
else if builtins.pathExists homeOverlaysDir then
  if !(isDir homeOverlaysDir) then
    throw (homeOverlaysDir + " should be a directory")
  else
    overlays homeOverlaysDir
else
  [ ]

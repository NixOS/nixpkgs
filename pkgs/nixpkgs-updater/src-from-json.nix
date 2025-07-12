{ lib
, stdenv
, fetchFromGitHub
}:

infoPath:

if lib.isPath infoPath && (builtins.baseNameOf infoPath == "info.json")

then

  let info = lib.importJSON infoPath; in

  if info.fetcher == "fetchFromGitHub" then
    {
      src = fetchFromGitHub info.fetcherArgs;
      version = info.version;
    }
  else
    abort "Invalid fetcher: ${info.fetcher}"

else
  {
    src = infoPath;
    version = "DEV";
  }

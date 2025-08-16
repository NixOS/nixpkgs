{ lib
, stdenv
, fetchurl
, fetchzip
, fetchsvn
, fetchgit
, fetchfossil
, fetchcvs
, fetchhg
, fetchFromGitea
, fetchFromGitHub
, fetchFromGitLab
, fetchFromGitiles
, fetchFromBitbucket
, fetchFromSavannah
, fetchFromRepoOrCz
, fetchFromSourcehut
}:

projectInfo:

if lib.isPath projectInfo && (builtins.baseNameOf projectInfo == "info.json")

then

  let
    info = lib.importJSON projectInfo;
    projectSrc =
      if info.fetcher == "fetchurl" then fetchurl info.fetcherArgs
      else if info.fetcher == "fetchzip" then fetchzip info.fetcherArgs
      else if info.fetcher == "fetchsvn" then fetchsvn info.fetcherArgs
      else if info.fetcher == "fetchgit" then fetchgit info.fetcherArgs
      else if info.fetcher == "fetchfossil" then fetchfossil info.fetcherArgs
      else if info.fetcher == "fetchcvs" then fetchcvs info.fetcherArgs
      else if info.fetcher == "fetchhg" then fetchhg info.fetcherArgs
      else if info.fetcher == "fetchFromGitea" then fetchFromGitea info.fetcherArgs
      else if info.fetcher == "fetchFromGitHub" then fetchFromGitHub info.fetcherArgs
      else if info.fetcher == "fetchFromGitLab" then fetchFromGitLab info.fetcherArgs
      else if info.fetcher == "fetchFromGitiles" then fetchFromGitiles info.fetcherArgs
      else if info.fetcher == "fetchFromBitbucket" then fetchFromBitbucket info.fetcherArgs
      else if info.fetcher == "fetchFromSavannah" then fetchFromSavannah info.fetcherArgs
      else if info.fetcher == "fetchFromRepoOrCz" then fetchFromRepoOrCz info.fetcherArgs
      else if info.fetcher == "fetchFromSourcehut" then fetchFromSourcehut info.fetcherArgs
      else abort "Invalid fetcher: ${ info.fetcher}";

  in
  info // { src = projectSrc; }
else
  projectInfo

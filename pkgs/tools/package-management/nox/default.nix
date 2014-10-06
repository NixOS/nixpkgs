{ lib, pythonPackages, git, fetchgit, makeWrapper, nix }:

pythonPackages.buildPythonPackage rec {
  name = "nox-0.0.1";
  namePrefix = "";

  src = fetchgit {
    url = "git://github.com/madjar/nox.git";
    rev = "088249aa766c9fa929aa08a60f1a7eb41008da40";
    sha256 = "0dscnmhm1va2h0jz7hh60nvjwxv5a92n5pp8c0g7hz76g67mi5xs";
    leaveDotGit = true; # required by pbr
  };

  buildInputs = [ git pythonPackages.pbr makeWrapper ];

  pythonPath = with pythonPackages; [
      dogpile_cache
      click
      requests2
      characteristic
    ];

  postInstall = "wrapProgram $out/bin/nox --prefix PATH : ${nix}/bin";

  meta = {
    homepage = https://github.com/madjar/nox;
    description = "Tools to make nix nicer to use";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}

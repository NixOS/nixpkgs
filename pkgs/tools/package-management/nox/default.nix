{ lib, pythonPackages, git, fetchgit, makeWrapper, nix }:

pythonPackages.buildPythonPackage rec {
  name = "nox-0.0.1";
  namePrefix = "";

  src = fetchgit {
    url = "git://github.com/madjar/nox.git";
    rev = "49e4bb7de473ac5e446a76c292bdaefa7e20a1c6";
    sha256 = "0rsw0hs5swv6lwkfmj5fw3j22ah8g5gdb0hb5ikk321c6ww5dm5p";
    leaveDotGit = true; # required by pbr
  };

  buildInputs = [ git pythonPackages.pbr makeWrapper ];

  pythonPath =
    [ pythonPackages.dogpile_cache
      pythonPackages.click
    ];

  postInstall = "wrapProgram $out/bin/nox --prefix PATH : ${nix}/bin";

  meta = {
    homepage = https://github.com/madjar/nox;
    description = "Tools to make nix nicer to use";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}

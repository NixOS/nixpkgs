{ lib, pythonPackages, git, fetchgit, makeWrapper, nix }:

pythonPackages.buildPythonPackage rec {
  name = "nox-0.0.1";
  namePrefix = "";

  src = fetchgit {
    url = "git://github.com/madjar/nox.git";
    rev = "e5a4dbe5d11c3258e3038b4ae6f49d53f02d76cd";
    sha256 = "25d0ae9eeb6387bb45cbda8da08760ffef6a1661ebd106c537b468c93e66c035";
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

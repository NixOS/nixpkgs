{ pkgs, erlang, lowPrio }:

let

erlangPackages = modules // {
  inherit pkgs erlang;
  inherit (pkgs) stdenv fetchurl;
  self = erlangPackages;
} // rec {

  inherit erlang;
  inherit (pkgs) fetchurl fetchsvn fetchgit stdenv;

  # helpers

  callPackage = pkgs.lib.callPackageWith (pkgs // erlangPackages);

  buildInputs = [

  ];

  buildErlangPackage = import ../development/erlang-modules/generic {
    inherit (pkgs) rebar;
    inherit erlang;
  };

  nixpart = callPackage ../tools/filesystems/nixpart { };

  # packages defined here

  heroku_crashdumps = buildErlangPackage {

  name = "heroku_crashdumps-0.1.0";
  src = fetchurl {
    url = https://github.com/heroku/heroku_crashdumps/archive/0.1.0.tar.gz;
    md5 = "0cf27cf738ef2679b0a5e17b34fa5528";
  };

  meta = {
    description = "";
    license = "MIT";
  };

  };
}; in erlangPackages
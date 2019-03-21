{ stdenv, lib, coreutils, findutils, gnugrep, darwin
# Avoid having GHC in the build-time closure of all NixOS configurations
, doCheck ? false, shellcheck
}:

stdenv.mkDerivation {
  name = "nix-info";
  src = ./info.sh;

  path = lib.makeBinPath ([
    coreutils findutils gnugrep
  ] ++ (if stdenv.isDarwin then [ darwin.DarwinTools ] else []));
  is_darwin = if stdenv.isDarwin then "yes" else "no";

  sandboxtest = ./sandbox.nix;
  relaxedsandboxtest = ./relaxedsandbox.nix;
  multiusertest = ./multiuser.nix;

  unpackCmd = ''
    mkdir nix-info
    cp $src ./nix-info/nix-info
  '';

  buildPhase  = ''
    substituteAllInPlace ./nix-info
  '';

  inherit doCheck;
  checkInputs = [ shellcheck ];

  checkPhase = ''
    shellcheck ./nix-info
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./nix-info $out/bin/nix-info
  '';

  preferLocalBuild = true;

  meta = {
    platforms = lib.platforms.all;
  };
}

{ stdenv, lib, coreutils, findutils, gnugrep, darwin, shellcheck
, doCheck ? false # Avoid having GHC in the build-time closure of all NixOS configuratinos
}:

stdenv.mkDerivation {
  name = "nix-info";
  src = ./info.sh;

  nativeBuildInputs = lib.optionals doCheck [
    shellcheck
  ];

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
  checkPhase = ''
    shellcheck ./nix-info
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./nix-info $out/bin/nix-info
  '';

  meta = {
    platforms = lib.platforms.all;
  };
}

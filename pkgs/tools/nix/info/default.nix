{
  stdenv,
  lib,
  coreutils,
  findutils,
  gnugrep,
  darwin,
  bash,
  # Avoid having GHC in the build-time closure of all NixOS configurations
  doCheck ? false,
  shellcheck,
}:

stdenv.mkDerivation {
  name = "nix-info";
  src = ./info.sh;

  path = lib.makeBinPath (
    [
      coreutils
      findutils
      gnugrep
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ])
  );
  is_darwin = if stdenv.hostPlatform.isDarwin then "yes" else "no";

  sandboxtest = ./sandbox.nix;
  relaxedsandboxtest = ./relaxedsandbox.nix;
  multiusertest = ./multiuser.nix;

  unpackCmd = ''
    mkdir nix-info
    cp $src ./nix-info/nix-info
  '';

  buildPhase = ''
    substituteAllInPlace ./nix-info
  '';

  inherit doCheck;
  strictDeps = true;
  nativeCheckInputs = [ shellcheck ];
  buildInputs = [ bash ];

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

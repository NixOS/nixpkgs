{ stdenv, lib, coreutils, findutils, gnugrep, darwin, shellcheck }:
stdenv.mkDerivation {
  name = "nix-info";
  src = ./info.sh;

  buildInputs = [
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

  doCheck = true;
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

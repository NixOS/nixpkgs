{ lib, stdenv, bundlerEnv, ruby, bundlerUpdateScript, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lvmsync";
  version = (import ./gemset.nix).${pname}.version;

  buildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = let
    env = bundlerEnv {
      name = "${pname}-${version}-gems";
      ruby = ruby;
      gemfile  = ./Gemfile;
      lockfile = ./Gemfile.lock;
      gemset   = ./gemset.nix;
    };
  in ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/lvmsync $out/bin/lvmsync
  '';

  passthru.updateScript = bundlerUpdateScript "lvmsync";

  meta = with lib; {
    description = "Optimised synchronisation of LVM snapshots over a network";
    homepage = "https://theshed.hezmatt.org/lvmsync/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine nicknovitski ];
  };

}

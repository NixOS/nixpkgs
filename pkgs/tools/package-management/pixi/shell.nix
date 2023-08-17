{ lib
, stdenv
, buildFHSEnv
, xorg
, libselinux
, libGL
, pixi
, pixiDeps ? [ stdenv.cc xorg.libSM xorg.libICE xorg.libX11 xorg.libXau xorg.libXi xorg.libXrender libselinux libGL ]
, extraPkgs ? [ ]
}:

buildFHSEnv {
  name = "pixi-shell";

  targetPkgs = pkgs: (builtins.concatLists [ [ pixi ] pixiDeps extraPkgs]);

  runScript = "bash -l";

  meta = pixi.meta;
}

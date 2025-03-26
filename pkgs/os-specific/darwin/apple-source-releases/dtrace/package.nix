{
  lib,
  mkAppleDerivation,
  bison,
  flex,
}:

mkAppleDerivation {
  releaseName = "dtrace";

  xcodeHash = "sha256-aiWh5M+qboE4i6lERvYqG/K2Gc4Nd8fz2pOY8zwJ97k=";

  dontCopyMeson = true;
  postUnpack = ''
    substitute ${lib.escapeShellArg "${./meson/meson.build.in}"} "$sourceRoot/meson.build" --subst-var version
    cp -R ${./meson}/* "$sourceRoot"
    chmod -R +w "$sourceRoot"
  '';

  nativeBuildInputs = [
    bison
    flex
  ];

  patches = [
    ./0001-Patches-for-building-externally-to-Apple.patch
  ];

  meta = {
    description = "dtrace dynamic tracer";
    longDescription = ''
      The dtrace dynamic tracer. This packaging is just present for generating
      stubs; there is no guarantee it actually works for tracing, use the
      system version for that.
    '';
    maintainers = lib.teams.lix.members;
  };
}

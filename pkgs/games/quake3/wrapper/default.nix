{
  stdenv,
  buildEnv,
  lib,
  libGL,
  ioquake3,
  makeWrapper,
}:

{
  paks,
  name ? (lib.head paks).name,
  description ? "",
}:

let
  libPath = lib.makeLibraryPath [
    libGL
    stdenv.cc.cc
  ];
  env = buildEnv {
    name = "quake3-env";
    paths = [ ioquake3 ] ++ paks;
  };

in
stdenv.mkDerivation {
  name = "${name}-${ioquake3.name}";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin

      # We add Mesa to the end of $LD_LIBRARY_PATH to provide fallback
      # software rendering. GCC is needed so that libgcc_s.so can be found
      # when Mesa is used.
      makeWrapper ${env}/bin/ioquake3* $out/bin/quake3 \
        --suffix-each LD_LIBRARY_PATH ':' "${libPath}" \
        --add-flags "+set fs_basepath ${env} +set r_allowSoftwareGL 1"

      makeWrapper ${env}/bin/ioq3ded* $out/bin/quake3-server \
        --add-flags "+set fs_basepath ${env}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications $out/bin
      makeWrapper ${env}/bin/ioquake3* $out/bin/ioquake3 \
        --add-flags "+set fs_basepath ${env}"
      makeWrapper ${env}/bin/ioq3ded* $out/bin/ioq3ded \
        --add-flags "+set fs_basepath ${env}"

      # Renaming application packages on darwin is not quite as simple as they internally
      # refer to the old name in many places. So we shelve that for now.
      cp -RL ${env}/Applications/ioquake3.app $out/Applications/
      chmod -R +w $out/Applications/

      wrapProgram $out/Applications/ioquake3.app/Contents/MacOS/ioquake3 \
        --add-flags "+set fs_basepath ${env}"
      wrapProgram $out/Applications/ioquake3.app/Contents/MacOS/ioq3ded \
        --add-flags "+set fs_basepath ${env}"
    '';

  meta = {
    inherit description;
  };
}

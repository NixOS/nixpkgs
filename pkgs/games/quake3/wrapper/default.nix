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
  pname ? (lib.head paks).pname,
  version ? (lib.head paks).version,
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
    let
      setBasepath = "+set fs_basepath ${env}";
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin

      # We add Mesa to the end of $LD_LIBRARY_PATH to provide fallback
      # software rendering. GCC is needed so that libgcc_s.so can be found
      # when Mesa is used.
      makeWrapper ${env}/bin/ioquake3 $out/bin/${pname} \
        --suffix-each LD_LIBRARY_PATH ':' "${libPath}" \
        --add-flags "${setBasepath} +set r_allowSoftwareGL 1"

      makeWrapper ${env}/bin/ioq3ded $out/bin/${pname}-server \
        --add-flags "${setBasepath}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications $out/bin
      makeWrapper ${env}/bin/ioquake3 $out/bin/${pname} \
        --add-flags "${setBasepath}"
      makeWrapper ${env}/bin/ioq3ded $out/bin/${pname}-server \
        --add-flags "${setBasepath}"

      # Renaming application packages on darwin is not quite as simple as they internally
      # refer to the old name in many places. So we shelve that for now.
      cp -RL ${env}/Applications/ioquake3.app $out/Applications/
      chmod -R +w $out/Applications/

      wrapProgram $out/Applications/ioquake3.app/Contents/MacOS/ioquake3 \
        --add-flags "${setBasepath}"
      wrapProgram $out/Applications/ioquake3.app/Contents/MacOS/ioq3ded \
        --add-flags "${setBasepath}"
    '';

  meta = {
    inherit description;
  };
}

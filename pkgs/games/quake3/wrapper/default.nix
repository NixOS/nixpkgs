{ stdenv, buildEnv, lib, fetchurl, libGL, ioquake3, makeWrapper }:

{ paks, name ? (stdenv.lib.head paks).name, description ? "" }:

let
  libPath = lib.makeLibraryPath [ libGL stdenv.cc.cc ];
  env = buildEnv {
    name = "quake3-env";
    paths = [ ioquake3 ] ++ paks;
  };

in stdenv.mkDerivation {
  name = "${name}-${ioquake3.name}";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin

    # We add Mesa to the end of $LD_LIBRARY_PATH to provide fallback
    # software rendering. GCC is needed so that libgcc_s.so can be found
    # when Mesa is used.
    makeWrapper ${env}/ioquake3.* $out/bin/quake3 \
      --suffix-each LD_LIBRARY_PATH ':' "${libPath}" \
      --add-flags "+set fs_basepath ${env} +set r_allowSoftwareGL 1"

    makeWrapper ${env}/ioq3ded.* $out/bin/quake3-server \
      --add-flags "+set fs_basepath ${env}"
  '';

  meta = {
    inherit description;
  };
}

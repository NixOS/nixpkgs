{
  lib,
  pkgsBuildBuild,
  runCommand,
  writeText,
  source,
}:

{
  pname,
  path,
  extraPaths ? [ ],
}:

let
  sortedPaths = lib.naturalSort ([ path ] ++ extraPaths);
  filterText = writeText "${pname}-src-include" (
    lib.concatMapStringsSep "\n" (path: "/${path}") sortedPaths
  );
in
runCommand "${pname}-filtered-src" { nativeBuildInputs = [ pkgsBuildBuild.rsync ]; } ''
  rsync -a -r --files-from=${filterText} ${source}/ $out
''

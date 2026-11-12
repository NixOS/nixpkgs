{
  lib,
  runCommand,
  source,
}:

{
  pname,
  path,
  extraPaths ? [ ],
}:

let
  sortedPaths = lib.naturalSort ([ path ] ++ extraPaths);
in
runCommand "${pname}-filtered-src" { } (
  lib.concatMapStringsSep "\n" (path: ''
    mkdir -p "$(dirname "$out/${path}")"
    cp --archive --no-target-directory "${source}/${path}" "$out/${path}"
    chmod --recursive u+rwX "$out/${path}"
  '') sortedPaths
)

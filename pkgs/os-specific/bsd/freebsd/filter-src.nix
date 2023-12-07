{lib, runCommand, pkgsBuildBuild, source, ...}: {pname, path, extraPaths ? []}: runCommand "${pname}-filtered-src" {
  nativeBuildInputs = [ (pkgsBuildBuild.rsync.override { enableZstd = false; enableXXHash = false; }) ];
} ''
  for p in ${lib.concatStringsSep " " ([ path ] ++ extraPaths)}; do
    set -x
    path="$out/$p"
    mkdir -p "$(dirname "$path")"
    src_path="${source}/$p"
    if [[ -d "$src_path" ]]; then src_path+=/; fi
    rsync --chmod="+w" -r "$src_path" "$path"
    set +x
  done
''

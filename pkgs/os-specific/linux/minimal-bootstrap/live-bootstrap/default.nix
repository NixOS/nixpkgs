{ lib
, fetchurl
, sources ? import ./sources.nix
}:
let
  # inherit (sources) targetCommit files;
  pname = "live-bootstrap";
  buildURL = commit: file: "https://github.com/fosslinux/${pname}/raw/${commit}/${file}";
  # keep name inline with fetch-sources.py so they're found in the store rather than re-fetched
  # note: doesn't affect getting the right sha
  # e.g. /nix/store/3425qxmzdw3q3yarx4jcqcslair5dvd5-live-bootstrap-1bc4296-sysa-gzip-1.2.4-mk-main.mk
  buildName = commit: file: "${pname}-${builtins.substring 0 7 commit}-${lib.replaceStrings ["/"] ["-"] file}";
  fileFetcher = commit: file: sha256: fetchurl {
    name = buildName commit file;
    url = buildURL commit file;
    inherit sha256;
  };
  fetchedFiles = lib.mapAttrs
    (commit: files: lib.mapAttrs
      (fileName: sha256:
        fileFetcher commit fileName sha256
      )
      files)
    sources;
in
rec {
  getSubsetOfFiles = files: prefix:
    # trim prefix from filtered files
    lib.mapAttrs'
      (n: v: lib.nameValuePair (lib.removePrefix prefix n) v)
      # filter files with a matching prefix
      (lib.filterAttrs
        (n: _: lib.hasPrefix prefix n)
        files);
  packageFiles = { commit, parent, pname, version, files ? fetchedFiles }:
    getSubsetOfFiles fetchedFiles.${commit} "${parent}/${pname}-${version}/";
  files = fetchedFiles;
}

{ buildPackages, sourceData, hostVersion }:
# `buildPackages.fetchgit` avoids some probably splicing-caused infinite
# recursion.
buildPackages.fetchgit {
  # TODO: Find some other more descriptive name with minor and such?
  name = "${hostVersion}-src";
  url = "https://git.FreeBSD.org/src.git";
  inherit (sourceData) rev hash;
}

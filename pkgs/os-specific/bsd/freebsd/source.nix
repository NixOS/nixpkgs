{ buildPackages }:
release:

let
  versionInfos = {
    "freebsd13" = rec { version = "13.1.0"; rev = "release/${version}"; hash = "14nhk0kls83xfb64d5xy14vpi6k8laswjycjg80indq9pkcr2rlv"; };
    "freebsd14" = rec { version = "14.0.0-ALPHA1"; rev = "d1d7a273707a50d4ad1691b2c4dbf645dfa253ea"; hash = "sha256-l4zlta3jfSRVwFwivU+f5v6lIiKcAWbNt2H0Jy1buDc="; };
  };
  versionInfo = versionInfos.${release} or (throw "${release} is not a known FreeBSD version. Are you trying to compile FreeBSD for a non-FreeBSD platform?");
  rev = versionInfo.rev;
  hash = versionInfo.hash;
in
# `buildPackages.fetchgit` avoids some probably splicing-caused infinite
# recursion.
buildPackages.fetchgit {
  name = "${release}-src";
  url = "https://git.FreeBSD.org/src.git";
  rev = rev;
  sha256 = hash;
}

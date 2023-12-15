{ buildPackages, ... }:
release:

let
  versionInfos = {
    "freebsd13" = { version = "13.2.0"; hash = "14nhk0kls83xfb64d5xy14vpi6k8laswjycjg80indq9pkcr2rlv"; };
    "freebsd14" = { version = "14.0.0"; hash = "sha256-eBKwCYcOG9Lg7gBA2gZqxQFO/3uMMrcQGtgqi8se6zA="; };
    "freebsd15" = { version = "15.0.0-CURRENT"; rev = "60e845ceef25533bfb60450549bea56a17b1e467"; hash = "sha256-l4zlta3jfSRVwFwivU+f5v6lIiKcAWbNt2H0Jy1buDA="; };
  };
  versionInfo = versionInfos.${release} or (throw "${release} is not a known FreeBSD version. Are you trying to compile FreeBSD for a non-FreeBSD platform?");
  rev = versionInfo.rev or "release/${versionInfo.version}";
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

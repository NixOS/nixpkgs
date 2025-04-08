{ fetchFromGitHub, sourceData }:

# Using fetchFromGitHub from their mirror because it's a lot faster than their git server
# If you want you could fetchgit from "https://git.FreeBSD.org/src.git" instead.
# The update script still pulls directly from git.freebsd.org
fetchFromGitHub {
  owner = "freebsd";
  repo = "freebsd-src";
  inherit (sourceData) rev hash;

  # The GitHub export excludes some files in the git source
  # that were marked `export-ignore`.
  # A normal git checkout will keep those files,
  # matching the update script
  forceFetchGit = true;
}

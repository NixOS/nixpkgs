{
  callPackage,
  # All versions, revisions, and checksums are stored in ./versions.json.
  # The update process is the following:
  #   * pick the latest commit
  #   * update .invidious.rev, .invidious.version, and .invidious.sha256
  #   * prefetch the videojs dependencies with scripts/fetch-player-dependencies.cr
  #     and update .videojs.sha256 (they are normally fetched during build
  #     but nix's sandboxing does not allow that)
  #   * if shard.lock changed
  #     * recreate shards.nix by running crystal2nix
  #     * update lsquic and boringssl if necessarry, lsquic.cr depends on
  #       the same version of lsquic and lsquic requires the boringssl
  #       commit mentioned in its README
  versions ? (builtins.fromJSON (builtins.readFile ./versions.json))
}:

callPackage ./invidious.nix {
  inherit versions;
  # needs a specific version of lsquic
  lsquic = callPackage ./lsquic.nix { inherit versions; };
  # normally video.js is downloaded at build time
  videojs = callPackage ./videojs.nix { inherit versions; };
}

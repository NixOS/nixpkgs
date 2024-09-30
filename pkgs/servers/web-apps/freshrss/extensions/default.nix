{ config
, lib
, fetchFromGitHub
, fetchFromGitLab
, callPackage
}:

let
  buildFreshRssExtension = (callPackage ./freshrss-utils.nix { }).buildFreshRssExtension;

  official_extensions_version = "unstable-2024-04-27";
  official_extensions_src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "Extensions";
    rev = "71de129744ba37fd4cf363b78445f5345bc6d0b7";
    hash = "sha256-A+hOjbGNfhwTOAMeo08MUdqfWxxetzLz865oQQDsQlg=";
  };

  baseExtensions =
    _self:
    lib.mapAttrs (_n: lib.recurseIntoAttrs) {
      auto-ttl = buildFreshRssExtension rec {
        FreshRssExtUniqueId = "AutoTTL";
        pname = "auto-ttl";
        version = "0.5.0";
        src = fetchFromGitHub {
          owner = "mgnsk";
          repo = "FreshRSS-AutoTTL";
          rev = "v${version}";
          hash = "sha256-OiTiLZ2BjQD1W/BD8EkUt7WB2wOjL6GMGJ+APT4YpwE=";
        };
        meta = {
          description = "FreshRSS extension for automatic feed refresh TTL based on the average frequency of entries.";
          homepage = "https://github.com/mgnsk/FreshRSS-AutoTTL";
          license = lib.licenses.agpl3Only;
          maintainers = [ lib.maintainers.stunkymonkey ];
        };
      };

      demo = buildFreshRssExtension {
        FreshRssExtUniqueId = "Demo";
        pname = "demo";
        version = "unstable-2023-12-22";
        src = fetchFromGitHub {
          owner = "FreshRSS";
          repo = "xExtension-Demo";
          rev = "8d60f71a2f0411f5fbbb1f88a57791cee0848f35";
          hash = "sha256-5fe8TjefSiGMaeZkurxSJjX8qEEa1ArhJxDztp7ZNZc=";
        };
        meta = {
          description = "FreshRSS Extension for the demo version.";
          homepage = "https://github.com/FreshRSS/xExtension-Demo";
          license = lib.licenses.agpl3Only;
          maintainers = [ lib.maintainers.stunkymonkey ];
        };
      };

      reading-time = buildFreshRssExtension rec {
        FreshRssExtUniqueId = "ReadingTime";
        pname = "reading-time";
        version = "1.5";
        src = fetchFromGitLab {
          domain = "framagit.org";
          owner = "Lapineige";
          repo = "FreshRSS_Extension-ReadingTime";
          rev = "fb6e9e944ef6c5299fa56ffddbe04c41e5a34ebf";
          hash = "sha256-C5cRfaphx4Qz2xg2z+v5qRji8WVSIpvzMbethTdSqsk=";
        };
        meta = {
          description = "FreshRSS extension adding a reading time estimation next to each article.";
          homepage = "https://framagit.org/Lapineige/FreshRSS_Extension-ReadingTime";
          license = lib.licenses.agpl3Only;
          maintainers = [ lib.maintainers.stunkymonkey ];
        };
      };

      reddit-image = buildFreshRssExtension rec {
        FreshRssExtUniqueId = "RedditImage";
        pname = "reddit-image";
        version = "1.2.0";
        src = fetchFromGitHub {
          owner = "aledeg";
          repo = "xExtension-RedditImage";
          rev = "v${version}";
          hash = "sha256-H/uxt441ygLL0RoUdtTn9Q6Q/Ois8RHlhF8eLpTza4Q=";
        };
        meta = {
          description = "FreshRSS extension to process Reddit feeds.";
          homepage = "https://github.com/aledeg/xExtension-RedditImage";
          license = lib.licenses.agpl3Only;
          maintainers = [ lib.maintainers.stunkymonkey ];
        };
      };

      title-wrap = buildFreshRssExtension {
        FreshRssExtUniqueId = "TitleWrap";
        pname = "title-wrap";
        version = official_extensions_version;
        src = official_extensions_src;
        sourceRoot = "${official_extensions_src.name}/xExtension-TitleWrap";
        meta = {
          description = "FreshRSS extension instead of truncating the title is wrapped.";
          homepage = "https://github.com/FreshRSS/Extensions/tree/master/xExtension-TitleWrap";
          license = lib.licenses.agpl3Only;
          maintainers = [ lib.maintainers.stunkymonkey ];
        };
      };

      youtube = buildFreshRssExtension {
        FreshRssExtUniqueId = "YouTube";
        pname = "youtube";
        version = official_extensions_version;
        src = official_extensions_src;
        sourceRoot = "${official_extensions_src.name}/xExtension-YouTube";
        meta = {
          description = "FreshRSS extension allows you to directly watch YouTube/PeerTube videos from within subscribed channel feeds.";
          homepage = "https://github.com/FreshRSS/Extensions/tree/master/xExtension-YouTube";
          license = lib.licenses.agpl3Only;
          maintainers = [ lib.maintainers.stunkymonkey ];
        };
      };
    };

  # add possibility to define aliases
  aliases = super: {
    # example:  RedditImage = super.reddit-image;
  };

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = lib.optionals config.allowAliases [
    (_self: super: lib.recursiveUpdate super (aliases super))
  ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
(lib.fix toFix) // {
  inherit buildFreshRssExtension;
}

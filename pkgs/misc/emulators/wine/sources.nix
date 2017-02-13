{ pkgs ? import <nixpkgs> {} }:
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "2.0";
    url = "https://dl.winehq.org/wine/source/2.0/wine-${version}.tar.bz2";
    sha256 = "1ik6q0h3ph3jizmp7bxhf6kcm1pzrdrn2m0yf2x86slv2aigamlp";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86.msi";
      sha256 = "0fk4fwb4ym8xn0i5jv5r5y198jbpka24xmxgr8hjv5b3blgkd2iv";
    };
    gecko64 = fetchurl rec {
      version = "2.47";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86_64.msi";
      sha256 = "0zaagqsji6zaag92fqwlasjs8v9hwjci5c2agn9m7a8fwljylrf5";
    };

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "4.6.4";
      url = "http://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "0lj1rhp9s8aaxd6764mfvnyswwalafaanz80vxg3badrfy0xbdwi";
    };
  };

  unstable = fetchurl rec {
    version = "2.1";
    url = "https://dl.winehq.org/wine/source/2.x/wine-${version}.tar.xz";
    sha256 = "0vhykmypv8zqdma7nfwv40klwaywcslam6cmipr3vjci6vvapfdz";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    inherit (unstable) version;
    sha256 = "1r3mpdyhq3nmbqgj99bgrhx202k5c046bl8fhi5hr1x0adybb9hs";
    owner = "wine-compholio";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    version = "20170207";
    sha256 = "1zmx041rxxawkv3ifsdjbmshp654bib75n5hll0g1f205arbahzw";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}

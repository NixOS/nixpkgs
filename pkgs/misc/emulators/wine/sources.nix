{ pkgs ? import <nixpkgs> {} }:
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "2.0.1";
    url = "https://dl.winehq.org/wine/source/2.0/wine-${version}.tar.xz";
    sha256 = "10qm0xxqzvl4y3mhvaxcaacrcs8d5kdz5wf0gbxpmp36wnm4xyvc";

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
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "2.11";
    url = "https://dl.winehq.org/wine/source/2.x/wine-${version}.tar.xz";
    sha256 = "0g6cwjyqwc660w33453aklh3hpc0b8rrb88dryn23ah6wannvagg";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    inherit (unstable) version;
    sha256 = "0crv7hl39as0pjbi8ldws611izccdnss4hca4pgbz5cc80bki9gw";
    owner = "wine-compholio";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    version = "20170614";
    sha256 = "1xszflrdmixxr0v7vjby8fpnl8fgc9gldr1gnjpwzq1rnb84idqa";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}

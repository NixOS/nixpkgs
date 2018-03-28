{ pkgs ? import <nixpkgs> {} }:
## we default to importing <nixpkgs> here, so that you can use
## a simple shell command to insert new sha256's into this file
## e.g. with emacs C-u M-x shell-command
##
##     nix-prefetch-url sources.nix -A {stable{,.mono,.gecko64,.gecko32}, unstable, staging, winetricks}

# here we wrap fetchurl and fetchFromGitHub, in order to be able to pass additional args around it
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "3.0";
    url = "https://dl.winehq.org/wine/source/3.0/wine-${version}.tar.xz";
    sha256 = "1v7vq9iinkscbq6wg85fb0d2137660fg2nk5iabxkl2wr850asil";

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
      version = "4.7.1";
      url = "http://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "1ai9qsrgiwd371pyqr3mjaddaczly5d1z68r4lxl3hrkz2vmv39c";
    };
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "3.4";
    url = "https://dl.winehq.org/wine/source/3.x/wine-${version}.tar.xz";
    sha256 = "14wf7536rkmhav9ibbvhqqkfqmbk1dckhd2679i5scizr5x290x4";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-compholio/wine-staging/releases
    inherit (unstable) version;
    sha256 = "11cdymdd0qf8khhrakzj7qz12gx19h2a30r8bimbx6rriqryhlc2";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20180217";
    sha256 = "0k3vlsqjbzys5dfbxwgw76al8gh44jsjqkc06va103frkrgjxvc5";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}

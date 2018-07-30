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
    version = "3.0.2";
    url = "https://dl.winehq.org/wine/source/3.0/wine-${version}.tar.xz";
    sha256 = "1zv3nk31s758ghp4795ym3w8l5868c2dllmjx9245qh9ahvp3mya";

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
      version = "4.7.3";
      url = "http://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "0fkd22v2vm3ml76x1ngg42byvmry24xb92vpl4j84zhw6wbq0jnj";
    };
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "3.13";
    url = "https://dl.winehq.org/wine/source/3.x/wine-${version}.tar.xz";
    sha256 = "1m5v854r5wgw68b97j6wim1a8692x5sih25c0xp1yb13a94dg187";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-compholio/wine-staging/releases
    inherit (unstable) version;
    sha256 = "0996gsiqawp24dq8qpff2cpqm8w9d0pxf537bgdbhjncn88xjwhr";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20180603";
    sha256 = "02valprlb64cc40ivd8sxgxy2hsgqn22s49a47inl6pknj5nmvar";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };
}

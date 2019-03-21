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
    version = "4.0";
    url = "https://dl.winehq.org/wine/source/4.0/wine-${version}.tar.xz";
    sha256 = "0k8d90mgjzv8vjspmnxzr3i5mbccxnbr9hf03q1bpf5jjppcsdk7";

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
      version = "4.7.5";
      url = "http://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "0gsb03dc97hqdkw8kpl5ky53bygfnpxkgn2ry5bfzvfdfva6hk8m";
    };
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "4.2";
    url = "https://dl.winehq.org/wine/source/4.x/wine-${version}.tar.xz";
    sha256 = "1ysvq2jyvh7r27iwpsrlrwzj672jnrihry91bx3m3fysz3sl3ld1";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "1dhv6y60g64bj3kgfknbfzxfzmy686dh7svxlvi4lfis2faikxmk";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20181203";
    sha256 = "1as5h5xibpplm619b1i73g974p96q2jnd7fqm28xj3zkqy7qjdm3";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };
}

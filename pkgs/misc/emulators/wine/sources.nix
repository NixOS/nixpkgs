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
    version = "4.0.2";
    url = "https://dl.winehq.org/wine/source/4.0/wine-${version}.tar.xz";
    sha256 = "0x5x9pvhryzhq1m7i8gx5wwwj341zz05zymadlhfw5w45xlm0h4r";

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
      version = "4.9.2";
      url = "http://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "0x7z0216j21bzc9v1q283qlsvbfzn92yiaf26ilh6bd7zib4c7xr";
    };
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "4.14";
    url = "https://dl.winehq.org/wine/source/4.x/wine-${version}.tar.xz";
    sha256 = "1rl1a3k5sr0hyxc61d68kwandhxcnxwv6b77vh7x2rkl1h4nxmfs";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "1s17hcrp1aa0v99y5iav2s0lxdx2rzgm7z0c4zhxyydqxj399f5j";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20190615";
    sha256 = "1bdvj363yjn7agqq1fxdfz31j1rrs2wc02v874jjx5sw1bfq5qsa";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };
}

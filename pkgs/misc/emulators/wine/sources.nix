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
    version = "5.0.2";
    url = "https://dl.winehq.org/wine/source/5.0/wine-${version}.tar.xz";
    sha256 = "1g7c5djbi262h6zivmxbk26rsflwq8mrghr7hci3ajw7f3s89hn2";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47.1";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86.msi";
      sha256 = "0ld03pjm65xkpgqkvfsmk6h9krjsqbgxw4b8rvl2fj20j8l0w2zh";
    };
    gecko64 = fetchurl rec {
      version = "2.47.1";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86_64.msi";
      sha256 = "0jj7azmpy07319238g52a8m4nkdwj9g010i355ykxnl8m5wjwcb9";
    };

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "4.9.4";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "1p8g45xphxnns7dkg9rbaknarbjy5cjhrngaf0fsgk9z68wgz9ji";
    };
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "5.20";
    url = "https://dl.winehq.org/wine/source/5.x/wine-${version}.tar.xz";
    sha256 = "sha256-j1Ui+M6+vbqhL1jhumcaEfZjcuCu33T7kyz1qJOQhhw=";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "sha256-1oWoLb5w9g3wDghpvHpNsJCws7QoZ/E2dqxLuaIgi6o=";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";

    # Just keep list empty, if current release haven't broken patchsets
    disabledPatchsets = [ ];
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20200412";
    sha256 = "0ccr8wdmhkhbccxs5hvn44ppl969n8j0c3rnnir5v6akjcb2nzzv";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };
}

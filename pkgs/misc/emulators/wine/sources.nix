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
    version = "6.0";
    url = "https://dl.winehq.org/wine/source/6.0/wine-${version}.tar.xz";
    sha256 = "sha256-tJMGXy+D7kKcYuLsWGmKPPY+94ci4bIHZYIxUuhYLFY=";

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
      version = "5.1.1";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      sha256 = "09wjrfxbw0072iv6d2vqnkc3y7dzj15vp8mv4ay44n1qp5ji4m3l";
    };

    patches = [
      # Also look for root certificates at $NIX_SSL_CERT_FILE
      ./cert-path.patch
    ];
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "6.7";
    url = "https://dl.winehq.org/wine/source/6.x/wine-${version}.tar.xz";
    sha256 = "sha256-wwUUt3YdRhFRSuAhyx41QSjXfv9UooPxQB7nAid7vqQ=";
    inherit (stable) gecko32 gecko64;

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "6.1.1";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      sha256 = "sha256-rDsUvq/eNLhIIofllwABE9wGqRXzLJ/QbHfrgZB544s=";
    };

    patches = [
      # Also look for root certificates at $NIX_SSL_CERT_FILE
      ./cert-path.patch
     ];
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "sha256-fWriizSk2+U7Mpn6w/Dlrevd4vc5MnlSWSGxQDf2p+M=";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";

    # Just keep list empty, if current release haven't broken patchsets
    disabledPatchsets = [ ];
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20201206";
    sha256 = "1xs09v1zr98yvwvdsmzgryc2hbk92mwn54yxx8162l461465razc";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };
}

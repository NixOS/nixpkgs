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
    version = "5.0.3";
    url = "https://dl.winehq.org/wine/source/5.0/wine-${version}.tar.xz";
    sha256 = "sha256-nBo1Ni/VE9/1yEW/dtpj6hBaeUrHFEqlA/cTYa820i8=";

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
      ./cert-path-stable.patch
    ];
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "5.22";
    url = "https://dl.winehq.org/wine/source/5.x/wine-${version}.tar.xz";
    sha256 = "sha256-Cb0GyHyMl05q00UHzsh11yF+tW/Anfg41UU+DrvOTSE=";
    inherit (stable) mono gecko32 gecko64;

    patches = [
      # Also look for root certificates at $NIX_SSL_CERT_FILE
      ./cert-path.patch

      # Hotfix picked from master for https://bugs.winehq.org/show_bug.cgi?id=50163
      (pkgs.fetchpatch {
        url = "https://bugs.winehq.org/attachment.cgi?id=68680";
        sha256 = "sha256-GTPQhRWeu6DPadqgFiuVUjI6MzJPaTN4l//8DSG6hpo=";
      })
     ];
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "sha256-HzAKLPlybO1lrkHo4Q1Y9H0vmjiqo9HiT05TcX08Ubk=";
    owner = "wine-staging";
    repo = "wine-staging";
    #rev = "v${version}"; # revert back to this statement on next release
    # Include hotfix for https://bugs.winehq.org/show_bug.cgi?id=50162
    rev = "f257f37b92041fc718de04aa83ec3139b748ffa2";

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

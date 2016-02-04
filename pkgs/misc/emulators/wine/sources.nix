{ pkgs ? import <nixpkgs> {} }:
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "1.8.1";
    url = "mirror://sourceforge/wine/wine-${version}.tar.bz2";
    sha256 = "15ya496qq24ipqii7ij8x8h5x8n21vgqa4h6binb74w5mzdd76hl";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.40";
      url = "mirror://sourceforge/wine/wine_gecko-${version}-x86.msi";
      sha256 = "00nkaxhb9dwvf53ij0q75fb9fh7pf43hmwx6rripcax56msd2a8s";
    };
    gecko64 = fetchurl rec {
      version = "2.40";
      url = "mirror://sourceforge/wine/wine_gecko-${version}-x86_64.msi";
      sha256 = "0c4jikfzb4g7fyzp0jcz9fk2rpdl1v8nkif4dxcj28nrwy48kqn3";
    };
    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "4.5.6";
      url = "mirror://sourceforge/wine/wine-mono-${version}.msi";
      sha256 = "09dwfccvfdp3walxzp6qvnyxdj2bbyw9wlh6cxw2sx43gxriys5c";
    };
  };

  unstable = fetchurl rec {
    version = "1.9.2";
    url = "mirror://sourceforge/wine/wine-${version}.tar.bz2";
    sha256 = "0yjf0i2yc0yj366kg6b2ci9bwz3jq5k5vl01bqw4lbpgf5m4sk9k";
    inherit (stable) gecko32 gecko64 mono;
  };

  staging = fetchFromGitHub rec {
    inherit (unstable) version;
    sha256 = "05lxhl9rv936xh8v640l36xswszwc41iwpbjq7n5cwk361mdh1lp";
    owner = "wine-compholio";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    version = "20160109";
    sha256 = "0pnl5362g5q7py368vj07swbdp1fqbpvpq4jv4l5ddyclps8ajg8";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}

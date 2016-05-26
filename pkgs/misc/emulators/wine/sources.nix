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
    version = "1.9.10";
    url = "mirror://sourceforge/wine/wine-${version}.tar.bz2";
    sha256 = "1gqvhqq8a7h4s2ll5y54x65w51bdv8izw4k17qy9fb2lyvgh0jcd";
    inherit (stable) mono;
    gecko32 = fetchurl rec {
      version = "2.44";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86.msi";
      sha256 = "0fbd8pxkihhfxs5mcx8n0rcygdx43qdrp2x8hq1s1cvifp8lm9kp";
    };
    gecko64 = fetchurl rec {
      version = "2.44";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86_64.msi";
      sha256 = "0qb6zx4ycj37q26y2zn73w49bxifdvh9n4riy39cn1kl7c6mm3k2";
    };
  };

  staging = fetchFromGitHub rec {
    inherit (unstable) version;
    sha256 = "0lk171mk8iar7vhgv7af90975dqa4vrj5p3729bvp6r6fs3pqxkh";
    owner = "wine-compholio";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    version = "20160219";
    sha256 = "1wqsbdh2qa5xxswilniki9wzbhlmkl6jqmryjd9f5smirr7ryy2r";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}

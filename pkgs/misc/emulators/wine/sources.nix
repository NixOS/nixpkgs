{ pkgs ? import <nixpkgs> {} }:
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "1.8.4";
    url = "https://dl.winehq.org/wine/source/1.8/wine-${version}.tar.bz2";
    sha256 = "0yahh1n3s3y0bp1a1sr3zpna56749jdgr85hwmpq393pjx1i0pai";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.40";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86.msi";
      sha256 = "00nkaxhb9dwvf53ij0q75fb9fh7pf43hmwx6rripcax56msd2a8s";
    };
    gecko64 = fetchurl rec {
      version = "2.40";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86_64.msi";
      sha256 = "0c4jikfzb4g7fyzp0jcz9fk2rpdl1v8nkif4dxcj28nrwy48kqn3";
    };
    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "4.6.3";
      url = "http://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "1f98xwgv665zb9cwc5zphcdbffyh3sm26h62hzca6zlcwy5fi0zq";
    };
  };

  unstable = fetchurl rec {
    version = "1.9.20";
    url = "https://dl.winehq.org/wine/source/1.9/wine-${version}.tar.bz2";
    sha256 = "1pvrlawp079qg74q348v9p2qzlj4aqibxxwn4vqid69j883g6s97";
    inherit (stable) mono;
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
  };

  staging = fetchFromGitHub rec {
    inherit (unstable) version;
    sha256 = "1hk20axv0hppi5rqgslibwfjmcpjks3xa2dxi5v1y27qqhphvxpl";
    owner = "wine-compholio";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    version = "20160724";
    sha256 = "0nl8gnmsqwwrc8773q8py64kv3r5836xjxsnxjv91n4hhmvgyrzs";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}

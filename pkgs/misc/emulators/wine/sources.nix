{ pkgs ? import <nixpkgs> {} }:
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "2.0.2";
    url = "https://dl.winehq.org/wine/source/2.0/wine-${version}.tar.xz";
    sha256 = "16iwf48cfi39aqyy8131jz4x7lr551c9yc0mnks7g24j77sq867p";

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
    version = "2.19";
    url = "https://dl.winehq.org/wine/source/2.x/wine-${version}.tar.xz";
    sha256 = "15b0lvs456zjh5wwkhs9wh1ycih12ragk6170hnrrbkmk3k32wa8";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    inherit (unstable) version;
    sha256 = "16jps0x4srxnpdy3vxygvspz7qpd09i83c6j6kg8vv4qkna2lswi";
    owner = "wine-compholio";
    repo = "wine-staging";
    rev = "v${version}";
  };

  winetricks = fetchFromGitHub rec {
    version = "20171018";
    sha256 = "0qlnxyaydpqx87kfyrkkmwg0jv9dfh3mkq27g224a8v1kf9z3r3h";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}

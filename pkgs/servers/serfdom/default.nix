{ stdenv, fetchurl, fetchgit, fetchhg, go, lib }:

let
  goDeps = [
    {
      dir     = "github.com/hashicorp";
      name    = "serf";
      rev     = "c5b41a9d1d261135117a8d501d3293efade3cc74";
      sha256  = "a314d3c13fb370842a8f7c6650abfa907b51172a09c64f9184a240fab05b43df";
      fetcher = git;
    }
    {
      dir     = "github.com/armon";
      name    = "go-metrics";
      rev     = "e12c3591b520e819e8234bd585d592774f2b2ad5";
      sha256  = "79476efefb68876fcad7e71e76d95f4a7eece2cfcdc5a9c10f998af3178230ba";
      fetcher = git;
    }
    {
      dir     = "github.com/hashicorp";
      name    = "logutils";
      rev     = "8e0820fe7ac5eb2b01626b1d99df47c5449eb2d8";
      sha256  = "184lnn7x1v3xvj6zz1rg9s0252wkkd59kij2iyrrm7y80bym2jys";
      fetcher = git;
    }
    {
      dir     = "github.com/hashicorp";
      name    = "memberlist";
      rev     = "d5be01d1f4d75b086eba4ae808f2767c08cbbf73";
      sha256  = "4ab2b610d439e96c169d9caf9ac0e009d71d3ef9a2fd2c812870b71eb6b27dfc";
      fetcher = git;
    }
    {
      dir     = "github.com/ugorji";
      name    = "go";
      rev     = "71c2886f5a673a35f909803f38ece5810165097b";
      sha256  = "128853bcc5f114c300772cbce316b55e84206fa56705c5b9cc94c1693b11ee94";
      fetcher = git;
    }
    {
      dir     = "github.com/mitchellh";
      name    = "cli";
      rev     = "69f0b65ce53b27f729b1b807b88dc88007f41dd3";
      sha256  = "0hnnqd8vg5ca2hglkrj141ba2akdh7crl2lsrgz8d6ipw6asszx3";
      fetcher = git;
    }
    {
      dir     = "github.com/armon";
      name    = "mdns";
      rev     = "8be7e3ac4e941555169a99d01abcabd3c982d87a";
      sha256  = "87cd3a0ada3b094ee8fc4c4742158e0d051cde893da1ea320158a47d6254f69d";
      fetcher = git;
    }
    {
      dir     = "github.com/miekg";
      name    = "dns";
      rev     = "7ebb4c59b39d5984952a355086606dd91f6cfe86";
      sha256  = "8418ad2d27e607cef1dc0003471416294443e467f2de9df135e3a2ab411e2512";
      fetcher = git;
    }
    {
      dir     = "github.com/mitchellh";
      name    = "mapstructure";
      rev     = "57bb2fa7a7e00b26c80e4c4b0d4f15a210d94039";
      sha256  = "13lvd5vw8y6h5zl3samkrb7237kk778cky7k7ys1cm46mfd957zy";
      fetcher = git;
    }
    {
      dir     = "github.com/ryanuber";
      name    = "columnize";
      rev     = "d066e113d6e13232f45bda646a915dffeee7f1a4";
      sha256  = "2aaec396a223fc4b45117a595e74c0a874bd5cd9604c742b8c4747436b4721e9";
      fetcher = git;
    }
    {
      dir     = "code.google.com/p";
      name    = "go.net";
      rev     = "89dbba2db2d4";
      sha256  = "0168inai10nkdrz4g0rjlj8b5v34mv135v8bhyvh501vnqql50jn";
      fetcher = hg;
    }
  ];
  git = desc: fetchgit { url = "https://${desc.dir}/${desc.name}";
                         inherit (desc) rev sha256; };
  hg = desc: fetchhg { url = "https://${desc.dir}/${desc.name}";
                       tag = desc.rev;
                       inherit (desc) sha256; };
  createGoPathCmds =
    lib.concatStrings
      (map (desc:
            let fetched = desc.fetcher desc; in ''
              mkdir -p $GOPATH/src/${desc.dir}
              ln -s ${fetched} $GOPATH/src/${desc.dir}/${desc.name}
            '') goDeps);
in
  stdenv.mkDerivation rec {
    version = "0.5.0";
    name = "serfdom-${version}";

    src = fetchurl {
      url = "https://github.com/hashicorp/serf/archive/v${version}.tar.gz";
      sha256 = "1p2cpkdx0gck1ypxc98im7gsv3275avpkizhsif3nxvl1xd8g1qp";
    };

    buildInputs = [ go ];

    buildPhase = ''
      mkdir $TMPDIR/go
      export GOPATH=$TMPDIR/go
      ${createGoPathCmds}
      go build -v -o bin/serf
    '';

    installPhase = ''
      ensureDir $out/bin
      cp bin/serf $out/bin
    '';

    meta = with stdenv.lib; {
      description = "Serf is a service discovery and orchestration tool that is decentralized, highly available, and fault tolerant";
      homepage = http://www.serfdom.io/;
      license = licenses.mpl20;
      maintainers = [ maintainers.msackman ];
      platforms = platforms.linux;
    };
  }

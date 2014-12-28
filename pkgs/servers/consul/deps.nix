{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/armon/circbuf";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "circbuf";
        rev = "f092b4f207b6e5cce0569056fba9e1a2735cb6cf";
        sha256 = "06kwwdwa3hskdh6ws7clj1vim80dyc3ldim8k9y5qpd30x0avn5s";
      };
    }
    {
      root = "github.com/armon/consul-api";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "consul-api";
        rev = "1b81c8e0c4cbf1d382310e4c0dc11221632e79d1";
        sha256 = "0fgawc1si0hn41kfr9sq351jccy8y5ac83l437vnshj60i9q9s6w";
      };
    }
    {
      root = "github.com/armon/go-metrics";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "go-metrics";
        rev = "2b75159ce5d3641fb35b5a159cff309ac3cf4177";
        sha256 = "1fjsa7r97zlpdzi5l7qvgyabznn5pm6bpwi1rgrwaxh7gc3a28vi";
      };
    }
    {
      root = "github.com/armon/go-radix";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "go-radix";
        rev = "b045fc0ad3587e8620fb42a0dea882cf8c08aef9";
        sha256 = "1p09dwhngaszbr9si68xl1la74i359l0wibhhirpxrc8q4pgjplx";
      };
    }
    {
      root = "github.com/armon/gomdb";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "gomdb";
        rev = "a8e036c4dabe7437014ecf9dbc03c6f6f0766ef8";
        sha256 = "0hiw5qkkyfd22v291w7rbnlrb4kraqzbkjfx2dvl7rqchkb0hv68";
      };
    }
    {
      root = "github.com/hashicorp/consul";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "consul";
        rev = "v0.4.1";
        sha256 = "0fqrhmzi0jbbwylv7c1l0ywqr67aqlv6s891f4inp0y4abd7shc7";
      };
    }
    {
      root = "github.com/hashicorp/go-checkpoint";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-checkpoint";
        rev = "89ef2a697dd8cdb4623097d5bb9acdb19a470767";
        sha256 = "0mfykh9jkh1m2zxlm2df4j5i6hd6iq1kc8afjladdhcqyrkwcch0";
      };
    }
    {
      root = "github.com/hashicorp/go-msgpack";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-msgpack";
        rev = "71c2886f5a673a35f909803f38ece5810165097b";
        sha256 = "157f24xnkhclrjwwa1b7lmpj112ynlbf7g1cfw0c657iqny5720j";
      };
    }
    {
      root = "github.com/hashicorp/go-syslog";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-syslog";
        rev = "ac3963b72ac367e48b1e68a831e62b93fb69091c";
        sha256 = "1r9s1gsa4azcs05gx1179ixk7qvrkrik3v92wr4s8gwm00m0gf81";
      };
    }
    {
      root = "github.com/hashicorp/golang-lru";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "golang-lru";
        rev = "253b2dc1ca8bae42c3b5b6e53dd2eab1a7551116";
        sha256 = "01vdya86x4fylzwapnz6p3wkb8y17sfvbss656sixc37iirrhqr2";
      };
    }
    {
      root = "github.com/hashicorp/hcl";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "hcl";
        rev = "e51eabcdf801f663738fa12f4340fbad13062738";
        sha256 = "09d047lg6py9waqd6zwb0c9id8hya4xv2cg7yi9jbx8kwq31s75l";
      };
    }
    {
      root = "github.com/hashicorp/logutils";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "logutils";
        rev = "23b0af5510a2d1442103ef83ffcf53eb82f3debc";
        sha256 = "018bfknmc2qdk0br1ri6dgd45sx308j3qd77sxnzxsyaivw1mm0d";
      };
    }
    {
      root = "github.com/hashicorp/memberlist";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "memberlist";
        rev = "16d947e2d4b3f1fe508ee1d9b6ec34b8fd2e96d8";
        sha256 = "0xagvyyfl37r0n6s67m1dmrahaxf4gprnfkm12x9jcpp5rbq7jjq";
      };
    }
    {
      root = "github.com/hashicorp/raft";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "raft";
        rev = "cc9710ab540985954a67c108f414aa3152f5916f";
        sha256 = "1v4hib68gaicaqcx3iyclxbp5p3g750rayh8f35sh5fwbklqw1qi";
      };
    }
    {
      root = "github.com/hashicorp/raft-mdb";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "raft-mdb";
        rev = "6f52d0ce62a34e3f5bd29aa4d7068030d700d94a";
        sha256 = "0pchi88ib7nzz6rdc91dpxq1k3q2021m8245v0yqh0ilbvvvyj7i";
      };
    }
    {
      root = "github.com/hashicorp/serf";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "serf";
        rev = "v0.6.3";
        sha256 = "0ck77ji28bvm4ahzxyyi4sm17c3fxc16k0k5mihl1nlkgdd73m8y";
      };
    }
    {
      root = "github.com/hashicorp/terraform";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "terraform";
        rev = "v0.3.1";
        sha256 = "0z6r9dbqrzxaw4b1vbr14ci85jgz6qrq8p36ylcyabzfvwbxrl1m";
      };
    }
    {
      root = "github.com/hashicorp/yamux";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "yamux";
        rev = "9feabe6854fadca1abec9cd3bd2a613fe9a34000";
        sha256 = "03lgbhwhiqk6rivc5cl6zxph5n2pdbdz95h0x7m0ngp3yk3aqgan";
      };
    }
    {
      root = "github.com/inconshreveable/muxado";
      src = fetchFromGitHub {
        owner = "inconshreveable";
        repo = "muxado";
        rev = "f693c7e88ba316d1a0ae3e205e22a01aa3ec2848";
        sha256 = "1vgiwwxhgx9c899f6ikvrs0w6vfsnypzalcqyr0mqm2w816r9hhs";
      };
    }
    {
      root = "github.com/miekg/dns";
      src = fetchFromGitHub {
        owner = "miekg";
        repo = "dns";
        rev = "dc30c7cd4ed2fc8af73d49da4ee285404958b8bd";
        sha256 = "1pqdgjz0qwbbfgya2brsvhj88jp6rmprjwzgjsjnnv9nxwfsbb5s";
      };
    }
    {
      root = "github.com/mitchellh/cli";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "cli";
        rev = "e3c2e3d39391e9beb9660ccd6b4bd9a2f38dd8a0";
        sha256 = "1fwf7wmlhri19bl2yyjd4zlgndgwwqrdry45clpszzjsr8b5wfgm";
      };
    }
    {
      root = "github.com/mitchellh/mapstructure";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "mapstructure";
        rev = "740c764bc6149d3f1806231418adb9f52c11bcbf";
        sha256 = "0rlz93rmz465nr0wmzvq1n58yc0qdw7v1chr6zmj9jj9pix0a7cb";
      };
    }
    {
      root = "github.com/ryanuber/columnize";
      src = fetchFromGitHub {
        owner = "ryanuber";
        repo = "columnize";
        rev = "v2.0.1";
        sha256 = "1h3sxzhiwz65vf3cvclirlf6zhdr97v01dpn5cmf3m09rxxpnp3f";
      };
    }
    {
      root = "github.com/ugorji/go";
      src = fetchFromGitHub {
        owner = "ugorji";
        repo = "go";
        rev = "a7f0616e8cd41d08149bec05c87524abe4e0520e";
        sha256 = "1sxbsvfb46gp6jpb8wy9z6329g2zzbm07xnzml627dsvwdcxvy4q";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}

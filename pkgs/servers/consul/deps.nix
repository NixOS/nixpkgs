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
        rev = "045662de1042be0662fe4a1e21b57c8f7669261a";
        sha256 = "1cdf9mpfa97qwzc0nz0788d97xmwh08dsvqmkmijrdm2a6c07q1r";
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
        rev = "e1d87dee26c05cea64342fadd2a728894b764aec";
        sha256 = "0y05pjvvxlamf74s15pcgv48xyd6116m5lyyd7jkh28lb3l2fykf";
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
        rev = "4dfff096c4973178c8f35cf6dd1a732a0a139370";
        sha256 = "16x78183xzk9bjn7il71l3mff3rqjwc88q9fpbj5i65kvl5ws9di";
      };
    }
    {
      root = "github.com/hashicorp/hcl";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "hcl";
        rev = "9b5d9eb9b09475889ae49a4a613c60280875b3d1";
        sha256 = "02x5by78a3bblzqnhl9dm98wz61h0vkk1wcw7mx6480a7qj5jx3m";
      };
    }
    {
      root = "github.com/hashicorp/logutils";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "logutils";
        rev = "8e0820fe7ac5eb2b01626b1d99df47c5449eb2d8";
        sha256 = "033rbkc066g657r0dnzysigjz2bs4biiz0kmiypd139d34jvslwz";
      };
    }
    {
      root = "github.com/hashicorp/memberlist";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "memberlist";
        rev = "def5afe3702fce72d72922fb44ef2b8e5608b205";
        sha256 = "1ch8c160nkqb79ql59vgpnf9kfq2v38xjrprvfv4hmnpmf6yx6i2";
      };
    }
    {
      root = "github.com/hashicorp/raft";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "raft";
        rev = "35f5fa082f5a064595d84715b0cf8821f002e9ac";
        sha256 = "0s5qhs19n0rxdhsxw77q5sjw4hrkfggxz3w0p3szcd8rsnpfswkg";
      };
    }
    {
      root = "github.com/hashicorp/raft-mdb";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "raft-mdb";
        rev = "95d26447c3c54581de2bb102ecc3344079b234bd";
        sha256 = "1fqf7s2snzbjzxy1k04wdfkqsrxddp6iz72b9hxz9jmgx3l7nl2z";
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
        rev = "v0.2.2";
        sha256 = "05hy9vq8b05nxbmm277ll6p7ncjhxifnqii8y1dralz5x3cw27r3";
      };
    }
    {
      root = "github.com/hashicorp/yamux";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "yamux";
        rev = "35417c7dfab4085d7c921b33e4d5ea6cf9ceef65";
        sha256 = "02pk30dgjmp0zz5g3dcll6lf7izmpfh6fw2rp13al7771vaziqyl";
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
        rev = "5cdb7e11a3f60c88cf2dbce42866e7b42c74b394";
        sha256 = "0glzs9r2i5vrncb3skdl987mdzqj2w86fqr5aj64lqgp7ghwj6hw";
      };
    }
    {
      root = "github.com/mitchellh/cli";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "cli";
        rev = "bfacda5ba006a32b10ddfe2abad56c11661573eb";
        sha256 = "0lzvsya04nh7m804azanhs28vsk4g8knw3yay2yx4wffikbkjbgk";
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
        rev = "e906e395b9d45d3230e800c8ad1f92f99764e753";
        sha256 = "0dqzbxa4ziw10sa5ksl8sfzm0rhrddp6gs732zs9bjkq4rl50j89";
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

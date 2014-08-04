{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "code.google.com/p/go.net";
      src = fetchhg {
        url = "http://code.google.com/p/go.net";
        rev = "134";
        sha256 = "1jycpgrfwgkfac60zjbx6babcz7sgyn9xgy6cr3l811j6k8r2pbv";
      };
    }
    {
      root = "code.google.com/p/go.text";
      src = fetchhg {
        url = "http://code.google.com/p/go.text";
        rev = "85";
        sha256 = "1x8h6vq9g5gbi7iiwla6dkaaqqf7wmkdm4szj7wvzlsijf2x8dwr";
      };
    }
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
      root = "github.com/armon/go-metrics";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "go-metrics";
        rev = "02567bbc4f518a43853d262b651a3c8257c3f141";
        sha256 = "08fk3zmw0ywmdfp2qhrpv0vrk1y97hzqczrgr3y2yip3x8sr37ar";
      };
    }
    {
      root = "github.com/armon/mdns";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "mdns";
        rev = "70462deb060d44247356ee238ebafd7699ddcffe";
        sha256 = "0xkm3d0hsixdm1yrkx9c39723kfjkb3wvrzrmx3np9ylcwn6h5p5";
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
        rev = "17d39b695094be943bfb98442a80b082e6b9ac47";
        sha256 = "0nvgjnwmfqhv2wvr77d2q5mq1bfw4xbpil6wgyj4fyrmhsfzrv3g";
      };
    }
    {
      root = "github.com/hashicorp/serf";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "serf";
        rev = "5e0771b8d61bee28986087a246f7611d6bd4a87a";
        sha256 = "0ck77ji28bvm4ahzxyyi4sm17c3fxc16k0k5mihl1nlkgdd73m8y";
      };
    }
    {
      root = "github.com/miekg/dns";
      src = fetchFromGitHub {
        owner = "miekg";
        repo = "dns";
        rev = "fc67c4b981930a377f8a26a5a1f2c0ccd5dd1514";
        sha256 = "1csjmkx0gl34r4hmkhdbdxb0693f1p10yrjaj8f2jwli9p9sl4mg";
      };
    }
    {
      root = "github.com/mitchellh/cli";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "cli";
        rev = "8262fe3f76f0da53b5674eb35c8c6436430794c3";
        sha256 = "0pqkxh1q49kkxihggrfjs8174d927g4c5qqx00ggw8sqqsgrw6vn";
      };
    }
    {
      root = "github.com/mitchellh/mapstructure";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "mapstructure";
        rev = "6fb2c832bcac61d01212ab1d172f7a14a8585b07";
        sha256 = "0mx855lwhv0rk461wmbnbzbpkhmq5p2ipmrm5bhzimagrr1w17hw";
      };
    }
    {
      root = "github.com/ryanuber/columnize";
      src = fetchFromGitHub {
        owner = "ryanuber";
        repo = "columnize";
        rev = "785d943a7b6886e0bb2f139a60487b823dd8d9de";
        sha256 = "1h3sxzhiwz65vf3cvclirlf6zhdr97v01dpn5cmf3m09rxxpnp3f";
      };
    }
    {
      root = "github.com/ugorji/go";
      src = fetchFromGitHub {
        owner = "ugorji";
        repo = "go";
        rev = "71c2886f5a673a35f909803f38ece5810165097b";
        sha256 = "157f24xnkhclrjwwa1b7lmpj112ynlbf7g1cfw0c657iqny5720j";
      };
    }
    {
      root = "github.com/ugorji/go-msgpack";
      src = fetchFromGitHub {
        owner = "ugorji";
        repo = "go-msgpack";
        rev = "75092644046c5e38257395b86ed26c702dc95b92";
        sha256 = "1bmqi16bfiqw7qhb3d5hbh0dfzhx2bbq1g15nh2pxwxckwh80x98";
      };
    }
    {
      root = "github.com/vmihailenco/bufio";
      src = fetchFromGitHub {
        owner = "vmihailenco";
        repo = "bufio";
        rev = "24e7e48f60fc2d9e99e43c07485d9fff42051e66";
        sha256 = "0x46qnf2f15v7m0j2dcb16raxjamk5rdc7hqwgyxfr1sqmmw3983";
      };
    }
    {
      root = "github.com/vmihailenco/msgpack";
      src = fetchFromGitHub {
        owner = "vmihailenco";
        repo = "msgpack";
        rev = "20c1b88a6c7fc5432037439f4e8c582e236fb205";
        sha256 = "1dj5scpfhgnw0yrh0w6jlrb9d03halvsv4l3wgjhazrrimdqf0q0";
      };
    }
    {
      root = "launchpad.net/gocheck";
      src = fetchbzr {
        url = "https://launchpad.net/gocheck";
        rev = "87";
        sha256 = "1y9fa2mv61if51gpik9isls48idsdz87zkm1p3my7swjdix7fcl0";
      };
    }
    {
      root = "launchpad.net/mgo";
      src = fetchbzr {
        url = "https://launchpad.net/mgo";
        rev = "2";
        sha256 = "0h1dxzyx5c4r4gfnmjxv92hlhjxrgx9p4g53p4fhmz6x2fdglb0x";
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

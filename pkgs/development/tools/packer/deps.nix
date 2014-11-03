{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/mitchellh/packer";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "packer";
        rev = "12e28f257f66299e3bb13a053bf06ccd236e7efd";
        sha256 = "1r5j864kr7lx137c23kk5s82znk11hsrgq98zfz5r8sbzq1xpbzw";
      };
    }
    {
      root = "code.google.com/p/go.crypto";
      src = fetchhg {
        url = "http://code.google.com/p/go.crypto";
        rev = "199";
        sha256 = "0ibrpc6kknzl6a2g2fkxn03mvrd635lcnvf4a9rk1dfrpjbpcixh";
      };
    }
    {
      root = "code.google.com/p/goauth2";
      src = fetchhg {
        url = "http://code.google.com/p/goauth2";
        rev = "67";
        sha256 = "053vajj8hd9869by7z9qfgzn84h6avpcjvyxcyw5jml8dsln4bah";
      };
    }
    {
      root = "code.google.com/p/google-api-go-client";
      src = fetchhg {
        url = "http://code.google.com/p/google-api-go-client";
        rev = "111";
        sha256 = "1ib8i1c2mb86lkrr5w7bgwb70gkqmp860wa3h1j8080gxdx3yy16";
      };
    }
    {
      root = "code.google.com/p/gosshold";
      src = fetchhg {
        url = "http://code.google.com/p/gosshold";
        rev = "2";
        sha256 = "1ljl8pcxxfz5rv89b2ajd31gxxzifl57kzpksvdhyjdxh98gkvg8";
      };
    }
    {
      root = "github.com/ActiveState/tail";
      src = fetchFromGitHub {
        owner = "ActiveState";
        repo = "tail";
        rev = "8dcd1ad3e57aa8ce5614a837cbbdb21945fbb55a";
        sha256 = "1jxj576dd7mawawwg5nzwf6k7sks0r3lp2x8f6kxaps50n3k1wiz";
      };
    }
    {
      root = "github.com/howeyc/fsnotify";
      src = fetchFromGitHub {
        owner = "howeyc";
        repo = "fsnotify";
        rev = "441bbc86b167f3c1f4786afae9931403b99fdacf";
        sha256 = "1v5vrwhmidxjj6sppinyizf85v60zrmn7i6c9xk0pvx6k0kw2mr2";
      };
    }
    {
      root = "launchpad.net/tomb";
      src = fetchbzr {
        url = "https://launchpad.net/tomb";
        rev = "17";
        sha256 = "1cjw0sr9hald1darq6n8akfpkzcgrk3mcq59hga3ibf2lrg35ha0";
      };
    }
    {
      root = "github.com/going/toolkit";
      src = fetchFromGitHub {
        owner = "going";
        repo = "toolkit";
        rev = "6185c1893604d52d36a97dd6bb1247ace93a9b80";
        sha256 = "1kzy5yppalcidsmv5yxmr6lpqplqj07kdqpn77fdp6fbb0y0sg11";
      };
    }
    {
      root = "code.google.com/p/goprotobuf";
      src = fetchhg {
        url = "http://code.google.com/p/goprotobuf";
        rev = "246";
        sha256 = "0k4wcv1dnkwcp0gdrajj6kr25f1lg4lgpbi0h5v9l9n7sdwzplf4";
      };
    }
    {
      root = "github.com/bmizerany/assert";
      src = fetchFromGitHub {
        owner = "bmizerany";
        repo = "assert";
        rev = "e17e99893cb6509f428e1728281c2ad60a6b31e3";
        sha256 = "1lfrvqqmb09y6pcr76yjv4r84cshkd4s7fpmiy7268kfi2cvqnpc";
      };
    }
    {
      root = "github.com/kr/pretty";
      src = fetchFromGitHub {
        owner = "kr";
        repo = "pretty";
        rev = "bc9499caa0f45ee5edb2f0209fbd61fbf3d9018f";
        sha256 = "1m61y592qsnwsqn76v54mm6h2pcvh4wlzbzscc1ag645x0j33vvl";
      };
    }
    {
      root = "github.com/kr/text";
      src = fetchFromGitHub {
        owner = "kr";
        repo = "text";
        rev = "6807e777504f54ad073ecef66747de158294b639";
        sha256 = "1wkszsg08zar3wgspl9sc8bdsngiwdqmg3ws4y0bh02sjx5a4698";
      };
    }
    {
      root = "github.com/kr/pty";
      src = fetchFromGitHub {
        owner = "kr";
        repo = "pty";
        rev = "67e2db24c831afa6c64fc17b4a143390674365ef";
        sha256 = "1l3z3wbb112ar9br44m8g838z0pq2gfxcp5s3ka0xvm1hjvanw2d";
      };
    }
    {
      root = "github.com/xiocode/toolkit";
      src = fetchFromGitHub {
        owner = "xiocode";
        repo = "toolkit";
        rev = "352fd7c6700074a81056cdfc9e82b3e8c5681ac5";
        sha256 = "0p33zh57xpxyk2wyp9xahdxyrkq48ysihpr0n9kj713q0dh7x4a3";
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
      root = "github.com/hashicorp/go-version";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-version";
        rev = "bb92dddfa9792e738a631f04ada52858a139bcf7";
        sha256 = "0fl5a6j6nk1xsxwjdpa24a24fxvgnvm3jjlgpyrnmbdn380zil3m";
      };
    }
    {
      root = "github.com/mitchellh/go-fs";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "go-fs";
        rev = "faaa223588dd7005e49bf66fa2d19e35c8c4d761";
        sha256 = "19jsvy35g14f18ckymzxasy0zfd6n99zlqg6grpj1yqdfxfvqn9b";
      };
    }
    {
      root = "github.com/mitchellh/go-vnc";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "go-vnc";
        rev = "fc93dd80f5da4ccde0a9d97f0c73e56e04e0cf72";
        sha256 = "03rwsp1frvfx6c7yxr711lq7jdgsr1gcwg14jw26xvbzzxwjvnsf";
      };
    }
    {
      root = "github.com/mitchellh/goamz";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "goamz";
        rev = "c3ff5f734c89f1ea1f290c6aadbbceeeb19a623c";
        sha256 = "1nyi1p5yh21r161icnwkcgmj2y38b4m1jis47vvjbqinrp45w1gq";
      };
    }
    {
      root = "github.com/motain/gocheck";
      src = fetchFromGitHub {
        owner = "motain";
        repo = "gocheck";
        rev = "9beb271d26e640863a5bf4a3c5ea40ccdd466b84";
        sha256 = "07arpwfdb51b5f7kzqnm5s5ndfmxv5j793hpn30nbdcya46diwjd";
      };
    }
    {
      root = "github.com/mitchellh/iochan";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "iochan";
        rev = "b584a329b193e206025682ae6c10cdbe03b0cd77";
        sha256 = "1fcwdhfci41ibpng2j4c1bqfng578cwzb3c00yw1lnbwwhaq9r6b";
      };
    }
    {
      root = "github.com/mitchellh/mapstructure";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "mapstructure";
        rev = "743fcf103ac7cdbc159e540d9d0e3a7889b87d68";
        sha256 = "1qqxsnxabd7c04n0ip1wmpr2g913qchqrbmblq0shrf5p1hnszgn";
      };
    }
    {
      root = "github.com/mitchellh/multistep";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "multistep";
        rev = "162146fc57112954184d90266f4733e900ed05a5";
        sha256 = "0ydhbxziy9204qr43pjdh88y2jg34g2mhzdapjyfpf8a1rin6dn3";
      };
    }
    {
      root = "github.com/mitchellh/osext";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "osext";
        rev = "0dd3f918b21bec95ace9dc86c7e70266cfc5c702";
        sha256 = "02pczqml6p1mnfdrygm3rs02g0r65qx8v1bi3x24dx8wv9dr5y23";
      };
    }
    {
      root = "github.com/mitchellh/panicwrap";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "panicwrap";
        rev = "1aedff2aaa8b8ff7f65ab58e94ef9f593e2e3bf4";
        sha256 = "05brbpc7kizzbs1a128fmjddh7rdyg0jzzxgbvrl58cgklh4yzaa";
      };
    }
    {
      root = "github.com/rackspace/gophercloud";
      src = fetchFromGitHub {
        owner = "rackspace";
        repo = "gophercloud";
        rev = "2285a429874c1365ef6c6d3ceb08b1d428e26aca";
        sha256 = "0py3h64r4wkl2r9j7xlh81nazpg2b0r5ba9iblh6d1380yk4fa7f";
      };
    }
    {
      root = "github.com/racker/perigee";
      src = fetchFromGitHub {
        owner = "racker";
        repo = "perigee";
        rev = "01db3191866051f2ec854c2d876ac1a179d3049c";
        sha256 = "05pmlgwjynbr59bw50zhrklzhr5pgnij9ym5hqvijjrpw3qd9ivf";
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
      root = "github.com/vmihailenco/msgpack";
      src = fetchFromGitHub {
        owner = "vmihailenco";
        repo = "msgpack";
        rev = "20c1b88a6c7fc5432037439f4e8c582e236fb205";
        sha256 = "1dj5scpfhgnw0yrh0w6jlrb9d03halvsv4l3wgjhazrrimdqf0q0";
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
      root = "launchpad.net/mgo";
      src = fetchbzr {
        url = "https://launchpad.net/mgo";
        rev = "2";
        sha256 = "0h1dxzyx5c4r4gfnmjxv92hlhjxrgx9p4g53p4fhmz6x2fdglb0x";
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

{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/mitchellh/packer";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "packer";
        rev = "3006be43766b0b538e10d1e355344d7996eeebfb";
        sha256 = "0lkf2y5znic63b8f8qpgm3gsqhxxafk7aky5m9i8sr83508i5xxv";
      };
    }
    {
      root = "code.google.com/p/go.crypto";
      src = fetchhg {
        url = "http://code.google.com/p/go.crypto";
        rev = "6e881b5273dfffbadb6a76a61d3c39a71e3588d1";
        sha256 = "0ibrpc6kknzl6a2g2fkxn03mvrd635lcnvf4a9rk1dfrpjbpcixh";
      };
    }
    {
      root = "code.google.com/p/goauth2";
      src = fetchhg {
        url = "http://code.google.com/p/goauth2";
        rev = "afe77d958c701557ec5dc56f6936fcc194d15520";
        sha256 = "053vajj8hd9869by7z9qfgzn84h6avpcjvyxcyw5jml8dsln4bah";
      };
    }
    {
      root = "code.google.com/p/google-api-go-client";
      src = fetchhg {
        url = "http://code.google.com/p/google-api-go-client";
        rev = "e1c259484b495133836706f46319f5897f1e9bf6";
        sha256 = "1ib8i1c2mb86lkrr5w7bgwb70gkqmp860wa3h1j8080gxdx3yy16";
      };
    }
    {
      root = "code.google.com/p/gosshold";
      src = fetchhg {
        url = "http://code.google.com/p/gosshold";
        rev = "9dd3b6b6e7b3e1b7f30c2b58c5ec5fff6bf9feff";
        sha256 = "1ljl8pcxxfz5rv89b2ajd31gxxzifl57kzpksvdhyjdxh98gkvg8";
      };
    }
    {
      root = "github.com/ActiveState/tail";
      src = fetchFromGitHub {
        owner = "ActiveState";
        repo = "tail";
        rev = "fd3ba4e64ca930fe21edc4c8a8bd1a075ef7f4ac";
        sha256 = "0fjaxwxbb74x3nwk5d6ki42b196yp8w661scs6w4pn2s0kkh96a2";
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
      root = "github.com/hashicorp/yamux";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "yamux";
        rev = "35417c7dfab4085d7c921b33e4d5ea6cf9ceef65";
        sha256 = "02pk30dgjmp0zz5g3dcll6lf7izmpfh6fw2rp13al7771vaziqyl";
      };
    }
    {
      root = "github.com/howeyc/fsnotify";
      src = fetchFromGitHub {
        owner = "howeyc";
        repo = "fsnotify";
        rev = "6b1ef893dc11e0447abda6da20a5203481878dda";
        sha256 = "0s0cs12g7l5xwi555k52jxgz43x7y1pvy9j21qsa2qxxs1d12zv0";
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
        rev = "6dc85cb578f710cbbb84e7f50eb3cfcc49dbf3ba";
        sha256 = "1irlzrqv8q146bhy550326jx52ab4f0v8ypm8pbrmcbffpq8g3lb";
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
        rev = "740c764bc6149d3f1806231418adb9f52c11bcbf";
        sha256 = "0rlz93rmz465nr0wmzvq1n58yc0qdw7v1chr6zmj9jj9pix0a7cb";
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
        rev = "45cbfd3bae250c7676c077fb275be1a2968e066a";
        sha256 = "0mbha0nz6zcgp2pny2x03chq1igf9ylpz55xxq8z8g2jl6cxaghn";
      };
    }
    {
      root = "github.com/rackspace/gophercloud";
      src = fetchFromGitHub {
        owner = "rackspace";
        repo = "gophercloud";
        rev = "e13cda260ce48d63ce816f4fa72b6c6cd096596d";
        sha256 = "1bmg9yg36kkqqrnh3dlqkgk6gihfmq48yga9z9y58xnxs2mv1r6v";
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
      root = "github.com/tonnerre/golang-pretty";
      src = fetchFromGitHub {
        owner = "tonnerre";
        repo = "golang-pretty";
        rev = "e7fccc03e91bad289b96c21aa3312a220689bdd7";
        sha256 = "1hq36dgd7zpkqqwgx67pw34pig6yihjgzjha278f9x0l85xr9p8n";
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
    {
      root = "github.com/vaughan0/go-ini";
      src = fetchFromGitHub {
        owner = "vaughan0";
        repo = "go-ini";
        rev = "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1";
        sha256 = "1l1isi3czis009d9k5awsj4xdxgbxn4n9yqjc1ac7f724x6jacfa";
      };
    }
    {
      root = "gopkg.in/tomb.v1";
      src = fetchFromGitHub {
        owner = "go-tomb";
        repo = "tomb";
        rev = "c131134a1947e9afd9cecfe11f4c6dff0732ae58";
        sha256 = "1pi79071qdlm40m2lab0jis54nc3vwi37wz5rb57jz4gqc7bahn6";
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

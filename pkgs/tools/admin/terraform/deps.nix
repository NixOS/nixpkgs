{ stdenv, lib, fetchFromGitHub, fetchgit }:

let
  goDeps = [
    {
      goPackagePath = "github.com/hashicorp/atlas-go";
      src = fetchFromGitHub {
        rev = "6a87d5f443991e9916104392cd5fc77678843e1d";
        owner = "hashicorp";
        repo = "atlas-go";
        sha256 = "1c041nwqxzyp65mpa17gpwi84l78vy3xp7ijdpz0m7qf2za55wj1";
      };
    }
    {
      goPackagePath = "github.com/vaughan0/go-ini";
      src = fetchFromGitHub {
        rev = "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1";
        owner = "vaughan0";
        repo = "go-ini";
        sha256 = "1l1isi3czis009d9k5awsj4xdxgbxn4n9yqjc1ac7f724x6jacfa";
      };
    }
    {
      goPackagePath = "github.com/awslabs/aws-sdk-go";
      src = fetchFromGitHub {
        rev = "24d1eef417392c6e30f730b268719a320eec3075";
        owner = "awslabs";
        repo = "aws-sdk-go";
        sha256 = "1qvnllpgm9bj0qhl7d2ffycm5y3pnhhf6ydw3d78zid9zs5hl09h";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/terraform";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "terraform";
        rev = "v0.5.0";
        sha256 = "1qf33dx8vzqpijqxhicjpmyjbv30vycd3b39kkjh7w3b439cn0da";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/consul"; 
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "consul";
        rev = "v0.5.0";
        sha256 = "1xw7jbpxhf897iq3xc1j1cccj6qhfv8abzsck37zk2mfnq721wvr";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/errwrap"; 
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "errwrap";
        rev = "7554cd9344cec97297fa6649b055a8c98c2a1e55";
        sha256 = "0kmv0p605di6jc8i1778qzass18m0mv9ks9vxxrfsiwcp4la82jf";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-checkpoint"; 
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-checkpoint";
        rev = "88326f6851319068e7b34981032128c0b1a6524d";
        sha256 = "1npasn9lmvx57nw3wkswwvl5k0wmn01jpalbwv832x5wq4r0nsz4";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-multierror"; 
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-multierror";
        rev = "fcdddc395df1ddf4247c69bd436e84cfa0733f7e";
        sha256 = "1gvrm2bqi425mfg55m01z9gppfd7v4ljz1z8bykmh2sc82fj25jz";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-version"; 
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-version";
        rev = "bb92dddfa9792e738a631f04ada52858a139bcf7";
        sha256 = "0fl5a6j6nk1xsxwjdpa24a24fxvgnvm3jjlgpyrnmbdn380zil3m";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/hcl"; 
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "hcl";
        rev = "513e04c400ee2e81e97f5e011c08fb42c6f69b84";
        sha256 = "041js0k8bj7qsgr79p207m6r3nkpw7839gq31747618sap6w3g8c";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/yamux"; 
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "yamux";
        rev = "b2e55852ddaf823a85c67f798080eb7d08acd71d";
        sha256 = "0mr87my5m8lgc0byjcddlclxg34d07cpi9p78ps3rhzq7p37g533";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/cli"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "cli";
        rev = "6cc8bc522243675a2882b81662b0b0d2e04b99c9";
        sha256 = "05w9ypliva9lyn3h4rahznj04mh0fws7vaqlwhxfs5nnd5g03dma";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/colorstring"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "colorstring";
        rev = "61164e49940b423ba1f12ddbdf01632ac793e5e9";
        sha256 = "19dkdg8hp49x76ygn0y1am1mgbs7xvlcwllfdmqiaxqspf3dj631";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/copystructure"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "copystructure";
        rev = "6fc66267e9da7d155a9d3bd489e00dad02666dc6";
        sha256 = "193s5vhw68d8npjyf5yvc5j24crazvy7d5dk316hl7590qrmbxrd";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/go-homedir"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "go-homedir";
        rev = "1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4";
        sha256 = "1l5lrsjrnwxn299mhvyxvz8hd0spkx0d31gszm4cyx21bg1xsiy9";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/mapstructure"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "mapstructure";
        rev = "442e588f213303bec7936deba67901f8fc8f18b1";
        sha256 = "076svhy5jlnw4jykm3dsrx2dswifajrpr7d09mz9y6g3lg901rqd";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/osext"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "osext";
        rev = "0dd3f918b21bec95ace9dc86c7e70266cfc5c702";
        sha256 = "02pczqml6p1mnfdrygm3rs02g0r65qx8v1bi3x24dx8wv9dr5y23";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/panicwrap"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "panicwrap";
        rev = "45cbfd3bae250c7676c077fb275be1a2968e066a";
        sha256 = "0mbha0nz6zcgp2pny2x03chq1igf9ylpz55xxq8z8g2jl6cxaghn";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/prefixedio"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "prefixedio";
        rev = "89d9b535996bf0a185f85b59578f2e245f9e1724";
        sha256 = "0lc64rlizb412msd32am2fixkh0536pjv7czvgyw5fskn9kgk3y2";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/reflectwalk"; 
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "reflectwalk";
        rev = "242be0c275dedfba00a616563e6db75ab8f279ec";
        sha256 = "0xjyjs7ci7yaslk0rcgdw99ys2kq0p14cx6c90pmdzl0m9pcc9v4";
      };
    }
    {
      goPackagePath = "golang.org/x/crypto";
      src = fetchgit {
        url = "https://go.googlesource.com/crypto";
        rev = "74f810a0152f4c50a16195f6b9ff44afc35594e8";
        sha256 = "14ybzq08jxba2qyhjn1bzkh70fnb3aba2qnldxapzgwyy22dkg54";
      };
    }

  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.goPackagePath}`
              ln -s ${dep.src} $out/src/${dep.goPackagePath}
            '') goDeps);
}


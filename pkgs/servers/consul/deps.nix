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
        rev = "dcfedd50ed5334f96adee43fc88518a4f095e15c";
        sha256 = "1k3yl34j4d8y6xxqdm70pjrbdcnp11dbf8i1mp60480xg0cwpb6d";
      };
    }
    {
      root = "github.com/armon/go-metrics";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "go-metrics";
        rev = "88b7658f24511c4b885942b26e9ea7a61ee37ebc";
        sha256 = "18f7nr6khirdmcsy5mic1yggwc189wfiqvms8i7yfcvfns5nq9cc";
      };
    }
    {
      root = "github.com/armon/go-radix";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "go-radix";
        rev = "e39d623f12e8e41c7b5529e9a9dd67a1e2261f80";
        sha256 = "10vhgr35dfbsm90q8aqp82vhdf4izqrx8bzzgn0h3vrx94c2pnq1";
      };
    }
    {
      root = "github.com/armon/gomdb";
      src = fetchFromGitHub {
        owner = "armon";
        repo = "gomdb";
        rev = "151f2e08ef45cb0e57d694b2562f351955dff572";
        sha256 = "02wdhgfarmmwfbc75snd1dh6p9k9c1y2135apdm6mkr062qlxx61";
      };
    }
    {
      root = "github.com/golang/protobuf";
      src = fetchFromGitHub {
        owner = "golang";
        repo = "protobuf";
        rev = "c22ae3cf020a21ebb7ae566dccbe90fc8ea4f9ea";
        sha256 = "1ab605jw0cprq0kbp0b5iyjw805wk08r3p9mvcyland7v4gfqys2";
      };
    }
    {
      root = "github.com/hashicorp/consul";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "consul";
        rev = "a022dfcb32246274adc8fb383882353c056d1da3";
        sha256 = "1al6bc62c8qygq4yhr8rq9jkx51ijv11816kipphylw73kyyrzg5";
      };
    }
    {
      root = "github.com/hashicorp/go-multierror";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-multierror";
        rev = "fcdddc395df1ddf4247c69bd436e84cfa0733f7e";
        sha256 = "1gvrm2bqi425mfg55m01z9gppfd7v4ljz1z8bykmh2sc82fj25jz";
      };
    }
    {
      root = "github.com/hashicorp/consul-template";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "consul-template";
        rev = "v0.7.0";
        sha256 = "0xaym2mi8j3hw1waplhqfypnxv32fi81xxx3clfzk0a6bjmaihfx";
      };
    }
    {
      root = "github.com/hashicorp/go-checkpoint";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "go-checkpoint";
        rev = "88326f6851319068e7b34981032128c0b1a6524d";
        sha256 = "1npasn9lmvx57nw3wkswwvl5k0wmn01jpalbwv832x5wq4r0nsz4";
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
        rev = "42a2b573b664dbf281bd48c3cc12c086b17a39ba";
        sha256 = "1j53m2wjyczm9m55znfycdvm4c8vfniqgk93dvzwy8vpj5gm6sb3";
      };
    }
    {
      root = "github.com/hashicorp/golang-lru";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "golang-lru";
        rev = "f09f965649501e2ac1b0c310c632a7bebdbdc1d4";
        sha256 = "0yjnmk2d2x0kqvkg1sdfkl3jr408yl76rpyqzkkbpkvdcjrz554c";
      };
    }
    {
      root = "github.com/hashicorp/hcl";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "hcl";
        rev = "513e04c400ee2e81e97f5e011c08fb42c6f69b84";
        sha256 = "041js0k8bj7qsgr79p207m6r3nkpw7839gq31747618sap6w3g8c";
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
        rev = "3d05e25e06bbb9e2b0e0afbd0b1c7dcebdd29cab";
        sha256 = "1pjknjfvbs692y6laizgd4fmd4pqn039vvnmnag7q362mrpf5aj4";
      };
    }
    {
      root = "github.com/hashicorp/net-rpc-msgpackrpc";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "net-rpc-msgpackrpc";
        rev = "d377902b7aba83dd3895837b902f6cf3f71edcb2";
        sha256 = "05q8qlf42ygafcp8zdyx7y7kv9vpjrxnp8ak4qcszz9kgl2cg969";
      };
    }
    {
      root = "github.com/hashicorp/raft";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "raft";
        rev = "a88bfa8385bc52c1f25d0fc02d1b55a2708d04ab";
        sha256 = "02kr7919m6iv7l26wnihalfi4lydz886j6x75a53vgchdcsbv7ai";
      };
    }
    {
      root = "github.com/hashicorp/raft-mdb";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "raft-mdb";
        rev = "4ec3694ffbc74d34f7532e70ef2e9c3546a0c0b0";
        sha256 = "15l4n6zygwn3h118m2945h9jxkryaxxcgy8xij2rxjhzrzpfyj3i";
      };
    }
    {
      root = "github.com/hashicorp/scada-client";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "scada-client";
        rev = "c26580cfe35393f6f4bf1b9ba55e6afe33176bae";
        sha256 = "0s8xg49fa7d2d0vv8pi37f43rjrgkb7w6x6ydkikz1v8ccg05p3b";
      };
    }
    {
      root = "github.com/hashicorp/serf";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "serf";
        rev = "f1fd5030d6a55d3edc6916d2ba58e933c21314de";
        sha256 = "0w84iw255aray7acasacwn8njm36aqbxiyalnjqwfsn0pwfjla0b";
      };
    }
    {
      root = "github.com/hashicorp/terraform";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "terraform";
        rev = "v0.3.7";
        sha256 = "04cs6sjwysg95l5cfsmnpnx3d126bv86qbkg91gj8h98knk5bs6z";
      };
    }
    {
      root = "github.com/hashicorp/yamux";
      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "yamux";
        rev = "b4f943b3f25da97dec8e26bee1c3269019de070d";
        sha256 = "18ivpiix006f0g085a11gra8z0n6bq344rrgc5rphn7nmnghqchz";
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
      root = "github.com/matttproud/golang_protobuf_extensions";
      src = fetchFromGitHub {
        owner = "matttproud";
        repo = "golang_protobuf_extensions";
        rev = "ba7d65ac66e9da93a714ca18f6d1bc7a0c09100c";
        sha256 = "1vz6zj94v90x8mv9h6qfp1211kmzn60ri5qh7p9fzpjkhga5k936";
      };
    }
    {
      root = "github.com/miekg/dns";
      src = fetchFromGitHub {
        owner = "miekg";
        repo = "dns";
        rev = "6427527bba3ea8fdf2b56fba43d20d1e3e76336d";
        sha256 = "1zszpn44kak4cs5lmy9i7sslizqngldgb0ixn0la9x9gxf16h9zn";
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
        rev = "442e588f213303bec7936deba67901f8fc8f18b1";
        sha256 = "076svhy5jlnw4jykm3dsrx2dswifajrpr7d09mz9y6g3lg901rqd";
      };
    }
    {
      root = "github.com/prometheus/client_golang";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "client_golang";
        rev = "0.2.0";
        sha256 = "0iq2hlmdazwmpjq2k9gvpv2zprzxzmyzsc89c2kalrwl52ksg250";
      };
    }
    {
      root = "github.com/prometheus/client_model";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "client_model";
        rev = "fa8ad6fec33561be4280a8f0514318c79d7f6cb6";
        sha256 = "11a7v1fjzhhwsl128znjcf5v7v6129xjgkdpym2lial4lac1dhm9";
      };
    }
    {
      root = "github.com/prometheus/procfs";
      src = fetchFromGitHub {
        owner = "prometheus";
        repo = "procfs";
        rev = "6c34ef819e19b4e16f410100ace4aa006f0e3bf8";
        sha256 = "1n48jhx50bhnjznxds4nmz04digbbbbjq3hkvvl29js1grylda0i";
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
        rev = "c8676e5e9db1226325ca0ed7771633fb0109878b";
        sha256 = "18r1iajmc9a461kx0pz3lpv91lzlfg93cjw0k0j7ffk6901m0084";
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

{ stdenv, lib, gox, gotools, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "packer-0.12.1";
  version = "0.12.1";
  rev = "002e678f09aa9ba3930ec21ce37a30648ee7910e";

  buildInputs = [ gox gotools ];

  goPackagePath = "github.com/mitchellh/packer";

  src = fetchgit {
    url = "https://github.com/mitchellh/packer";
    rev = "002e678f09aa9ba3930ec21ce37a30648ee7910e";
    sha256 = "05wd8xf4nahpg96wzligk5av10p0xd2msnb3imk67qgbffrlvmvi";
  };

  extraSrcs = [
    {
      goPackagePath = "github.com/1and1/oneandone-cloudserver-sdk-go";

      src = fetchgit {
        url = "https://github.com/1and1/oneandone-cloudserver-sdk-go";
        rev = "5678f03fc801525df794f953aa82f5ad7555a2ef";
        sha256 = "0280l44jkib5xd3xfy8spibxdm4wpghd1xz9kxbf8k8fr0dqb1ry";
      };
    }
    {
      goPackagePath = "github.com/approvals/go-approval-tests";

      src = fetchgit {
        url = "https://github.com/approvals/go-approval-tests";
        rev = "ad96e53bea43a905c17beeb983a0f9ce087dc48d";
        sha256 = "05jncnjmrymx456lk70fn3yk5c9mq19jmjsm3kza6khyhf9yxpyy";
      };
    }
    {
      goPackagePath = "github.com/armon/go-radix";

      src = fetchgit {
        url = "https://github.com/armon/go-radix";
        rev = "4239b77079c7b5d1243b7b4736304ce8ddb6f0f2";
        sha256 = "0rn45qxi1jlapb0nwa05xbr3g9q9ni3hv6x1pfnh0xdjs08mxsj8";
      };
    }
    {
      goPackagePath = "github.com/aws/aws-sdk-go";

      src = fetchgit {
        url = "https://github.com/aws/aws-sdk-go";
        rev = "6ac30507cca29249f4d49af45a8efc98b84088ee";
        sha256 = "08pwzjsfqphalgzlr2m710hkznxigfs6djkqbyn12agj1jph47j5";
      };
    }
    {
      goPackagePath = "github.com/Azure/azure-sdk-for-go";

      src = fetchgit {
        url = "https://github.com/Azure/azure-sdk-for-go";
        rev = "902d95d9f311ae585ee98cfd18f418b467d60d5a";
        sha256 = "0n4pljvm7gvdv5qs30hgyyfx5bx48gaaxqjnx7vsdwk8r3mznhww";
      };
    }
    {
      goPackagePath = "github.com/Azure/go-autorest";

      src = fetchgit {
        url = "https://github.com/Azure/go-autorest";
        rev = "6f40a8acfe03270d792cb8155e2942c09d7cff95";
        sha256 = "15i20rs5d8dvii2wq6ij2ljpgllv1rabkkjchf0s0ayviz2mcslq";
      };
    }
    {
      goPackagePath = "github.com/Azure/go-ntlmssp";

      src = fetchgit {
        url = "https://github.com/Azure/go-ntlmssp";
        rev = "e0b63eb299a769ea4b04dadfe530f6074b277afb";
        sha256 = "19bn9ds12cyf8y3w5brnxwg8lwdkg16ww9hmnq14y2kmli42l14m";
      };
    }
    {
      goPackagePath = "github.com/bgentry/speakeasy";

      src = fetchgit {
        url = "https://github.com/bgentry/speakeasy";
        rev = "36e9cfdd690967f4f690c6edcc9ffacd006014a0";
        sha256 = "1gv69wvy17ggaydr3xdnnc0amys70wcmjhjj1xz2bj0kxi7yf8yf";
      };
    }
    {
      goPackagePath = "github.com/biogo/hts";

      src = fetchgit {
        url = "https://github.com/biogo/hts";
        rev = "50da7d4131a3b5c9d063932461cab4d1fafb20b0";
        sha256 = "15mfvwddigrcdxqmqrma8fx0glp96fvlk0q0vcwhbl50i3517vnw";
      };
    }
    {
      goPackagePath = "github.com/davecgh/go-spew";

      src = fetchgit {
        url = "https://github.com/davecgh/go-spew";
        rev = "6d212800a42e8ab5c146b8ace3490ee17e5225f9";
        sha256 = "01i0n1s4j7khb7n6mz2wymniz37q0vbzkgfv7rbi6p9hpg227q93";
      };
    }
    {
      goPackagePath = "github.com/dgrijalva/jwt-go";

      src = fetchgit {
        url = "https://github.com/dgrijalva/jwt-go";
        rev = "d2709f9f1f31ebcda9651b03077758c1f3a0018c";
        sha256 = "02zhyimshzfzp3by2lggm2z382j4pvbrbcxx9p1wqmmmwy5yz182";
      };
    }
    {
      goPackagePath = "github.com/digitalocean/godo";

      src = fetchgit {
        url = "https://github.com/digitalocean/godo";
        rev = "6ca5b770f203b82a0fca68d0941736458efa8a4f";
        sha256 = "00di15gdv47jfdr1l8cqphmlv5bzalxk7dk53g3mif7vwhs8749j";
      };
    }
    {
      goPackagePath = "github.com/dylanmei/iso8601";

      src = fetchgit {
        url = "https://github.com/dylanmei/iso8601";
        rev = "2075bf119b58e5576c6ed9f867b8f3d17f2e54d4";
        sha256 = "0px5aq4w96yyjii586h3049xm7rvw5r8w7ph3axhyismrqddqgx1";
      };
    }
    {
      goPackagePath = "github.com/dylanmei/winrmtest";

      src = fetchgit {
        url = "https://github.com/dylanmei/winrmtest";
        rev = "025617847eb2cf9bd1d851bc3b22ed28e6245ce5";
        sha256 = "1i0wq6r1vm3nhnia3ycm5l590gyia7cwh6971ppnn4rrdmvsw2qh";
      };
    }
    {
      goPackagePath = "github.com/go-ini/ini";

      src = fetchgit {
        url = "https://github.com/go-ini/ini";
        rev = "afbd495e5aaea13597b5e14fe514ddeaa4d76fc3";
        sha256 = "0xi8zr9qw38sdbv95c2ip31yczbm4axdvmj3ljyivn9xh2nbxfia";
      };
    }
    {
      goPackagePath = "github.com/golang/protobuf";

      src = fetchgit {
        url = "https://github.com/golang/protobuf";
        rev = "b982704f8bb716bb608144408cff30e15fbde841";
        sha256 = "0wm0kqsibk7g4rvn86mlm1d8h220hbz8xrdx4k0jxrzsz86jjbdp";
      };
    }
    {
      goPackagePath = "github.com/google/go-querystring";

      src = fetchgit {
        url = "https://github.com/google/go-querystring";
        rev = "2a60fc2ba6c19de80291203597d752e9ba58e4c0";
        sha256 = "0raf6r3dd8rxxppzrbhp1y6k5csgfkfs7b0jylj65sbg0hbzxvbr";
      };
    }
    {
      goPackagePath = "github.com/google/shlex";

      src = fetchgit {
        url = "https://github.com/google/shlex";
        rev = "6f45313302b9c56850fc17f99e40caebce98c716";
        sha256 = "0ybz1w3hndma8myq3pxan36533hy9f4w598hsv4hnj21l4br8jpx";
      };
    }
    {
      goPackagePath = "github.com/gophercloud/gophercloud";

      src = fetchgit {
        url = "https://github.com/gophercloud/gophercloud";
        rev = "d5eda9707e146108e4d424062b602fd97a71c2e6";
        sha256 = "04lllgh52x4s2j6sp4fql927cd3pf9klhi8lfkralg0fpd1rhmqw";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/atlas-go";

      src = fetchgit {
        url = "https://github.com/hashicorp/atlas-go";
        rev = "1792bd8de119ba49b17fd8d3c3c1f488ec613e62";
        sha256 = "1anh89y9413sl0yazg5l0q3y3prqvzydr8qwmdysc2cs62p1k71d";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/errwrap";

      src = fetchgit {
        url = "https://github.com/hashicorp/errwrap";
        rev = "7554cd9344cec97297fa6649b055a8c98c2a1e55";
        sha256 = "0kmv0p605di6jc8i1778qzass18m0mv9ks9vxxrfsiwcp4la82jf";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-checkpoint";

      src = fetchgit {
        url = "https://github.com/hashicorp/go-checkpoint";
        rev = "e4b2dc34c0f698ee04750bf2035d8b9384233e1b";
        sha256 = "0qjfk1fh5zmn04yzxn98zam8j4ay5mzd5kryazqj01hh7szd0sh5";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-cleanhttp";

      src = fetchgit {
        url = "https://github.com/hashicorp/go-cleanhttp";
        rev = "875fb671b3ddc66f8e2f0acc33829c8cb989a38d";
        sha256 = "0ammv6gn9cmh6padaaw76wa6xvg22a9b3sw078v9chcvfk2bggha";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-multierror";

      src = fetchgit {
        url = "https://github.com/hashicorp/go-multierror";
        rev = "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5";
        sha256 = "0dc02mvv11hvanh12nhw8jsislnxf6i4gkh6vcil0x23kj00z3iz";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-rootcerts";

      src = fetchgit {
        url = "https://github.com/hashicorp/go-rootcerts";
        rev = "6bb64b370b90e7ef1fa532be9e591a81c3493e00";
        sha256 = "1a81fcm1i0ji2iva0dcimiichgwpbcb7lx0vyaks87zj5wf04qy9";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-uuid";

      src = fetchgit {
        url = "https://github.com/hashicorp/go-uuid";
        rev = "73d19cdc2bf00788cc25f7d5fd74347d48ada9ac";
        sha256 = "0myc3pcdafilcvj0k82q8axf4m2s5205ligg6kc70g1xfh0lz6lq";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/go-version";

      src = fetchgit {
        url = "https://github.com/hashicorp/go-version";
        rev = "7e3c02b30806fa5779d3bdfc152ce4c6f40e7b38";
        sha256 = "0ibqaq6z02himzci4krbfhqdi8fw2gzj9a8z375nl3qbzdgzqnm7";
      };
    }
    {
      goPackagePath = "github.com/hashicorp/yamux";

      src = fetchgit {
        url = "https://github.com/hashicorp/yamux";
        rev = "df949784da9ed028ee76df44652e42d37a09d7e4";
        sha256 = "0mavyqm3wvxpbiyap79vh3j4yksfy4g7p3vwyr7ha5kcav1918x4";
      };
    }
    {
      goPackagePath = "github.com/jmespath/go-jmespath";

      src = fetchgit {
        url = "https://github.com/jmespath/go-jmespath";
        rev = "c01cf91b011868172fdcd9f41838e80c9d716264";
        sha256 = "0gfrqwl648qngp77g8m1g9g7difggq2cac4ydjw9bpx4bd7mw1rw";
      };
    }
    {
      goPackagePath = "github.com/kardianos/osext";

      src = fetchgit {
        url = "https://github.com/kardianos/osext";
        rev = "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc";
        sha256 = "1mawalaz84i16njkz6f9fd5jxhcbxkbsjnav3cmqq2dncv2hyv8a";
      };
    }
    {
      goPackagePath = "github.com/klauspost/compress";

      src = fetchgit {
        url = "https://github.com/klauspost/compress";
        rev = "f86d2e6d8a77c6a2c4e42a87ded21c6422f7557e";
        sha256 = "0z4i47w841wzvlij9rsz9667a8d37milqwl2kfhmfz754yx7sgzd";
      };
    }
    {
      goPackagePath = "github.com/klauspost/cpuid";

      src = fetchgit {
        url = "https://github.com/klauspost/cpuid";
        rev = "349c675778172472f5e8f3a3e0fe187e302e5a10";
        sha256 = "1s8baj42k66ny77qkm3n06kwayk4srwf4b9ss42612f3h86ka5i2";
      };
    }
    {
      goPackagePath = "github.com/klauspost/crc32";

      src = fetchgit {
        url = "https://github.com/klauspost/crc32";
        rev = "999f3125931f6557b991b2f8472172bdfa578d38";
        sha256 = "00ws3hrszxdnyj0cjk9b8b44xc8x5hizm0h22x6m3bb4c5b487wv";
      };
    }
    {
      goPackagePath = "github.com/klauspost/pgzip";

      src = fetchgit {
        url = "https://github.com/klauspost/pgzip";
        rev = "47f36e165cecae5382ecf1ec28ebf7d4679e307d";
        sha256 = "1bfka02xrhp4fg9pz2v4ppxa46b59bwy5n88c7hbbxqxm8z30yca";
      };
    }
    {
      goPackagePath = "github.com/kr/fs";

      src = fetchgit {
        url = "https://github.com/kr/fs";
        rev = "2788f0dbd16903de03cb8186e5c7d97b69ad387b";
        sha256 = "1c0fipl4rsh0v5liq1ska1dl83v3llab4k6lm8mvrx9c4dyp71ly";
      };
    }
    {
      goPackagePath = "github.com/masterzen/simplexml";

      src = fetchgit {
        url = "https://github.com/masterzen/simplexml";
        rev = "95ba30457eb1121fa27753627c774c7cd4e90083";
        sha256 = "0pwsis1f5n4is0nmn6dnggymj32mldhbvihv8ikn3nglgxclz4kz";
      };
    }
    {
      goPackagePath = "github.com/masterzen/winrm";

      src = fetchgit {
        url = "https://github.com/masterzen/winrm";
        rev = "ef3efbb97f99fc204bd9c7edf778a0dbd9781baf";
        sha256 = "0p9r21qkvpcfqnhqs8hs7jgp9xr70830ag4m5fjdpld07g1f95yx";
      };
    }
    {
      goPackagePath = "github.com/masterzen/xmlpath";

      src = fetchgit {
        url = "https://github.com/masterzen/xmlpath";
        rev = "13f4951698adc0fa9c1dda3e275d489a24201161";
        sha256 = "1y81h7ymk3dp3w3a2iy6qd1dkm323rkxa27dzxw8vwy888j5z8bk";
      };
    }
    {
      goPackagePath = "github.com/mattn/go-isatty";

      src = fetchgit {
        url = "https://github.com/mattn/go-isatty";
        rev = "56b76bdf51f7708750eac80fa38b952bb9f32639";
        sha256 = "0l8lcp8gcqgy0g1cd89r8vk96nami6sp9cnkx60ms1dn6cqwf5n3";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/cli";

      src = fetchgit {
        url = "https://github.com/mitchellh/cli";
        rev = "5c87c51cedf76a1737bf5ca3979e8644871598a6";
        sha256 = "1ajxzh3winjnmqhd4yn6b6f155vfzi0dszhzl4a00zb5pdppp1rd";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/go-fs";

      src = fetchgit {
        url = "https://github.com/mitchellh/go-fs";
        rev = "7bae45d9a684750e82b97ff320c82556614e621b";
        sha256 = "073bahchz9irlx5was1r5780z4849kvh9dly6s64d7dihnfm53zj";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/go-homedir";

      src = fetchgit {
        url = "https://github.com/mitchellh/go-homedir";
        rev = "d682a8f0cf139663a984ff12528da460ca963de9";
        sha256 = "0vsiby9fbkaz7q067wmc6s5pzgpq4gdfx66cj2a1lbdarf7j1kbs";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/go-vnc";

      src = fetchgit {
        url = "https://github.com/mitchellh/go-vnc";
        rev = "723ed9867aed0f3209a81151e52ddc61681f0b01";
        sha256 = "0nlya2rbmwb3jycqsyah1pn4386712mfrfiprprkbzcna9q7lp1h";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/iochan";

      src = fetchgit {
        url = "https://github.com/mitchellh/iochan";
        rev = "87b45ffd0e9581375c491fef3d32130bb15c5bd7";
        sha256 = "1435kdcx3j1xgr6mm5c7w7hjx015jb20yfqlkp93q143hspf02fx";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/mapstructure";

      src = fetchgit {
        url = "https://github.com/mitchellh/mapstructure";
        rev = "281073eb9eb092240d33ef253c404f1cca550309";
        sha256 = "1zjx9fv29639sp1fn84rxs830z7gp7bs38yd5y1hl5adb8s5x1mh";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/multistep";

      src = fetchgit {
        url = "https://github.com/mitchellh/multistep";
        rev = "162146fc57112954184d90266f4733e900ed05a5";
        sha256 = "0ydhbxziy9204qr43pjdh88y2jg34g2mhzdapjyfpf8a1rin6dn3";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/panicwrap";

      src = fetchgit {
        url = "https://github.com/mitchellh/panicwrap";
        rev = "a1e50bc201f387747a45ffff020f1af2d8759e88";
        sha256 = "0w5y21psgrl1afsap613c3qw84ik7zhnalnv3bf6r51hyv187y69";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/prefixedio";

      src = fetchgit {
        url = "https://github.com/mitchellh/prefixedio";
        rev = "6e6954073784f7ee67b28f2d22749d6479151ed7";
        sha256 = "0an2pnnda33ns94v7x0sv9kmsnk62r8xm0cj4d69f2p63r85fdp6";
      };
    }
    {
      goPackagePath = "github.com/mitchellh/reflectwalk";

      src = fetchgit {
        url = "https://github.com/mitchellh/reflectwalk";
        rev = "eecf4c70c626c7cfbb95c90195bc34d386c74ac6";
        sha256 = "1nm2ig7gwlmf04w7dbqd8d7p64z2030fnnfbgnd56nmd7dz8gpxq";
      };
    }
    {
      goPackagePath = "github.com/nu7hatch/gouuid";

      src = fetchgit {
        url = "https://github.com/nu7hatch/gouuid";
        rev = "179d4d0c4d8d407a32af483c2354df1d2c91e6c3";
        sha256 = "1isyfix5w1wm26y3a15ha3nnpsxqaxz5ngq06hnh6c6y0inl2fwj";
      };
    }
    {
      goPackagePath = "github.com/packer-community/winrmcp";

      src = fetchgit {
        url = "https://github.com/packer-community/winrmcp";
        rev = "7f50d16167d327698b91ccd5363d8691865e2580";
        sha256 = "0rfqaf3ww17rvv1amqx6hiajgmj8bcisz4xczdm0r5a5nffy5xh7";
      };
    }
    {
      goPackagePath = "github.com/pierrec/lz4";

      src = fetchgit {
        url = "https://github.com/pierrec/lz4";
        rev = "383c0d87b5dd7c090d3cddefe6ff0c2ffbb88470";
        sha256 = "0l23bmzqfvgh61zlikj6iakg0kz7lybs8zf0nscylskl2hlr09rp";
      };
    }
    {
      goPackagePath = "github.com/pierrec/xxHash";

      src = fetchgit {
        url = "https://github.com/pierrec/xxHash";
        rev = "5a004441f897722c627870a981d02b29924215fa";
        sha256 = "146ibrgvgh61jhbbv9wks0mabkci3s0m68sg6shmlv1yixkw6gja";
      };
    }
    {
      goPackagePath = "github.com/pkg/sftp";

      src = fetchgit {
        url = "https://github.com/pkg/sftp";
        rev = "e84cc8c755ca39b7b64f510fe1fffc1b51f210a5";
        sha256 = "1gkmk60lskyrn5751rgb9pxn41wi7y29wsn8psrfb16bg4flcvrq";
      };
    }
    {
      goPackagePath = "github.com/pmezard/go-difflib";

      src = fetchgit {
        url = "https://github.com/pmezard/go-difflib";
        rev = "792786c7400a136282c1664665ae0a8db921c6c2";
        sha256 = "0c1cn55m4rypmscgf0rrb88pn58j3ysvc2d0432dp3c6fqg6cnzw";
      };
    }
    {
      goPackagePath = "github.com/satori/go.uuid";

      src = fetchgit {
        url = "https://github.com/satori/go.uuid";
        rev = "d41af8bb6a7704f00bc3b7cba9355ae6a5a80048";
        sha256 = "0lw8k39s7hab737rn4nngpbsganrniiv7px6g41l6f6vci1skyn2";
      };
    }
    {
      goPackagePath = "github.com/stretchr/testify";

      src = fetchgit {
        url = "https://github.com/stretchr/testify";
        rev = "976c720a22c8eb4eb6a0b4348ad85ad12491a506";
        sha256 = "0a2gxvqzacrj9k8h022zhr8fchhn9afc6a511m07j71dzw9g4y3m";
      };
    }
    {
      goPackagePath = "github.com/tent/http-link-go";

      src = fetchgit {
        url = "https://github.com/tent/http-link-go";
        rev = "ac974c61c2f990f4115b119354b5e0b47550e888";
        sha256 = "1fph21b6vp4cm73fkkykffggi57m656x9fd1k369fr6jbvq5fffj";
      };
    }
    {
      goPackagePath = "github.com/ugorji/go";

      src = fetchgit {
        url = "https://github.com/ugorji/go";
        rev = "646ae4a518c1c3be0739df898118d9bccf993858";
        sha256 = "0njncpdbh115l5mxyks08jh91kdmy0mvbmxj9mr1psv5k97gf0pn";
      };
    }
    {
      goPackagePath = "github.com/xanzy/go-cloudstack";

      src = fetchgit {
        url = "https://github.com/xanzy/go-cloudstack";
        rev = "7d6a4449b586546246087e96e5c97dbc450f4917";
        sha256 = "18xm3d6l8qglp7m18r0pa3rfw3zjiraqvjgd893gpn5cmgnqynfl";
      };
    }
    {
      goPackagePath = "golang.org/x/crypto";

      src = fetchgit {
        url = "https://go.googlesource.com/crypto";
        rev = "7682e7e3945130cf3cde089834664f68afdd1523";
        sha256 = "1yg53yycnzn569jssij0w1jxhjs9wmscw29hasqqkvhkzdwyjzhf";
      };
    }
    {
      goPackagePath = "golang.org/x/net";

      src = fetchgit {
        url = "https://go.googlesource.com/net";
        rev = "6ccd6698c634f5d835c40c1c31848729e0cecda1";
        sha256 = "10gnjjcgzn7z9l4hyqlammilxigln4m7jriv5apcsdk81ywbjrb5";
      };
    }
    {
      goPackagePath = "golang.org/x/oauth2";

      src = fetchgit {
        url = "https://go.googlesource.com/oauth2";
        rev = "8a57ed94ffd43444c0879fe75701732a38afc985";
        sha256 = "10pxnbsy1lnx7a1x6g3cna5gdm11aal1r446dpmpgj94xiw96mxv";
      };
    }
    {
      goPackagePath = "golang.org/x/sys";

      src = fetchgit {
        url = "https://go.googlesource.com/sys";
        rev = "50c6bc5e4292a1d4e65c6e9be5f53be28bcbe28e";
        sha256 = "0v6a1qh4znxwx5zdfsp8hwa1jrvqas9k4m6iaf734izqngyq5vmw";
      };
    }
    {
      goPackagePath = "golang.org/x/text";

      src = fetchgit {
        url = "https://go.googlesource.com/text";
        rev = "16e1d1f27f7aba51c74c0aeb7a7ee31a75c5c63c";
        sha256 = "1xip5sbksgf42fm0fhfkgh7cvmib8fnv5yammsdmxd9v1dgla2i1";
      };
    }
    {
      goPackagePath = "google.golang.org/appengine";

      src = fetchgit {
        url = "https://github.com/golang/appengine";
        rev = "6bde959377a90acb53366051d7d587bfd7171354";
        sha256 = "1dqi1620dj6rm9g5qshfplifxwq3dyqjvpx5n5fmkz4vazgdpz4w";
      };
    }
    {
      goPackagePath = "google.golang.org/cloud";

      src = fetchgit {
        url = "https://code.googlesource.com/gocloud";
        rev = "5a3b06f8b5da3b7c3a93da43163b872c86c509ef";
        sha256 = "03zrw3mgh82gvfgz17k97n8hivnvvplc42c7vyr76i90n1mv29g7";
      };
    }
    {
      goPackagePath = "gopkg.in/xmlpath.v2";

      src = fetchgit {
        url = "https://gopkg.in/xmlpath.v2";
        rev = "860cbeca3ebcc600db0b213c0e83ad6ce91f5739";
        sha256 = "0jgvd0y78fir4vkcj8acs0pdvlc0xr7i7cspbkm2yjm8wv23p63h";
      };
    }
  ];
}

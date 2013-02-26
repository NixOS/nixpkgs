{ pkgs, stdenv, nodejs, fetchurl, neededNatives }:

let self = {
  buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
    inherit stdenv nodejs neededNatives;
    inherit (pkgs) runCommand;
  };

  patchLatest = srcAttrs:
                  let src = fetchurl srcAttrs; in
                  pkgs.runCommand src.name {} ''
                    tar xf ${src}
                    sed -i -e "s/: \"latest\"/: \"*\"/" package/package.json
                    tar cf $out package
                  '';

  "abbrev" = self."abbrev-1";

  "abbrev-1" = self.buildNodePackage rec {
    name = "abbrev-1.0.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/abbrev/-/${name}.tgz";
      sha256 = "8dc0f480571a4a19e74f1abd4f31f6a70f94953d1ccafa16ed1a544a19a6f3a8";
    };
    deps = [

    ];
  };

  "active-x-obfuscator" = self."active-x-obfuscator-0.0.1";

  "active-x-obfuscator-0.0.1" = self.buildNodePackage rec {
    name = "active-x-obfuscator-0.0.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/active-x-obfuscator/-/${name}.tgz";
      sha256 = "069cc18a0e7790ec106b267d28b47c691220f119a8daec925dd47f06866ce1c6";
    };
    deps = [
      self."zeparser-0.0.5"
    ];
  };

  "ansi" = self."ansi-~0.1.2";

  "ansi-~0.1.2" = self.buildNodePackage rec {
    name = "ansi-0.1.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi/-/${name}.tgz";
      sha256 = "6f2288b1db642eb822578f4ee70bf26bf97173cc7d3f10f496070fb96250006b";
    };
    deps = [

    ];
  };

  "asn1" = self."asn1-0.1.11";

  "asn1-0.1.11" = self.buildNodePackage rec {
    name = "asn1-0.1.11";
    src = fetchurl {
      url = "http://registry.npmjs.org/asn1/-/${name}.tgz";
      sha256 = "7206eadc8a9344e484bcce979e22a12c9fa64c1395aa0544b8b767808b268f43";
    };
    deps = [

    ];
  };

  "async" = self."async-0.1.22";

  "async-0.1.22" = self.buildNodePackage rec {
    name = "async-0.1.22";
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/${name}.tgz";
      sha256 = "6fd2750cd519a754b0e32ef3423e64768055129e00a95d9297005bda29fdef18";
    };
    deps = [

    ];
  };

  "backbone" = self."backbone-0.9.2";

  "backbone-0.9.2" = self.buildNodePackage rec {
    name = "backbone-0.9.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/backbone/-/${name}.tgz";
      sha256 = "0a5ebc8d32949ea2870a684e8430a8b4dec75a163ecf2740eb5fb4865393bb32";
    };
    deps = [
      self."underscore->=1.3.1"
    ];
  };

  "bindings" = self."bindings-1";

  "bindings-1" = self.buildNodePackage rec {
    name = "bindings-1.0.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/bindings/-/${name}.tgz";
      sha256 = "cb211ac856d135af5ee864762fae9e554225a613ea1fd815c20b8fdd1679c9ed";
    };
    deps = [

    ];
  };

  "block-stream" = self."block-stream-*";

  "block-stream-*" = self.buildNodePackage rec {
    name = "block-stream-0.0.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/block-stream/-/${name}.tgz";
      sha256 = "2fc365b42b8601c8ee150d453f6cc762a01054b7fb28bdfcfcbce7c97e93601b";
    };
    deps = [
      self."inherits-~1.0.0"
    ];
  };

  "browserchannel" = self."browserchannel-0.4.1";

  "browserchannel-0.4.1" = self.buildNodePackage rec {
    name = "browserchannel-0.4.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/browserchannel/-/${name}.tgz";
      sha256 = "f5d038347cee6802bb6f30f53bcf2adf196d241505b77ffca3d5f8a76a109c5f";
    };
    deps = [
      self."coffee-script-~1"
      self."hat"
      self."connect-~1.7"
      self."timerstub"
      self."request-~2"
    ];
  };

  "bson" = self."bson-0.1.5";

  "bson-0.1.5" = self.buildNodePackage rec {
    name = "bson-0.1.5";
    src = fetchurl {
      url = "http://registry.npmjs.org/bson/-/${name}.tgz";
      sha256 = "58af4a1697b015190b40c2a7e5743f9d4494887ef98dfe2f58f24c70f2d31150";
    };
    deps = [

    ];
  };

  "buffertools" = self."buffertools-~1";

  "buffertools-~1" = self.buildNodePackage rec {
    name = "buffertools-1.1.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/buffertools/-/${name}.tgz";
      sha256 = "a0520dbf39eedbd8c685ac4989bf822ac57cc161924abf82ba567234620380a5";
    };
    deps = [

    ];
  };

  "bunyan" = self."bunyan-0.8.0";

  "bunyan-0.8.0" = self.buildNodePackage rec {
    name = "bunyan-0.8.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/bunyan/-/${name}.tgz";
      sha256 = "059b8948dd34d371d39aa87227d26d62180c365afeb6625c07187c8f0ad29f27";
    };
    deps = [

    ];
  };

  "byline" = self."byline-2.0.2";

  "byline-2.0.2" = self.buildNodePackage rec {
    name = "byline-2.0.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/byline/-/${name}.tgz";
      sha256 = "a916ffde5ee385f7d682c13028907a96fe33cdeed6d72cea903d09fb154dae50";
    };
    deps = [

    ];
  };

  "bytes" = self."bytes-0.1.0";

  "bytes-0.1.0" = self.buildNodePackage rec {
    name = "bytes-0.1.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/bytes/-/${name}.tgz";
      sha256 = "32954618600f6566ecd95aec0ea0ae3318a1b4a29bf6a7970462c29a843bf701";
    };
    deps = [

    ];
  };

  "cipher-block-size" = self."cipher-block-size-0.0.0";

  "cipher-block-size-0.0.0" = self.buildNodePackage rec {
    name = "cipher-block-size-0.0.0";
    src = fetchurl {
      url = https://bitbucket.org/shlevy/node-cipher-block-size/get/0.0.0.tar.gz;
      sha256 = "0j4i19ckb9ab9aqd4w3j0vrvcw7c6icq279x4fx8xs1h9massxng";
      name = "${name}.tgz";
    };
    deps = [
      self."bindings-1"
    ];
    buildInputs = [
      pkgs.openssl
    ];
  };

  "coffee-script" = self."coffee-script-1.4.0";
  "coffee-script-~1" = self."coffee-script-1.4.0";

  "coffee-script-~1.1.2" = self.buildNodePackage rec {
    name = "coffee-script-1.1.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/${name}.tgz";
      sha256 = "3b431da901f753bde0ab26245c7111e1e4b8be1bba0086cf4a7470d739acae87";
    };
    deps = [

    ];
  };

  "coffee-script-1.3.3" = self.buildNodePackage rec {
    name = "coffee-script-1.3.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/${name}.tgz";
      sha256 = "deedd2cf9d5abe2bad724e6809bec40efa07215dae85f44d78cd37736bb50bc5";
    };
    deps = [

    ];
  };

  "coffee-script-1.4.0" = self.buildNodePackage rec {
    name = "coffee-script-1.4.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/${name}.tgz";
      sha256 = "146e8985d89210b63dae83378fd851ccf54d38d7d11cadcdca01520d50882613";
    };
    deps = [

    ];
  };

  "commander" = self."commander-~0.6.1";

  "commander-~0.6.1" = self.buildNodePackage rec {
    name = "commander-0.6.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/${name}.tgz";
      sha256 = "7b7fdd1bc4d16f6776169a64f133d629efe2e3a7cd338b1d0884ee909abbd729";
    };
    deps = [

    ];
  };

  "connect" = self."connect-2.4.4";

  "connect-~1.7" = self.buildNodePackage rec {
    name = "connect-1.7.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/connect/-/${name}.tgz";
      sha256 = "773fd6ca8c90e33cc28d012fb3d72d66eb99114b20d88228330458628f030d12";
    };
    deps = [
      self."qs->= 0.3.1"
      self."mime->= 0.0.1"
    ];
  };

  "connect-2.4.4" = self.buildNodePackage rec {
    name = "connect-2.4.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/connect/-/${name}.tgz";
      sha256 = "1f474ca9db05b9d58f3469ad4932722e49bec1f6ec35665ddea09155382914e9";
    };
    deps = [
      self."qs-0.4.2"
      self."formidable-1.0.11"
      self."crc-0.2.0"
      self."cookie-0.0.4"
      self."bytes-0.1.0"
      self."send-0.0.4"
      self."fresh-0.1.0"
      self."pause-0.0.1"
      self."debug"
    ];
  };

  "cookie" = self."cookie-0.0.4";

  "cookie-0.0.4" = self.buildNodePackage rec {
    name = "cookie-0.0.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie/-/${name}.tgz";
      sha256 = "a917477c448a6a91ef73d550d8d8a6d4864e8fbd247b6f73baaca66c9bfc3b0b";
    };
    deps = [

    ];
  };

  "crc" = self."crc-0.2.0";

  "crc-0.2.0" = self.buildNodePackage rec {
    name = "crc-0.2.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/crc/-/${name}.tgz";
      sha256 = "027c180bbbddd0960e6000f7ef60623997dfa61b3c2ef141acf00c29a1763b5d";
    };
    deps = [

    ];
  };

  "cssmin" = self."cssmin-0.3.1";

  "cssmin-0.3.1" = self.buildNodePackage rec {
    name = "cssmin-0.3.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/cssmin/-/${name}.tgz";
      sha256 = "56f1854fd0c6cb4cf78cea861e7b617ccf1daf91b47fba5bc80abdf2529b3102";
    };
    deps = [

    ];
  };

  "ctype" = self."ctype->=0.0.2";

  "ctype->=0.0.2" = self.buildNodePackage rec {
    name = "ctype-0.5.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/ctype/-/${name}.tgz";
      sha256 = "4a7224a74f19dc6a1206fa1c04ae1a4ab795cd4ba842466e2f511fa714f82c60";
    };
    deps = [

    ];
  };

  "ctype-0.5.0" = self.buildNodePackage rec {
    name = "ctype-0.5.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/ctype/-/${name}.tgz";
      sha256 = "50157e6c5e44d1c833bfc239a7a337ee08fd6f3c5a15f7ef5cee5571a86b0378";
    };
    deps = [

    ];
  };

  "datetime" = self."datetime-0.0.3";

  "datetime-0.0.3" = self.buildNodePackage rec {
    name = "datetime-0.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/datetime/-/${name}.tgz";
      sha256 = "d584a5b140ced7bd44199fc5e1b6cd55ec2d3c946dc990ced42f6ab2687747f0";
    };
    deps = [
      self."vows->=0.5.4"
    ];
  };

  "debug" = self."debug-*";

  "debug-*" = self.buildNodePackage rec {
    name = "debug-0.7.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/${name}.tgz";
      sha256 = "113c041fb01fd8db2a1b83320529849ccbb23794a4c3799a0154312de2a5d618";
    };
    deps = [

    ];
  };

  "diff" = self."diff-~1.0.3";

  "diff-~1.0.3" = self.buildNodePackage rec {
    name = "diff-1.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/diff/-/${name}.tgz";
      sha256 = "88e1bb04e3707c5601ec0841e170f8892a3b929bf8c4030f826cd32c1fa21472";
    };
    deps = [

    ];
  };

  "dtrace-provider" = self."dtrace-provider-0.0.6";

  "dtrace-provider-0.0.6" = self.buildNodePackage rec {
    name = "dtrace-provider-0.0.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/dtrace-provider/-/${name}.tgz";
      sha256 = "ce48363aefa9e8afb3c8e8e5ce8d321a5d5a7eecbb28eaa997c48c5e9d502508";
    };
    deps = [

    ];
  };

  "escape-html" = self."escape-html-0.0.1";

  "escape-html-0.0.1" = self.buildNodePackage rec {
    name = "escape-html-0.0.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-html/-/${name}.tgz";
      sha256 = "03c24a492f80659c25f788809ae64277408a4c12594cff62f89db4b3259c6b58";
    };
    deps = [

    ];
  };

  "eyes" = self."eyes->=0.1.6";

  "eyes->=0.1.6" = self.buildNodePackage rec {
    name = "eyes-0.1.8";
    src = fetchurl {
      url = "http://registry.npmjs.org/eyes/-/${name}.tgz";
      sha256 = "4fa6db8f2c9926fb39a211c622d7eb3a76efbc4878559f9bd155d647a6963735";
    };
    deps = [

    ];
  };

  "faye-websocket" = self."faye-websocket-0.4.0";

  "faye-websocket-0.4.0" = self.buildNodePackage rec {
    name = "faye-websocket-0.4.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/faye-websocket/-/${name}.tgz";
      sha256 = "853b8d2f4611013da89faf45b6c9f6e440ad6c46616e405b8cf59b4302e78e2f";
    };
    deps = [

    ];
  };

  "formidable" = self."formidable-1.0.11";

  "formidable-1.0.11" = self.buildNodePackage rec {
    name = "formidable-1.0.11";
    src = fetchurl {
      url = "http://registry.npmjs.org/formidable/-/${name}.tgz";
      sha256 = "39b345d14d69c27fe262e12f16900cef6be220510788866e0a12c9fedd03766e";
    };
    deps = [

    ];
  };

  "fresh" = self."fresh-0.1.0";

  "fresh-0.1.0" = self.buildNodePackage rec {
    name = "fresh-0.1.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/fresh/-/${name}.tgz";
      sha256 = "c402fbd25e26c0167bf288e1ba791716808bfaa5de32b76ae68e8e8a3d7e2b33";
    };
    deps = [

    ];
  };

  "fstream" = self."fstream-0.1.18";
  "fstream-~0.1.8" = self."fstream-0.1.18";
  "fstream-~0.1.13" = self."fstream-0.1.18";

  "fstream-0.1.18" = self.buildNodePackage rec {
    name = "fstream-0.1.18";
    src = fetchurl {
      url = "http://registry.npmjs.org/fstream/-/${name}.tgz";
      sha256 = "fd5791dd0ce8d7b707fa171ac5bd482e09f80cd09ec8176b45d547416893372d";
    };
    deps = [
      self."rimraf-2"
      self."mkdirp-0.3"
      self."graceful-fs-~1.1.2"
      self."inherits-~1.0.0"
    ];
  };

  "glob" = self."glob-3";

  "glob-3" = self.buildNodePackage rec {
    name = "glob-3.1.12";
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/${name}.tgz";
      sha256 = "a37c02e9a91915fe4e3232229676e842803151dde831d1046620ec96118f6036";
    };
    deps = [
      self."minimatch-0.2"
      self."graceful-fs-~1.1.2"
      self."inherits-1"
    ];
  };

  "graceful-fs" = self."graceful-fs-1.1.10";
  "graceful-fs-1" = self."graceful-fs-1.1.10";
  "graceful-fs-~1.1" = self."graceful-fs-1.1.10";
  "graceful-fs-~1.1.2" = self."graceful-fs-1.1.10";

  "graceful-fs-1.1.10" = self.buildNodePackage rec {
    name = "graceful-fs-1.1.10";
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/${name}.tgz";
      sha256 = "1f9b7da8b0c75db49e0e5d2aaecc6f1dd3fca2bdbb2aecf95d1dbdec7f0cee24";
    };
    deps = [

    ];
  };

  "hat" = self."hat-0.0.3";

  "hat-0.0.3" = self.buildNodePackage rec {
    name = "hat-0.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/hat/-/${name}.tgz";
      sha256 = "7bf52b3b020ca333a42eb67411090912b21abb6ac746d587022a0955b16e5f5c";
    };
    deps = [

    ];
  };

  "hiredis" = self."hiredis-*";

  "hiredis-*" = self.buildNodePackage rec {
    name = "hiredis-0.1.14";
    src = fetchurl {
      url = "http://registry.npmjs.org/hiredis/-/${name}.tgz";
      sha256 = "9d7ce0a7ae81cf465a0c26c07fb618b6ffd98ca344f14369114abf548d75637a";
    };
    deps = [

    ];
  };

  "http-signature" = self."http-signature-0.9.9";

  "http-signature-0.9.9" = self.buildNodePackage rec {
    name = "http-signature-0.9.9";
    src = fetchurl {
      url = "http://registry.npmjs.org/http-signature/-/${name}.tgz";
      sha256 = "c1e193f1195028f2cc8a8f402c7755fc215552a81f6bebbdf6f21de9390a438e";
    };
    deps = [
      self."asn1-0.1.11"
      self."ctype-0.5.0"
    ];
  };

  "inherits" = self."inherits-1.0.0";
  "inherits-1" = self."inherits-1.0.0";
  "inherits-1.x" = self."inherits-1.0.0";
  "inherits-~1.0.0" = self."inherits-1.0.0";

  "inherits-1.0.0" = self.buildNodePackage rec {
    name = "inherits-1.0.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/${name}.tgz";
      sha256 = "2be196fa6bc6a0c65fecd737af457589ef88b22a95d5dc31aab01d92ace48186";
    };
    deps = [

    ];
  };

  "jsontool" = self."jsontool-*";

  "jsontool-*" = self.buildNodePackage rec {
    name = "jsontool-5.1.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/jsontool/-/${name}.tgz";
      sha256 = "f7c12a0de635905f8134dfc8385f237135494d8c99fc0a5f112ee9735c2b6d05";
    };
    deps = [

    ];
  };

  "knox" = self."knox-*";

  "knox-*" = self.buildNodePackage rec {
    name = "knox-0.3.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/knox/-/${name}.tgz";
      sha256 = "d62623482cc2f8b2fe08ff0c0cf2ed7f35a320e806ebdfa6ac36df5486018517";
    };
    deps = [
      self."mime"
    ];
  };

  "less" = self."less-1.3.0";

  "less-1.3.0" = self.buildNodePackage rec {
    name = "less-1.3.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/less/-/${name}.tgz";
      sha256 = "a182824764d5feefe8a66c5f9c7fe8b92d24a7677942fd650b9092bbd3f63d1b";
    };
    deps = [

    ];
  };

  "lru-cache" = self."lru-cache-~2.0.0";

  "lru-cache-1.1.0" = self.buildNodePackage rec {
    name = "lru-cache-1.1.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/${name}.tgz";
      sha256 = "735898f87ba800d6f2f3517ab92b631f03976c9d3fbaedb6ce357cfe3813ee8b";
    };
    deps = [

    ];
  };

  "lru-cache-~2.0.0" = self.buildNodePackage rec {
    name = "lru-cache-2.0.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/${name}.tgz";
      sha256 = "3b4fd68f0bd75f5abf69e349b6ffa918bfe4990ff36d2d88dc74f334a9ed627e";
    };
    deps = [

    ];
  };

  "mime" = self."mime-*";

  "mime->= 0.0.1" = self."mime-*";

  "mime-1.2.5" = self.buildNodePackage rec {
    name = "mime-1.2.5";
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/${name}.tgz";
      sha256 = "ccf05a6c47146e8acb9d0671eee09d2eb077cf9ddd1f7e8eccf49dbf969d6c72";
    };
    deps = [

    ];
  };

  "mime-1.2.6" = self.buildNodePackage rec {
    name = "mime-1.2.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/${name}.tgz";
      sha256 = "7460134d6b4686d64fd1e7b878d34e2bdd258ad29b6665cf62e6d92659e81591";
    };
    deps = [

    ];
  };

  "mime-*" = self.buildNodePackage rec {
    name = "mime-1.2.7";
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/${name}.tgz";
      sha256 = "a80244918c9c75fa4d0b37f311920c7d5270aab9a05aca9a74783764ad152df6";
    };
    deps = [

    ];
  };

  "minimatch" = self."minimatch-0.2";

  "minimatch-0.2" = self.buildNodePackage rec {
    name = "minimatch-0.2.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/${name}.tgz";
      sha256 = "f0030112575a815ff304fa3bc64ee7e60ab8bfddb281602bc37eca0cddd48350";
    };
    deps = [
      self."lru-cache-~2.0.0"
    ];
  };

  "mkdirp" = self."mkdirp-0.3";

  "mkdirp-0.3" = self.buildNodePackage rec {
    name = "mkdirp-0.3.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/${name}.tgz";
      sha256 = "f87444f2376c56bf47846f3b885aae926c5d9504328923b166794b78c0e08425";
    };
    deps = [

    ];
  };

  "mongodb" = self."mongodb-1.1.11";

  "mongodb-1.1.11" = self.buildNodePackage rec {
    name = "mongodb-1.1.11";
    src = fetchurl {
      url = "http://registry.npmjs.org/mongodb/-/${name}.tgz";
      sha256 = "fedd14b097a58ae5c2c83e5cb0af85a191ad00c2ce8d6db46520ee6cc1650277";
    };
    deps = [
      self."bson-0.1.5"
    ];
  };

  "mrclean" = self."mrclean-0.1.0";

  "mrclean-0.1.0" = self.buildNodePackage rec {
    name = "mrclean-0.1.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/mrclean/-/${name}.tgz";
      sha256 = "5a8921007d8d3db990d41924d220f90efc8cbeb1f425c52fe0fe28be22223705";
    };
    deps = [

    ];
  };

  "nijs" = self."nijs-0.0.3";

  "nijs-0.0.3" = self.buildNodePackage rec {
    name = "nijs-0.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/nijs/-/${name}.tgz";
      sha256 = "0rcqycb4nigfasxfjw1ngh556r5ik1qr58938nx6qbxzkrm0k1ip";
    };
    deps = [
      self."optparse"
    ];
  };

  "node-expat" = self."node-expat-*";

  "node-expat-*" = self.buildNodePackage rec {
    name = "node-expat-1.6.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/node-expat/-/${name}.tgz";
      sha256 = "15c0566889ef8a54b2b626956b7dfc160469eb6c0d44a582a0b1077fadf034d2";
    };
    deps = [

    ];
    buildInputs = [ pkgs.expat ];
  };

  "node-gyp" = self."node-gyp-*";

  "node-gyp-*" = self.buildNodePackage rec {
    name = "node-gyp-0.6.8";
    src = fetchurl {
      url = "http://registry.npmjs.org/node-gyp/-/${name}.tgz";
      sha256 = "b40064d825c492c544389812ecea2089606c31cbe4f3ee9e68048ea56a9aed4d";
    };
    deps = [
      self."glob-3"
      self."graceful-fs-1"
      self."fstream-~0.1.13"
      self."minimatch-0.2"
      self."mkdirp-0.3"
      self."nopt-2"
      self."npmlog-0"
      self."osenv-0"
      self."request-2.9"
      self."rimraf-2"
      self."semver-1"
      self."tar-~0.1.12"
      self."which-1"
    ];
  };

  "node-uuid" = self."node-uuid-1.3.3";

  "node-uuid-1.3.3" = self.buildNodePackage rec {
    name = "node-uuid-1.3.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/${name}.tgz";
      sha256 = "a3fbccc904944a9c8eadc59e55aaac908cc458569f539b50077d9672a84587a8";
    };
    deps = [

    ];
  };

  "nopt" = self."nopt-2";

  "nopt-1.0.10" = self.buildNodePackage rec {
    name = "nopt-1.0.10";
    src = fetchurl {
      url = "http://registry.npmjs.org/nopt/-/${name}.tgz";
      sha256 = "426562943bfbbfc059eac83575ade5b78c6c01e5c1000a90a7defecfe2334927";
    };
    deps = [
      self."abbrev-1"
    ];
  };

  "nopt-2" = self.buildNodePackage rec {
    name = "nopt-2.0.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/nopt/-/${name}.tgz";
      sha256 = "112e9bea8b745a2e5a59d239e6f6f02e720e080ab8cdca89b6b8f0143ae718b5";
    };
    deps = [
      self."abbrev-1"
    ];
  };

  "npm2nix" = self."npm2nix-0.1.3";

  "npm2nix-0.1.3" = self.buildNodePackage rec {
    name = "npm2nix-0.1.3";
    src = fetchurl {
      url = https://bitbucket.org/shlevy/npm2nix/get/0.1.3.tar.gz;
      sha256 = "1728fzmixcyg4g8mqcgn5yf7d4nin9zyqv8bs8b6660swhfdn4il";
      name = "${name}.tgz";
    };
    deps = [
      self."semver-1"
    ];
  };

  "npmlog" = self."npmlog-0";

  "npmlog-0" = self.buildNodePackage rec {
    name = "npmlog-0.0.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/npmlog/-/${name}.tgz";
      sha256 = "ce98d4d3380390c0259695cce407e2e96d2970c5caee1461a62ecbd38e8caed4";
    };
    deps = [
      self."ansi-~0.1.2"
    ];
  };

  "optimist" = self."optimist-*";

  "optimist-*" = self.buildNodePackage rec {
    name = "optimist-0.3.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/optimist/-/${name}.tgz";
      sha256 = "add88b473a660ad8a9ff88a3eec49a74d9c64f592acbcd219ff4c0d7249f4d60";
    };
    deps = [
      self."wordwrap-~0.0.2"
    ];
  };

  "options" = self."options-*";

  "options-*" = self.buildNodePackage rec {
    name = "options-0.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/options/-/${name}.tgz";
      sha256 = "06cfe21b54b45f8cf7bb0a184d6ea6de3adb2dc471bf0663d06c791b4d48536d";
    };
    deps = [

    ];
  };

  "optparse" = self."optparse-1.0.3";
  
  "optparse-1.0.3" = self.buildNodePackage rec {
    name = "optparse-1.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/optparse/-/${name}.tgz";
      sha256 = "1cg99i4rq8azxikzqz0ykw4q971azbj49d3m7slj041yscb6m883";
    };
    deps = [
    
    ];
  };

  "osenv" = self."osenv-0";

  "osenv-0" = self.buildNodePackage rec {
    name = "osenv-0.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/osenv/-/${name}.tgz";
      sha256 = "aafbb23637b7338c9025f9da336f31f96674d7926c30f209e4d93ce16d5251c4";
    };
    deps = [

    ];
  };

  "pause" = self."pause-0.0.1";

  "pause-0.0.1" = self.buildNodePackage rec {
    name = "pause-0.0.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/pause/-/${name}.tgz";
      sha256 = "d37b84046db0c28c9768be649e8f02bd991ede34b276b5dba7bade23b523235e";
    };
    deps = [

    ];
  };

  "policyfile" = self."policyfile-0.0.4";

  "policyfile-0.0.4" = self.buildNodePackage rec {
    name = "policyfile-0.0.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/policyfile/-/${name}.tgz";
      sha256 = "e19e9e57d6262ab7965212ec5456eae2c07438de3b09fd8f3cba36a61a14c43f";
    };
    deps = [

    ];
  };

  "qs" = self."qs-0.5.0";
  "qs->= 0.3.1" = self."qs-0.5.0";

  "qs-0.4.2" = self.buildNodePackage rec {
    name = "qs-0.4.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/${name}.tgz";
      sha256 = "c44875d3aa882693cf73185b46fed63c1a89c34dce600b191b41dd90fb019b86";
    };
    deps = [

    ];
  };

  "qs-0.5.0" = self.buildNodePackage rec {
    name = "qs-0.5.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/${name}.tgz";
      sha256 = "229a99fc833d50307833a13d898f3de137f2823593220273295e7e1dc81ab993";
    };
    deps = [

    ];
  };

  "range-parser" = self."range-parser-0.0.4";

  "range-parser-0.0.4" = self.buildNodePackage rec {
    name = "range-parser-0.0.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/range-parser/-/${name}.tgz";
      sha256 = "8e1bcce3544330b51644ea0cb4d25f0daa4b43008a75da27e285635f4ac4b1ce";
    };
    deps = [

    ];
  };

  "rbytes" = self."rbytes-0.0.2";

  "rbytes-0.0.2" = self.buildNodePackage rec {
    name = "rbytes-0.0.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/rbytes/-/${name}.tgz";
      sha256 = "0fd4697be996ee12c65f8fb13b2edc7a554d22c31d1a344539bc611ce73b69aa";
    };
    deps = [

    ];
    buildInputs = [
      pkgs.openssl
    ];
  };

  "redis" = self."redis-0.7.2";

  "redis-0.6.7" = self.buildNodePackage rec {
    name = "redis-0.6.7";
    src = fetchurl {
      url = "http://registry.npmjs.org/redis/-/${name}.tgz";
      sha256 = "6a65c0204a773ca4adec0635d747c80a7565ba5e2028775c7d0e95d23df088bb";
    };
    deps = [

    ];
  };

  "redis-0.7.2" = self.buildNodePackage rec {
    name = "redis-0.7.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/redis/-/${name}.tgz";
      sha256 = "d56d99e15dd35f6fabf545d9e91545553d60eaeb32ecf5caa1f357458df161ab";
    };
    deps = [
      self."hiredis"
    ];
  };

  "request" = self."request-~2";

  "request-2.9" = self.buildNodePackage rec {
    name = "request-2.9.203";
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/${name}.tgz";
      sha256 = "2af8f83a63c7227383fbdd6114e470e0921af86a037c4e82f42883120f35f836";
    };
    deps = [

    ];
  };

  "request-~2" = self.buildNodePackage rec {
    name = "request-2.11.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/${name}.tgz";
      sha256 = "01e5c144c755c8ee1a1ec93077b684bd63efb8df32d54675e20737e8e1c1afa6";
    };
    deps = [

    ];
  };

  "requirejs" = self."requirejs-0.26.0";

  "requirejs-==0.26.0" = self."requirejs-0.26.0";

  "requirejs-0.26.0" = self.buildNodePackage rec {
    name = "requirejs-0.26.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/requirejs/-/${name}.tgz";
      sha256 = "5ec7264031784fd1b5844aba813ace9045918a0b004a52fafa6b52e9e9760407";
    };
    deps = [

    ];
  };

  "restify" = self."restify-1.4.3";

  "restify-1.4.3" = self.buildNodePackage rec {
    name = "restify-1.4.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/restify/-/${name}.tgz";
      sha256 = "7c95b1e58d6effab3b947409892a20260b6d1142aefec9c3eb1e46165363d64e";
    };
    deps = [
      self."async-0.1.22"
      self."bunyan-0.8.0"
      self."byline-2.0.2"
      self."formidable-1.0.11"
      self."dtrace-provider-0.0.6"
      self."http-signature-0.9.9"
      self."lru-cache-1.1.0"
      self."mime-1.2.5"
      self."node-uuid-1.3.3"
      self."qs-0.5.0"
      self."retry-0.6.0"
      self."semver-1.0.14"
    ];
  };

  "retry" = self."retry-0.6.0";

  "retry-0.6.0" = self.buildNodePackage rec {
    name = "retry-0.6.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/retry/-/${name}.tgz";
      sha256 = "983e676af24ff4dcbac396420fca3c195ce3b1de5f731f697888b4fe6b7bbd2a";
    };
    deps = [

    ];
  };

  "rimraf" = self."rimraf-2";

  "rimraf-2" = self.buildNodePackage rec {
    name = "rimraf-2.0.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/${name}.tgz";
      sha256 = "3efcc60c9f6715a8746f3e0b82770468247f3e256778ef20733f334377392ab0";
    };
    deps = [
      self."graceful-fs-~1.1"
    ];
  };

  "semver" = self."semver-1";

  "semver-1" = self."semver-1.0.14";

  "semver-1.0.14" = self.buildNodePackage rec {
    name = "semver-1.0.14";
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/${name}.tgz";
      sha256 = "560df522ae0e8834d8b07f6ca9c60bd8836e844642361abde108018cbe9ca82f";
    };
    deps = [

    ];
  };

  "send" = self."send-0.0.4";

  "send-0.0.4" = self.buildNodePackage rec {
    name = "send-0.0.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/send/-/${name}.tgz";
      sha256 = "7e028fa3760884d8103414f079dc4bcc99d0b72bc21bcaa9d66a319d59010d6c";
    };
    deps = [
      self."debug"
      self."mime-1.2.6"
      self."fresh-0.1.0"
      self."range-parser-0.0.4"
    ];
  };

  "showdown" = self."showdown-0.0.1";

  "showdown-0.0.1" = self.buildNodePackage rec {
    name = "showdown-0.0.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/showdown/-/${name}.tgz";
      sha256 = "669a3284344a4cb51b0327af8d84b9e35c895ef1cedbafada5284a31f4d4783d";
    };
    deps = [

    ];
  };

  "smartdc" = self."smartdc-*";

  "smartdc-*" = self.buildNodePackage rec {
    name = "smartdc-6.5.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/smartdc/-/${name}.tgz";
      sha256 = "a5d7ba965a863a411b52f0321a9fa1be350cb6af807175beb16529e4282dff4d";
    };
    deps = [
      self."http-signature-0.9.9"
      self."lru-cache-1.1.0"
      self."nopt-1.0.10"
      self."restify-1.4.3"
      self."bunyan-0.8.0"
      self."ssh-agent-0.1.0"
    ];
  };

  "ssh-agent" = self."ssh-agent-0.1.0";

  "ssh-agent-0.1.0" = self.buildNodePackage rec {
    name = "ssh-agent-0.1.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/ssh-agent/-/${name}.tgz";
      sha256 = "62860d09a84d0bf1250d8c90aae3d0a922a7812591a9f4243330178774eb87b5";
    };
    deps = [
      self."ctype->=0.0.2"
    ];
  };

  "socket.io" = self."socket.io-0.9.6";

  "socket.io-0.9.6" = self.buildNodePackage rec {
    name = "socket.io-0.9.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io/-/${name}.tgz";
      sha256 = "444e346e2701e2212590461a1fcf656f5d685ceb209e473517603286f09e743c";
    };
    deps = [
      self."socket.io-client-0.9.6"
      self."policyfile-0.0.4"
      self."redis-0.6.7"
    ];
  };

  "socket.io-client" = self."socket.io-client-0.9.6";

  "socket.io-client-0.9.6" = self.buildNodePackage rec {
    name = "socket.io-client-0.9.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-client/-/${name}.tgz";
      sha256 = "eab65186515d5206fe18b9ced75aae8c803dbcd18295a9a1cb71e5ae772ba399";
    };
    deps = [
      self."uglify-js-1.2.5"
      self."ws-0.4.x"
      self."xmlhttprequest-1.2.2"
      self."active-x-obfuscator-0.0.1"
    ];
  };

  "sockjs" = self."sockjs-0.3.1";

  "sockjs-0.3.1" = self.buildNodePackage rec {
    name = "sockjs-0.3.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/sockjs/-/${name}.tgz";
      sha256 = "056476f23dbe2e2182e5edea755108a8b6dbaea4b675b228172e876c8649efdf";
    };
    deps = [
      self."node-uuid-1.3.3"
      self."faye-websocket-0.4.0"
      self."rbytes-0.0.2"
    ];
  };

  "source-map" = self."source-map-0.1.2";

  "source-map-0.1.2" = self.buildNodePackage rec {
    name = "source-map-0.1.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/source-map/-/${name}.tgz";
      sha256 = "4465bb3a293c0e86092affb7cbdd6d9356cad69231c56f6e73bba7750497035f";
    };
    deps = [
      self."requirejs-==0.26.0"
    ];
  };
  
  "swig" = self."swig-0.13.2";
  
  "swig-0.13.2" = self.buildNodePackage rec {
    name = "swig-0.13.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/swig/-/${name}.tgz";
      sha256 = "1fxc1cg0g5bn0ksm4gddx75ff5yzzbhqn4yqh6xqa5ag73nvxiyg";
    };
    deps = [
      self."underscore"
    ];
  };

  "tar" = self."tar-~0.1.12";

  "tar-~0.1.12" = self.buildNodePackage rec {
    name = "tar-0.1.13";
    src = fetchurl {
      url = "http://registry.npmjs.org/tar/-/${name}.tgz";
      sha256 = "fdf79b5e172badf924a12b501686e5cbf33c3ec7631eccc29c0e3e9fdcbb5ffe";
    };
    deps = [
      self."inherits-1.x"
      self."block-stream"
      self."fstream-~0.1.8"
    ];
  };

  "temp" = self."temp-*";

  "temp-*" = self.buildNodePackage rec {
    name = "temp-0.4.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/temp/-/${name}.tgz";
      sha256 = "ca8274250d36d94e670b8773bf062a28bc43eb342ae47ff629fbb627d48d710b";
    };
    deps = [

    ];
  };

  "timerstub" = self."timerstub-*";

  "timerstub-*" = self.buildNodePackage rec {
    name = "timerstub-0.1.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/timerstub/-/${name}.tgz";
      sha256 = "0ecbd05a10e0db1d628505c8a3b6ae07246bb8cf1074c435ddc26f22fcb5e153";
    };
    deps = [
      self."coffee-script-~1.1.2"
    ];
  };

  "tinycolor" = self."tinycolor-0.x";

  "tinycolor-0.x" = self.buildNodePackage rec {
    name = "tinycolor-0.0.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/tinycolor/-/${name}.tgz";
      sha256 = "f5aaf5df002750c4af19181988c8789c9e230445747e511dde7c660424f286a0";
    };
    deps = [

    ];
  };

  "uglify-js" = self."uglify-js-1.2.6";

  "uglify-js-1.2.5" = self.buildNodePackage rec {
    name = "uglify-js-1.2.5";
    src = fetchurl {
      url = "http://registry.npmjs.org/uglify-js/-/${name}.tgz";
      sha256 = "111fa1b844885b94df8cd73eb864bd96ff2e9173e8eb7045cc778fa237304a74";
    };
    deps = [

    ];
  };

  "uglify-js-1.2.6" = self.buildNodePackage rec {
    name = "uglify-js-1.2.6";
    src = fetchurl {
      url = "http://registry.npmjs.org/uglify-js/-/${name}.tgz";
      sha256 = "6d9202c8332e78868510a5441de4d54d8c2e08901ea7945eb332be8d7670788d";
    };
    deps = [

    ];
  };

  "underscore" = self."underscore-1.4.2";
  "underscore->=1.3.1" = self."underscore-1.4.2";

  "underscore-1.4.2" = self.buildNodePackage rec {
    name = "underscore-1.4.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/${name}.tgz";
      sha256 = "329ab22ba9b37be4a0c694ca21b9ed85b99256a45c2e0cf3624c4719443366d6";
    };
    deps = [

    ];
  };

  "vows" = self."vows->=0.5.4";

  "vows->=0.5.4" = self.buildNodePackage rec {
    name = "vows-0.6.4";
    src = fetchurl {
      url = "http://registry.npmjs.org/vows/-/${name}.tgz";
      sha256 = "017586c2fbdd5cd15aacdc870ea0c1b1ab60558306457ddc9b0aa4dae8290597";
    };
    deps = [
      self."eyes->=0.1.6"
      self."diff-~1.0.3"
    ];
  };

  "which" = self."which-1";

  "which-1" = self.buildNodePackage rec {
    name = "which-1.0.5";
    src = fetchurl {
      url = "http://registry.npmjs.org/which/-/${name}.tgz";
      sha256 = "e26f39d7b152c700636472ab4da57bfb9af17972c49a9e2a06f9ff347d8fad42";
    };
    deps = [

    ];
  };

  "wordwrap" = self."wordwrap-~0.0.2";

  "wordwrap-~0.0.2" = self.buildNodePackage rec {
    name = "wordwrap-0.0.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/wordwrap/-/${name}.tgz";
      sha256 = "66a2fa688509738922c3ad62a6159fe3c93268bd3bca2bff24df4bc02cc31582";
    };
    deps = [

    ];
  };

  "ws" = self."ws-0.4.x";
  "ws-0.4.x" = self."ws-0.4.21";

  "ws-0.4.21" = self.buildNodePackage rec {
    name = "ws-0.4.21";
    src = self.patchLatest {
      url = "http://registry.npmjs.org/ws/-/${name}.tgz";
      sha256 = "f21bc0058730355e1ff9d6ccf84a4cb56a2fc28e939edd15395770ea9e87fa0e";
    };
    deps = [
      self."commander-~0.6.1"
      self."tinycolor-0.x"
      self."options"
    ];
  };

  "wu" = self."wu-0.1.8";

  "wu-0.1.8" = self.buildNodePackage rec {
    name = "wu-0.1.8";
    src = fetchurl {
      url = "http://registry.npmjs.org/wu/-/${name}.tgz";
      sha256 = "2400d0ca7da862a9063a6a8d914bb4e585f81a5121b0fda8e40b1f6e782c72c6";
    };
    deps = [

    ];
  };

  "xmlhttprequest" = self."xmlhttprequest-1.2.2";

  "xmlhttprequest-1.2.2" = self.buildNodePackage rec {
    name = "xmlhttprequest-1.2.2";
    src = fetchurl {
      url = "http://registry.npmjs.org/xmlhttprequest/-/${name}.tgz";
      sha256 = "44ce4ed6e5f7b5df84f27590fa142ecd175f53da4807b9f06c0c4733e23bd95d";
    };
    deps = [

    ];
  };

  "zeparser" = self."zeparser-0.0.5";

  "zeparser-0.0.5" = self.buildNodePackage rec {
    name = "zeparser-0.0.5";
    src = fetchurl {
      url = "http://registry.npmjs.org/zeparser/-/${name}.tgz";
      sha256 = "8b5a57ae84a7b7adf8827d1469c8f66d08d1660bd1375a07381877cd1bb9ed0b";
    };
    deps = [

    ];
  };
};

in self

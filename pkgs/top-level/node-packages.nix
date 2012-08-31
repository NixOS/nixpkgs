{ pkgs, stdenv, nodejs, fetchurl }:

let self = {
  buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
    inherit stdenv nodejs;
  };

  "coffee-script" = self."coffee-script-1.3.3";

  "coffee-script-1.3.3" = self.buildNodePackage rec {
    name = "coffee-script-1.3.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/${name}.tgz";
      sha256 = "deedd2cf9d5abe2bad724e6809bec40efa07215dae85f44d78cd37736bb50bc5";
    };
    deps = [

    ];
  };

  "semver" = self."semver-1";

  "semver-1" = self.buildNodePackage rec {
    name = "semver-1.0.14";
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/${name}.tgz";
      sha256 = "560df522ae0e8834d8b07f6ca9c60bd8836e844642361abde108018cbe9ca82f";
    };
    deps = [

    ];
  };

  "npm2nix" = self."npm2nix-0.1.2";

  "npm2nix-0.1.2" = self.buildNodePackage rec {
    name = "npm2nix-0.1.2";
    src = fetchurl {
      url = https://bitbucket.org/shlevy/npm2nix/get/0.1.2.tar.gz;
      sha256 = "0wmgdbjvvwqv47113xdipzkmdafsca9av1s0fq605jf97wrpvbw3";
      name = "${name}.tgz";
    };
    deps = [
      self."semver-1"
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

  "nopt" = self."nopt-2";

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

  "graceful-fs" = self."graceful-fs-1";

  "graceful-fs-1" = self.buildNodePackage rec {
    name = "graceful-fs-1.1.10";
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/${name}.tgz";
      sha256 = "1f9b7da8b0c75db49e0e5d2aaecc6f1dd3fca2bdbb2aecf95d1dbdec7f0cee24";
    };
    deps = [

    ];
  };

  "fstream" = self."fstream-~0.1.13";

  "fstream-~0.1.13" = self.buildNodePackage rec {
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

  "abbrev" = self."abbrev-1";

  "abbrev-1" = self.buildNodePackage rec {
    name = "abbrev-1.0.3";
    src = fetchurl {
      url = "http://registry.npmjs.org/abbrev/-/${name}.tgz";
      sha256 = "d444c07f411418828a5e81ac85569afe638e6441a562086faa0209ec7bdf55f2";
    };
    deps = [

    ];
  };

  "graceful-fs-~1.1.2" = self.buildNodePackage rec {
    name = "graceful-fs-1.1.10";
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/${name}.tgz";
      sha256 = "1f9b7da8b0c75db49e0e5d2aaecc6f1dd3fca2bdbb2aecf95d1dbdec7f0cee24";
    };
    deps = [

    ];
  };

  "request" = self."request-2.9";

  "request-2.9" = self.buildNodePackage rec {
    name = "request-2.9.203";
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/${name}.tgz";
      sha256 = "2af8f83a63c7227383fbdd6114e470e0921af86a037c4e82f42883120f35f836";
    };
    deps = [

    ];
  };

  "inherits-~1.0.0" = self.buildNodePackage rec {
    name = "inherits-1.0.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/${name}.tgz";
      sha256 = "2be196fa6bc6a0c65fecd737af457589ef88b22a95d5dc31aab01d92ace48186";
    };
    deps = [

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

  "lru-cache" = self."lru-cache-~2.0.0";

  "lru-cache-~2.0.0" = self.buildNodePackage rec {
    name = "lru-cache-2.0.1";
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/${name}.tgz";
      sha256 = "3b4fd68f0bd75f5abf69e349b6ffa918bfe4990ff36d2d88dc74f334a9ed627e";
    };
    deps = [

    ];
  };

  "graceful-fs-~1.1" = self.buildNodePackage rec {
    name = "graceful-fs-1.1.10";
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/${name}.tgz";
      sha256 = "1f9b7da8b0c75db49e0e5d2aaecc6f1dd3fca2bdbb2aecf95d1dbdec7f0cee24";
    };
    deps = [

    ];
  };

  "inherits" = self."inherits-1";

  "inherits-1" = self.buildNodePackage rec {
    name = "inherits-1.0.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/${name}.tgz";
      sha256 = "2be196fa6bc6a0c65fecd737af457589ef88b22a95d5dc31aab01d92ace48186";
    };
    deps = [

    ];
  };

  "inherits-1.x" = self.buildNodePackage rec {
    name = "inherits-1.0.0";
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/${name}.tgz";
      sha256 = "2be196fa6bc6a0c65fecd737af457589ef88b22a95d5dc31aab01d92ace48186";
    };
    deps = [

    ];
  };

  "fstream-~0.1.8" = self.buildNodePackage rec {
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
};

in self

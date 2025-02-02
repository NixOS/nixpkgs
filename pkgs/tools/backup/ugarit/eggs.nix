{ eggDerivation, fetchegg }:
rec {
  aes = eggDerivation {
    name = "aes-1.5";

    src = fetchegg {
      name = "aes";
      version = "1.5";
      sha256 = "0gjlvz5nk0fnaclljpyfk21rkf0nidjj6wcv3jbnpmfafgjny5fi";
    };

    buildInputs = [
      
    ];
  };

  blob-utils = eggDerivation {
    name = "blob-utils-1.0.3";

    src = fetchegg {
      name = "blob-utils";
      version = "1.0.3";
      sha256 = "17vdn02fnxnjx5ixgqimln93lqvzyq4y9w02fw7xnbdcjzqm0xml";
    };

    buildInputs = [
      setup-helper
      string-utils
    ];
  };

  check-errors = eggDerivation {
    name = "check-errors-1.13.0";

    src = fetchegg {
      name = "check-errors";
      version = "1.13.0";
      sha256 = "12a0sn82n98jybh72zb39fdddmr5k4785xglxb16750fhy8rmjwi";
    };

    buildInputs = [
      setup-helper
    ];
  };

  crypto-tools = eggDerivation {
    name = "crypto-tools-1.3";

    src = fetchegg {
      name = "crypto-tools";
      version = "1.3";
      sha256 = "0442wly63zis19vh8xc9nhxgp9sabaccxylpzmchd5f1d48iag65";
    };

    buildInputs = [
      
    ];
  };

  foreigners = eggDerivation {
    name = "foreigners-1.4.1";

    src = fetchegg {
      name = "foreigners";
      version = "1.4.1";
      sha256 = "07nvyadhkd52q0kkvch1a5d7ivpmrhmyg295s4mxb1nw4wz46gfz";
    };

    buildInputs = [
      matchable
    ];
  };

  lookup-table = eggDerivation {
    name = "lookup-table-1.13.5";

    src = fetchegg {
      name = "lookup-table";
      version = "1.13.5";
      sha256 = "1nzly6rhynawlvzlyilk8z8cxz57cf9n5iv20glkhh28pz2izmrb";
    };

    buildInputs = [
      setup-helper
      check-errors
      miscmacros
      record-variants
      synch
    ];
  };

  lru-cache = eggDerivation {
    name = "lru-cache-0.5.3";

    src = fetchegg {
      name = "lru-cache";
      version = "0.5.3";
      sha256 = "0z6g3106c4j21v968hfzy9nnbfq2d83y0nyd20aifpq4g55c0d40";
    };

    buildInputs = [
      record-variants
    ];
  };

  matchable = eggDerivation {
    name = "matchable-3.3";

    src = fetchegg {
      name = "matchable";
      version = "3.3";
      sha256 = "07y3lpzgm4djiwi9y2adc796f9kwkmdr28fkfkw65syahdax8990";
    };

    buildInputs = [
      
    ];
  };

  message-digest = eggDerivation {
    name = "message-digest-3.1.0";

    src = fetchegg {
      name = "message-digest";
      version = "3.1.0";
      sha256 = "1w6bax19dwgih78vcimiws0rja7qsd8hmbm6qqg2hf9cw3vab21s";
    };

    buildInputs = [
      setup-helper
      miscmacros
      check-errors
      variable-item
      blob-utils
      string-utils
    ];
  };

  miscmacros = eggDerivation {
    name = "miscmacros-2.96";

    src = fetchegg {
      name = "miscmacros";
      version = "2.96";
      sha256 = "1ajdgjrni10i2hmhcp4rawnxajjxry3kmq1krdmah4sf0kjrgajc";
    };

    buildInputs = [
      
    ];
  };

  parley = eggDerivation {
    name = "parley-0.9.2";

    src = fetchegg {
      name = "parley";
      version = "0.9.2";
      sha256 = "1vsbx4dk1240gzq02slzmavd1jrq04qj7ssnvg15h8xh81xwhbbz";
    };

    buildInputs = [
      stty
      srfi-71
      miscmacros
    ];
  };

  pathname-expand = eggDerivation {
    name = "pathname-expand-0.1";

    src = fetchegg {
      name = "pathname-expand";
      version = "0.1";
      sha256 = "14llya7l04z49xpi3iylk8aglrw968vy304ymavhhqlyzmzwkx3g";
    };

    buildInputs = [
      
    ];
  };

  posix-extras = eggDerivation {
    name = "posix-extras-0.1.6";

    src = fetchegg {
      name = "posix-extras";
      version = "0.1.6";
      sha256 = "0gnmhn2l0161ham7f8i0lx1ay94ap8l8l7ga4nw9qs86lk024abi";
    };

    buildInputs = [
      
    ];
  };

  record-variants = eggDerivation {
    name = "record-variants-0.5.1";

    src = fetchegg {
      name = "record-variants";
      version = "0.5.1";
      sha256 = "15wgysxkm8m4hx9nhhw9akchzipdnqc7yj3qd3zn0z7sxg4sld1h";
    };

    buildInputs = [
      
    ];
  };

  regex = eggDerivation {
    name = "regex-1.0";

    src = fetchegg {
      name = "regex";
      version = "1.0";
      sha256 = "1z9bh7xvab6h5cdlsz8jk02pv5py1i6ryqarbcs3wdgkkjgmmkif";
    };

    buildInputs = [
      
    ];
  };

  setup-helper = eggDerivation {
    name = "setup-helper-1.5.5";

    src = fetchegg {
      name = "setup-helper";
      version = "1.5.5";
      sha256 = "1lpplp8f2wyc486dd98gs4wl1kkhh1cs6vdqkxrdk7f92ikmwbx3";
    };

    buildInputs = [
      
    ];
  };

  sha2 = eggDerivation {
    name = "sha2-3.1.0";

    src = fetchegg {
      name = "sha2";
      version = "3.1.0";
      sha256 = "01ch290f2kcv1yv8spjdaqwipl80vvgpqc4divsj3vxckvgkawq2";
    };

    buildInputs = [
      message-digest
    ];
  };

  sql-de-lite = eggDerivation {
    name = "sql-de-lite-0.6.6";

    src = fetchegg {
      name = "sql-de-lite";
      version = "0.6.6";
      sha256 = "1mh3hpsibq2gxcpjaycqa4ckznj268xpfzsa6pn0i6iac6my3qra";
    };

    buildInputs = [
      lru-cache
      foreigners
    ];
  };

  srfi-37 = eggDerivation {
    name = "srfi-37-1.3.1";

    src = fetchegg {
      name = "srfi-37";
      version = "1.3.1";
      sha256 = "1a2zdkdzrv15fw9dfdy8067fsgh4kr8ppffm8mc3cmlczrrd58cb";
    };

    buildInputs = [
      
    ];
  };

  srfi-71 = eggDerivation {
    name = "srfi-71-1.1";

    src = fetchegg {
      name = "srfi-71";
      version = "1.1";
      sha256 = "01mlaxw2lfczykmx69xki2s0f4ywlg794rl4kz07plvzn0s3fbqq";
    };

    buildInputs = [
      
    ];
  };

  ssql = eggDerivation {
    name = "ssql-0.2.4";

    src = fetchegg {
      name = "ssql";
      version = "0.2.4";
      sha256 = "0qhnghhx1wrvav4s7l780mspwlh8s6kzq4bl0cslwp1km90fx9bk";
    };

    buildInputs = [
      matchable
    ];
  };

  string-utils = eggDerivation {
    name = "string-utils-1.2.4";

    src = fetchegg {
      name = "string-utils";
      version = "1.2.4";
      sha256 = "07alvghg0dahilrm4jg44bndl0x69sv1zbna9l20cbdvi35i0jp1";
    };

    buildInputs = [
      setup-helper
      miscmacros
      lookup-table
      check-errors
    ];
  };

  stty = eggDerivation {
    name = "stty-0.2.6";

    src = fetchegg {
      name = "stty";
      version = "0.2.6";
      sha256 = "09jmjpdsd3yg6d0f0imcihmn49i28x09lgl60i2dllffs25k22s4";
    };

    buildInputs = [
      setup-helper
      foreigners
    ];
  };

  synch = eggDerivation {
    name = "synch-2.1.2";

    src = fetchegg {
      name = "synch";
      version = "2.1.2";
      sha256 = "1m9mnbq0m5jsxmd1a3rqpwpxj0l1b7vn1fknvxycc047pmlcyl00";
    };

    buildInputs = [
      setup-helper
      check-errors
    ];
  };

  tiger-hash = eggDerivation {
    name = "tiger-hash-3.1.0";

    src = fetchegg {
      name = "tiger-hash";
      version = "3.1.0";
      sha256 = "0j9dsbjp9cw0y4w4srg0qwgh53jw2v3mx4y4h040ds0fkxlzzknx";
    };

    buildInputs = [
      message-digest
    ];
  };

  ugarit = eggDerivation {
    name = "ugarit-2.0";

    src = fetchegg {
      name = "ugarit";
      version = "2.0";
      sha256 = "1l5zkr6b8l5dw9p5mimbva0ncqw1sbvp3d4cywm1hqx2m03a0f1n";
    };

    buildInputs = [
      miscmacros
      sql-de-lite
      crypto-tools
      srfi-37
      stty
      matchable
      regex
      tiger-hash
      message-digest
      posix-extras
      parley
      ssql
      pathname-expand
    ];
  };

  variable-item = eggDerivation {
    name = "variable-item-1.3.1";

    src = fetchegg {
      name = "variable-item";
      version = "1.3.1";
      sha256 = "19b3mhb8kr892sz9yyzq79l0vv28dgilw9cf415kj6aq16yp4d5n";
    };

    buildInputs = [
      setup-helper
      check-errors
    ];
  };

  bind = eggDerivation {
    name = "bind-1.5.2";

    src = fetchegg {
      name = "bind";
      version = "1.5.2";
      sha256 = "1x768k7dlfmkvgaf2idiaaqqgnqdnif5yb7ib6a6zndacbwz9jps";
    };

    buildInputs = [
      silex
      matchable
      coops
      regex
      make
    ];
  };

  coops = eggDerivation {
    name = "coops-1.93";

    src = fetchegg {
      name = "coops";
      version = "1.93";
      sha256 = "0mrkk7pmn9r691svzm4113mn0xsk36zi3f15m86n29a6c7897php";
    };

    buildInputs = [
      matchable
      record-variants
    ];
  };

  make = eggDerivation {
    name = "make-1.8";

    src = fetchegg {
      name = "make";
      version = "1.8";
      sha256 = "1w6xsjyapi2x8dv21dpidkyw1kjfsbasddn554xx561pi3i0yv9h";
    };

    buildInputs = [
      
    ];
  };

  silex = eggDerivation {
    name = "silex-1.4";

    src = fetchegg {
      name = "silex";
      version = "1.4";
      sha256 = "17x7f07aa3qnay3bhjr7knjivhycs54j97jyv3gjs1h8qnp63g00";
    };

    buildInputs = [
      
    ];
  };

  z3 = eggDerivation {
    name = "z3-1.44";

    src = fetchegg {
      name = "z3";
      version = "1.44";
      sha256 = "16ayp4zkgm332q4bmjj22acqg197aqp6d8ifyyjj205iv6k0f3x4";
    };

    buildInputs = [
      bind
    ];
  };
}

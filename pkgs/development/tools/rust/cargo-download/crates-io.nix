{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# adler32-1.0.2

  crates.adler32."1.0.2" = deps: { features?(features_.adler32."1.0.2" deps {}) }: buildRustCrate {
    crateName = "adler32";
    version = "1.0.2";
    description = "Minimal Adler32 implementation for Rust.";
    authors = [ "Remi Rampin <remirampin@gmail.com>" ];
    sha256 = "1974q3nysai026zhz24df506cxwi09jdzqksll4h7ibpb5n9g1d4";
  };
  features_.adler32."1.0.2" = deps: f: updateFeatures f ({
    adler32."1.0.2".default = (f.adler32."1.0.2".default or true);
  }) [];


# end
# aho-corasick-0.5.3

  crates.aho_corasick."0.5.3" = deps: { features?(features_.aho_corasick."0.5.3" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.5.3";
    description = "Fast multiple substring searching with finite state machines.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1igab46mvgknga3sxkqc917yfff0wsjxjzabdigmh240p5qxqlnn";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.5.3"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.5.3" = deps: f: updateFeatures f ({
    aho_corasick."0.5.3".default = (f.aho_corasick."0.5.3".default or true);
    memchr."${deps.aho_corasick."0.5.3".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.5.3"."memchr"}" deps)
  ];


# end
# ansi_term-0.9.0

  crates.ansi_term."0.9.0" = deps: { features?(features_.ansi_term."0.9.0" deps {}) }: buildRustCrate {
    crateName = "ansi_term";
    version = "0.9.0";
    description = "Library for ANSI terminal colours and styles (bold, underline)";
    authors = [ "ogham@bsago.me" "Ryan Scheel (Havvy) <ryan.havvy@gmail.com>" ];
    sha256 = "1vcd8m2hglrdi4zmqnkkz5zy3c73ifgii245k7vj6qr5dzpn9hij";
  };
  features_.ansi_term."0.9.0" = deps: f: updateFeatures f ({
    ansi_term."0.9.0".default = (f.ansi_term."0.9.0".default or true);
  }) [];


# end
# arrayvec-0.4.8

  crates.arrayvec."0.4.8" = deps: { features?(features_.arrayvec."0.4.8" deps {}) }: buildRustCrate {
    crateName = "arrayvec";
    version = "0.4.8";
    description = "A vector with fixed capacity, backed by an array (it can be stored on the stack too). Implements fixed capacity ArrayVec and ArrayString.";
    authors = [ "bluss" ];
    sha256 = "0zwpjdxgr0a11h9x7mkrif4wyx3c81b90paxjf326i86s13kib1g";
    dependencies = mapFeatures features ([
      (crates."nodrop"."${deps."arrayvec"."0.4.8"."nodrop"}" deps)
    ]);
    features = mkFeatures (features."arrayvec"."0.4.8" or {});
  };
  features_.arrayvec."0.4.8" = deps: f: updateFeatures f (rec {
    arrayvec = fold recursiveUpdate {} [
      { "0.4.8"."serde" =
        (f.arrayvec."0.4.8"."serde" or false) ||
        (f.arrayvec."0.4.8".serde-1 or false) ||
        (arrayvec."0.4.8"."serde-1" or false); }
      { "0.4.8"."std" =
        (f.arrayvec."0.4.8"."std" or false) ||
        (f.arrayvec."0.4.8".default or false) ||
        (arrayvec."0.4.8"."default" or false); }
      { "0.4.8".default = (f.arrayvec."0.4.8".default or true); }
    ];
    nodrop."${deps.arrayvec."0.4.8".nodrop}".default = (f.nodrop."${deps.arrayvec."0.4.8".nodrop}".default or false);
  }) [
    (features_.nodrop."${deps."arrayvec"."0.4.8"."nodrop"}" deps)
  ];


# end
# atty-0.2.3

  crates.atty."0.2.3" = deps: { features?(features_.atty."0.2.3" deps {}) }: buildRustCrate {
    crateName = "atty";
    version = "0.2.3";
    description = "A simple interface for querying atty";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "0zl0cjfgarp5y78nd755lpki5bbkj4hgmi88v265m543yg29i88f";
    dependencies = (if kernel == "redox" then mapFeatures features ([
      (crates."termion"."${deps."atty"."0.2.3"."termion"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."atty"."0.2.3"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."atty"."0.2.3"."kernel32_sys"}" deps)
      (crates."winapi"."${deps."atty"."0.2.3"."winapi"}" deps)
    ]) else []);
  };
  features_.atty."0.2.3" = deps: f: updateFeatures f ({
    atty."0.2.3".default = (f.atty."0.2.3".default or true);
    kernel32_sys."${deps.atty."0.2.3".kernel32_sys}".default = true;
    libc."${deps.atty."0.2.3".libc}".default = (f.libc."${deps.atty."0.2.3".libc}".default or false);
    termion."${deps.atty."0.2.3".termion}".default = true;
    winapi."${deps.atty."0.2.3".winapi}".default = true;
  }) [
    (features_.termion."${deps."atty"."0.2.3"."termion"}" deps)
    (features_.libc."${deps."atty"."0.2.3"."libc"}" deps)
    (features_.kernel32_sys."${deps."atty"."0.2.3"."kernel32_sys"}" deps)
    (features_.winapi."${deps."atty"."0.2.3"."winapi"}" deps)
  ];


# end
# base64-0.9.3

  crates.base64."0.9.3" = deps: { features?(features_.base64."0.9.3" deps {}) }: buildRustCrate {
    crateName = "base64";
    version = "0.9.3";
    description = "encodes and decodes base64 as bytes or utf8";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "11hhz8ln4zbpn2h2gm9fbbb9j254wrd4fpmddlyah2rrnqsmmqkd";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."base64"."0.9.3"."byteorder"}" deps)
      (crates."safemem"."${deps."base64"."0.9.3"."safemem"}" deps)
    ]);
  };
  features_.base64."0.9.3" = deps: f: updateFeatures f ({
    base64."0.9.3".default = (f.base64."0.9.3".default or true);
    byteorder."${deps.base64."0.9.3".byteorder}".default = true;
    safemem."${deps.base64."0.9.3".safemem}".default = true;
  }) [
    (features_.byteorder."${deps."base64"."0.9.3"."byteorder"}" deps)
    (features_.safemem."${deps."base64"."0.9.3"."safemem"}" deps)
  ];


# end
# bitflags-0.7.0

  crates.bitflags."0.7.0" = deps: { features?(features_.bitflags."0.7.0" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.7.0";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1hr72xg5slm0z4pxs2hiy4wcyx3jva70h58b7mid8l0a4c8f7gn5";
  };
  features_.bitflags."0.7.0" = deps: f: updateFeatures f ({
    bitflags."0.7.0".default = (f.bitflags."0.7.0".default or true);
  }) [];


# end
# bitflags-0.9.1

  crates.bitflags."0.9.1" = deps: { features?(features_.bitflags."0.9.1" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.9.1";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "18h073l5jd88rx4qdr95fjddr9rk79pb1aqnshzdnw16cfmb9rws";
    features = mkFeatures (features."bitflags"."0.9.1" or {});
  };
  features_.bitflags."0.9.1" = deps: f: updateFeatures f (rec {
    bitflags = fold recursiveUpdate {} [
      { "0.9.1"."example_generated" =
        (f.bitflags."0.9.1"."example_generated" or false) ||
        (f.bitflags."0.9.1".default or false) ||
        (bitflags."0.9.1"."default" or false); }
      { "0.9.1".default = (f.bitflags."0.9.1".default or true); }
    ];
  }) [];


# end
# bitflags-1.0.4

  crates.bitflags."1.0.4" = deps: { features?(features_.bitflags."1.0.4" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.0.4";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1g1wmz2001qmfrd37dnd5qiss5njrw26aywmg6yhkmkbyrhjxb08";
    features = mkFeatures (features."bitflags"."1.0.4" or {});
  };
  features_.bitflags."1.0.4" = deps: f: updateFeatures f ({
    bitflags."1.0.4".default = (f.bitflags."1.0.4".default or true);
  }) [];


# end
# byteorder-1.1.0

  crates.byteorder."1.1.0" = deps: { features?(features_.byteorder."1.1.0" deps {}) }: buildRustCrate {
    crateName = "byteorder";
    version = "1.1.0";
    description = "Library for reading/writing numbers in big-endian and little-endian.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1i2n0161jm00zvzh4bncgv9zrwa6ydbxdn5j4bx0wwn7rvi9zycp";
    features = mkFeatures (features."byteorder"."1.1.0" or {});
  };
  features_.byteorder."1.1.0" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "1.1.0"."std" =
        (f.byteorder."1.1.0"."std" or false) ||
        (f.byteorder."1.1.0".default or false) ||
        (byteorder."1.1.0"."default" or false); }
      { "1.1.0".default = (f.byteorder."1.1.0".default or true); }
    ];
  }) [];


# end
# bytes-0.4.11

  crates.bytes."0.4.11" = deps: { features?(features_.bytes."0.4.11" deps {}) }: buildRustCrate {
    crateName = "bytes";
    version = "0.4.11";
    description = "Types and traits for working with bytes";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1lk8bnxcd8shiizarf0n6ljmj1542n90jw6lz6i270gxl7rzplmh";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."bytes"."0.4.11"."byteorder"}" deps)
      (crates."iovec"."${deps."bytes"."0.4.11"."iovec"}" deps)
    ]);
    features = mkFeatures (features."bytes"."0.4.11" or {});
  };
  features_.bytes."0.4.11" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "${deps.bytes."0.4.11".byteorder}"."i128" =
        (f.byteorder."${deps.bytes."0.4.11".byteorder}"."i128" or false) ||
        (bytes."0.4.11"."i128" or false) ||
        (f."bytes"."0.4.11"."i128" or false); }
      { "${deps.bytes."0.4.11".byteorder}".default = true; }
    ];
    bytes."0.4.11".default = (f.bytes."0.4.11".default or true);
    iovec."${deps.bytes."0.4.11".iovec}".default = true;
  }) [
    (features_.byteorder."${deps."bytes"."0.4.11"."byteorder"}" deps)
    (features_.iovec."${deps."bytes"."0.4.11"."iovec"}" deps)
  ];


# end
# cargo-download-0.1.2

  crates.cargo_download."0.1.2" = deps: { features?(features_.cargo_download."0.1.2" deps {}) }: buildRustCrate {
    crateName = "cargo-download";
    version = "0.1.2";
    description = "Cargo subcommand for downloading crate sources";
    authors = [ "Karol Kuczmarski <karol.kuczmarski@gmail.com>" ];
    sha256 = "1gfn0iabiriq0n9sqkyp2g73rw12mr9ng61fx198xaffflxk7g36";
    crateBin =
      [{  name = "cargo-download"; }];
    dependencies = mapFeatures features ([
      (crates."ansi_term"."${deps."cargo_download"."0.1.2"."ansi_term"}" deps)
      (crates."clap"."${deps."cargo_download"."0.1.2"."clap"}" deps)
      (crates."conv"."${deps."cargo_download"."0.1.2"."conv"}" deps)
      (crates."derive_error"."${deps."cargo_download"."0.1.2"."derive_error"}" deps)
      (crates."exitcode"."${deps."cargo_download"."0.1.2"."exitcode"}" deps)
      (crates."flate2"."${deps."cargo_download"."0.1.2"."flate2"}" deps)
      (crates."isatty"."${deps."cargo_download"."0.1.2"."isatty"}" deps)
      (crates."itertools"."${deps."cargo_download"."0.1.2"."itertools"}" deps)
      (crates."lazy_static"."${deps."cargo_download"."0.1.2"."lazy_static"}" deps)
      (crates."log"."${deps."cargo_download"."0.1.2"."log"}" deps)
      (crates."maplit"."${deps."cargo_download"."0.1.2"."maplit"}" deps)
      (crates."reqwest"."${deps."cargo_download"."0.1.2"."reqwest"}" deps)
      (crates."semver"."${deps."cargo_download"."0.1.2"."semver"}" deps)
      (crates."serde_json"."${deps."cargo_download"."0.1.2"."serde_json"}" deps)
      (crates."slog"."${deps."cargo_download"."0.1.2"."slog"}" deps)
      (crates."slog_envlogger"."${deps."cargo_download"."0.1.2"."slog_envlogger"}" deps)
      (crates."slog_stdlog"."${deps."cargo_download"."0.1.2"."slog_stdlog"}" deps)
      (crates."slog_stream"."${deps."cargo_download"."0.1.2"."slog_stream"}" deps)
      (crates."tar"."${deps."cargo_download"."0.1.2"."tar"}" deps)
      (crates."time"."${deps."cargo_download"."0.1.2"."time"}" deps)
    ]);
  };
  features_.cargo_download."0.1.2" = deps: f: updateFeatures f ({
    ansi_term."${deps.cargo_download."0.1.2".ansi_term}".default = true;
    cargo_download."0.1.2".default = (f.cargo_download."0.1.2".default or true);
    clap."${deps.cargo_download."0.1.2".clap}".default = true;
    conv."${deps.cargo_download."0.1.2".conv}".default = true;
    derive_error."${deps.cargo_download."0.1.2".derive_error}".default = true;
    exitcode."${deps.cargo_download."0.1.2".exitcode}".default = true;
    flate2."${deps.cargo_download."0.1.2".flate2}".default = true;
    isatty."${deps.cargo_download."0.1.2".isatty}".default = true;
    itertools."${deps.cargo_download."0.1.2".itertools}".default = true;
    lazy_static."${deps.cargo_download."0.1.2".lazy_static}".default = true;
    log."${deps.cargo_download."0.1.2".log}".default = true;
    maplit."${deps.cargo_download."0.1.2".maplit}".default = true;
    reqwest."${deps.cargo_download."0.1.2".reqwest}".default = true;
    semver."${deps.cargo_download."0.1.2".semver}".default = true;
    serde_json."${deps.cargo_download."0.1.2".serde_json}".default = true;
    slog."${deps.cargo_download."0.1.2".slog}".default = true;
    slog_envlogger."${deps.cargo_download."0.1.2".slog_envlogger}".default = true;
    slog_stdlog."${deps.cargo_download."0.1.2".slog_stdlog}".default = true;
    slog_stream."${deps.cargo_download."0.1.2".slog_stream}".default = true;
    tar."${deps.cargo_download."0.1.2".tar}".default = true;
    time."${deps.cargo_download."0.1.2".time}".default = true;
  }) [
    (features_.ansi_term."${deps."cargo_download"."0.1.2"."ansi_term"}" deps)
    (features_.clap."${deps."cargo_download"."0.1.2"."clap"}" deps)
    (features_.conv."${deps."cargo_download"."0.1.2"."conv"}" deps)
    (features_.derive_error."${deps."cargo_download"."0.1.2"."derive_error"}" deps)
    (features_.exitcode."${deps."cargo_download"."0.1.2"."exitcode"}" deps)
    (features_.flate2."${deps."cargo_download"."0.1.2"."flate2"}" deps)
    (features_.isatty."${deps."cargo_download"."0.1.2"."isatty"}" deps)
    (features_.itertools."${deps."cargo_download"."0.1.2"."itertools"}" deps)
    (features_.lazy_static."${deps."cargo_download"."0.1.2"."lazy_static"}" deps)
    (features_.log."${deps."cargo_download"."0.1.2"."log"}" deps)
    (features_.maplit."${deps."cargo_download"."0.1.2"."maplit"}" deps)
    (features_.reqwest."${deps."cargo_download"."0.1.2"."reqwest"}" deps)
    (features_.semver."${deps."cargo_download"."0.1.2"."semver"}" deps)
    (features_.serde_json."${deps."cargo_download"."0.1.2"."serde_json"}" deps)
    (features_.slog."${deps."cargo_download"."0.1.2"."slog"}" deps)
    (features_.slog_envlogger."${deps."cargo_download"."0.1.2"."slog_envlogger"}" deps)
    (features_.slog_stdlog."${deps."cargo_download"."0.1.2"."slog_stdlog"}" deps)
    (features_.slog_stream."${deps."cargo_download"."0.1.2"."slog_stream"}" deps)
    (features_.tar."${deps."cargo_download"."0.1.2"."tar"}" deps)
    (features_.time."${deps."cargo_download"."0.1.2"."time"}" deps)
  ];


# end
# case-0.1.0

  crates.case."0.1.0" = deps: { features?(features_.case."0.1.0" deps {}) }: buildRustCrate {
    crateName = "case";
    version = "0.1.0";
    description = "A set of letter case string helpers";
    authors = [ "Skyler Lipthay <skyler.lipthay@gmail.com>" ];
    sha256 = "06i1x3wqv30rkvlgj134qf9vzxhzz28bz41mm0rgki0i0f7gf96n";
  };
  features_.case."0.1.0" = deps: f: updateFeatures f ({
    case."0.1.0".default = (f.case."0.1.0".default or true);
  }) [];


# end
# cc-1.0.3

  crates.cc."1.0.3" = deps: { features?(features_.cc."1.0.3" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.3";
    description = "A build-time dependency for Cargo build scripts to assist in invoking the native\nC compiler to compile native C code into a static archive to be linked into Rust\ncode.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "193pwqgh79w6k0k29svyds5nnlrwx44myqyrw605d5jj4yk2zmpr";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.3" or {});
  };
  features_.cc."1.0.3" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.3"."rayon" =
        (f.cc."1.0.3"."rayon" or false) ||
        (f.cc."1.0.3".parallel or false) ||
        (cc."1.0.3"."parallel" or false); }
      { "1.0.3".default = (f.cc."1.0.3".default or true); }
    ];
  }) [];


# end
# cfg-if-0.1.2

  crates.cfg_if."0.1.2" = deps: { features?(features_.cfg_if."0.1.2" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.2";
    description = "A macro to ergonomically define an item depending on a large number of #[cfg]\nparameters. Structured like an if-else chain, the first matching branch is the\nitem that gets emitted.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0x06hvrrqy96m97593823vvxcgvjaxckghwyy2jcyc8qc7c6cyhi";
  };
  features_.cfg_if."0.1.2" = deps: f: updateFeatures f ({
    cfg_if."0.1.2".default = (f.cfg_if."0.1.2".default or true);
  }) [];


# end
# chrono-0.2.25

  crates.chrono."0.2.25" = deps: { features?(features_.chrono."0.2.25" deps {}) }: buildRustCrate {
    crateName = "chrono";
    version = "0.2.25";
    description = "Date and time library for Rust";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "0gsvqk8cnmm43qj3xyngqvfqh50cbdbqas7ik0wjgnvknirmmca7";
    dependencies = mapFeatures features ([
      (crates."num"."${deps."chrono"."0.2.25"."num"}" deps)
      (crates."time"."${deps."chrono"."0.2.25"."time"}" deps)
    ]);
  };
  features_.chrono."0.2.25" = deps: f: updateFeatures f ({
    chrono."0.2.25".default = (f.chrono."0.2.25".default or true);
    num."${deps.chrono."0.2.25".num}".default = (f.num."${deps.chrono."0.2.25".num}".default or false);
    time."${deps.chrono."0.2.25".time}".default = true;
  }) [
    (features_.num."${deps."chrono"."0.2.25"."num"}" deps)
    (features_.time."${deps."chrono"."0.2.25"."time"}" deps)
  ];


# end
# clap-2.27.1

  crates.clap."2.27.1" = deps: { features?(features_.clap."2.27.1" deps {}) }: buildRustCrate {
    crateName = "clap";
    version = "2.27.1";
    description = "A simple to use, efficient, and full featured  Command Line Argument Parser\n";
    authors = [ "Kevin K. <kbknapp@gmail.com>" ];
    sha256 = "0zx8rskqfl3iqn3vlyxzyd99hpifa7bm871akhxpz9wvrm688zaj";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."clap"."2.27.1"."bitflags"}" deps)
      (crates."textwrap"."${deps."clap"."2.27.1"."textwrap"}" deps)
      (crates."unicode_width"."${deps."clap"."2.27.1"."unicode_width"}" deps)
    ]
      ++ (if features.clap."2.27.1".ansi_term or false then [ (crates.ansi_term."${deps."clap"."2.27.1".ansi_term}" deps) ] else [])
      ++ (if features.clap."2.27.1".atty or false then [ (crates.atty."${deps."clap"."2.27.1".atty}" deps) ] else [])
      ++ (if features.clap."2.27.1".strsim or false then [ (crates.strsim."${deps."clap"."2.27.1".strsim}" deps) ] else [])
      ++ (if features.clap."2.27.1".vec_map or false then [ (crates.vec_map."${deps."clap"."2.27.1".vec_map}" deps) ] else []));
    features = mkFeatures (features."clap"."2.27.1" or {});
  };
  features_.clap."2.27.1" = deps: f: updateFeatures f (rec {
    ansi_term."${deps.clap."2.27.1".ansi_term}".default = true;
    atty."${deps.clap."2.27.1".atty}".default = true;
    bitflags."${deps.clap."2.27.1".bitflags}".default = true;
    clap = fold recursiveUpdate {} [
      { "2.27.1"."ansi_term" =
        (f.clap."2.27.1"."ansi_term" or false) ||
        (f.clap."2.27.1".color or false) ||
        (clap."2.27.1"."color" or false); }
      { "2.27.1"."atty" =
        (f.clap."2.27.1"."atty" or false) ||
        (f.clap."2.27.1".color or false) ||
        (clap."2.27.1"."color" or false); }
      { "2.27.1"."clippy" =
        (f.clap."2.27.1"."clippy" or false) ||
        (f.clap."2.27.1".lints or false) ||
        (clap."2.27.1"."lints" or false); }
      { "2.27.1"."color" =
        (f.clap."2.27.1"."color" or false) ||
        (f.clap."2.27.1".default or false) ||
        (clap."2.27.1"."default" or false); }
      { "2.27.1"."strsim" =
        (f.clap."2.27.1"."strsim" or false) ||
        (f.clap."2.27.1".suggestions or false) ||
        (clap."2.27.1"."suggestions" or false); }
      { "2.27.1"."suggestions" =
        (f.clap."2.27.1"."suggestions" or false) ||
        (f.clap."2.27.1".default or false) ||
        (clap."2.27.1"."default" or false); }
      { "2.27.1"."term_size" =
        (f.clap."2.27.1"."term_size" or false) ||
        (f.clap."2.27.1".wrap_help or false) ||
        (clap."2.27.1"."wrap_help" or false); }
      { "2.27.1"."vec_map" =
        (f.clap."2.27.1"."vec_map" or false) ||
        (f.clap."2.27.1".default or false) ||
        (clap."2.27.1"."default" or false); }
      { "2.27.1"."yaml" =
        (f.clap."2.27.1"."yaml" or false) ||
        (f.clap."2.27.1".doc or false) ||
        (clap."2.27.1"."doc" or false); }
      { "2.27.1"."yaml-rust" =
        (f.clap."2.27.1"."yaml-rust" or false) ||
        (f.clap."2.27.1".yaml or false) ||
        (clap."2.27.1"."yaml" or false); }
      { "2.27.1".default = (f.clap."2.27.1".default or true); }
    ];
    strsim."${deps.clap."2.27.1".strsim}".default = true;
    textwrap = fold recursiveUpdate {} [
      { "${deps.clap."2.27.1".textwrap}"."term_size" =
        (f.textwrap."${deps.clap."2.27.1".textwrap}"."term_size" or false) ||
        (clap."2.27.1"."wrap_help" or false) ||
        (f."clap"."2.27.1"."wrap_help" or false); }
      { "${deps.clap."2.27.1".textwrap}".default = true; }
    ];
    unicode_width."${deps.clap."2.27.1".unicode_width}".default = true;
    vec_map."${deps.clap."2.27.1".vec_map}".default = true;
  }) [
    (features_.ansi_term."${deps."clap"."2.27.1"."ansi_term"}" deps)
    (features_.atty."${deps."clap"."2.27.1"."atty"}" deps)
    (features_.bitflags."${deps."clap"."2.27.1"."bitflags"}" deps)
    (features_.strsim."${deps."clap"."2.27.1"."strsim"}" deps)
    (features_.textwrap."${deps."clap"."2.27.1"."textwrap"}" deps)
    (features_.unicode_width."${deps."clap"."2.27.1"."unicode_width"}" deps)
    (features_.vec_map."${deps."clap"."2.27.1"."vec_map"}" deps)
  ];


# end
# cloudabi-0.0.3

  crates.cloudabi."0.0.3" = deps: { features?(features_.cloudabi."0.0.3" deps {}) }: buildRustCrate {
    crateName = "cloudabi";
    version = "0.0.3";
    description = "Low level interface to CloudABI. Contains all syscalls and related types.";
    authors = [ "Nuxi (https://nuxi.nl/) and contributors" ];
    sha256 = "1z9lby5sr6vslfd14d6igk03s7awf91mxpsfmsp3prxbxlk0x7h5";
    libPath = "cloudabi.rs";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.cloudabi."0.0.3".bitflags or false then [ (crates.bitflags."${deps."cloudabi"."0.0.3".bitflags}" deps) ] else []));
    features = mkFeatures (features."cloudabi"."0.0.3" or {});
  };
  features_.cloudabi."0.0.3" = deps: f: updateFeatures f (rec {
    bitflags."${deps.cloudabi."0.0.3".bitflags}".default = true;
    cloudabi = fold recursiveUpdate {} [
      { "0.0.3"."bitflags" =
        (f.cloudabi."0.0.3"."bitflags" or false) ||
        (f.cloudabi."0.0.3".default or false) ||
        (cloudabi."0.0.3"."default" or false); }
      { "0.0.3".default = (f.cloudabi."0.0.3".default or true); }
    ];
  }) [
    (features_.bitflags."${deps."cloudabi"."0.0.3"."bitflags"}" deps)
  ];


# end
# conv-0.3.3

  crates.conv."0.3.3" = deps: { features?(features_.conv."0.3.3" deps {}) }: buildRustCrate {
    crateName = "conv";
    version = "0.3.3";
    description = "This crate provides a number of conversion traits with more specific semantics than those provided by 'as' or 'From'/'Into'.";
    authors = [ "Daniel Keep <daniel.keep@gmail.com>" ];
    sha256 = "08rl72k1a48xah0ar5l9v1bw19pp8jdw2pdkd3vvj9ijsyyg9yik";
    dependencies = mapFeatures features ([
      (crates."custom_derive"."${deps."conv"."0.3.3"."custom_derive"}" deps)
    ]);
  };
  features_.conv."0.3.3" = deps: f: updateFeatures f ({
    conv."0.3.3".default = (f.conv."0.3.3".default or true);
    custom_derive."${deps.conv."0.3.3".custom_derive}".default = true;
  }) [
    (features_.custom_derive."${deps."conv"."0.3.3"."custom_derive"}" deps)
  ];


# end
# core-foundation-0.5.1

  crates.core_foundation."0.5.1" = deps: { features?(features_.core_foundation."0.5.1" deps {}) }: buildRustCrate {
    crateName = "core-foundation";
    version = "0.5.1";
    description = "Bindings to Core Foundation for OS X";
    authors = [ "The Servo Project Developers" ];
    sha256 = "03s11z23rb1kk325c34rmsbd7k0l5rkzk4q6id55n174z28zqln1";
    dependencies = mapFeatures features ([
      (crates."core_foundation_sys"."${deps."core_foundation"."0.5.1"."core_foundation_sys"}" deps)
      (crates."libc"."${deps."core_foundation"."0.5.1"."libc"}" deps)
    ]);
    features = mkFeatures (features."core_foundation"."0.5.1" or {});
  };
  features_.core_foundation."0.5.1" = deps: f: updateFeatures f (rec {
    core_foundation = fold recursiveUpdate {} [
      { "0.5.1"."chrono" =
        (f.core_foundation."0.5.1"."chrono" or false) ||
        (f.core_foundation."0.5.1".with-chrono or false) ||
        (core_foundation."0.5.1"."with-chrono" or false); }
      { "0.5.1"."uuid" =
        (f.core_foundation."0.5.1"."uuid" or false) ||
        (f.core_foundation."0.5.1".with-uuid or false) ||
        (core_foundation."0.5.1"."with-uuid" or false); }
      { "0.5.1".default = (f.core_foundation."0.5.1".default or true); }
    ];
    core_foundation_sys = fold recursiveUpdate {} [
      { "${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_7_support" =
        (f.core_foundation_sys."${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_7_support" or false) ||
        (core_foundation."0.5.1"."mac_os_10_7_support" or false) ||
        (f."core_foundation"."0.5.1"."mac_os_10_7_support" or false); }
      { "${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_8_features" =
        (f.core_foundation_sys."${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_8_features" or false) ||
        (core_foundation."0.5.1"."mac_os_10_8_features" or false) ||
        (f."core_foundation"."0.5.1"."mac_os_10_8_features" or false); }
      { "${deps.core_foundation."0.5.1".core_foundation_sys}".default = true; }
    ];
    libc."${deps.core_foundation."0.5.1".libc}".default = true;
  }) [
    (features_.core_foundation_sys."${deps."core_foundation"."0.5.1"."core_foundation_sys"}" deps)
    (features_.libc."${deps."core_foundation"."0.5.1"."libc"}" deps)
  ];


# end
# core-foundation-sys-0.5.1

  crates.core_foundation_sys."0.5.1" = deps: { features?(features_.core_foundation_sys."0.5.1" deps {}) }: buildRustCrate {
    crateName = "core-foundation-sys";
    version = "0.5.1";
    description = "Bindings to Core Foundation for OS X";
    authors = [ "The Servo Project Developers" ];
    sha256 = "0qbrasll5nw1bgr071i8s8jc975d0y4qfysf868bh9xp0f6vcypa";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."core_foundation_sys"."0.5.1"."libc"}" deps)
    ]);
    features = mkFeatures (features."core_foundation_sys"."0.5.1" or {});
  };
  features_.core_foundation_sys."0.5.1" = deps: f: updateFeatures f ({
    core_foundation_sys."0.5.1".default = (f.core_foundation_sys."0.5.1".default or true);
    libc."${deps.core_foundation_sys."0.5.1".libc}".default = true;
  }) [
    (features_.libc."${deps."core_foundation_sys"."0.5.1"."libc"}" deps)
  ];


# end
# crc32fast-1.1.1

  crates.crc32fast."1.1.1" = deps: { features?(features_.crc32fast."1.1.1" deps {}) }: buildRustCrate {
    crateName = "crc32fast";
    version = "1.1.1";
    description = "Fast, SIMD-accelerated CRC32 (IEEE) checksum computation";
    authors = [ "Sam Rijs <srijs@airpost.net>" "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1rwvhb98w41mk5phr84mryally58f68h0v933772gdxqvqbcayqy";
  };
  features_.crc32fast."1.1.1" = deps: f: updateFeatures f ({
    crc32fast."1.1.1".default = (f.crc32fast."1.1.1".default or true);
  }) [];


# end
# crossbeam-0.2.10

  crates.crossbeam."0.2.10" = deps: { features?(features_.crossbeam."0.2.10" deps {}) }: buildRustCrate {
    crateName = "crossbeam";
    version = "0.2.10";
    description = "Support for lock-free data structures, synchronizers, and parallel programming";
    authors = [ "Aaron Turon <aturon@mozilla.com>" ];
    sha256 = "1k1a4q5gy7zakiw39hdzrblnw3kk4nsqmkdp1dpzh8h558140rhq";
    features = mkFeatures (features."crossbeam"."0.2.10" or {});
  };
  features_.crossbeam."0.2.10" = deps: f: updateFeatures f ({
    crossbeam."0.2.10".default = (f.crossbeam."0.2.10".default or true);
  }) [];


# end
# crossbeam-deque-0.6.2

  crates.crossbeam_deque."0.6.2" = deps: { features?(features_.crossbeam_deque."0.6.2" deps {}) }: buildRustCrate {
    crateName = "crossbeam-deque";
    version = "0.6.2";
    description = "Concurrent work-stealing deque";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "0qjdpq03snj6xp5gydgy1bdd5zzwpdxa57vhky3mf4djxiq81ara";
    dependencies = mapFeatures features ([
      (crates."crossbeam_epoch"."${deps."crossbeam_deque"."0.6.2"."crossbeam_epoch"}" deps)
      (crates."crossbeam_utils"."${deps."crossbeam_deque"."0.6.2"."crossbeam_utils"}" deps)
    ]);
  };
  features_.crossbeam_deque."0.6.2" = deps: f: updateFeatures f ({
    crossbeam_deque."0.6.2".default = (f.crossbeam_deque."0.6.2".default or true);
    crossbeam_epoch."${deps.crossbeam_deque."0.6.2".crossbeam_epoch}".default = true;
    crossbeam_utils."${deps.crossbeam_deque."0.6.2".crossbeam_utils}".default = true;
  }) [
    (features_.crossbeam_epoch."${deps."crossbeam_deque"."0.6.2"."crossbeam_epoch"}" deps)
    (features_.crossbeam_utils."${deps."crossbeam_deque"."0.6.2"."crossbeam_utils"}" deps)
  ];


# end
# crossbeam-epoch-0.6.1

  crates.crossbeam_epoch."0.6.1" = deps: { features?(features_.crossbeam_epoch."0.6.1" deps {}) }: buildRustCrate {
    crateName = "crossbeam-epoch";
    version = "0.6.1";
    description = "Epoch-based garbage collection";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "0qlwzsf2xmdjbh6pv9bxra2qdq72cmywq4fq1q114zw2s06zr039";
    dependencies = mapFeatures features ([
      (crates."arrayvec"."${deps."crossbeam_epoch"."0.6.1"."arrayvec"}" deps)
      (crates."cfg_if"."${deps."crossbeam_epoch"."0.6.1"."cfg_if"}" deps)
      (crates."crossbeam_utils"."${deps."crossbeam_epoch"."0.6.1"."crossbeam_utils"}" deps)
      (crates."memoffset"."${deps."crossbeam_epoch"."0.6.1"."memoffset"}" deps)
      (crates."scopeguard"."${deps."crossbeam_epoch"."0.6.1"."scopeguard"}" deps)
    ]
      ++ (if features.crossbeam_epoch."0.6.1".lazy_static or false then [ (crates.lazy_static."${deps."crossbeam_epoch"."0.6.1".lazy_static}" deps) ] else []));
    features = mkFeatures (features."crossbeam_epoch"."0.6.1" or {});
  };
  features_.crossbeam_epoch."0.6.1" = deps: f: updateFeatures f (rec {
    arrayvec = fold recursiveUpdate {} [
      { "${deps.crossbeam_epoch."0.6.1".arrayvec}"."use_union" =
        (f.arrayvec."${deps.crossbeam_epoch."0.6.1".arrayvec}"."use_union" or false) ||
        (crossbeam_epoch."0.6.1"."nightly" or false) ||
        (f."crossbeam_epoch"."0.6.1"."nightly" or false); }
      { "${deps.crossbeam_epoch."0.6.1".arrayvec}".default = (f.arrayvec."${deps.crossbeam_epoch."0.6.1".arrayvec}".default or false); }
    ];
    cfg_if."${deps.crossbeam_epoch."0.6.1".cfg_if}".default = true;
    crossbeam_epoch = fold recursiveUpdate {} [
      { "0.6.1"."lazy_static" =
        (f.crossbeam_epoch."0.6.1"."lazy_static" or false) ||
        (f.crossbeam_epoch."0.6.1".std or false) ||
        (crossbeam_epoch."0.6.1"."std" or false); }
      { "0.6.1"."std" =
        (f.crossbeam_epoch."0.6.1"."std" or false) ||
        (f.crossbeam_epoch."0.6.1".default or false) ||
        (crossbeam_epoch."0.6.1"."default" or false); }
      { "0.6.1".default = (f.crossbeam_epoch."0.6.1".default or true); }
    ];
    crossbeam_utils = fold recursiveUpdate {} [
      { "${deps.crossbeam_epoch."0.6.1".crossbeam_utils}"."std" =
        (f.crossbeam_utils."${deps.crossbeam_epoch."0.6.1".crossbeam_utils}"."std" or false) ||
        (crossbeam_epoch."0.6.1"."std" or false) ||
        (f."crossbeam_epoch"."0.6.1"."std" or false); }
      { "${deps.crossbeam_epoch."0.6.1".crossbeam_utils}".default = (f.crossbeam_utils."${deps.crossbeam_epoch."0.6.1".crossbeam_utils}".default or false); }
    ];
    lazy_static."${deps.crossbeam_epoch."0.6.1".lazy_static}".default = true;
    memoffset."${deps.crossbeam_epoch."0.6.1".memoffset}".default = true;
    scopeguard."${deps.crossbeam_epoch."0.6.1".scopeguard}".default = (f.scopeguard."${deps.crossbeam_epoch."0.6.1".scopeguard}".default or false);
  }) [
    (features_.arrayvec."${deps."crossbeam_epoch"."0.6.1"."arrayvec"}" deps)
    (features_.cfg_if."${deps."crossbeam_epoch"."0.6.1"."cfg_if"}" deps)
    (features_.crossbeam_utils."${deps."crossbeam_epoch"."0.6.1"."crossbeam_utils"}" deps)
    (features_.lazy_static."${deps."crossbeam_epoch"."0.6.1"."lazy_static"}" deps)
    (features_.memoffset."${deps."crossbeam_epoch"."0.6.1"."memoffset"}" deps)
    (features_.scopeguard."${deps."crossbeam_epoch"."0.6.1"."scopeguard"}" deps)
  ];


# end
# crossbeam-utils-0.6.1

  crates.crossbeam_utils."0.6.1" = deps: { features?(features_.crossbeam_utils."0.6.1" deps {}) }: buildRustCrate {
    crateName = "crossbeam-utils";
    version = "0.6.1";
    description = "Utilities for concurrent programming";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "031lk6ls49yvwkdxhjm4fvg81iww01h108jq1cnlh88yzbcnwn2c";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."crossbeam_utils"."0.6.1"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."crossbeam_utils"."0.6.1" or {});
  };
  features_.crossbeam_utils."0.6.1" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.crossbeam_utils."0.6.1".cfg_if}".default = true;
    crossbeam_utils = fold recursiveUpdate {} [
      { "0.6.1"."std" =
        (f.crossbeam_utils."0.6.1"."std" or false) ||
        (f.crossbeam_utils."0.6.1".default or false) ||
        (crossbeam_utils."0.6.1"."default" or false); }
      { "0.6.1".default = (f.crossbeam_utils."0.6.1".default or true); }
    ];
  }) [
    (features_.cfg_if."${deps."crossbeam_utils"."0.6.1"."cfg_if"}" deps)
  ];


# end
# custom_derive-0.1.7

  crates.custom_derive."0.1.7" = deps: { features?(features_.custom_derive."0.1.7" deps {}) }: buildRustCrate {
    crateName = "custom_derive";
    version = "0.1.7";
    description = "(Note: superseded by `macro-attr`) This crate provides a macro that enables the use of custom derive attributes.";
    authors = [ "Daniel Keep <daniel.keep@gmail.com>" ];
    sha256 = "160q3pzri2fgrr6czfdkwy1sbddki2za96r7ivvyii52qp1523zs";
    features = mkFeatures (features."custom_derive"."0.1.7" or {});
  };
  features_.custom_derive."0.1.7" = deps: f: updateFeatures f (rec {
    custom_derive = fold recursiveUpdate {} [
      { "0.1.7"."std" =
        (f.custom_derive."0.1.7"."std" or false) ||
        (f.custom_derive."0.1.7".default or false) ||
        (custom_derive."0.1.7"."default" or false); }
      { "0.1.7".default = (f.custom_derive."0.1.7".default or true); }
    ];
  }) [];


# end
# derive-error-0.0.3

  crates.derive_error."0.0.3" = deps: { features?(features_.derive_error."0.0.3" deps {}) }: buildRustCrate {
    crateName = "derive-error";
    version = "0.0.3";
    description = "Derive macro for Error using macros 1.1";
    authors = [ "rushmorem <rushmore@webenchanter.com>" ];
    sha256 = "0239vzxn5xr9nm3i4d6hmqy7dv8llcjblgh1xixfk5dcgcqan77y";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."case"."${deps."derive_error"."0.0.3"."case"}" deps)
      (crates."quote"."${deps."derive_error"."0.0.3"."quote"}" deps)
      (crates."syn"."${deps."derive_error"."0.0.3"."syn"}" deps)
    ]);
  };
  features_.derive_error."0.0.3" = deps: f: updateFeatures f ({
    case."${deps.derive_error."0.0.3".case}".default = true;
    derive_error."0.0.3".default = (f.derive_error."0.0.3".default or true);
    quote."${deps.derive_error."0.0.3".quote}".default = true;
    syn."${deps.derive_error."0.0.3".syn}".default = true;
  }) [
    (features_.case."${deps."derive_error"."0.0.3"."case"}" deps)
    (features_.quote."${deps."derive_error"."0.0.3"."quote"}" deps)
    (features_.syn."${deps."derive_error"."0.0.3"."syn"}" deps)
  ];


# end
# dtoa-0.4.2

  crates.dtoa."0.4.2" = deps: { features?(features_.dtoa."0.4.2" deps {}) }: buildRustCrate {
    crateName = "dtoa";
    version = "0.4.2";
    description = "Fast functions for printing floating-point primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1bxsh6fags7nr36vlz07ik2a1rzyipc8x1y30kjk832hf2pzadmw";
  };
  features_.dtoa."0.4.2" = deps: f: updateFeatures f ({
    dtoa."0.4.2".default = (f.dtoa."0.4.2".default or true);
  }) [];


# end
# either-1.4.0

  crates.either."1.4.0" = deps: { features?(features_.either."1.4.0" deps {}) }: buildRustCrate {
    crateName = "either";
    version = "1.4.0";
    description = "The enum [`Either`] with variants `Left` and `Right` is a general purpose sum type with two cases.\n";
    authors = [ "bluss" ];
    sha256 = "04kpfd84lvyrkb2z4sljlz2d3d5qczd0sb1yy37fgijq2yx3vb37";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."either"."1.4.0" or {});
  };
  features_.either."1.4.0" = deps: f: updateFeatures f (rec {
    either = fold recursiveUpdate {} [
      { "1.4.0"."use_std" =
        (f.either."1.4.0"."use_std" or false) ||
        (f.either."1.4.0".default or false) ||
        (either."1.4.0"."default" or false); }
      { "1.4.0".default = (f.either."1.4.0".default or true); }
    ];
  }) [];


# end
# encoding_rs-0.8.13

  crates.encoding_rs."0.8.13" = deps: { features?(features_.encoding_rs."0.8.13" deps {}) }: buildRustCrate {
    crateName = "encoding_rs";
    version = "0.8.13";
    description = "A Gecko-oriented implementation of the Encoding Standard";
    authors = [ "Henri Sivonen <hsivonen@hsivonen.fi>" ];
    sha256 = "1a91x1cnw1iz3hc32mvdmwhbqcfx36kk04pnil17mcii1ni6xyy5";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."encoding_rs"."0.8.13"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."encoding_rs"."0.8.13" or {});
  };
  features_.encoding_rs."0.8.13" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.encoding_rs."0.8.13".cfg_if}".default = true;
    encoding_rs = fold recursiveUpdate {} [
      { "0.8.13"."fast-big5-hanzi-encode" =
        (f.encoding_rs."0.8.13"."fast-big5-hanzi-encode" or false) ||
        (f.encoding_rs."0.8.13".fast-legacy-encode or false) ||
        (encoding_rs."0.8.13"."fast-legacy-encode" or false); }
      { "0.8.13"."fast-gb-hanzi-encode" =
        (f.encoding_rs."0.8.13"."fast-gb-hanzi-encode" or false) ||
        (f.encoding_rs."0.8.13".fast-legacy-encode or false) ||
        (encoding_rs."0.8.13"."fast-legacy-encode" or false); }
      { "0.8.13"."fast-hangul-encode" =
        (f.encoding_rs."0.8.13"."fast-hangul-encode" or false) ||
        (f.encoding_rs."0.8.13".fast-legacy-encode or false) ||
        (encoding_rs."0.8.13"."fast-legacy-encode" or false); }
      { "0.8.13"."fast-hanja-encode" =
        (f.encoding_rs."0.8.13"."fast-hanja-encode" or false) ||
        (f.encoding_rs."0.8.13".fast-legacy-encode or false) ||
        (encoding_rs."0.8.13"."fast-legacy-encode" or false); }
      { "0.8.13"."fast-kanji-encode" =
        (f.encoding_rs."0.8.13"."fast-kanji-encode" or false) ||
        (f.encoding_rs."0.8.13".fast-legacy-encode or false) ||
        (encoding_rs."0.8.13"."fast-legacy-encode" or false); }
      { "0.8.13"."simd" =
        (f.encoding_rs."0.8.13"."simd" or false) ||
        (f.encoding_rs."0.8.13".simd-accel or false) ||
        (encoding_rs."0.8.13"."simd-accel" or false); }
      { "0.8.13".default = (f.encoding_rs."0.8.13".default or true); }
    ];
  }) [
    (features_.cfg_if."${deps."encoding_rs"."0.8.13"."cfg_if"}" deps)
  ];


# end
# exitcode-1.1.2

  crates.exitcode."1.1.2" = deps: { features?(features_.exitcode."1.1.2" deps {}) }: buildRustCrate {
    crateName = "exitcode";
    version = "1.1.2";
    description = "Preferred system exit codes as defined by sysexits.h";
    authors = [ "Ben Wilber <benwilber@gmail.com>" ];
    sha256 = "1cw9p4vzbscvyrbzv7z68gv2cairrns2d4wcb4nkahkcjk25phip";
  };
  features_.exitcode."1.1.2" = deps: f: updateFeatures f ({
    exitcode."1.1.2".default = (f.exitcode."1.1.2".default or true);
  }) [];


# end
# filetime-0.1.14

  crates.filetime."0.1.14" = deps: { features?(features_.filetime."0.1.14" deps {}) }: buildRustCrate {
    crateName = "filetime";
    version = "0.1.14";
    description = "Platform-agnostic accessors of timestamps in File metadata\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0i6dvc3ba7vl1iccc91k7c9bv9j5md98mbvlmfy0kicikx0ffn08";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."filetime"."0.1.14"."cfg_if"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."filetime"."0.1.14"."redox_syscall"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."filetime"."0.1.14"."libc"}" deps)
    ]) else []);
  };
  features_.filetime."0.1.14" = deps: f: updateFeatures f ({
    cfg_if."${deps.filetime."0.1.14".cfg_if}".default = true;
    filetime."0.1.14".default = (f.filetime."0.1.14".default or true);
    libc."${deps.filetime."0.1.14".libc}".default = true;
    redox_syscall."${deps.filetime."0.1.14".redox_syscall}".default = true;
  }) [
    (features_.cfg_if."${deps."filetime"."0.1.14"."cfg_if"}" deps)
    (features_.redox_syscall."${deps."filetime"."0.1.14"."redox_syscall"}" deps)
    (features_.libc."${deps."filetime"."0.1.14"."libc"}" deps)
  ];


# end
# flate2-0.2.20

  crates.flate2."0.2.20" = deps: { features?(features_.flate2."0.2.20" deps {}) }: buildRustCrate {
    crateName = "flate2";
    version = "0.2.20";
    description = "Bindings to miniz.c for DEFLATE compression and decompression exposed as\nReader/Writer streams. Contains bindings for zlib, deflate, and gzip-based\nstreams.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1am0d2vmqym1vcg7rvv516vpcrbhdn1jisy0q03r3nbzdzh54ppl";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."flate2"."0.2.20"."libc"}" deps)
    ]
      ++ (if features.flate2."0.2.20".miniz-sys or false then [ (crates.miniz_sys."${deps."flate2"."0.2.20".miniz_sys}" deps) ] else []));
    features = mkFeatures (features."flate2"."0.2.20" or {});
  };
  features_.flate2."0.2.20" = deps: f: updateFeatures f (rec {
    flate2 = fold recursiveUpdate {} [
      { "0.2.20"."futures" =
        (f.flate2."0.2.20"."futures" or false) ||
        (f.flate2."0.2.20".tokio or false) ||
        (flate2."0.2.20"."tokio" or false); }
      { "0.2.20"."libz-sys" =
        (f.flate2."0.2.20"."libz-sys" or false) ||
        (f.flate2."0.2.20".zlib or false) ||
        (flate2."0.2.20"."zlib" or false); }
      { "0.2.20"."miniz-sys" =
        (f.flate2."0.2.20"."miniz-sys" or false) ||
        (f.flate2."0.2.20".default or false) ||
        (flate2."0.2.20"."default" or false); }
      { "0.2.20"."tokio-io" =
        (f.flate2."0.2.20"."tokio-io" or false) ||
        (f.flate2."0.2.20".tokio or false) ||
        (flate2."0.2.20"."tokio" or false); }
      { "0.2.20".default = (f.flate2."0.2.20".default or true); }
    ];
    libc."${deps.flate2."0.2.20".libc}".default = true;
    miniz_sys."${deps.flate2."0.2.20".miniz_sys}".default = true;
  }) [
    (features_.libc."${deps."flate2"."0.2.20"."libc"}" deps)
    (features_.miniz_sys."${deps."flate2"."0.2.20"."miniz_sys"}" deps)
  ];


# end
# fnv-1.0.6

  crates.fnv."1.0.6" = deps: { features?(features_.fnv."1.0.6" deps {}) }: buildRustCrate {
    crateName = "fnv";
    version = "1.0.6";
    description = "Fowler–Noll–Vo hash function";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "128mlh23y3gg6ag5h8iiqlcbl59smisdzraqy88ldrf75kbw27ip";
    libPath = "lib.rs";
  };
  features_.fnv."1.0.6" = deps: f: updateFeatures f ({
    fnv."1.0.6".default = (f.fnv."1.0.6".default or true);
  }) [];


# end
# foreign-types-0.3.2

  crates.foreign_types."0.3.2" = deps: { features?(features_.foreign_types."0.3.2" deps {}) }: buildRustCrate {
    crateName = "foreign-types";
    version = "0.3.2";
    description = "A framework for Rust wrappers over C APIs";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "105n8sp2djb1s5lzrw04p7ss3dchr5qa3canmynx396nh3vwm2p8";
    dependencies = mapFeatures features ([
      (crates."foreign_types_shared"."${deps."foreign_types"."0.3.2"."foreign_types_shared"}" deps)
    ]);
  };
  features_.foreign_types."0.3.2" = deps: f: updateFeatures f ({
    foreign_types."0.3.2".default = (f.foreign_types."0.3.2".default or true);
    foreign_types_shared."${deps.foreign_types."0.3.2".foreign_types_shared}".default = true;
  }) [
    (features_.foreign_types_shared."${deps."foreign_types"."0.3.2"."foreign_types_shared"}" deps)
  ];


# end
# foreign-types-shared-0.1.1

  crates.foreign_types_shared."0.1.1" = deps: { features?(features_.foreign_types_shared."0.1.1" deps {}) }: buildRustCrate {
    crateName = "foreign-types-shared";
    version = "0.1.1";
    description = "An internal crate used by foreign-types";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0b6cnvqbflws8dxywk4589vgbz80049lz4x1g9dfy4s1ppd3g4z5";
  };
  features_.foreign_types_shared."0.1.1" = deps: f: updateFeatures f ({
    foreign_types_shared."0.1.1".default = (f.foreign_types_shared."0.1.1".default or true);
  }) [];


# end
# fuchsia-zircon-0.2.1

  crates.fuchsia_zircon."0.2.1" = deps: { features?(features_.fuchsia_zircon."0.2.1" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon";
    version = "0.2.1";
    description = "Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0yd4rd7ql1vdr349p6vgq2dnwmpylky1kjp8g1zgvp250jxrhddb";
    dependencies = mapFeatures features ([
      (crates."fuchsia_zircon_sys"."${deps."fuchsia_zircon"."0.2.1"."fuchsia_zircon_sys"}" deps)
    ]);
  };
  features_.fuchsia_zircon."0.2.1" = deps: f: updateFeatures f ({
    fuchsia_zircon."0.2.1".default = (f.fuchsia_zircon."0.2.1".default or true);
    fuchsia_zircon_sys."${deps.fuchsia_zircon."0.2.1".fuchsia_zircon_sys}".default = true;
  }) [
    (features_.fuchsia_zircon_sys."${deps."fuchsia_zircon"."0.2.1"."fuchsia_zircon_sys"}" deps)
  ];


# end
# fuchsia-zircon-0.3.3

  crates.fuchsia_zircon."0.3.3" = deps: { features?(features_.fuchsia_zircon."0.3.3" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon";
    version = "0.3.3";
    description = "Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0jrf4shb1699r4la8z358vri8318w4mdi6qzfqy30p2ymjlca4gk";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."fuchsia_zircon"."0.3.3"."bitflags"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."fuchsia_zircon"."0.3.3"."fuchsia_zircon_sys"}" deps)
    ]);
  };
  features_.fuchsia_zircon."0.3.3" = deps: f: updateFeatures f ({
    bitflags."${deps.fuchsia_zircon."0.3.3".bitflags}".default = true;
    fuchsia_zircon."0.3.3".default = (f.fuchsia_zircon."0.3.3".default or true);
    fuchsia_zircon_sys."${deps.fuchsia_zircon."0.3.3".fuchsia_zircon_sys}".default = true;
  }) [
    (features_.bitflags."${deps."fuchsia_zircon"."0.3.3"."bitflags"}" deps)
    (features_.fuchsia_zircon_sys."${deps."fuchsia_zircon"."0.3.3"."fuchsia_zircon_sys"}" deps)
  ];


# end
# fuchsia-zircon-sys-0.2.0

  crates.fuchsia_zircon_sys."0.2.0" = deps: { features?(features_.fuchsia_zircon_sys."0.2.0" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon-sys";
    version = "0.2.0";
    description = "Low-level Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "1yrqsrjwlhl3di6prxf5xmyd82gyjaysldbka5wwk83z11mpqh4w";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."fuchsia_zircon_sys"."0.2.0"."bitflags"}" deps)
    ]);
  };
  features_.fuchsia_zircon_sys."0.2.0" = deps: f: updateFeatures f ({
    bitflags."${deps.fuchsia_zircon_sys."0.2.0".bitflags}".default = true;
    fuchsia_zircon_sys."0.2.0".default = (f.fuchsia_zircon_sys."0.2.0".default or true);
  }) [
    (features_.bitflags."${deps."fuchsia_zircon_sys"."0.2.0"."bitflags"}" deps)
  ];


# end
# fuchsia-zircon-sys-0.3.3

  crates.fuchsia_zircon_sys."0.3.3" = deps: { features?(features_.fuchsia_zircon_sys."0.3.3" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon-sys";
    version = "0.3.3";
    description = "Low-level Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "08jp1zxrm9jbrr6l26bjal4dbm8bxfy57ickdgibsqxr1n9j3hf5";
  };
  features_.fuchsia_zircon_sys."0.3.3" = deps: f: updateFeatures f ({
    fuchsia_zircon_sys."0.3.3".default = (f.fuchsia_zircon_sys."0.3.3".default or true);
  }) [];


# end
# futures-0.1.25

  crates.futures."0.1.25" = deps: { features?(features_.futures."0.1.25" deps {}) }: buildRustCrate {
    crateName = "futures";
    version = "0.1.25";
    description = "An implementation of futures and streams featuring zero allocations,\ncomposability, and iterator-like interfaces.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1gdn9z3mi3jjzbxgvawqh90895130c3ydks55rshja0ncpn985q3";
    features = mkFeatures (features."futures"."0.1.25" or {});
  };
  features_.futures."0.1.25" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "0.1.25"."use_std" =
        (f.futures."0.1.25"."use_std" or false) ||
        (f.futures."0.1.25".default or false) ||
        (futures."0.1.25"."default" or false); }
      { "0.1.25"."with-deprecated" =
        (f.futures."0.1.25"."with-deprecated" or false) ||
        (f.futures."0.1.25".default or false) ||
        (futures."0.1.25"."default" or false); }
      { "0.1.25".default = (f.futures."0.1.25".default or true); }
    ];
  }) [];


# end
# futures-cpupool-0.1.7

  crates.futures_cpupool."0.1.7" = deps: { features?(features_.futures_cpupool."0.1.7" deps {}) }: buildRustCrate {
    crateName = "futures-cpupool";
    version = "0.1.7";
    description = "An implementation of thread pools which hand out futures to the results of the\ncomputation on the threads themselves.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1m0z5d54q1zr687acb4fh5fb3x692vr5ais6135lvp7vxap6p0xb";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."futures_cpupool"."0.1.7"."futures"}" deps)
      (crates."num_cpus"."${deps."futures_cpupool"."0.1.7"."num_cpus"}" deps)
    ]);
    features = mkFeatures (features."futures_cpupool"."0.1.7" or {});
  };
  features_.futures_cpupool."0.1.7" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "${deps.futures_cpupool."0.1.7".futures}"."use_std" = true; }
      { "${deps.futures_cpupool."0.1.7".futures}"."with-deprecated" =
        (f.futures."${deps.futures_cpupool."0.1.7".futures}"."with-deprecated" or false) ||
        (futures_cpupool."0.1.7"."with-deprecated" or false) ||
        (f."futures_cpupool"."0.1.7"."with-deprecated" or false); }
      { "${deps.futures_cpupool."0.1.7".futures}".default = (f.futures."${deps.futures_cpupool."0.1.7".futures}".default or false); }
    ];
    futures_cpupool = fold recursiveUpdate {} [
      { "0.1.7"."with-deprecated" =
        (f.futures_cpupool."0.1.7"."with-deprecated" or false) ||
        (f.futures_cpupool."0.1.7".default or false) ||
        (futures_cpupool."0.1.7"."default" or false); }
      { "0.1.7".default = (f.futures_cpupool."0.1.7".default or true); }
    ];
    num_cpus."${deps.futures_cpupool."0.1.7".num_cpus}".default = true;
  }) [
    (features_.futures."${deps."futures_cpupool"."0.1.7"."futures"}" deps)
    (features_.num_cpus."${deps."futures_cpupool"."0.1.7"."num_cpus"}" deps)
  ];


# end
# h2-0.1.13

  crates.h2."0.1.13" = deps: { features?(features_.h2."0.1.13" deps {}) }: buildRustCrate {
    crateName = "h2";
    version = "0.1.13";
    description = "An HTTP/2.0 client and server";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1nmbr5i1ssqbnfwmkgsfzghzr4m8676z38s2dmzs9gchha7n8wv7";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."h2"."0.1.13"."byteorder"}" deps)
      (crates."bytes"."${deps."h2"."0.1.13"."bytes"}" deps)
      (crates."fnv"."${deps."h2"."0.1.13"."fnv"}" deps)
      (crates."futures"."${deps."h2"."0.1.13"."futures"}" deps)
      (crates."http"."${deps."h2"."0.1.13"."http"}" deps)
      (crates."indexmap"."${deps."h2"."0.1.13"."indexmap"}" deps)
      (crates."log"."${deps."h2"."0.1.13"."log"}" deps)
      (crates."slab"."${deps."h2"."0.1.13"."slab"}" deps)
      (crates."string"."${deps."h2"."0.1.13"."string"}" deps)
      (crates."tokio_io"."${deps."h2"."0.1.13"."tokio_io"}" deps)
    ]);
    features = mkFeatures (features."h2"."0.1.13" or {});
  };
  features_.h2."0.1.13" = deps: f: updateFeatures f ({
    byteorder."${deps.h2."0.1.13".byteorder}".default = true;
    bytes."${deps.h2."0.1.13".bytes}".default = true;
    fnv."${deps.h2."0.1.13".fnv}".default = true;
    futures."${deps.h2."0.1.13".futures}".default = true;
    h2."0.1.13".default = (f.h2."0.1.13".default or true);
    http."${deps.h2."0.1.13".http}".default = true;
    indexmap."${deps.h2."0.1.13".indexmap}".default = true;
    log."${deps.h2."0.1.13".log}".default = true;
    slab."${deps.h2."0.1.13".slab}".default = true;
    string."${deps.h2."0.1.13".string}".default = true;
    tokio_io."${deps.h2."0.1.13".tokio_io}".default = true;
  }) [
    (features_.byteorder."${deps."h2"."0.1.13"."byteorder"}" deps)
    (features_.bytes."${deps."h2"."0.1.13"."bytes"}" deps)
    (features_.fnv."${deps."h2"."0.1.13"."fnv"}" deps)
    (features_.futures."${deps."h2"."0.1.13"."futures"}" deps)
    (features_.http."${deps."h2"."0.1.13"."http"}" deps)
    (features_.indexmap."${deps."h2"."0.1.13"."indexmap"}" deps)
    (features_.log."${deps."h2"."0.1.13"."log"}" deps)
    (features_.slab."${deps."h2"."0.1.13"."slab"}" deps)
    (features_.string."${deps."h2"."0.1.13"."string"}" deps)
    (features_.tokio_io."${deps."h2"."0.1.13"."tokio_io"}" deps)
  ];


# end
# http-0.1.14

  crates.http."0.1.14" = deps: { features?(features_.http."0.1.14" deps {}) }: buildRustCrate {
    crateName = "http";
    version = "0.1.14";
    description = "A set of types for representing HTTP requests and responses.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Carl Lerche <me@carllerche.com>" "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1828cz2fh25nmp9rca0yzr548phsvkmzsqhspjnscqg1l9yc1557";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."http"."0.1.14"."bytes"}" deps)
      (crates."fnv"."${deps."http"."0.1.14"."fnv"}" deps)
      (crates."itoa"."${deps."http"."0.1.14"."itoa"}" deps)
    ]);
  };
  features_.http."0.1.14" = deps: f: updateFeatures f ({
    bytes."${deps.http."0.1.14".bytes}".default = true;
    fnv."${deps.http."0.1.14".fnv}".default = true;
    http."0.1.14".default = (f.http."0.1.14".default or true);
    itoa."${deps.http."0.1.14".itoa}".default = true;
  }) [
    (features_.bytes."${deps."http"."0.1.14"."bytes"}" deps)
    (features_.fnv."${deps."http"."0.1.14"."fnv"}" deps)
    (features_.itoa."${deps."http"."0.1.14"."itoa"}" deps)
  ];


# end
# httparse-1.2.3

  crates.httparse."1.2.3" = deps: { features?(features_.httparse."1.2.3" deps {}) }: buildRustCrate {
    crateName = "httparse";
    version = "1.2.3";
    description = "A tiny, safe, speedy, zero-copy HTTP/1.x parser.";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "13x17y9bip0bija06y4vwpgh8jdmdi2gsvjq02kyfy0fbp5cqa93";
    features = mkFeatures (features."httparse"."1.2.3" or {});
  };
  features_.httparse."1.2.3" = deps: f: updateFeatures f (rec {
    httparse = fold recursiveUpdate {} [
      { "1.2.3"."std" =
        (f.httparse."1.2.3"."std" or false) ||
        (f.httparse."1.2.3".default or false) ||
        (httparse."1.2.3"."default" or false); }
      { "1.2.3".default = (f.httparse."1.2.3".default or true); }
    ];
  }) [];


# end
# hyper-0.12.16

  crates.hyper."0.12.16" = deps: { features?(features_.hyper."0.12.16" deps {}) }: buildRustCrate {
    crateName = "hyper";
    version = "0.12.16";
    description = "A fast and correct HTTP library.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1h5h9swxh02jcg1m4cvwb5nmkb8z9g4b0p4wfbhfvsd7wf14qr0y";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."hyper"."0.12.16"."bytes"}" deps)
      (crates."futures"."${deps."hyper"."0.12.16"."futures"}" deps)
      (crates."h2"."${deps."hyper"."0.12.16"."h2"}" deps)
      (crates."http"."${deps."hyper"."0.12.16"."http"}" deps)
      (crates."httparse"."${deps."hyper"."0.12.16"."httparse"}" deps)
      (crates."iovec"."${deps."hyper"."0.12.16"."iovec"}" deps)
      (crates."itoa"."${deps."hyper"."0.12.16"."itoa"}" deps)
      (crates."log"."${deps."hyper"."0.12.16"."log"}" deps)
      (crates."time"."${deps."hyper"."0.12.16"."time"}" deps)
      (crates."tokio_io"."${deps."hyper"."0.12.16"."tokio_io"}" deps)
      (crates."want"."${deps."hyper"."0.12.16"."want"}" deps)
    ]
      ++ (if features.hyper."0.12.16".futures-cpupool or false then [ (crates.futures_cpupool."${deps."hyper"."0.12.16".futures_cpupool}" deps) ] else [])
      ++ (if features.hyper."0.12.16".net2 or false then [ (crates.net2."${deps."hyper"."0.12.16".net2}" deps) ] else [])
      ++ (if features.hyper."0.12.16".tokio or false then [ (crates.tokio."${deps."hyper"."0.12.16".tokio}" deps) ] else [])
      ++ (if features.hyper."0.12.16".tokio-executor or false then [ (crates.tokio_executor."${deps."hyper"."0.12.16".tokio_executor}" deps) ] else [])
      ++ (if features.hyper."0.12.16".tokio-reactor or false then [ (crates.tokio_reactor."${deps."hyper"."0.12.16".tokio_reactor}" deps) ] else [])
      ++ (if features.hyper."0.12.16".tokio-tcp or false then [ (crates.tokio_tcp."${deps."hyper"."0.12.16".tokio_tcp}" deps) ] else [])
      ++ (if features.hyper."0.12.16".tokio-threadpool or false then [ (crates.tokio_threadpool."${deps."hyper"."0.12.16".tokio_threadpool}" deps) ] else [])
      ++ (if features.hyper."0.12.16".tokio-timer or false then [ (crates.tokio_timer."${deps."hyper"."0.12.16".tokio_timer}" deps) ] else []));
    features = mkFeatures (features."hyper"."0.12.16" or {});
  };
  features_.hyper."0.12.16" = deps: f: updateFeatures f (rec {
    bytes."${deps.hyper."0.12.16".bytes}".default = true;
    futures."${deps.hyper."0.12.16".futures}".default = true;
    futures_cpupool."${deps.hyper."0.12.16".futures_cpupool}".default = true;
    h2."${deps.hyper."0.12.16".h2}".default = true;
    http."${deps.hyper."0.12.16".http}".default = true;
    httparse."${deps.hyper."0.12.16".httparse}".default = true;
    hyper = fold recursiveUpdate {} [
      { "0.12.16"."__internal_flaky_tests" =
        (f.hyper."0.12.16"."__internal_flaky_tests" or false) ||
        (f.hyper."0.12.16".default or false) ||
        (hyper."0.12.16"."default" or false); }
      { "0.12.16"."futures-cpupool" =
        (f.hyper."0.12.16"."futures-cpupool" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16"."net2" =
        (f.hyper."0.12.16"."net2" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16"."runtime" =
        (f.hyper."0.12.16"."runtime" or false) ||
        (f.hyper."0.12.16".default or false) ||
        (hyper."0.12.16"."default" or false); }
      { "0.12.16"."tokio" =
        (f.hyper."0.12.16"."tokio" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16"."tokio-executor" =
        (f.hyper."0.12.16"."tokio-executor" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16"."tokio-reactor" =
        (f.hyper."0.12.16"."tokio-reactor" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16"."tokio-tcp" =
        (f.hyper."0.12.16"."tokio-tcp" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16"."tokio-threadpool" =
        (f.hyper."0.12.16"."tokio-threadpool" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16"."tokio-timer" =
        (f.hyper."0.12.16"."tokio-timer" or false) ||
        (f.hyper."0.12.16".runtime or false) ||
        (hyper."0.12.16"."runtime" or false); }
      { "0.12.16".default = (f.hyper."0.12.16".default or true); }
    ];
    iovec."${deps.hyper."0.12.16".iovec}".default = true;
    itoa."${deps.hyper."0.12.16".itoa}".default = true;
    log."${deps.hyper."0.12.16".log}".default = true;
    net2."${deps.hyper."0.12.16".net2}".default = true;
    time."${deps.hyper."0.12.16".time}".default = true;
    tokio."${deps.hyper."0.12.16".tokio}".default = true;
    tokio_executor."${deps.hyper."0.12.16".tokio_executor}".default = true;
    tokio_io."${deps.hyper."0.12.16".tokio_io}".default = true;
    tokio_reactor."${deps.hyper."0.12.16".tokio_reactor}".default = true;
    tokio_tcp."${deps.hyper."0.12.16".tokio_tcp}".default = true;
    tokio_threadpool."${deps.hyper."0.12.16".tokio_threadpool}".default = true;
    tokio_timer."${deps.hyper."0.12.16".tokio_timer}".default = true;
    want."${deps.hyper."0.12.16".want}".default = true;
  }) [
    (features_.bytes."${deps."hyper"."0.12.16"."bytes"}" deps)
    (features_.futures."${deps."hyper"."0.12.16"."futures"}" deps)
    (features_.futures_cpupool."${deps."hyper"."0.12.16"."futures_cpupool"}" deps)
    (features_.h2."${deps."hyper"."0.12.16"."h2"}" deps)
    (features_.http."${deps."hyper"."0.12.16"."http"}" deps)
    (features_.httparse."${deps."hyper"."0.12.16"."httparse"}" deps)
    (features_.iovec."${deps."hyper"."0.12.16"."iovec"}" deps)
    (features_.itoa."${deps."hyper"."0.12.16"."itoa"}" deps)
    (features_.log."${deps."hyper"."0.12.16"."log"}" deps)
    (features_.net2."${deps."hyper"."0.12.16"."net2"}" deps)
    (features_.time."${deps."hyper"."0.12.16"."time"}" deps)
    (features_.tokio."${deps."hyper"."0.12.16"."tokio"}" deps)
    (features_.tokio_executor."${deps."hyper"."0.12.16"."tokio_executor"}" deps)
    (features_.tokio_io."${deps."hyper"."0.12.16"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."hyper"."0.12.16"."tokio_reactor"}" deps)
    (features_.tokio_tcp."${deps."hyper"."0.12.16"."tokio_tcp"}" deps)
    (features_.tokio_threadpool."${deps."hyper"."0.12.16"."tokio_threadpool"}" deps)
    (features_.tokio_timer."${deps."hyper"."0.12.16"."tokio_timer"}" deps)
    (features_.want."${deps."hyper"."0.12.16"."want"}" deps)
  ];


# end
# hyper-tls-0.3.1

  crates.hyper_tls."0.3.1" = deps: { features?(features_.hyper_tls."0.3.1" deps {}) }: buildRustCrate {
    crateName = "hyper-tls";
    version = "0.3.1";
    description = "Default TLS implementation for use with hyper";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "0sk46mmnccxgxwn62rl5m58c2ivwgxgd590cjwg60pjkhx9qn5r7";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."hyper_tls"."0.3.1"."bytes"}" deps)
      (crates."futures"."${deps."hyper_tls"."0.3.1"."futures"}" deps)
      (crates."hyper"."${deps."hyper_tls"."0.3.1"."hyper"}" deps)
      (crates."native_tls"."${deps."hyper_tls"."0.3.1"."native_tls"}" deps)
      (crates."tokio_io"."${deps."hyper_tls"."0.3.1"."tokio_io"}" deps)
    ]);
    features = mkFeatures (features."hyper_tls"."0.3.1" or {});
  };
  features_.hyper_tls."0.3.1" = deps: f: updateFeatures f (rec {
    bytes."${deps.hyper_tls."0.3.1".bytes}".default = true;
    futures."${deps.hyper_tls."0.3.1".futures}".default = true;
    hyper."${deps.hyper_tls."0.3.1".hyper}".default = true;
    hyper_tls."0.3.1".default = (f.hyper_tls."0.3.1".default or true);
    native_tls = fold recursiveUpdate {} [
      { "${deps.hyper_tls."0.3.1".native_tls}"."vendored" =
        (f.native_tls."${deps.hyper_tls."0.3.1".native_tls}"."vendored" or false) ||
        (hyper_tls."0.3.1"."vendored" or false) ||
        (f."hyper_tls"."0.3.1"."vendored" or false); }
      { "${deps.hyper_tls."0.3.1".native_tls}".default = true; }
    ];
    tokio_io."${deps.hyper_tls."0.3.1".tokio_io}".default = true;
  }) [
    (features_.bytes."${deps."hyper_tls"."0.3.1"."bytes"}" deps)
    (features_.futures."${deps."hyper_tls"."0.3.1"."futures"}" deps)
    (features_.hyper."${deps."hyper_tls"."0.3.1"."hyper"}" deps)
    (features_.native_tls."${deps."hyper_tls"."0.3.1"."native_tls"}" deps)
    (features_.tokio_io."${deps."hyper_tls"."0.3.1"."tokio_io"}" deps)
  ];


# end
# idna-0.1.4

  crates.idna."0.1.4" = deps: { features?(features_.idna."0.1.4" deps {}) }: buildRustCrate {
    crateName = "idna";
    version = "0.1.4";
    description = "IDNA (Internationalizing Domain Names in Applications) and Punycode.";
    authors = [ "The rust-url developers" ];
    sha256 = "15j44qgjx1skwg9i7f4cm36ni4n99b1ayx23yxx7axxcw8vjf336";
    dependencies = mapFeatures features ([
      (crates."matches"."${deps."idna"."0.1.4"."matches"}" deps)
      (crates."unicode_bidi"."${deps."idna"."0.1.4"."unicode_bidi"}" deps)
      (crates."unicode_normalization"."${deps."idna"."0.1.4"."unicode_normalization"}" deps)
    ]);
  };
  features_.idna."0.1.4" = deps: f: updateFeatures f ({
    idna."0.1.4".default = (f.idna."0.1.4".default or true);
    matches."${deps.idna."0.1.4".matches}".default = true;
    unicode_bidi."${deps.idna."0.1.4".unicode_bidi}".default = true;
    unicode_normalization."${deps.idna."0.1.4".unicode_normalization}".default = true;
  }) [
    (features_.matches."${deps."idna"."0.1.4"."matches"}" deps)
    (features_.unicode_bidi."${deps."idna"."0.1.4"."unicode_bidi"}" deps)
    (features_.unicode_normalization."${deps."idna"."0.1.4"."unicode_normalization"}" deps)
  ];


# end
# indexmap-1.0.2

  crates.indexmap."1.0.2" = deps: { features?(features_.indexmap."1.0.2" deps {}) }: buildRustCrate {
    crateName = "indexmap";
    version = "1.0.2";
    description = "A hash table with consistent order and fast iteration.\n\nThe indexmap is a hash table where the iteration order of the key-value\npairs is independent of the hash values of the keys. It has the usual\nhash table functionality, it preserves insertion order except after\nremovals, and it allows lookup of its elements by either hash table key\nor numerical index. A corresponding hash set type is also provided.\n\nThis crate was initially published under the name ordermap, but it was renamed to\nindexmap.\n";
    authors = [ "bluss" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "18a0cn5xy3a7wswxg5lwfg3j4sh5blk28ykw0ysgr486djd353gf";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."indexmap"."1.0.2" or {});
  };
  features_.indexmap."1.0.2" = deps: f: updateFeatures f (rec {
    indexmap = fold recursiveUpdate {} [
      { "1.0.2"."serde" =
        (f.indexmap."1.0.2"."serde" or false) ||
        (f.indexmap."1.0.2".serde-1 or false) ||
        (indexmap."1.0.2"."serde-1" or false); }
      { "1.0.2".default = (f.indexmap."1.0.2".default or true); }
    ];
  }) [];


# end
# iovec-0.1.1

  crates.iovec."0.1.1" = deps: { features?(features_.iovec."0.1.1" deps {}) }: buildRustCrate {
    crateName = "iovec";
    version = "0.1.1";
    description = "Portable buffer type for scatter/gather I/O operations\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "14fns3g3arbql6lkczf2gbbzaqh22mfv7y1wq5rr2y8jhh5m8jmm";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."iovec"."0.1.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."iovec"."0.1.1"."winapi"}" deps)
    ]) else []);
  };
  features_.iovec."0.1.1" = deps: f: updateFeatures f ({
    iovec."0.1.1".default = (f.iovec."0.1.1".default or true);
    libc."${deps.iovec."0.1.1".libc}".default = true;
    winapi."${deps.iovec."0.1.1".winapi}".default = true;
  }) [
    (features_.libc."${deps."iovec"."0.1.1"."libc"}" deps)
    (features_.winapi."${deps."iovec"."0.1.1"."winapi"}" deps)
  ];


# end
# isatty-0.1.5

  crates.isatty."0.1.5" = deps: { features?(features_.isatty."0.1.5" deps {}) }: buildRustCrate {
    crateName = "isatty";
    version = "0.1.5";
    description = "libc::isatty that also works on Windows";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0gp781mgqmvsp6a3iyhwk2sqis2ys8jfg3grq40m135zgb4d2cvj";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."isatty"."0.1.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."isatty"."0.1.5"."kernel32_sys"}" deps)
      (crates."winapi"."${deps."isatty"."0.1.5"."winapi"}" deps)
    ]) else []);
  };
  features_.isatty."0.1.5" = deps: f: updateFeatures f ({
    isatty."0.1.5".default = (f.isatty."0.1.5".default or true);
    kernel32_sys."${deps.isatty."0.1.5".kernel32_sys}".default = true;
    libc."${deps.isatty."0.1.5".libc}".default = true;
    winapi."${deps.isatty."0.1.5".winapi}".default = true;
  }) [
    (features_.libc."${deps."isatty"."0.1.5"."libc"}" deps)
    (features_.kernel32_sys."${deps."isatty"."0.1.5"."kernel32_sys"}" deps)
    (features_.winapi."${deps."isatty"."0.1.5"."winapi"}" deps)
  ];


# end
# itertools-0.6.5

  crates.itertools."0.6.5" = deps: { features?(features_.itertools."0.6.5" deps {}) }: buildRustCrate {
    crateName = "itertools";
    version = "0.6.5";
    description = "Extra iterator adaptors, iterator methods, free functions, and macros.";
    authors = [ "bluss" ];
    sha256 = "0gbhgn7s8qkxxw10i514fzpqnc3aissn4kcgylm2cvnv9zmg8mw1";
    dependencies = mapFeatures features ([
      (crates."either"."${deps."itertools"."0.6.5"."either"}" deps)
    ]);
  };
  features_.itertools."0.6.5" = deps: f: updateFeatures f ({
    either."${deps.itertools."0.6.5".either}".default = (f.either."${deps.itertools."0.6.5".either}".default or false);
    itertools."0.6.5".default = (f.itertools."0.6.5".default or true);
  }) [
    (features_.either."${deps."itertools"."0.6.5"."either"}" deps)
  ];


# end
# itoa-0.3.4

  crates.itoa."0.3.4" = deps: { features?(features_.itoa."0.3.4" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.3.4";
    description = "Fast functions for printing integer primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1nfkzz6vrgj0d9l3yzjkkkqzdgs68y294fjdbl7jq118qi8xc9d9";
    features = mkFeatures (features."itoa"."0.3.4" or {});
  };
  features_.itoa."0.3.4" = deps: f: updateFeatures f ({
    itoa."0.3.4".default = (f.itoa."0.3.4".default or true);
  }) [];


# end
# itoa-0.4.3

  crates.itoa."0.4.3" = deps: { features?(features_.itoa."0.4.3" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.3";
    description = "Fast functions for printing integer primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0zadimmdgvili3gdwxqg7ljv3r4wcdg1kkdfp9nl15vnm23vrhy1";
    features = mkFeatures (features."itoa"."0.4.3" or {});
  };
  features_.itoa."0.4.3" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.3"."std" =
        (f.itoa."0.4.3"."std" or false) ||
        (f.itoa."0.4.3".default or false) ||
        (itoa."0.4.3"."default" or false); }
      { "0.4.3".default = (f.itoa."0.4.3".default or true); }
    ];
  }) [];


# end
# kernel32-sys-0.2.2

  crates.kernel32_sys."0.2.2" = deps: { features?(features_.kernel32_sys."0.2.2" deps {}) }: buildRustCrate {
    crateName = "kernel32-sys";
    version = "0.2.2";
    description = "Contains function definitions for the Windows API library kernel32. See winapi for types and constants.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
    libName = "kernel32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
    ]);
  };
  features_.kernel32_sys."0.2.2" = deps: f: updateFeatures f ({
    kernel32_sys."0.2.2".default = (f.kernel32_sys."0.2.2".default or true);
    winapi."${deps.kernel32_sys."0.2.2".winapi}".default = true;
    winapi_build."${deps.kernel32_sys."0.2.2".winapi_build}".default = true;
  }) [
    (features_.winapi."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    (features_.winapi_build."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
  ];


# end
# lazy_static-0.2.10

  crates.lazy_static."0.2.10" = deps: { features?(features_.lazy_static."0.2.10" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "0.2.10";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "0ylwjvppsm56fpv32l4br7zw0pwn81wbfb1abalyyr1d9c94vg8r";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."0.2.10" or {});
  };
  features_.lazy_static."0.2.10" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "0.2.10"."compiletest_rs" =
        (f.lazy_static."0.2.10"."compiletest_rs" or false) ||
        (f.lazy_static."0.2.10".compiletest or false) ||
        (lazy_static."0.2.10"."compiletest" or false); }
      { "0.2.10"."nightly" =
        (f.lazy_static."0.2.10"."nightly" or false) ||
        (f.lazy_static."0.2.10".spin_no_std or false) ||
        (lazy_static."0.2.10"."spin_no_std" or false); }
      { "0.2.10"."spin" =
        (f.lazy_static."0.2.10"."spin" or false) ||
        (f.lazy_static."0.2.10".spin_no_std or false) ||
        (lazy_static."0.2.10"."spin_no_std" or false); }
      { "0.2.10".default = (f.lazy_static."0.2.10".default or true); }
    ];
  }) [];


# end
# lazy_static-1.2.0

  crates.lazy_static."1.2.0" = deps: { features?(features_.lazy_static."1.2.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.2.0";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "07p3b30k2akyr6xw08ggd5qiz5nw3vd3agggj360fcc1njz7d0ss";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.2.0" or {});
  };
  features_.lazy_static."1.2.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.2.0"."spin" =
        (f.lazy_static."1.2.0"."spin" or false) ||
        (f.lazy_static."1.2.0".spin_no_std or false) ||
        (lazy_static."1.2.0"."spin_no_std" or false); }
      { "1.2.0".default = (f.lazy_static."1.2.0".default or true); }
    ];
  }) [];


# end
# lazycell-1.2.0

  crates.lazycell."1.2.0" = deps: { features?(features_.lazycell."1.2.0" deps {}) }: buildRustCrate {
    crateName = "lazycell";
    version = "1.2.0";
    description = "A library providing a lazily filled Cell struct";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Nikita Pekin <contact@nikitapek.in>" ];
    sha256 = "1lzdb3q17yjihw9hksynxgyg8wbph1h791wff8rrf1c2aqjwhmax";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazycell"."1.2.0" or {});
  };
  features_.lazycell."1.2.0" = deps: f: updateFeatures f (rec {
    lazycell = fold recursiveUpdate {} [
      { "1.2.0"."clippy" =
        (f.lazycell."1.2.0"."clippy" or false) ||
        (f.lazycell."1.2.0".nightly-testing or false) ||
        (lazycell."1.2.0"."nightly-testing" or false); }
      { "1.2.0"."nightly" =
        (f.lazycell."1.2.0"."nightly" or false) ||
        (f.lazycell."1.2.0".nightly-testing or false) ||
        (lazycell."1.2.0"."nightly-testing" or false); }
      { "1.2.0".default = (f.lazycell."1.2.0".default or true); }
    ];
  }) [];


# end
# libc-0.2.44

  crates.libc."0.2.44" = deps: { features?(features_.libc."0.2.44" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.44";
    description = "A library for types and bindings to native C functions often found in libc or\nother common platform libraries.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "17a7p0lcf3qwl1pcxffdflgnx8zr2659mgzzg4zi5fnv1mlj3q6z";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.44" or {});
  };
  features_.libc."0.2.44" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.44"."align" =
        (f.libc."0.2.44"."align" or false) ||
        (f.libc."0.2.44".rustc-dep-of-std or false) ||
        (libc."0.2.44"."rustc-dep-of-std" or false); }
      { "0.2.44"."rustc-std-workspace-core" =
        (f.libc."0.2.44"."rustc-std-workspace-core" or false) ||
        (f.libc."0.2.44".rustc-dep-of-std or false) ||
        (libc."0.2.44"."rustc-dep-of-std" or false); }
      { "0.2.44"."use_std" =
        (f.libc."0.2.44"."use_std" or false) ||
        (f.libc."0.2.44".default or false) ||
        (libc."0.2.44"."default" or false); }
      { "0.2.44".default = (f.libc."0.2.44".default or true); }
    ];
  }) [];


# end
# libflate-0.1.19

  crates.libflate."0.1.19" = deps: { features?(features_.libflate."0.1.19" deps {}) }: buildRustCrate {
    crateName = "libflate";
    version = "0.1.19";
    description = "A Rust implementation of DEFLATE algorithm and related formats (ZLIB, GZIP)";
    authors = [ "Takeru Ohta <phjgt308@gmail.com>" ];
    sha256 = "1klhvys9541xrwspyyv41qbr37xnwx4bdaspk6gbiprhrsqqkjp0";
    dependencies = mapFeatures features ([
      (crates."adler32"."${deps."libflate"."0.1.19"."adler32"}" deps)
      (crates."byteorder"."${deps."libflate"."0.1.19"."byteorder"}" deps)
      (crates."crc32fast"."${deps."libflate"."0.1.19"."crc32fast"}" deps)
    ]);
  };
  features_.libflate."0.1.19" = deps: f: updateFeatures f ({
    adler32."${deps.libflate."0.1.19".adler32}".default = true;
    byteorder."${deps.libflate."0.1.19".byteorder}".default = true;
    crc32fast."${deps.libflate."0.1.19".crc32fast}".default = true;
    libflate."0.1.19".default = (f.libflate."0.1.19".default or true);
  }) [
    (features_.adler32."${deps."libflate"."0.1.19"."adler32"}" deps)
    (features_.byteorder."${deps."libflate"."0.1.19"."byteorder"}" deps)
    (features_.crc32fast."${deps."libflate"."0.1.19"."crc32fast"}" deps)
  ];


# end
# lock_api-0.1.5

  crates.lock_api."0.1.5" = deps: { features?(features_.lock_api."0.1.5" deps {}) }: buildRustCrate {
    crateName = "lock_api";
    version = "0.1.5";
    description = "Wrappers to create fully-featured Mutex and RwLock types. Compatible with no_std.";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "132sidr5hvjfkaqm3l95zpcpi8yk5ddd0g79zf1ad4v65sxirqqm";
    dependencies = mapFeatures features ([
      (crates."scopeguard"."${deps."lock_api"."0.1.5"."scopeguard"}" deps)
    ]
      ++ (if features.lock_api."0.1.5".owning_ref or false then [ (crates.owning_ref."${deps."lock_api"."0.1.5".owning_ref}" deps) ] else []));
    features = mkFeatures (features."lock_api"."0.1.5" or {});
  };
  features_.lock_api."0.1.5" = deps: f: updateFeatures f ({
    lock_api."0.1.5".default = (f.lock_api."0.1.5".default or true);
    owning_ref."${deps.lock_api."0.1.5".owning_ref}".default = true;
    scopeguard."${deps.lock_api."0.1.5".scopeguard}".default = (f.scopeguard."${deps.lock_api."0.1.5".scopeguard}".default or false);
  }) [
    (features_.owning_ref."${deps."lock_api"."0.1.5"."owning_ref"}" deps)
    (features_.scopeguard."${deps."lock_api"."0.1.5"."scopeguard"}" deps)
  ];


# end
# log-0.3.8

  crates.log."0.3.8" = deps: { features?(features_.log."0.3.8" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.3.8";
    description = "A lightweight logging facade for Rust\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1c43z4z85sxrsgir4s1hi84558ab5ic7jrn5qgmsiqcv90vvn006";
    features = mkFeatures (features."log"."0.3.8" or {});
  };
  features_.log."0.3.8" = deps: f: updateFeatures f (rec {
    log = fold recursiveUpdate {} [
      { "0.3.8"."use_std" =
        (f.log."0.3.8"."use_std" or false) ||
        (f.log."0.3.8".default or false) ||
        (log."0.3.8"."default" or false); }
      { "0.3.8".default = (f.log."0.3.8".default or true); }
    ];
  }) [];


# end
# log-0.4.6

  crates.log."0.4.6" = deps: { features?(features_.log."0.4.6" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.4.6";
    description = "A lightweight logging facade for Rust\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1nd8dl9mvc9vd6fks5d4gsxaz990xi6rzlb8ymllshmwi153vngr";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."log"."0.4.6"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."log"."0.4.6" or {});
  };
  features_.log."0.4.6" = deps: f: updateFeatures f ({
    cfg_if."${deps.log."0.4.6".cfg_if}".default = true;
    log."0.4.6".default = (f.log."0.4.6".default or true);
  }) [
    (features_.cfg_if."${deps."log"."0.4.6"."cfg_if"}" deps)
  ];


# end
# maplit-0.1.6

  crates.maplit."0.1.6" = deps: { features?(features_.maplit."0.1.6" deps {}) }: buildRustCrate {
    crateName = "maplit";
    version = "0.1.6";
    description = "Container / collection literal macros for HashMap, HashSet, BTreeMap, BTreeSet.";
    authors = [ "bluss" ];
    sha256 = "1f8kf5v7xra8ssvh5c10qlacbk4l0z2817pkscflx5s5q6y7925h";
  };
  features_.maplit."0.1.6" = deps: f: updateFeatures f ({
    maplit."0.1.6".default = (f.maplit."0.1.6".default or true);
  }) [];


# end
# matches-0.1.6

  crates.matches."0.1.6" = deps: { features?(features_.matches."0.1.6" deps {}) }: buildRustCrate {
    crateName = "matches";
    version = "0.1.6";
    description = "A macro to evaluate, as a boolean, whether an expression matches a pattern.";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "1zlrqlbvzxdil8z8ial2ihvxjwvlvg3g8dr0lcdpsjclkclasjan";
    libPath = "lib.rs";
  };
  features_.matches."0.1.6" = deps: f: updateFeatures f ({
    matches."0.1.6".default = (f.matches."0.1.6".default or true);
  }) [];


# end
# memchr-0.1.11

  crates.memchr."0.1.11" = deps: { features?(features_.memchr."0.1.11" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "0.1.11";
    description = "Safe interface to memchr.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "0x73jghamvxxq5fsw9wb0shk5m6qp3q6fsf0nibn0i6bbqkw91s8";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."memchr"."0.1.11"."libc"}" deps)
    ]);
  };
  features_.memchr."0.1.11" = deps: f: updateFeatures f ({
    libc."${deps.memchr."0.1.11".libc}".default = true;
    memchr."0.1.11".default = (f.memchr."0.1.11".default or true);
  }) [
    (features_.libc."${deps."memchr"."0.1.11"."libc"}" deps)
  ];


# end
# memoffset-0.2.1

  crates.memoffset."0.2.1" = deps: { features?(features_.memoffset."0.2.1" deps {}) }: buildRustCrate {
    crateName = "memoffset";
    version = "0.2.1";
    description = "offset_of functionality for Rust structs.";
    authors = [ "Gilad Naaman <gilad.naaman@gmail.com>" ];
    sha256 = "00vym01jk9slibq2nsiilgffp7n6k52a4q3n4dqp0xf5kzxvffcf";
  };
  features_.memoffset."0.2.1" = deps: f: updateFeatures f ({
    memoffset."0.2.1".default = (f.memoffset."0.2.1".default or true);
  }) [];


# end
# mime-0.3.12

  crates.mime."0.3.12" = deps: { features?(features_.mime."0.3.12" deps {}) }: buildRustCrate {
    crateName = "mime";
    version = "0.3.12";
    description = "Strongly Typed Mimes";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "0lmcwkmxwbla9457w9ak13cfgqxfyn5wa1syjy1kll2ras5xifvh";
    dependencies = mapFeatures features ([
      (crates."unicase"."${deps."mime"."0.3.12"."unicase"}" deps)
    ]);
  };
  features_.mime."0.3.12" = deps: f: updateFeatures f ({
    mime."0.3.12".default = (f.mime."0.3.12".default or true);
    unicase."${deps.mime."0.3.12".unicase}".default = true;
  }) [
    (features_.unicase."${deps."mime"."0.3.12"."unicase"}" deps)
  ];


# end
# mime_guess-2.0.0-alpha.6

  crates.mime_guess."2.0.0-alpha.6" = deps: { features?(features_.mime_guess."2.0.0-alpha.6" deps {}) }: buildRustCrate {
    crateName = "mime_guess";
    version = "2.0.0-alpha.6";
    description = "A simple crate for detection of a file's MIME type by its extension.";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "1k2mdq43gi2qr63b7m5zs624rfi40ysk33cay49jlhq97jwnk9db";
    dependencies = mapFeatures features ([
      (crates."mime"."${deps."mime_guess"."2.0.0-alpha.6"."mime"}" deps)
      (crates."phf"."${deps."mime_guess"."2.0.0-alpha.6"."phf"}" deps)
      (crates."unicase"."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."phf_codegen"."${deps."mime_guess"."2.0.0-alpha.6"."phf_codegen"}" deps)
      (crates."unicase"."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
    ]);
    features = mkFeatures (features."mime_guess"."2.0.0-alpha.6" or {});
  };
  features_.mime_guess."2.0.0-alpha.6" = deps: f: updateFeatures f ({
    mime."${deps.mime_guess."2.0.0-alpha.6".mime}".default = true;
    mime_guess."2.0.0-alpha.6".default = (f.mime_guess."2.0.0-alpha.6".default or true);
    phf = fold recursiveUpdate {} [
      { "${deps.mime_guess."2.0.0-alpha.6".phf}"."unicase" = true; }
      { "${deps.mime_guess."2.0.0-alpha.6".phf}".default = true; }
    ];
    phf_codegen."${deps.mime_guess."2.0.0-alpha.6".phf_codegen}".default = true;
    unicase."${deps.mime_guess."2.0.0-alpha.6".unicase}".default = true;
  }) [
    (features_.mime."${deps."mime_guess"."2.0.0-alpha.6"."mime"}" deps)
    (features_.phf."${deps."mime_guess"."2.0.0-alpha.6"."phf"}" deps)
    (features_.unicase."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
    (features_.phf_codegen."${deps."mime_guess"."2.0.0-alpha.6"."phf_codegen"}" deps)
    (features_.unicase."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
  ];


# end
# miniz-sys-0.1.10

  crates.miniz_sys."0.1.10" = deps: { features?(features_.miniz_sys."0.1.10" deps {}) }: buildRustCrate {
    crateName = "miniz-sys";
    version = "0.1.10";
    description = "Bindings to the miniz.c library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "11vg6phafxil87nbxgrlhcx5hjr3145wsbwwkfmibvnmzxfdmvln";
    libPath = "lib.rs";
    libName = "miniz_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."miniz_sys"."0.1.10"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."miniz_sys"."0.1.10"."cc"}" deps)
    ]);
  };
  features_.miniz_sys."0.1.10" = deps: f: updateFeatures f ({
    cc."${deps.miniz_sys."0.1.10".cc}".default = true;
    libc."${deps.miniz_sys."0.1.10".libc}".default = true;
    miniz_sys."0.1.10".default = (f.miniz_sys."0.1.10".default or true);
  }) [
    (features_.libc."${deps."miniz_sys"."0.1.10"."libc"}" deps)
    (features_.cc."${deps."miniz_sys"."0.1.10"."cc"}" deps)
  ];


# end
# mio-0.6.16

  crates.mio."0.6.16" = deps: { features?(features_.mio."0.6.16" deps {}) }: buildRustCrate {
    crateName = "mio";
    version = "0.6.16";
    description = "Lightweight non-blocking IO";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "14vyrlmf0w984pi7ad9qvmlfj6vrb0wn6i8ik9j87w5za2r3rban";
    dependencies = mapFeatures features ([
      (crates."iovec"."${deps."mio"."0.6.16"."iovec"}" deps)
      (crates."lazycell"."${deps."mio"."0.6.16"."lazycell"}" deps)
      (crates."log"."${deps."mio"."0.6.16"."log"}" deps)
      (crates."net2"."${deps."mio"."0.6.16"."net2"}" deps)
      (crates."slab"."${deps."mio"."0.6.16"."slab"}" deps)
    ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."mio"."0.6.16"."fuchsia_zircon"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."mio"."0.6.16"."fuchsia_zircon_sys"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."mio"."0.6.16"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."mio"."0.6.16"."kernel32_sys"}" deps)
      (crates."miow"."${deps."mio"."0.6.16"."miow"}" deps)
      (crates."winapi"."${deps."mio"."0.6.16"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."mio"."0.6.16" or {});
  };
  features_.mio."0.6.16" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.mio."0.6.16".fuchsia_zircon}".default = true;
    fuchsia_zircon_sys."${deps.mio."0.6.16".fuchsia_zircon_sys}".default = true;
    iovec."${deps.mio."0.6.16".iovec}".default = true;
    kernel32_sys."${deps.mio."0.6.16".kernel32_sys}".default = true;
    lazycell."${deps.mio."0.6.16".lazycell}".default = true;
    libc."${deps.mio."0.6.16".libc}".default = true;
    log."${deps.mio."0.6.16".log}".default = true;
    mio = fold recursiveUpdate {} [
      { "0.6.16"."with-deprecated" =
        (f.mio."0.6.16"."with-deprecated" or false) ||
        (f.mio."0.6.16".default or false) ||
        (mio."0.6.16"."default" or false); }
      { "0.6.16".default = (f.mio."0.6.16".default or true); }
    ];
    miow."${deps.mio."0.6.16".miow}".default = true;
    net2."${deps.mio."0.6.16".net2}".default = true;
    slab."${deps.mio."0.6.16".slab}".default = true;
    winapi."${deps.mio."0.6.16".winapi}".default = true;
  }) [
    (features_.iovec."${deps."mio"."0.6.16"."iovec"}" deps)
    (features_.lazycell."${deps."mio"."0.6.16"."lazycell"}" deps)
    (features_.log."${deps."mio"."0.6.16"."log"}" deps)
    (features_.net2."${deps."mio"."0.6.16"."net2"}" deps)
    (features_.slab."${deps."mio"."0.6.16"."slab"}" deps)
    (features_.fuchsia_zircon."${deps."mio"."0.6.16"."fuchsia_zircon"}" deps)
    (features_.fuchsia_zircon_sys."${deps."mio"."0.6.16"."fuchsia_zircon_sys"}" deps)
    (features_.libc."${deps."mio"."0.6.16"."libc"}" deps)
    (features_.kernel32_sys."${deps."mio"."0.6.16"."kernel32_sys"}" deps)
    (features_.miow."${deps."mio"."0.6.16"."miow"}" deps)
    (features_.winapi."${deps."mio"."0.6.16"."winapi"}" deps)
  ];


# end
# miow-0.2.1

  crates.miow."0.2.1" = deps: { features?(features_.miow."0.2.1" deps {}) }: buildRustCrate {
    crateName = "miow";
    version = "0.2.1";
    description = "A zero overhead I/O library for Windows, focusing on IOCP and Async I/O\nabstractions.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "14f8zkc6ix7mkyis1vsqnim8m29b6l55abkba3p2yz7j1ibcvrl0";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
      (crates."net2"."${deps."miow"."0.2.1"."net2"}" deps)
      (crates."winapi"."${deps."miow"."0.2.1"."winapi"}" deps)
      (crates."ws2_32_sys"."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
    ]);
  };
  features_.miow."0.2.1" = deps: f: updateFeatures f ({
    kernel32_sys."${deps.miow."0.2.1".kernel32_sys}".default = true;
    miow."0.2.1".default = (f.miow."0.2.1".default or true);
    net2."${deps.miow."0.2.1".net2}".default = (f.net2."${deps.miow."0.2.1".net2}".default or false);
    winapi."${deps.miow."0.2.1".winapi}".default = true;
    ws2_32_sys."${deps.miow."0.2.1".ws2_32_sys}".default = true;
  }) [
    (features_.kernel32_sys."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
    (features_.net2."${deps."miow"."0.2.1"."net2"}" deps)
    (features_.winapi."${deps."miow"."0.2.1"."winapi"}" deps)
    (features_.ws2_32_sys."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
  ];


# end
# native-tls-0.2.2

  crates.native_tls."0.2.2" = deps: { features?(features_.native_tls."0.2.2" deps {}) }: buildRustCrate {
    crateName = "native-tls";
    version = "0.2.2";
    description = "A wrapper over a platform's native TLS implementation";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0vl2hmmnrcjfylzjfsbnav20ri2n1qjgxn7bklb4mk3fyxfqm1m9";
    dependencies = (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([
      (crates."lazy_static"."${deps."native_tls"."0.2.2"."lazy_static"}" deps)
      (crates."libc"."${deps."native_tls"."0.2.2"."libc"}" deps)
      (crates."security_framework"."${deps."native_tls"."0.2.2"."security_framework"}" deps)
      (crates."security_framework_sys"."${deps."native_tls"."0.2.2"."security_framework_sys"}" deps)
      (crates."tempfile"."${deps."native_tls"."0.2.2"."tempfile"}" deps)
    ]) else [])
      ++ (if !(kernel == "windows" || kernel == "darwin" || kernel == "ios") then mapFeatures features ([
      (crates."openssl"."${deps."native_tls"."0.2.2"."openssl"}" deps)
      (crates."openssl_probe"."${deps."native_tls"."0.2.2"."openssl_probe"}" deps)
      (crates."openssl_sys"."${deps."native_tls"."0.2.2"."openssl_sys"}" deps)
    ]) else [])
      ++ (if kernel == "android" then mapFeatures features ([
      (crates."log"."${deps."native_tls"."0.2.2"."log"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."schannel"."${deps."native_tls"."0.2.2"."schannel"}" deps)
    ]) else []);
    features = mkFeatures (features."native_tls"."0.2.2" or {});
  };
  features_.native_tls."0.2.2" = deps: f: updateFeatures f ({
    lazy_static."${deps.native_tls."0.2.2".lazy_static}".default = true;
    libc."${deps.native_tls."0.2.2".libc}".default = true;
    log."${deps.native_tls."0.2.2".log}".default = true;
    native_tls."0.2.2".default = (f.native_tls."0.2.2".default or true);
    openssl."${deps.native_tls."0.2.2".openssl}".default = true;
    openssl_probe."${deps.native_tls."0.2.2".openssl_probe}".default = true;
    openssl_sys."${deps.native_tls."0.2.2".openssl_sys}".default = true;
    schannel."${deps.native_tls."0.2.2".schannel}".default = true;
    security_framework."${deps.native_tls."0.2.2".security_framework}".default = true;
    security_framework_sys."${deps.native_tls."0.2.2".security_framework_sys}".default = true;
    tempfile."${deps.native_tls."0.2.2".tempfile}".default = true;
  }) [
    (features_.lazy_static."${deps."native_tls"."0.2.2"."lazy_static"}" deps)
    (features_.libc."${deps."native_tls"."0.2.2"."libc"}" deps)
    (features_.security_framework."${deps."native_tls"."0.2.2"."security_framework"}" deps)
    (features_.security_framework_sys."${deps."native_tls"."0.2.2"."security_framework_sys"}" deps)
    (features_.tempfile."${deps."native_tls"."0.2.2"."tempfile"}" deps)
    (features_.openssl."${deps."native_tls"."0.2.2"."openssl"}" deps)
    (features_.openssl_probe."${deps."native_tls"."0.2.2"."openssl_probe"}" deps)
    (features_.openssl_sys."${deps."native_tls"."0.2.2"."openssl_sys"}" deps)
    (features_.log."${deps."native_tls"."0.2.2"."log"}" deps)
    (features_.schannel."${deps."native_tls"."0.2.2"."schannel"}" deps)
  ];


# end
# net2-0.2.33

  crates.net2."0.2.33" = deps: { features?(features_.net2."0.2.33" deps {}) }: buildRustCrate {
    crateName = "net2";
    version = "0.2.33";
    description = "Extensions to the standard library's networking types as proposed in RFC 1158.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1qnmajafgybj5wyxz9iffa8x5wgbwd2znfklmhqj7vl6lw1m65mq";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."net2"."0.2.33"."cfg_if"}" deps)
    ])
      ++ (if kernel == "redox" || (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.33"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."net2"."0.2.33"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."net2"."0.2.33" or {});
  };
  features_.net2."0.2.33" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.net2."0.2.33".cfg_if}".default = true;
    libc."${deps.net2."0.2.33".libc}".default = true;
    net2 = fold recursiveUpdate {} [
      { "0.2.33"."duration" =
        (f.net2."0.2.33"."duration" or false) ||
        (f.net2."0.2.33".default or false) ||
        (net2."0.2.33"."default" or false); }
      { "0.2.33".default = (f.net2."0.2.33".default or true); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.net2."0.2.33".winapi}"."handleapi" = true; }
      { "${deps.net2."0.2.33".winapi}"."winsock2" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2def" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2ipdef" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2tcpip" = true; }
      { "${deps.net2."0.2.33".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."net2"."0.2.33"."cfg_if"}" deps)
    (features_.libc."${deps."net2"."0.2.33"."libc"}" deps)
    (features_.winapi."${deps."net2"."0.2.33"."winapi"}" deps)
  ];


# end
# nodrop-0.1.13

  crates.nodrop."0.1.13" = deps: { features?(features_.nodrop."0.1.13" deps {}) }: buildRustCrate {
    crateName = "nodrop";
    version = "0.1.13";
    description = "A wrapper type to inhibit drop (destructor). Use std::mem::ManuallyDrop instead!";
    authors = [ "bluss" ];
    sha256 = "0gkfx6wihr9z0m8nbdhma5pyvbipznjpkzny2d4zkc05b0vnhinb";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."nodrop"."0.1.13" or {});
  };
  features_.nodrop."0.1.13" = deps: f: updateFeatures f (rec {
    nodrop = fold recursiveUpdate {} [
      { "0.1.13"."nodrop-union" =
        (f.nodrop."0.1.13"."nodrop-union" or false) ||
        (f.nodrop."0.1.13".use_union or false) ||
        (nodrop."0.1.13"."use_union" or false); }
      { "0.1.13"."std" =
        (f.nodrop."0.1.13"."std" or false) ||
        (f.nodrop."0.1.13".default or false) ||
        (nodrop."0.1.13"."default" or false); }
      { "0.1.13".default = (f.nodrop."0.1.13".default or true); }
    ];
  }) [];


# end
# num-0.1.40

  crates.num."0.1.40" = deps: { features?(features_.num."0.1.40" deps {}) }: buildRustCrate {
    crateName = "num";
    version = "0.1.40";
    description = "A collection of numeric types and traits for Rust, including bigint,\ncomplex, rational, range iterators, generic integers, and more!\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0b29c25n9mpf6a921khj7a6y3hz5va4vgwppcd2if975qq1shakg";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num"."0.1.40"."num_integer"}" deps)
      (crates."num_iter"."${deps."num"."0.1.40"."num_iter"}" deps)
      (crates."num_traits"."${deps."num"."0.1.40"."num_traits"}" deps)
    ]);
    features = mkFeatures (features."num"."0.1.40" or {});
  };
  features_.num."0.1.40" = deps: f: updateFeatures f (rec {
    num = fold recursiveUpdate {} [
      { "0.1.40"."bigint" =
        (f.num."0.1.40"."bigint" or false) ||
        (f.num."0.1.40".default or false) ||
        (num."0.1.40"."default" or false); }
      { "0.1.40"."complex" =
        (f.num."0.1.40"."complex" or false) ||
        (f.num."0.1.40".default or false) ||
        (num."0.1.40"."default" or false); }
      { "0.1.40"."num-bigint" =
        (f.num."0.1.40"."num-bigint" or false) ||
        (f.num."0.1.40".bigint or false) ||
        (num."0.1.40"."bigint" or false); }
      { "0.1.40"."num-complex" =
        (f.num."0.1.40"."num-complex" or false) ||
        (f.num."0.1.40".complex or false) ||
        (num."0.1.40"."complex" or false); }
      { "0.1.40"."num-rational" =
        (f.num."0.1.40"."num-rational" or false) ||
        (f.num."0.1.40".rational or false) ||
        (num."0.1.40"."rational" or false); }
      { "0.1.40"."rational" =
        (f.num."0.1.40"."rational" or false) ||
        (f.num."0.1.40".default or false) ||
        (num."0.1.40"."default" or false); }
      { "0.1.40"."rustc-serialize" =
        (f.num."0.1.40"."rustc-serialize" or false) ||
        (f.num."0.1.40".default or false) ||
        (num."0.1.40"."default" or false); }
      { "0.1.40".default = (f.num."0.1.40".default or true); }
    ];
    num_integer."${deps.num."0.1.40".num_integer}".default = true;
    num_iter."${deps.num."0.1.40".num_iter}".default = true;
    num_traits."${deps.num."0.1.40".num_traits}".default = true;
  }) [
    (features_.num_integer."${deps."num"."0.1.40"."num_integer"}" deps)
    (features_.num_iter."${deps."num"."0.1.40"."num_iter"}" deps)
    (features_.num_traits."${deps."num"."0.1.40"."num_traits"}" deps)
  ];


# end
# num-integer-0.1.35

  crates.num_integer."0.1.35" = deps: { features?(features_.num_integer."0.1.35" deps {}) }: buildRustCrate {
    crateName = "num-integer";
    version = "0.1.35";
    description = "Integer traits and functions";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0xybj8isi9b6wc646d5rc043i8l8j6wy0vrl4pn995qms9fxbbcc";
    dependencies = mapFeatures features ([
      (crates."num_traits"."${deps."num_integer"."0.1.35"."num_traits"}" deps)
    ]);
  };
  features_.num_integer."0.1.35" = deps: f: updateFeatures f ({
    num_integer."0.1.35".default = (f.num_integer."0.1.35".default or true);
    num_traits."${deps.num_integer."0.1.35".num_traits}".default = true;
  }) [
    (features_.num_traits."${deps."num_integer"."0.1.35"."num_traits"}" deps)
  ];


# end
# num-iter-0.1.34

  crates.num_iter."0.1.34" = deps: { features?(features_.num_iter."0.1.34" deps {}) }: buildRustCrate {
    crateName = "num-iter";
    version = "0.1.34";
    description = "External iterators for generic mathematics";
    authors = [ "The Rust Project Developers" ];
    sha256 = "02cld7x9dzbqbs6sxxzq1i22z3awlcd6ljkgvhkfr9rsnaxphzl9";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_iter"."0.1.34"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_iter"."0.1.34"."num_traits"}" deps)
    ]);
  };
  features_.num_iter."0.1.34" = deps: f: updateFeatures f ({
    num_integer."${deps.num_iter."0.1.34".num_integer}".default = true;
    num_iter."0.1.34".default = (f.num_iter."0.1.34".default or true);
    num_traits."${deps.num_iter."0.1.34".num_traits}".default = true;
  }) [
    (features_.num_integer."${deps."num_iter"."0.1.34"."num_integer"}" deps)
    (features_.num_traits."${deps."num_iter"."0.1.34"."num_traits"}" deps)
  ];


# end
# num-traits-0.1.40

  crates.num_traits."0.1.40" = deps: { features?(features_.num_traits."0.1.40" deps {}) }: buildRustCrate {
    crateName = "num-traits";
    version = "0.1.40";
    description = "Numeric traits for generic mathematics";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1fr8ghp4i97q3agki54i0hpmqxv3s65i2mqd1pinc7w7arc3fplw";
  };
  features_.num_traits."0.1.40" = deps: f: updateFeatures f ({
    num_traits."0.1.40".default = (f.num_traits."0.1.40".default or true);
  }) [];


# end
# num_cpus-1.8.0

  crates.num_cpus."1.8.0" = deps: { features?(features_.num_cpus."1.8.0" deps {}) }: buildRustCrate {
    crateName = "num_cpus";
    version = "1.8.0";
    description = "Get the number of CPUs on a machine.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1y6qnd9r8ga6y8mvlabdrr73nc8cshjjlzbvnanzyj9b8zzkfwk2";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."num_cpus"."1.8.0"."libc"}" deps)
    ]);
  };
  features_.num_cpus."1.8.0" = deps: f: updateFeatures f ({
    libc."${deps.num_cpus."1.8.0".libc}".default = true;
    num_cpus."1.8.0".default = (f.num_cpus."1.8.0".default or true);
  }) [
    (features_.libc."${deps."num_cpus"."1.8.0"."libc"}" deps)
  ];


# end
# openssl-0.10.15

  crates.openssl."0.10.15" = deps: { features?(features_.openssl."0.10.15" deps {}) }: buildRustCrate {
    crateName = "openssl";
    version = "0.10.15";
    description = "OpenSSL bindings";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0fj5g66ibkyb6vfdfjgaypfn45vpj2cdv7d7qpq653sv57glcqri";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."openssl"."0.10.15"."bitflags"}" deps)
      (crates."cfg_if"."${deps."openssl"."0.10.15"."cfg_if"}" deps)
      (crates."foreign_types"."${deps."openssl"."0.10.15"."foreign_types"}" deps)
      (crates."lazy_static"."${deps."openssl"."0.10.15"."lazy_static"}" deps)
      (crates."libc"."${deps."openssl"."0.10.15"."libc"}" deps)
      (crates."openssl_sys"."${deps."openssl"."0.10.15"."openssl_sys"}" deps)
    ]);
    features = mkFeatures (features."openssl"."0.10.15" or {});
  };
  features_.openssl."0.10.15" = deps: f: updateFeatures f (rec {
    bitflags."${deps.openssl."0.10.15".bitflags}".default = true;
    cfg_if."${deps.openssl."0.10.15".cfg_if}".default = true;
    foreign_types."${deps.openssl."0.10.15".foreign_types}".default = true;
    lazy_static."${deps.openssl."0.10.15".lazy_static}".default = true;
    libc."${deps.openssl."0.10.15".libc}".default = true;
    openssl."0.10.15".default = (f.openssl."0.10.15".default or true);
    openssl_sys = fold recursiveUpdate {} [
      { "${deps.openssl."0.10.15".openssl_sys}"."vendored" =
        (f.openssl_sys."${deps.openssl."0.10.15".openssl_sys}"."vendored" or false) ||
        (openssl."0.10.15"."vendored" or false) ||
        (f."openssl"."0.10.15"."vendored" or false); }
      { "${deps.openssl."0.10.15".openssl_sys}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."openssl"."0.10.15"."bitflags"}" deps)
    (features_.cfg_if."${deps."openssl"."0.10.15"."cfg_if"}" deps)
    (features_.foreign_types."${deps."openssl"."0.10.15"."foreign_types"}" deps)
    (features_.lazy_static."${deps."openssl"."0.10.15"."lazy_static"}" deps)
    (features_.libc."${deps."openssl"."0.10.15"."libc"}" deps)
    (features_.openssl_sys."${deps."openssl"."0.10.15"."openssl_sys"}" deps)
  ];


# end
# openssl-probe-0.1.2

  crates.openssl_probe."0.1.2" = deps: { features?(features_.openssl_probe."0.1.2" deps {}) }: buildRustCrate {
    crateName = "openssl-probe";
    version = "0.1.2";
    description = "Tool for helping to find SSL certificate locations on the system for OpenSSL\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1a89fznx26vvaxyrxdvgf6iwai5xvs6xjvpjin68fgvrslv6n15a";
  };
  features_.openssl_probe."0.1.2" = deps: f: updateFeatures f ({
    openssl_probe."0.1.2".default = (f.openssl_probe."0.1.2".default or true);
  }) [];


# end
# openssl-sys-0.9.39

  crates.openssl_sys."0.9.39" = deps: { features?(features_.openssl_sys."0.9.39" deps {}) }: buildRustCrate {
    crateName = "openssl-sys";
    version = "0.9.39";
    description = "FFI bindings to OpenSSL";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1lraqg3xz4jxrc99na17kn6srfhsgnj1yjk29mgsh803w40s2056";
    build = "build/main.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."openssl_sys"."0.9.39"."libc"}" deps)
    ])
      ++ (if abi == "msvc" then mapFeatures features ([
]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."openssl_sys"."0.9.39"."cc"}" deps)
      (crates."pkg_config"."${deps."openssl_sys"."0.9.39"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."openssl_sys"."0.9.39" or {});
  };
  features_.openssl_sys."0.9.39" = deps: f: updateFeatures f (rec {
    cc."${deps.openssl_sys."0.9.39".cc}".default = true;
    libc."${deps.openssl_sys."0.9.39".libc}".default = true;
    openssl_sys = fold recursiveUpdate {} [
      { "0.9.39"."openssl-src" =
        (f.openssl_sys."0.9.39"."openssl-src" or false) ||
        (f.openssl_sys."0.9.39".vendored or false) ||
        (openssl_sys."0.9.39"."vendored" or false); }
      { "0.9.39".default = (f.openssl_sys."0.9.39".default or true); }
    ];
    pkg_config."${deps.openssl_sys."0.9.39".pkg_config}".default = true;
  }) [
    (features_.libc."${deps."openssl_sys"."0.9.39"."libc"}" deps)
    (features_.cc."${deps."openssl_sys"."0.9.39"."cc"}" deps)
    (features_.pkg_config."${deps."openssl_sys"."0.9.39"."pkg_config"}" deps)
  ];


# end
# owning_ref-0.4.0

  crates.owning_ref."0.4.0" = deps: { features?(features_.owning_ref."0.4.0" deps {}) }: buildRustCrate {
    crateName = "owning_ref";
    version = "0.4.0";
    description = "A library for creating references that carry their owner with them.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1m95qpc3hamkw9wlbfzqkzk7h6skyj40zr6sa3ps151slcfnnchm";
    dependencies = mapFeatures features ([
      (crates."stable_deref_trait"."${deps."owning_ref"."0.4.0"."stable_deref_trait"}" deps)
    ]);
  };
  features_.owning_ref."0.4.0" = deps: f: updateFeatures f ({
    owning_ref."0.4.0".default = (f.owning_ref."0.4.0".default or true);
    stable_deref_trait."${deps.owning_ref."0.4.0".stable_deref_trait}".default = true;
  }) [
    (features_.stable_deref_trait."${deps."owning_ref"."0.4.0"."stable_deref_trait"}" deps)
  ];


# end
# parking_lot-0.6.4

  crates.parking_lot."0.6.4" = deps: { features?(features_.parking_lot."0.6.4" deps {}) }: buildRustCrate {
    crateName = "parking_lot";
    version = "0.6.4";
    description = "More compact and efficient implementations of the standard synchronization primitives.";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0qwfysx8zfkj72sfcrqvd6pp7lgjmklyixsi3y0g6xjspw876rax";
    dependencies = mapFeatures features ([
      (crates."lock_api"."${deps."parking_lot"."0.6.4"."lock_api"}" deps)
      (crates."parking_lot_core"."${deps."parking_lot"."0.6.4"."parking_lot_core"}" deps)
    ]);
    features = mkFeatures (features."parking_lot"."0.6.4" or {});
  };
  features_.parking_lot."0.6.4" = deps: f: updateFeatures f (rec {
    lock_api = fold recursiveUpdate {} [
      { "${deps.parking_lot."0.6.4".lock_api}"."nightly" =
        (f.lock_api."${deps.parking_lot."0.6.4".lock_api}"."nightly" or false) ||
        (parking_lot."0.6.4"."nightly" or false) ||
        (f."parking_lot"."0.6.4"."nightly" or false); }
      { "${deps.parking_lot."0.6.4".lock_api}"."owning_ref" =
        (f.lock_api."${deps.parking_lot."0.6.4".lock_api}"."owning_ref" or false) ||
        (parking_lot."0.6.4"."owning_ref" or false) ||
        (f."parking_lot"."0.6.4"."owning_ref" or false); }
      { "${deps.parking_lot."0.6.4".lock_api}".default = true; }
    ];
    parking_lot = fold recursiveUpdate {} [
      { "0.6.4"."owning_ref" =
        (f.parking_lot."0.6.4"."owning_ref" or false) ||
        (f.parking_lot."0.6.4".default or false) ||
        (parking_lot."0.6.4"."default" or false); }
      { "0.6.4".default = (f.parking_lot."0.6.4".default or true); }
    ];
    parking_lot_core = fold recursiveUpdate {} [
      { "${deps.parking_lot."0.6.4".parking_lot_core}"."deadlock_detection" =
        (f.parking_lot_core."${deps.parking_lot."0.6.4".parking_lot_core}"."deadlock_detection" or false) ||
        (parking_lot."0.6.4"."deadlock_detection" or false) ||
        (f."parking_lot"."0.6.4"."deadlock_detection" or false); }
      { "${deps.parking_lot."0.6.4".parking_lot_core}"."nightly" =
        (f.parking_lot_core."${deps.parking_lot."0.6.4".parking_lot_core}"."nightly" or false) ||
        (parking_lot."0.6.4"."nightly" or false) ||
        (f."parking_lot"."0.6.4"."nightly" or false); }
      { "${deps.parking_lot."0.6.4".parking_lot_core}".default = true; }
    ];
  }) [
    (features_.lock_api."${deps."parking_lot"."0.6.4"."lock_api"}" deps)
    (features_.parking_lot_core."${deps."parking_lot"."0.6.4"."parking_lot_core"}" deps)
  ];


# end
# parking_lot_core-0.3.1

  crates.parking_lot_core."0.3.1" = deps: { features?(features_.parking_lot_core."0.3.1" deps {}) }: buildRustCrate {
    crateName = "parking_lot_core";
    version = "0.3.1";
    description = "An advanced API for creating custom synchronization primitives.";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0h5p7dys8cx9y6ii4i57ampf7qdr8zmkpn543kd3h7nkhml8bw72";
    dependencies = mapFeatures features ([
      (crates."rand"."${deps."parking_lot_core"."0.3.1"."rand"}" deps)
      (crates."smallvec"."${deps."parking_lot_core"."0.3.1"."smallvec"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."parking_lot_core"."0.3.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."parking_lot_core"."0.3.1"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."parking_lot_core"."0.3.1"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."parking_lot_core"."0.3.1" or {});
  };
  features_.parking_lot_core."0.3.1" = deps: f: updateFeatures f (rec {
    libc."${deps.parking_lot_core."0.3.1".libc}".default = true;
    parking_lot_core = fold recursiveUpdate {} [
      { "0.3.1"."backtrace" =
        (f.parking_lot_core."0.3.1"."backtrace" or false) ||
        (f.parking_lot_core."0.3.1".deadlock_detection or false) ||
        (parking_lot_core."0.3.1"."deadlock_detection" or false); }
      { "0.3.1"."petgraph" =
        (f.parking_lot_core."0.3.1"."petgraph" or false) ||
        (f.parking_lot_core."0.3.1".deadlock_detection or false) ||
        (parking_lot_core."0.3.1"."deadlock_detection" or false); }
      { "0.3.1"."thread-id" =
        (f.parking_lot_core."0.3.1"."thread-id" or false) ||
        (f.parking_lot_core."0.3.1".deadlock_detection or false) ||
        (parking_lot_core."0.3.1"."deadlock_detection" or false); }
      { "0.3.1".default = (f.parking_lot_core."0.3.1".default or true); }
    ];
    rand."${deps.parking_lot_core."0.3.1".rand}".default = true;
    rustc_version."${deps.parking_lot_core."0.3.1".rustc_version}".default = true;
    smallvec."${deps.parking_lot_core."0.3.1".smallvec}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.parking_lot_core."0.3.1".winapi}"."errhandlingapi" = true; }
      { "${deps.parking_lot_core."0.3.1".winapi}"."handleapi" = true; }
      { "${deps.parking_lot_core."0.3.1".winapi}"."minwindef" = true; }
      { "${deps.parking_lot_core."0.3.1".winapi}"."ntstatus" = true; }
      { "${deps.parking_lot_core."0.3.1".winapi}"."winbase" = true; }
      { "${deps.parking_lot_core."0.3.1".winapi}"."winerror" = true; }
      { "${deps.parking_lot_core."0.3.1".winapi}"."winnt" = true; }
      { "${deps.parking_lot_core."0.3.1".winapi}".default = true; }
    ];
  }) [
    (features_.rand."${deps."parking_lot_core"."0.3.1"."rand"}" deps)
    (features_.smallvec."${deps."parking_lot_core"."0.3.1"."smallvec"}" deps)
    (features_.rustc_version."${deps."parking_lot_core"."0.3.1"."rustc_version"}" deps)
    (features_.libc."${deps."parking_lot_core"."0.3.1"."libc"}" deps)
    (features_.winapi."${deps."parking_lot_core"."0.3.1"."winapi"}" deps)
  ];


# end
# percent-encoding-1.0.1

  crates.percent_encoding."1.0.1" = deps: { features?(features_.percent_encoding."1.0.1" deps {}) }: buildRustCrate {
    crateName = "percent-encoding";
    version = "1.0.1";
    description = "Percent encoding and decoding";
    authors = [ "The rust-url developers" ];
    sha256 = "04ahrp7aw4ip7fmadb0bknybmkfav0kk0gw4ps3ydq5w6hr0ib5i";
    libPath = "lib.rs";
  };
  features_.percent_encoding."1.0.1" = deps: f: updateFeatures f ({
    percent_encoding."1.0.1".default = (f.percent_encoding."1.0.1".default or true);
  }) [];


# end
# phf-0.7.21

  crates.phf."0.7.21" = deps: { features?(features_.phf."0.7.21" deps {}) }: buildRustCrate {
    crateName = "phf";
    version = "0.7.21";
    description = "Runtime support for perfect hash function data structures";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "11m2rzm2s8s35m0s97gjxxb181xz352kjlhr387xj5c8q3qp5afg";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf"."0.7.21"."phf_shared"}" deps)
    ]);
    features = mkFeatures (features."phf"."0.7.21" or {});
  };
  features_.phf."0.7.21" = deps: f: updateFeatures f (rec {
    phf."0.7.21".default = (f.phf."0.7.21".default or true);
    phf_shared = fold recursiveUpdate {} [
      { "${deps.phf."0.7.21".phf_shared}"."core" =
        (f.phf_shared."${deps.phf."0.7.21".phf_shared}"."core" or false) ||
        (phf."0.7.21"."core" or false) ||
        (f."phf"."0.7.21"."core" or false); }
      { "${deps.phf."0.7.21".phf_shared}"."unicase" =
        (f.phf_shared."${deps.phf."0.7.21".phf_shared}"."unicase" or false) ||
        (phf."0.7.21"."unicase" or false) ||
        (f."phf"."0.7.21"."unicase" or false); }
      { "${deps.phf."0.7.21".phf_shared}".default = true; }
    ];
  }) [
    (features_.phf_shared."${deps."phf"."0.7.21"."phf_shared"}" deps)
  ];


# end
# phf_codegen-0.7.21

  crates.phf_codegen."0.7.21" = deps: { features?(features_.phf_codegen."0.7.21" deps {}) }: buildRustCrate {
    crateName = "phf_codegen";
    version = "0.7.21";
    description = "Codegen library for PHF types";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0kgy8s2q4zr0iqcm21mgq4ppc45wy6z7b5wn98xyfsrcad6lwmmj";
    dependencies = mapFeatures features ([
      (crates."phf_generator"."${deps."phf_codegen"."0.7.21"."phf_generator"}" deps)
      (crates."phf_shared"."${deps."phf_codegen"."0.7.21"."phf_shared"}" deps)
    ]);
  };
  features_.phf_codegen."0.7.21" = deps: f: updateFeatures f ({
    phf_codegen."0.7.21".default = (f.phf_codegen."0.7.21".default or true);
    phf_generator."${deps.phf_codegen."0.7.21".phf_generator}".default = true;
    phf_shared."${deps.phf_codegen."0.7.21".phf_shared}".default = true;
  }) [
    (features_.phf_generator."${deps."phf_codegen"."0.7.21"."phf_generator"}" deps)
    (features_.phf_shared."${deps."phf_codegen"."0.7.21"."phf_shared"}" deps)
  ];


# end
# phf_generator-0.7.21

  crates.phf_generator."0.7.21" = deps: { features?(features_.phf_generator."0.7.21" deps {}) }: buildRustCrate {
    crateName = "phf_generator";
    version = "0.7.21";
    description = "PHF generation logic";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1jxjfzc6d6d4l9nv0r2bb66if5brk9lnncmg4dpjjifn6zhhqd9g";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf_generator"."0.7.21"."phf_shared"}" deps)
      (crates."rand"."${deps."phf_generator"."0.7.21"."rand"}" deps)
    ]);
  };
  features_.phf_generator."0.7.21" = deps: f: updateFeatures f ({
    phf_generator."0.7.21".default = (f.phf_generator."0.7.21".default or true);
    phf_shared."${deps.phf_generator."0.7.21".phf_shared}".default = true;
    rand."${deps.phf_generator."0.7.21".rand}".default = true;
  }) [
    (features_.phf_shared."${deps."phf_generator"."0.7.21"."phf_shared"}" deps)
    (features_.rand."${deps."phf_generator"."0.7.21"."rand"}" deps)
  ];


# end
# phf_shared-0.7.21

  crates.phf_shared."0.7.21" = deps: { features?(features_.phf_shared."0.7.21" deps {}) }: buildRustCrate {
    crateName = "phf_shared";
    version = "0.7.21";
    description = "Support code shared by PHF libraries";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0lxpg3wgxfhzfalmf9ha9my1lsvfjy74ah9f6mfw88xlp545jlln";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."siphasher"."${deps."phf_shared"."0.7.21"."siphasher"}" deps)
    ]
      ++ (if features.phf_shared."0.7.21".unicase or false then [ (crates.unicase."${deps."phf_shared"."0.7.21".unicase}" deps) ] else []));
    features = mkFeatures (features."phf_shared"."0.7.21" or {});
  };
  features_.phf_shared."0.7.21" = deps: f: updateFeatures f ({
    phf_shared."0.7.21".default = (f.phf_shared."0.7.21".default or true);
    siphasher."${deps.phf_shared."0.7.21".siphasher}".default = true;
    unicase."${deps.phf_shared."0.7.21".unicase}".default = true;
  }) [
    (features_.siphasher."${deps."phf_shared"."0.7.21"."siphasher"}" deps)
    (features_.unicase."${deps."phf_shared"."0.7.21"."unicase"}" deps)
  ];


# end
# pkg-config-0.3.9

  crates.pkg_config."0.3.9" = deps: { features?(features_.pkg_config."0.3.9" deps {}) }: buildRustCrate {
    crateName = "pkg-config";
    version = "0.3.9";
    description = "A library to run the pkg-config system tool at build time in order to be used in\nCargo build scripts.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "06k8fxgrsrxj8mjpjcq1n7mn2p1shpxif4zg9y5h09c7vy20s146";
  };
  features_.pkg_config."0.3.9" = deps: f: updateFeatures f ({
    pkg_config."0.3.9".default = (f.pkg_config."0.3.9".default or true);
  }) [];


# end
# quote-0.3.15

  crates.quote."0.3.15" = deps: { features?(features_.quote."0.3.15" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.3.15";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "09il61jv4kd1360spaj46qwyl21fv1qz18fsv2jra8wdnlgl5jsg";
  };
  features_.quote."0.3.15" = deps: f: updateFeatures f ({
    quote."0.3.15".default = (f.quote."0.3.15".default or true);
  }) [];


# end
# rand-0.3.18

  crates.rand."0.3.18" = deps: { features?(features_.rand."0.3.18" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.3.18";
    description = "Random number generators and other randomness functionality.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "15d7c3myn968dzjs0a2pgv58hzdavxnq6swgj032lw2v966ir4xv";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."rand"."0.3.18"."libc"}" deps)
    ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."rand"."0.3.18"."fuchsia_zircon"}" deps)
    ]) else []);
    features = mkFeatures (features."rand"."0.3.18" or {});
  };
  features_.rand."0.3.18" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.rand."0.3.18".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.3.18".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.3.18"."i128_support" =
        (f.rand."0.3.18"."i128_support" or false) ||
        (f.rand."0.3.18".nightly or false) ||
        (rand."0.3.18"."nightly" or false); }
      { "0.3.18".default = (f.rand."0.3.18".default or true); }
    ];
  }) [
    (features_.libc."${deps."rand"."0.3.18"."libc"}" deps)
    (features_.fuchsia_zircon."${deps."rand"."0.3.18"."fuchsia_zircon"}" deps)
  ];


# end
# rand-0.5.5

  crates.rand."0.5.5" = deps: { features?(features_.rand."0.5.5" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.5.5";
    description = "Random number generators and other randomness functionality.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0d7pnsh57qxhz1ghrzk113ddkn13kf2g758ffnbxq4nhwjfzhlc9";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand"."0.5.5"."rand_core"}" deps)
    ])
      ++ (if kernel == "cloudabi" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".cloudabi or false then [ (crates.cloudabi."${deps."rand"."0.5.5".cloudabi}" deps) ] else [])) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".fuchsia-zircon or false then [ (crates.fuchsia_zircon."${deps."rand"."0.5.5".fuchsia_zircon}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".libc or false then [ (crates.libc."${deps."rand"."0.5.5".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".winapi or false then [ (crates.winapi."${deps."rand"."0.5.5".winapi}" deps) ] else [])) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);
    features = mkFeatures (features."rand"."0.5.5" or {});
  };
  features_.rand."0.5.5" = deps: f: updateFeatures f (rec {
    cloudabi."${deps.rand."0.5.5".cloudabi}".default = true;
    fuchsia_zircon."${deps.rand."0.5.5".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.5.5".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.5.5"."alloc" =
        (f.rand."0.5.5"."alloc" or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5"."cloudabi" =
        (f.rand."0.5.5"."cloudabi" or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5"."fuchsia-zircon" =
        (f.rand."0.5.5"."fuchsia-zircon" or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5"."i128_support" =
        (f.rand."0.5.5"."i128_support" or false) ||
        (f.rand."0.5.5".nightly or false) ||
        (rand."0.5.5"."nightly" or false); }
      { "0.5.5"."libc" =
        (f.rand."0.5.5"."libc" or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5"."serde" =
        (f.rand."0.5.5"."serde" or false) ||
        (f.rand."0.5.5".serde1 or false) ||
        (rand."0.5.5"."serde1" or false); }
      { "0.5.5"."serde_derive" =
        (f.rand."0.5.5"."serde_derive" or false) ||
        (f.rand."0.5.5".serde1 or false) ||
        (rand."0.5.5"."serde1" or false); }
      { "0.5.5"."std" =
        (f.rand."0.5.5"."std" or false) ||
        (f.rand."0.5.5".default or false) ||
        (rand."0.5.5"."default" or false); }
      { "0.5.5"."winapi" =
        (f.rand."0.5.5"."winapi" or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5".default = (f.rand."0.5.5".default or true); }
    ];
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand."0.5.5".rand_core}"."alloc" =
        (f.rand_core."${deps.rand."0.5.5".rand_core}"."alloc" or false) ||
        (rand."0.5.5"."alloc" or false) ||
        (f."rand"."0.5.5"."alloc" or false); }
      { "${deps.rand."0.5.5".rand_core}"."serde1" =
        (f.rand_core."${deps.rand."0.5.5".rand_core}"."serde1" or false) ||
        (rand."0.5.5"."serde1" or false) ||
        (f."rand"."0.5.5"."serde1" or false); }
      { "${deps.rand."0.5.5".rand_core}"."std" =
        (f.rand_core."${deps.rand."0.5.5".rand_core}"."std" or false) ||
        (rand."0.5.5"."std" or false) ||
        (f."rand"."0.5.5"."std" or false); }
      { "${deps.rand."0.5.5".rand_core}".default = (f.rand_core."${deps.rand."0.5.5".rand_core}".default or false); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.5.5".winapi}"."minwindef" = true; }
      { "${deps.rand."0.5.5".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.5.5".winapi}"."profileapi" = true; }
      { "${deps.rand."0.5.5".winapi}"."winnt" = true; }
      { "${deps.rand."0.5.5".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand"."0.5.5"."rand_core"}" deps)
    (features_.cloudabi."${deps."rand"."0.5.5"."cloudabi"}" deps)
    (features_.fuchsia_zircon."${deps."rand"."0.5.5"."fuchsia_zircon"}" deps)
    (features_.libc."${deps."rand"."0.5.5"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.5.5"."winapi"}" deps)
  ];


# end
# rand-0.6.1

  crates.rand."0.6.1" = deps: { features?(features_.rand."0.6.1" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.6.1";
    description = "Random number generators and other randomness functionality.\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "123s3w165iiifmf475lisqkd0kbr7nwnn3k4b1zg2cwap5v9m9bz";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_chacha"."${deps."rand"."0.6.1"."rand_chacha"}" deps)
      (crates."rand_core"."${deps."rand"."0.6.1"."rand_core"}" deps)
      (crates."rand_hc"."${deps."rand"."0.6.1"."rand_hc"}" deps)
      (crates."rand_isaac"."${deps."rand"."0.6.1"."rand_isaac"}" deps)
      (crates."rand_pcg"."${deps."rand"."0.6.1"."rand_pcg"}" deps)
      (crates."rand_xorshift"."${deps."rand"."0.6.1"."rand_xorshift"}" deps)
    ])
      ++ (if kernel == "cloudabi" then mapFeatures features ([
    ]
      ++ (if features.rand."0.6.1".cloudabi or false then [ (crates.cloudabi."${deps."rand"."0.6.1".cloudabi}" deps) ] else [])) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
    ]
      ++ (if features.rand."0.6.1".fuchsia-zircon or false then [ (crates.fuchsia_zircon."${deps."rand"."0.6.1".fuchsia_zircon}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.6.1".libc or false then [ (crates.libc."${deps."rand"."0.6.1".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.rand."0.6.1".winapi or false then [ (crates.winapi."${deps."rand"."0.6.1".winapi}" deps) ] else [])) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."rand"."0.6.1"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."rand"."0.6.1" or {});
  };
  features_.rand."0.6.1" = deps: f: updateFeatures f (rec {
    cloudabi."${deps.rand."0.6.1".cloudabi}".default = true;
    fuchsia_zircon."${deps.rand."0.6.1".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.6.1".libc}".default = (f.libc."${deps.rand."0.6.1".libc}".default or false);
    rand = fold recursiveUpdate {} [
      { "0.6.1"."alloc" =
        (f.rand."0.6.1"."alloc" or false) ||
        (f.rand."0.6.1".std or false) ||
        (rand."0.6.1"."std" or false); }
      { "0.6.1"."cloudabi" =
        (f.rand."0.6.1"."cloudabi" or false) ||
        (f.rand."0.6.1".std or false) ||
        (rand."0.6.1"."std" or false); }
      { "0.6.1"."fuchsia-zircon" =
        (f.rand."0.6.1"."fuchsia-zircon" or false) ||
        (f.rand."0.6.1".std or false) ||
        (rand."0.6.1"."std" or false); }
      { "0.6.1"."libc" =
        (f.rand."0.6.1"."libc" or false) ||
        (f.rand."0.6.1".std or false) ||
        (rand."0.6.1"."std" or false); }
      { "0.6.1"."packed_simd" =
        (f.rand."0.6.1"."packed_simd" or false) ||
        (f.rand."0.6.1".simd_support or false) ||
        (rand."0.6.1"."simd_support" or false); }
      { "0.6.1"."simd_support" =
        (f.rand."0.6.1"."simd_support" or false) ||
        (f.rand."0.6.1".nightly or false) ||
        (rand."0.6.1"."nightly" or false); }
      { "0.6.1"."std" =
        (f.rand."0.6.1"."std" or false) ||
        (f.rand."0.6.1".default or false) ||
        (rand."0.6.1"."default" or false); }
      { "0.6.1"."winapi" =
        (f.rand."0.6.1"."winapi" or false) ||
        (f.rand."0.6.1".std or false) ||
        (rand."0.6.1"."std" or false); }
      { "0.6.1".default = (f.rand."0.6.1".default or true); }
    ];
    rand_chacha."${deps.rand."0.6.1".rand_chacha}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand."0.6.1".rand_core}"."alloc" =
        (f.rand_core."${deps.rand."0.6.1".rand_core}"."alloc" or false) ||
        (rand."0.6.1"."alloc" or false) ||
        (f."rand"."0.6.1"."alloc" or false); }
      { "${deps.rand."0.6.1".rand_core}"."serde1" =
        (f.rand_core."${deps.rand."0.6.1".rand_core}"."serde1" or false) ||
        (rand."0.6.1"."serde1" or false) ||
        (f."rand"."0.6.1"."serde1" or false); }
      { "${deps.rand."0.6.1".rand_core}"."std" =
        (f.rand_core."${deps.rand."0.6.1".rand_core}"."std" or false) ||
        (rand."0.6.1"."std" or false) ||
        (f."rand"."0.6.1"."std" or false); }
      { "${deps.rand."0.6.1".rand_core}".default = (f.rand_core."${deps.rand."0.6.1".rand_core}".default or false); }
    ];
    rand_hc."${deps.rand."0.6.1".rand_hc}".default = true;
    rand_isaac = fold recursiveUpdate {} [
      { "${deps.rand."0.6.1".rand_isaac}"."serde1" =
        (f.rand_isaac."${deps.rand."0.6.1".rand_isaac}"."serde1" or false) ||
        (rand."0.6.1"."serde1" or false) ||
        (f."rand"."0.6.1"."serde1" or false); }
      { "${deps.rand."0.6.1".rand_isaac}".default = true; }
    ];
    rand_pcg."${deps.rand."0.6.1".rand_pcg}".default = true;
    rand_xorshift = fold recursiveUpdate {} [
      { "${deps.rand."0.6.1".rand_xorshift}"."serde1" =
        (f.rand_xorshift."${deps.rand."0.6.1".rand_xorshift}"."serde1" or false) ||
        (rand."0.6.1"."serde1" or false) ||
        (f."rand"."0.6.1"."serde1" or false); }
      { "${deps.rand."0.6.1".rand_xorshift}".default = true; }
    ];
    rustc_version."${deps.rand."0.6.1".rustc_version}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.6.1".winapi}"."minwindef" = true; }
      { "${deps.rand."0.6.1".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.6.1".winapi}"."profileapi" = true; }
      { "${deps.rand."0.6.1".winapi}"."winnt" = true; }
      { "${deps.rand."0.6.1".winapi}".default = true; }
    ];
  }) [
    (features_.rand_chacha."${deps."rand"."0.6.1"."rand_chacha"}" deps)
    (features_.rand_core."${deps."rand"."0.6.1"."rand_core"}" deps)
    (features_.rand_hc."${deps."rand"."0.6.1"."rand_hc"}" deps)
    (features_.rand_isaac."${deps."rand"."0.6.1"."rand_isaac"}" deps)
    (features_.rand_pcg."${deps."rand"."0.6.1"."rand_pcg"}" deps)
    (features_.rand_xorshift."${deps."rand"."0.6.1"."rand_xorshift"}" deps)
    (features_.rustc_version."${deps."rand"."0.6.1"."rustc_version"}" deps)
    (features_.cloudabi."${deps."rand"."0.6.1"."cloudabi"}" deps)
    (features_.fuchsia_zircon."${deps."rand"."0.6.1"."fuchsia_zircon"}" deps)
    (features_.libc."${deps."rand"."0.6.1"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.6.1"."winapi"}" deps)
  ];


# end
# rand_chacha-0.1.0

  crates.rand_chacha."0.1.0" = deps: { features?(features_.rand_chacha."0.1.0" deps {}) }: buildRustCrate {
    crateName = "rand_chacha";
    version = "0.1.0";
    description = "ChaCha random number generator\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0q5pq34cqv1mnibgzd1cmx9q49vkr2lvalkkvizmlld217jmlqc6";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_chacha"."0.1.0"."rand_core"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."rand_chacha"."0.1.0"."rustc_version"}" deps)
    ]);
  };
  features_.rand_chacha."0.1.0" = deps: f: updateFeatures f ({
    rand_chacha."0.1.0".default = (f.rand_chacha."0.1.0".default or true);
    rand_core."${deps.rand_chacha."0.1.0".rand_core}".default = (f.rand_core."${deps.rand_chacha."0.1.0".rand_core}".default or false);
    rustc_version."${deps.rand_chacha."0.1.0".rustc_version}".default = true;
  }) [
    (features_.rand_core."${deps."rand_chacha"."0.1.0"."rand_core"}" deps)
    (features_.rustc_version."${deps."rand_chacha"."0.1.0"."rustc_version"}" deps)
  ];


# end
# rand_core-0.2.2

  crates.rand_core."0.2.2" = deps: { features?(features_.rand_core."0.2.2" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.2.2";
    description = "Core random number generator traits and tools for implementation.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1cxnaxmsirz2wxsajsjkd1wk6lqfqbcprqkha4bq3didznrl22sc";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_core"."0.2.2"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_core"."0.2.2" or {});
  };
  features_.rand_core."0.2.2" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_core."0.2.2".rand_core}"."alloc" =
        (f.rand_core."${deps.rand_core."0.2.2".rand_core}"."alloc" or false) ||
        (rand_core."0.2.2"."alloc" or false) ||
        (f."rand_core"."0.2.2"."alloc" or false); }
      { "${deps.rand_core."0.2.2".rand_core}"."serde1" =
        (f.rand_core."${deps.rand_core."0.2.2".rand_core}"."serde1" or false) ||
        (rand_core."0.2.2"."serde1" or false) ||
        (f."rand_core"."0.2.2"."serde1" or false); }
      { "${deps.rand_core."0.2.2".rand_core}"."std" =
        (f.rand_core."${deps.rand_core."0.2.2".rand_core}"."std" or false) ||
        (rand_core."0.2.2"."std" or false) ||
        (f."rand_core"."0.2.2"."std" or false); }
      { "${deps.rand_core."0.2.2".rand_core}".default = (f.rand_core."${deps.rand_core."0.2.2".rand_core}".default or false); }
      { "0.2.2".default = (f.rand_core."0.2.2".default or true); }
    ];
  }) [
    (features_.rand_core."${deps."rand_core"."0.2.2"."rand_core"}" deps)
  ];


# end
# rand_core-0.3.0

  crates.rand_core."0.3.0" = deps: { features?(features_.rand_core."0.3.0" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.3.0";
    description = "Core random number generator traits and tools for implementation.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1vafw316apjys9va3j987s02djhqp7y21v671v3ix0p5j9bjq339";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."rand_core"."0.3.0" or {});
  };
  features_.rand_core."0.3.0" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "0.3.0"."alloc" =
        (f.rand_core."0.3.0"."alloc" or false) ||
        (f.rand_core."0.3.0".std or false) ||
        (rand_core."0.3.0"."std" or false); }
      { "0.3.0"."serde" =
        (f.rand_core."0.3.0"."serde" or false) ||
        (f.rand_core."0.3.0".serde1 or false) ||
        (rand_core."0.3.0"."serde1" or false); }
      { "0.3.0"."serde_derive" =
        (f.rand_core."0.3.0"."serde_derive" or false) ||
        (f.rand_core."0.3.0".serde1 or false) ||
        (rand_core."0.3.0"."serde1" or false); }
      { "0.3.0"."std" =
        (f.rand_core."0.3.0"."std" or false) ||
        (f.rand_core."0.3.0".default or false) ||
        (rand_core."0.3.0"."default" or false); }
      { "0.3.0".default = (f.rand_core."0.3.0".default or true); }
    ];
  }) [];


# end
# rand_hc-0.1.0

  crates.rand_hc."0.1.0" = deps: { features?(features_.rand_hc."0.1.0" deps {}) }: buildRustCrate {
    crateName = "rand_hc";
    version = "0.1.0";
    description = "HC128 random number generator\n";
    authors = [ "The Rand Project Developers" ];
    sha256 = "05agb75j87yp7y1zk8yf7bpm66hc0673r3dlypn0kazynr6fdgkz";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_hc"."0.1.0"."rand_core"}" deps)
    ]);
  };
  features_.rand_hc."0.1.0" = deps: f: updateFeatures f ({
    rand_core."${deps.rand_hc."0.1.0".rand_core}".default = (f.rand_core."${deps.rand_hc."0.1.0".rand_core}".default or false);
    rand_hc."0.1.0".default = (f.rand_hc."0.1.0".default or true);
  }) [
    (features_.rand_core."${deps."rand_hc"."0.1.0"."rand_core"}" deps)
  ];


# end
# rand_isaac-0.1.1

  crates.rand_isaac."0.1.1" = deps: { features?(features_.rand_isaac."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_isaac";
    version = "0.1.1";
    description = "ISAAC random number generator\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "10hhdh5b5sa03s6b63y9bafm956jwilx41s71jbrzl63ccx8lxdq";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_isaac"."0.1.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_isaac"."0.1.1" or {});
  };
  features_.rand_isaac."0.1.1" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_isaac."0.1.1".rand_core}"."serde1" =
        (f.rand_core."${deps.rand_isaac."0.1.1".rand_core}"."serde1" or false) ||
        (rand_isaac."0.1.1"."serde1" or false) ||
        (f."rand_isaac"."0.1.1"."serde1" or false); }
      { "${deps.rand_isaac."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_isaac."0.1.1".rand_core}".default or false); }
    ];
    rand_isaac = fold recursiveUpdate {} [
      { "0.1.1"."serde" =
        (f.rand_isaac."0.1.1"."serde" or false) ||
        (f.rand_isaac."0.1.1".serde1 or false) ||
        (rand_isaac."0.1.1"."serde1" or false); }
      { "0.1.1"."serde_derive" =
        (f.rand_isaac."0.1.1"."serde_derive" or false) ||
        (f.rand_isaac."0.1.1".serde1 or false) ||
        (rand_isaac."0.1.1"."serde1" or false); }
      { "0.1.1".default = (f.rand_isaac."0.1.1".default or true); }
    ];
  }) [
    (features_.rand_core."${deps."rand_isaac"."0.1.1"."rand_core"}" deps)
  ];


# end
# rand_pcg-0.1.1

  crates.rand_pcg."0.1.1" = deps: { features?(features_.rand_pcg."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_pcg";
    version = "0.1.1";
    description = "Selected PCG random number generators\n";
    authors = [ "The Rand Project Developers" ];
    sha256 = "0x6pzldj0c8c7gmr67ni5i7w2f7n7idvs3ckx0fc3wkhwl7wrbza";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_pcg"."0.1.1"."rand_core"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."rand_pcg"."0.1.1"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."rand_pcg"."0.1.1" or {});
  };
  features_.rand_pcg."0.1.1" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_pcg."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_pcg."0.1.1".rand_core}".default or false);
    rand_pcg = fold recursiveUpdate {} [
      { "0.1.1"."serde" =
        (f.rand_pcg."0.1.1"."serde" or false) ||
        (f.rand_pcg."0.1.1".serde1 or false) ||
        (rand_pcg."0.1.1"."serde1" or false); }
      { "0.1.1"."serde_derive" =
        (f.rand_pcg."0.1.1"."serde_derive" or false) ||
        (f.rand_pcg."0.1.1".serde1 or false) ||
        (rand_pcg."0.1.1"."serde1" or false); }
      { "0.1.1".default = (f.rand_pcg."0.1.1".default or true); }
    ];
    rustc_version."${deps.rand_pcg."0.1.1".rustc_version}".default = true;
  }) [
    (features_.rand_core."${deps."rand_pcg"."0.1.1"."rand_core"}" deps)
    (features_.rustc_version."${deps."rand_pcg"."0.1.1"."rustc_version"}" deps)
  ];


# end
# rand_xorshift-0.1.0

  crates.rand_xorshift."0.1.0" = deps: { features?(features_.rand_xorshift."0.1.0" deps {}) }: buildRustCrate {
    crateName = "rand_xorshift";
    version = "0.1.0";
    description = "Xorshift random number generator\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "063vxb678ki8gq4rx9w7yg5f9i29ig1zwykl67mfsxn0kxlkv2ih";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_xorshift"."0.1.0"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_xorshift"."0.1.0" or {});
  };
  features_.rand_xorshift."0.1.0" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_xorshift."0.1.0".rand_core}".default = (f.rand_core."${deps.rand_xorshift."0.1.0".rand_core}".default or false);
    rand_xorshift = fold recursiveUpdate {} [
      { "0.1.0"."serde" =
        (f.rand_xorshift."0.1.0"."serde" or false) ||
        (f.rand_xorshift."0.1.0".serde1 or false) ||
        (rand_xorshift."0.1.0"."serde1" or false); }
      { "0.1.0"."serde_derive" =
        (f.rand_xorshift."0.1.0"."serde_derive" or false) ||
        (f.rand_xorshift."0.1.0".serde1 or false) ||
        (rand_xorshift."0.1.0"."serde1" or false); }
      { "0.1.0".default = (f.rand_xorshift."0.1.0".default or true); }
    ];
  }) [
    (features_.rand_core."${deps."rand_xorshift"."0.1.0"."rand_core"}" deps)
  ];


# end
# redox_syscall-0.1.31

  crates.redox_syscall."0.1.31" = deps: { features?(features_.redox_syscall."0.1.31" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.31";
    description = "A Rust library to access raw Redox system calls";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "0kipd9qslzin4fgj4jrxv6yz5l3l71gnbd7fq1jhk2j7f2sq33j4";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.31" = deps: f: updateFeatures f ({
    redox_syscall."0.1.31".default = (f.redox_syscall."0.1.31".default or true);
  }) [];


# end
# redox_termios-0.1.1

  crates.redox_termios."0.1.1" = deps: { features?(features_.redox_termios."0.1.1" deps {}) }: buildRustCrate {
    crateName = "redox_termios";
    version = "0.1.1";
    description = "A Rust library to access Redox termios functions";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "04s6yyzjca552hdaqlvqhp3vw0zqbc304md5czyd3axh56iry8wh";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."redox_syscall"."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
    ]);
  };
  features_.redox_termios."0.1.1" = deps: f: updateFeatures f ({
    redox_syscall."${deps.redox_termios."0.1.1".redox_syscall}".default = true;
    redox_termios."0.1.1".default = (f.redox_termios."0.1.1".default or true);
  }) [
    (features_.redox_syscall."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
  ];


# end
# regex-0.1.80

  crates.regex."0.1.80" = deps: { features?(features_.regex."0.1.80" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.1.80";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0y4s8ghhx6sgzb35irwivm3w0l2hhqhmdcd2px9hirqnkagal9l6";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."0.1.80"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."0.1.80"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."0.1.80"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."0.1.80"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."0.1.80"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."0.1.80" or {});
  };
  features_.regex."0.1.80" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."0.1.80".aho_corasick}".default = true;
    memchr."${deps.regex."0.1.80".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "0.1.80"."simd" =
        (f.regex."0.1.80"."simd" or false) ||
        (f.regex."0.1.80".simd-accel or false) ||
        (regex."0.1.80"."simd-accel" or false); }
      { "0.1.80".default = (f.regex."0.1.80".default or true); }
    ];
    regex_syntax."${deps.regex."0.1.80".regex_syntax}".default = true;
    thread_local."${deps.regex."0.1.80".thread_local}".default = true;
    utf8_ranges."${deps.regex."0.1.80".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."0.1.80"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."0.1.80"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."0.1.80"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."0.1.80"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."0.1.80"."utf8_ranges"}" deps)
  ];


# end
# regex-syntax-0.3.9

  crates.regex_syntax."0.3.9" = deps: { features?(features_.regex_syntax."0.3.9" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.3.9";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1mzhphkbwppwd1zam2jkgjk550cqgf6506i87bw2yzrvcsraiw7m";
  };
  features_.regex_syntax."0.3.9" = deps: f: updateFeatures f ({
    regex_syntax."0.3.9".default = (f.regex_syntax."0.3.9".default or true);
  }) [];


# end
# remove_dir_all-0.5.1

  crates.remove_dir_all."0.5.1" = deps: { features?(features_.remove_dir_all."0.5.1" deps {}) }: buildRustCrate {
    crateName = "remove_dir_all";
    version = "0.5.1";
    description = "A safe, reliable implementation of remove_dir_all for Windows";
    authors = [ "Aaronepower <theaaronepower@gmail.com>" ];
    sha256 = "1chx3yvfbj46xjz4bzsvps208l46hfbcy0sm98gpiya454n4rrl7";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."remove_dir_all"."0.5.1"."winapi"}" deps)
    ]) else []);
  };
  features_.remove_dir_all."0.5.1" = deps: f: updateFeatures f ({
    remove_dir_all."0.5.1".default = (f.remove_dir_all."0.5.1".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.remove_dir_all."0.5.1".winapi}"."errhandlingapi" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."fileapi" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."std" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."winbase" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."winerror" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}".default = true; }
    ];
  }) [
    (features_.winapi."${deps."remove_dir_all"."0.5.1"."winapi"}" deps)
  ];


# end
# reqwest-0.9.5

  crates.reqwest."0.9.5" = deps: { features?(features_.reqwest."0.9.5" deps {}) }: buildRustCrate {
    crateName = "reqwest";
    version = "0.9.5";
    description = "higher level HTTP client library";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1y0fq8ifhbgn6bfvjq831svirqszszj7f73ykbd28inwc0xiv2ix";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."reqwest"."0.9.5"."base64"}" deps)
      (crates."bytes"."${deps."reqwest"."0.9.5"."bytes"}" deps)
      (crates."encoding_rs"."${deps."reqwest"."0.9.5"."encoding_rs"}" deps)
      (crates."futures"."${deps."reqwest"."0.9.5"."futures"}" deps)
      (crates."http"."${deps."reqwest"."0.9.5"."http"}" deps)
      (crates."hyper"."${deps."reqwest"."0.9.5"."hyper"}" deps)
      (crates."libflate"."${deps."reqwest"."0.9.5"."libflate"}" deps)
      (crates."log"."${deps."reqwest"."0.9.5"."log"}" deps)
      (crates."mime"."${deps."reqwest"."0.9.5"."mime"}" deps)
      (crates."mime_guess"."${deps."reqwest"."0.9.5"."mime_guess"}" deps)
      (crates."serde"."${deps."reqwest"."0.9.5"."serde"}" deps)
      (crates."serde_json"."${deps."reqwest"."0.9.5"."serde_json"}" deps)
      (crates."serde_urlencoded"."${deps."reqwest"."0.9.5"."serde_urlencoded"}" deps)
      (crates."tokio"."${deps."reqwest"."0.9.5"."tokio"}" deps)
      (crates."tokio_io"."${deps."reqwest"."0.9.5"."tokio_io"}" deps)
      (crates."url"."${deps."reqwest"."0.9.5"."url"}" deps)
      (crates."uuid"."${deps."reqwest"."0.9.5"."uuid"}" deps)
    ]
      ++ (if features.reqwest."0.9.5".hyper-tls or false then [ (crates.hyper_tls."${deps."reqwest"."0.9.5".hyper_tls}" deps) ] else [])
      ++ (if features.reqwest."0.9.5".native-tls or false then [ (crates.native_tls."${deps."reqwest"."0.9.5".native_tls}" deps) ] else []));
    features = mkFeatures (features."reqwest"."0.9.5" or {});
  };
  features_.reqwest."0.9.5" = deps: f: updateFeatures f (rec {
    base64."${deps.reqwest."0.9.5".base64}".default = true;
    bytes."${deps.reqwest."0.9.5".bytes}".default = true;
    encoding_rs."${deps.reqwest."0.9.5".encoding_rs}".default = true;
    futures."${deps.reqwest."0.9.5".futures}".default = true;
    http."${deps.reqwest."0.9.5".http}".default = true;
    hyper."${deps.reqwest."0.9.5".hyper}".default = true;
    hyper_tls."${deps.reqwest."0.9.5".hyper_tls}".default = true;
    libflate."${deps.reqwest."0.9.5".libflate}".default = true;
    log."${deps.reqwest."0.9.5".log}".default = true;
    mime."${deps.reqwest."0.9.5".mime}".default = true;
    mime_guess."${deps.reqwest."0.9.5".mime_guess}".default = true;
    native_tls."${deps.reqwest."0.9.5".native_tls}".default = true;
    reqwest = fold recursiveUpdate {} [
      { "0.9.5"."default-tls" =
        (f.reqwest."0.9.5"."default-tls" or false) ||
        (f.reqwest."0.9.5".default or false) ||
        (reqwest."0.9.5"."default" or false); }
      { "0.9.5"."hyper-old-types" =
        (f.reqwest."0.9.5"."hyper-old-types" or false) ||
        (f.reqwest."0.9.5".hyper-011 or false) ||
        (reqwest."0.9.5"."hyper-011" or false); }
      { "0.9.5"."hyper-tls" =
        (f.reqwest."0.9.5"."hyper-tls" or false) ||
        (f.reqwest."0.9.5".default-tls or false) ||
        (reqwest."0.9.5"."default-tls" or false); }
      { "0.9.5"."native-tls" =
        (f.reqwest."0.9.5"."native-tls" or false) ||
        (f.reqwest."0.9.5".default-tls or false) ||
        (reqwest."0.9.5"."default-tls" or false); }
      { "0.9.5".default = (f.reqwest."0.9.5".default or true); }
    ];
    serde."${deps.reqwest."0.9.5".serde}".default = true;
    serde_json."${deps.reqwest."0.9.5".serde_json}".default = true;
    serde_urlencoded."${deps.reqwest."0.9.5".serde_urlencoded}".default = true;
    tokio."${deps.reqwest."0.9.5".tokio}".default = true;
    tokio_io."${deps.reqwest."0.9.5".tokio_io}".default = true;
    url."${deps.reqwest."0.9.5".url}".default = true;
    uuid = fold recursiveUpdate {} [
      { "${deps.reqwest."0.9.5".uuid}"."v4" = true; }
      { "${deps.reqwest."0.9.5".uuid}".default = true; }
    ];
  }) [
    (features_.base64."${deps."reqwest"."0.9.5"."base64"}" deps)
    (features_.bytes."${deps."reqwest"."0.9.5"."bytes"}" deps)
    (features_.encoding_rs."${deps."reqwest"."0.9.5"."encoding_rs"}" deps)
    (features_.futures."${deps."reqwest"."0.9.5"."futures"}" deps)
    (features_.http."${deps."reqwest"."0.9.5"."http"}" deps)
    (features_.hyper."${deps."reqwest"."0.9.5"."hyper"}" deps)
    (features_.hyper_tls."${deps."reqwest"."0.9.5"."hyper_tls"}" deps)
    (features_.libflate."${deps."reqwest"."0.9.5"."libflate"}" deps)
    (features_.log."${deps."reqwest"."0.9.5"."log"}" deps)
    (features_.mime."${deps."reqwest"."0.9.5"."mime"}" deps)
    (features_.mime_guess."${deps."reqwest"."0.9.5"."mime_guess"}" deps)
    (features_.native_tls."${deps."reqwest"."0.9.5"."native_tls"}" deps)
    (features_.serde."${deps."reqwest"."0.9.5"."serde"}" deps)
    (features_.serde_json."${deps."reqwest"."0.9.5"."serde_json"}" deps)
    (features_.serde_urlencoded."${deps."reqwest"."0.9.5"."serde_urlencoded"}" deps)
    (features_.tokio."${deps."reqwest"."0.9.5"."tokio"}" deps)
    (features_.tokio_io."${deps."reqwest"."0.9.5"."tokio_io"}" deps)
    (features_.url."${deps."reqwest"."0.9.5"."url"}" deps)
    (features_.uuid."${deps."reqwest"."0.9.5"."uuid"}" deps)
  ];


# end
# rustc_version-0.2.3

  crates.rustc_version."0.2.3" = deps: { features?(features_.rustc_version."0.2.3" deps {}) }: buildRustCrate {
    crateName = "rustc_version";
    version = "0.2.3";
    description = "A library for querying the version of a installed rustc compiler";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "0rgwzbgs3i9fqjm1p4ra3n7frafmpwl29c8lw85kv1rxn7n2zaa7";
    dependencies = mapFeatures features ([
      (crates."semver"."${deps."rustc_version"."0.2.3"."semver"}" deps)
    ]);
  };
  features_.rustc_version."0.2.3" = deps: f: updateFeatures f ({
    rustc_version."0.2.3".default = (f.rustc_version."0.2.3".default or true);
    semver."${deps.rustc_version."0.2.3".semver}".default = true;
  }) [
    (features_.semver."${deps."rustc_version"."0.2.3"."semver"}" deps)
  ];


# end
# safemem-0.3.0

  crates.safemem."0.3.0" = deps: { features?(features_.safemem."0.3.0" deps {}) }: buildRustCrate {
    crateName = "safemem";
    version = "0.3.0";
    description = "Safe wrappers for memory-accessing functions, like `std::ptr::copy()`.";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "0pr39b468d05f6m7m4alsngmj5p7an8df21apsxbi57k0lmwrr18";
    features = mkFeatures (features."safemem"."0.3.0" or {});
  };
  features_.safemem."0.3.0" = deps: f: updateFeatures f (rec {
    safemem = fold recursiveUpdate {} [
      { "0.3.0"."std" =
        (f.safemem."0.3.0"."std" or false) ||
        (f.safemem."0.3.0".default or false) ||
        (safemem."0.3.0"."default" or false); }
      { "0.3.0".default = (f.safemem."0.3.0".default or true); }
    ];
  }) [];


# end
# schannel-0.1.14

  crates.schannel."0.1.14" = deps: { features?(features_.schannel."0.1.14" deps {}) }: buildRustCrate {
    crateName = "schannel";
    version = "0.1.14";
    description = "Schannel bindings for rust, allowing SSL/TLS (e.g. https) without openssl";
    authors = [ "Steven Fackler <sfackler@gmail.com>" "Steffen Butzer <steffen.butzer@outlook.com>" ];
    sha256 = "1g0a88jknns1kwn3x1k3ci5y5zvg58pwdg1xrxkrw3cwd2hynm9k";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."schannel"."0.1.14"."lazy_static"}" deps)
      (crates."winapi"."${deps."schannel"."0.1.14"."winapi"}" deps)
    ]);
  };
  features_.schannel."0.1.14" = deps: f: updateFeatures f ({
    lazy_static."${deps.schannel."0.1.14".lazy_static}".default = true;
    schannel."0.1.14".default = (f.schannel."0.1.14".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.schannel."0.1.14".winapi}"."lmcons" = true; }
      { "${deps.schannel."0.1.14".winapi}"."minschannel" = true; }
      { "${deps.schannel."0.1.14".winapi}"."schannel" = true; }
      { "${deps.schannel."0.1.14".winapi}"."securitybaseapi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."sspi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."sysinfoapi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."timezoneapi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."winbase" = true; }
      { "${deps.schannel."0.1.14".winapi}"."wincrypt" = true; }
      { "${deps.schannel."0.1.14".winapi}"."winerror" = true; }
      { "${deps.schannel."0.1.14".winapi}".default = true; }
    ];
  }) [
    (features_.lazy_static."${deps."schannel"."0.1.14"."lazy_static"}" deps)
    (features_.winapi."${deps."schannel"."0.1.14"."winapi"}" deps)
  ];


# end
# scopeguard-0.3.3

  crates.scopeguard."0.3.3" = deps: { features?(features_.scopeguard."0.3.3" deps {}) }: buildRustCrate {
    crateName = "scopeguard";
    version = "0.3.3";
    description = "A RAII scope guard that will run a given closure when it goes out of scope,\neven if the code between panics (assuming unwinding panic).\n\nDefines the macros `defer!` and `defer_on_unwind!`; the latter only runs\nif the scope is extited through unwinding on panic.\n";
    authors = [ "bluss" ];
    sha256 = "0i1l013csrqzfz6c68pr5pi01hg5v5yahq8fsdmaxy6p8ygsjf3r";
    features = mkFeatures (features."scopeguard"."0.3.3" or {});
  };
  features_.scopeguard."0.3.3" = deps: f: updateFeatures f (rec {
    scopeguard = fold recursiveUpdate {} [
      { "0.3.3"."use_std" =
        (f.scopeguard."0.3.3"."use_std" or false) ||
        (f.scopeguard."0.3.3".default or false) ||
        (scopeguard."0.3.3"."default" or false); }
      { "0.3.3".default = (f.scopeguard."0.3.3".default or true); }
    ];
  }) [];


# end
# security-framework-0.2.1

  crates.security_framework."0.2.1" = deps: { features?(features_.security_framework."0.2.1" deps {}) }: buildRustCrate {
    crateName = "security-framework";
    version = "0.2.1";
    description = "Security Framework bindings";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0qia5g66zmjn57m9swhrkz3cll3bs4061qim6w72v08c2w0pkvsw";
    dependencies = mapFeatures features ([
      (crates."core_foundation"."${deps."security_framework"."0.2.1"."core_foundation"}" deps)
      (crates."core_foundation_sys"."${deps."security_framework"."0.2.1"."core_foundation_sys"}" deps)
      (crates."libc"."${deps."security_framework"."0.2.1"."libc"}" deps)
      (crates."security_framework_sys"."${deps."security_framework"."0.2.1"."security_framework_sys"}" deps)
    ]);
    features = mkFeatures (features."security_framework"."0.2.1" or {});
  };
  features_.security_framework."0.2.1" = deps: f: updateFeatures f (rec {
    core_foundation."${deps.security_framework."0.2.1".core_foundation}".default = true;
    core_foundation_sys."${deps.security_framework."0.2.1".core_foundation_sys}".default = true;
    libc."${deps.security_framework."0.2.1".libc}".default = true;
    security_framework = fold recursiveUpdate {} [
      { "0.2.1"."OSX_10_10" =
        (f.security_framework."0.2.1"."OSX_10_10" or false) ||
        (f.security_framework."0.2.1".OSX_10_11 or false) ||
        (security_framework."0.2.1"."OSX_10_11" or false); }
      { "0.2.1"."OSX_10_11" =
        (f.security_framework."0.2.1"."OSX_10_11" or false) ||
        (f.security_framework."0.2.1".OSX_10_12 or false) ||
        (security_framework."0.2.1"."OSX_10_12" or false); }
      { "0.2.1"."OSX_10_9" =
        (f.security_framework."0.2.1"."OSX_10_9" or false) ||
        (f.security_framework."0.2.1".OSX_10_10 or false) ||
        (security_framework."0.2.1"."OSX_10_10" or false); }
      { "0.2.1".default = (f.security_framework."0.2.1".default or true); }
    ];
    security_framework_sys = fold recursiveUpdate {} [
      { "${deps.security_framework."0.2.1".security_framework_sys}"."OSX_10_10" =
        (f.security_framework_sys."${deps.security_framework."0.2.1".security_framework_sys}"."OSX_10_10" or false) ||
        (security_framework."0.2.1"."OSX_10_10" or false) ||
        (f."security_framework"."0.2.1"."OSX_10_10" or false); }
      { "${deps.security_framework."0.2.1".security_framework_sys}"."OSX_10_11" =
        (f.security_framework_sys."${deps.security_framework."0.2.1".security_framework_sys}"."OSX_10_11" or false) ||
        (security_framework."0.2.1"."OSX_10_11" or false) ||
        (f."security_framework"."0.2.1"."OSX_10_11" or false) ||
        (security_framework."0.2.1"."OSX_10_12" or false) ||
        (f."security_framework"."0.2.1"."OSX_10_12" or false); }
      { "${deps.security_framework."0.2.1".security_framework_sys}"."OSX_10_9" =
        (f.security_framework_sys."${deps.security_framework."0.2.1".security_framework_sys}"."OSX_10_9" or false) ||
        (security_framework."0.2.1"."OSX_10_9" or false) ||
        (f."security_framework"."0.2.1"."OSX_10_9" or false); }
      { "${deps.security_framework."0.2.1".security_framework_sys}".default = true; }
    ];
  }) [
    (features_.core_foundation."${deps."security_framework"."0.2.1"."core_foundation"}" deps)
    (features_.core_foundation_sys."${deps."security_framework"."0.2.1"."core_foundation_sys"}" deps)
    (features_.libc."${deps."security_framework"."0.2.1"."libc"}" deps)
    (features_.security_framework_sys."${deps."security_framework"."0.2.1"."security_framework_sys"}" deps)
  ];


# end
# security-framework-sys-0.2.1

  crates.security_framework_sys."0.2.1" = deps: { features?(features_.security_framework_sys."0.2.1" deps {}) }: buildRustCrate {
    crateName = "security-framework-sys";
    version = "0.2.1";
    description = "Security Framework bindings";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0ijxy7bdi4am092hrhm645hcv36xprdx1gjcjmnyw6n78x8sv2iz";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."core_foundation_sys"."${deps."security_framework_sys"."0.2.1"."core_foundation_sys"}" deps)
      (crates."libc"."${deps."security_framework_sys"."0.2.1"."libc"}" deps)
    ]);
    features = mkFeatures (features."security_framework_sys"."0.2.1" or {});
  };
  features_.security_framework_sys."0.2.1" = deps: f: updateFeatures f (rec {
    core_foundation_sys."${deps.security_framework_sys."0.2.1".core_foundation_sys}".default = true;
    libc."${deps.security_framework_sys."0.2.1".libc}".default = true;
    security_framework_sys = fold recursiveUpdate {} [
      { "0.2.1"."OSX_10_10" =
        (f.security_framework_sys."0.2.1"."OSX_10_10" or false) ||
        (f.security_framework_sys."0.2.1".OSX_10_11 or false) ||
        (security_framework_sys."0.2.1"."OSX_10_11" or false); }
      { "0.2.1"."OSX_10_11" =
        (f.security_framework_sys."0.2.1"."OSX_10_11" or false) ||
        (f.security_framework_sys."0.2.1".OSX_10_12 or false) ||
        (security_framework_sys."0.2.1"."OSX_10_12" or false); }
      { "0.2.1"."OSX_10_9" =
        (f.security_framework_sys."0.2.1"."OSX_10_9" or false) ||
        (f.security_framework_sys."0.2.1".OSX_10_10 or false) ||
        (security_framework_sys."0.2.1"."OSX_10_10" or false); }
      { "0.2.1".default = (f.security_framework_sys."0.2.1".default or true); }
    ];
  }) [
    (features_.core_foundation_sys."${deps."security_framework_sys"."0.2.1"."core_foundation_sys"}" deps)
    (features_.libc."${deps."security_framework_sys"."0.2.1"."libc"}" deps)
  ];


# end
# semver-0.9.0

  crates.semver."0.9.0" = deps: { features?(features_.semver."0.9.0" deps {}) }: buildRustCrate {
    crateName = "semver";
    version = "0.9.0";
    description = "Semantic version parsing and comparison.\n";
    authors = [ "Steve Klabnik <steve@steveklabnik.com>" "The Rust Project Developers" ];
    sha256 = "0azak2lb2wc36s3x15az886kck7rpnksrw14lalm157rg9sc9z63";
    dependencies = mapFeatures features ([
      (crates."semver_parser"."${deps."semver"."0.9.0"."semver_parser"}" deps)
    ]);
    features = mkFeatures (features."semver"."0.9.0" or {});
  };
  features_.semver."0.9.0" = deps: f: updateFeatures f (rec {
    semver = fold recursiveUpdate {} [
      { "0.9.0"."serde" =
        (f.semver."0.9.0"."serde" or false) ||
        (f.semver."0.9.0".ci or false) ||
        (semver."0.9.0"."ci" or false); }
      { "0.9.0".default = (f.semver."0.9.0".default or true); }
    ];
    semver_parser."${deps.semver."0.9.0".semver_parser}".default = true;
  }) [
    (features_.semver_parser."${deps."semver"."0.9.0"."semver_parser"}" deps)
  ];


# end
# semver-parser-0.7.0

  crates.semver_parser."0.7.0" = deps: { features?(features_.semver_parser."0.7.0" deps {}) }: buildRustCrate {
    crateName = "semver-parser";
    version = "0.7.0";
    description = "Parsing of the semver spec.\n";
    authors = [ "Steve Klabnik <steve@steveklabnik.com>" ];
    sha256 = "1da66c8413yakx0y15k8c055yna5lyb6fr0fw9318kdwkrk5k12h";
  };
  features_.semver_parser."0.7.0" = deps: f: updateFeatures f ({
    semver_parser."0.7.0".default = (f.semver_parser."0.7.0".default or true);
  }) [];


# end
# serde-1.0.21

  crates.serde."1.0.21" = deps: { features?(features_.serde."1.0.21" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.21";
    description = "A generic serialization/deserialization framework";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "10almq7pvx8s4ryiqk8gf7fj5igl0yq6dcjknwc67rkmxd8q50w3";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.21" or {});
  };
  features_.serde."1.0.21" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.21"."serde_derive" =
        (f.serde."1.0.21"."serde_derive" or false) ||
        (f.serde."1.0.21".derive or false) ||
        (serde."1.0.21"."derive" or false) ||
        (f.serde."1.0.21".playground or false) ||
        (serde."1.0.21"."playground" or false); }
      { "1.0.21"."std" =
        (f.serde."1.0.21"."std" or false) ||
        (f.serde."1.0.21".default or false) ||
        (serde."1.0.21"."default" or false); }
      { "1.0.21"."unstable" =
        (f.serde."1.0.21"."unstable" or false) ||
        (f.serde."1.0.21".alloc or false) ||
        (serde."1.0.21"."alloc" or false); }
      { "1.0.21".default = (f.serde."1.0.21".default or true); }
    ];
  }) [];


# end
# serde_json-1.0.6

  crates.serde_json."1.0.6" = deps: { features?(features_.serde_json."1.0.6" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.6";
    description = "A JSON serialization file format";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1kacyc59splwbg8gr7qs32pp9smgy1khq0ggnv07yxhs7h355vjz";
    dependencies = mapFeatures features ([
      (crates."dtoa"."${deps."serde_json"."1.0.6"."dtoa"}" deps)
      (crates."itoa"."${deps."serde_json"."1.0.6"."itoa"}" deps)
      (crates."num_traits"."${deps."serde_json"."1.0.6"."num_traits"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.6"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.6" or {});
  };
  features_.serde_json."1.0.6" = deps: f: updateFeatures f (rec {
    dtoa."${deps.serde_json."1.0.6".dtoa}".default = true;
    itoa."${deps.serde_json."1.0.6".itoa}".default = true;
    num_traits."${deps.serde_json."1.0.6".num_traits}".default = true;
    serde."${deps.serde_json."1.0.6".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.6"."linked-hash-map" =
        (f.serde_json."1.0.6"."linked-hash-map" or false) ||
        (f.serde_json."1.0.6".preserve_order or false) ||
        (serde_json."1.0.6"."preserve_order" or false); }
      { "1.0.6".default = (f.serde_json."1.0.6".default or true); }
    ];
  }) [
    (features_.dtoa."${deps."serde_json"."1.0.6"."dtoa"}" deps)
    (features_.itoa."${deps."serde_json"."1.0.6"."itoa"}" deps)
    (features_.num_traits."${deps."serde_json"."1.0.6"."num_traits"}" deps)
    (features_.serde."${deps."serde_json"."1.0.6"."serde"}" deps)
  ];


# end
# serde_urlencoded-0.5.1

  crates.serde_urlencoded."0.5.1" = deps: { features?(features_.serde_urlencoded."0.5.1" deps {}) }: buildRustCrate {
    crateName = "serde_urlencoded";
    version = "0.5.1";
    description = "`x-www-form-urlencoded` meets Serde";
    authors = [ "Anthony Ramine <n.oxyde@gmail.com>" ];
    sha256 = "0zh2wlnapmcwqhxnnq1mdlmg8vily7j54wvj01s7cvapzg5jphdl";
    dependencies = mapFeatures features ([
      (crates."dtoa"."${deps."serde_urlencoded"."0.5.1"."dtoa"}" deps)
      (crates."itoa"."${deps."serde_urlencoded"."0.5.1"."itoa"}" deps)
      (crates."serde"."${deps."serde_urlencoded"."0.5.1"."serde"}" deps)
      (crates."url"."${deps."serde_urlencoded"."0.5.1"."url"}" deps)
    ]);
  };
  features_.serde_urlencoded."0.5.1" = deps: f: updateFeatures f ({
    dtoa."${deps.serde_urlencoded."0.5.1".dtoa}".default = true;
    itoa."${deps.serde_urlencoded."0.5.1".itoa}".default = true;
    serde."${deps.serde_urlencoded."0.5.1".serde}".default = true;
    serde_urlencoded."0.5.1".default = (f.serde_urlencoded."0.5.1".default or true);
    url."${deps.serde_urlencoded."0.5.1".url}".default = true;
  }) [
    (features_.dtoa."${deps."serde_urlencoded"."0.5.1"."dtoa"}" deps)
    (features_.itoa."${deps."serde_urlencoded"."0.5.1"."itoa"}" deps)
    (features_.serde."${deps."serde_urlencoded"."0.5.1"."serde"}" deps)
    (features_.url."${deps."serde_urlencoded"."0.5.1"."url"}" deps)
  ];


# end
# siphasher-0.2.2

  crates.siphasher."0.2.2" = deps: { features?(features_.siphasher."0.2.2" deps {}) }: buildRustCrate {
    crateName = "siphasher";
    version = "0.2.2";
    description = "SipHash functions from rust-core < 1.13";
    authors = [ "Frank Denis <github@pureftpd.org>" ];
    sha256 = "0iyx7nlzfny9ly1634a6zcq0yvrinhxhypwas4p8ry3zqnn76qqr";
    dependencies = mapFeatures features ([
]);
  };
  features_.siphasher."0.2.2" = deps: f: updateFeatures f ({
    siphasher."0.2.2".default = (f.siphasher."0.2.2".default or true);
  }) [];


# end
# slab-0.4.0

  crates.slab."0.4.0" = deps: { features?(features_.slab."0.4.0" deps {}) }: buildRustCrate {
    crateName = "slab";
    version = "0.4.0";
    description = "Pre-allocated storage for a uniform data type";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1qy2vkgwqgj5z4ygdkh040n9yh1vz80v5flxb1xrvw3i4wxs7yx0";
  };
  features_.slab."0.4.0" = deps: f: updateFeatures f ({
    slab."0.4.0".default = (f.slab."0.4.0".default or true);
  }) [];


# end
# slog-1.7.1

  crates.slog."1.7.1" = deps: { features?(features_.slog."1.7.1" deps {}) }: buildRustCrate {
    crateName = "slog";
    version = "1.7.1";
    description = "Structured, composable logging for Rust";
    authors = [ "Dawid Ciężarkiewicz <dpc@dpc.pw>" ];
    sha256 = "1qhnwv2gbxmnwasaa0vlhddq6cdhq6n3l8d6h3ql73367h7aav65";
    features = mkFeatures (features."slog"."1.7.1" or {});
  };
  features_.slog."1.7.1" = deps: f: updateFeatures f (rec {
    slog = fold recursiveUpdate {} [
      { "1.7.1"."std" =
        (f.slog."1.7.1"."std" or false) ||
        (f.slog."1.7.1".default or false) ||
        (slog."1.7.1"."default" or false); }
      { "1.7.1".default = (f.slog."1.7.1".default or true); }
    ];
  }) [];


# end
# slog-envlogger-0.5.0

  crates.slog_envlogger."0.5.0" = deps: { features?(features_.slog_envlogger."0.5.0" deps {}) }: buildRustCrate {
    crateName = "slog-envlogger";
    version = "0.5.0";
    description = "Port of de facto standard logger implementation for Rust, to `slog-rs` framework.\n";
    authors = [ "The Rust Project Developers" "Dawid Ciężarkiewicz <dpc@dpc.pw>" ];
    sha256 = "0ry9k2ppj7z6prdz2kf924w7l9y2kbysrigca6shni1kz2j163qb";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."slog_envlogger"."0.5.0"."log"}" deps)
      (crates."regex"."${deps."slog_envlogger"."0.5.0"."regex"}" deps)
      (crates."slog"."${deps."slog_envlogger"."0.5.0"."slog"}" deps)
      (crates."slog_stdlog"."${deps."slog_envlogger"."0.5.0"."slog_stdlog"}" deps)
      (crates."slog_term"."${deps."slog_envlogger"."0.5.0"."slog_term"}" deps)
    ]);
  };
  features_.slog_envlogger."0.5.0" = deps: f: updateFeatures f ({
    log."${deps.slog_envlogger."0.5.0".log}".default = true;
    regex."${deps.slog_envlogger."0.5.0".regex}".default = true;
    slog."${deps.slog_envlogger."0.5.0".slog}".default = true;
    slog_envlogger."0.5.0".default = (f.slog_envlogger."0.5.0".default or true);
    slog_stdlog."${deps.slog_envlogger."0.5.0".slog_stdlog}".default = true;
    slog_term."${deps.slog_envlogger."0.5.0".slog_term}".default = true;
  }) [
    (features_.log."${deps."slog_envlogger"."0.5.0"."log"}" deps)
    (features_.regex."${deps."slog_envlogger"."0.5.0"."regex"}" deps)
    (features_.slog."${deps."slog_envlogger"."0.5.0"."slog"}" deps)
    (features_.slog_stdlog."${deps."slog_envlogger"."0.5.0"."slog_stdlog"}" deps)
    (features_.slog_term."${deps."slog_envlogger"."0.5.0"."slog_term"}" deps)
  ];


# end
# slog-extra-0.1.2

  crates.slog_extra."0.1.2" = deps: { features?(features_.slog_extra."0.1.2" deps {}) }: buildRustCrate {
    crateName = "slog-extra";
    version = "0.1.2";
    description = "Standard slog-rs extensions";
    authors = [ "Dawid Ciężarkiewicz <dpc@dpc.pw>" ];
    sha256 = "0jrw0xcc81wwcl59xx9qglfcv5l3ad5kbpcyp6ygk94p9kxfrhyj";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
      (crates."slog"."${deps."slog_extra"."0.1.2"."slog"}" deps)
      (crates."thread_local"."${deps."slog_extra"."0.1.2"."thread_local"}" deps)
    ]);
  };
  features_.slog_extra."0.1.2" = deps: f: updateFeatures f ({
    slog."${deps.slog_extra."0.1.2".slog}".default = true;
    slog_extra."0.1.2".default = (f.slog_extra."0.1.2".default or true);
    thread_local."${deps.slog_extra."0.1.2".thread_local}".default = true;
  }) [
    (features_.slog."${deps."slog_extra"."0.1.2"."slog"}" deps)
    (features_.thread_local."${deps."slog_extra"."0.1.2"."thread_local"}" deps)
  ];


# end
# slog-stdlog-1.1.0

  crates.slog_stdlog."1.1.0" = deps: { features?(features_.slog_stdlog."1.1.0" deps {}) }: buildRustCrate {
    crateName = "slog-stdlog";
    version = "1.1.0";
    description = "Standard Rust log crate adapter to slog-rs";
    authors = [ "Dawid Ciężarkiewicz <dpc@dpc.pw>" ];
    sha256 = "0ig4mjixr4y3dn3s53rlnrpplwkqb8b0z2zkaiiiwyv7nhjxdg46";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
      (crates."crossbeam"."${deps."slog_stdlog"."1.1.0"."crossbeam"}" deps)
      (crates."lazy_static"."${deps."slog_stdlog"."1.1.0"."lazy_static"}" deps)
      (crates."log"."${deps."slog_stdlog"."1.1.0"."log"}" deps)
      (crates."slog"."${deps."slog_stdlog"."1.1.0"."slog"}" deps)
      (crates."slog_term"."${deps."slog_stdlog"."1.1.0"."slog_term"}" deps)
    ]);
  };
  features_.slog_stdlog."1.1.0" = deps: f: updateFeatures f ({
    crossbeam."${deps.slog_stdlog."1.1.0".crossbeam}".default = true;
    lazy_static."${deps.slog_stdlog."1.1.0".lazy_static}".default = true;
    log."${deps.slog_stdlog."1.1.0".log}".default = true;
    slog."${deps.slog_stdlog."1.1.0".slog}".default = true;
    slog_stdlog."1.1.0".default = (f.slog_stdlog."1.1.0".default or true);
    slog_term."${deps.slog_stdlog."1.1.0".slog_term}".default = true;
  }) [
    (features_.crossbeam."${deps."slog_stdlog"."1.1.0"."crossbeam"}" deps)
    (features_.lazy_static."${deps."slog_stdlog"."1.1.0"."lazy_static"}" deps)
    (features_.log."${deps."slog_stdlog"."1.1.0"."log"}" deps)
    (features_.slog."${deps."slog_stdlog"."1.1.0"."slog"}" deps)
    (features_.slog_term."${deps."slog_stdlog"."1.1.0"."slog_term"}" deps)
  ];


# end
# slog-stream-1.2.1

  crates.slog_stream."1.2.1" = deps: { features?(features_.slog_stream."1.2.1" deps {}) }: buildRustCrate {
    crateName = "slog-stream";
    version = "1.2.1";
    description = "`io::Write` streamer for slog-rs";
    authors = [ "Dawid Ciężarkiewicz <dpc@dpc.pw>" ];
    sha256 = "03dwzbydaamfzjpr16gm065i696lk86gqcpspv5qaqyv938fm2yj";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
      (crates."slog"."${deps."slog_stream"."1.2.1"."slog"}" deps)
      (crates."slog_extra"."${deps."slog_stream"."1.2.1"."slog_extra"}" deps)
      (crates."thread_local"."${deps."slog_stream"."1.2.1"."thread_local"}" deps)
    ]);
  };
  features_.slog_stream."1.2.1" = deps: f: updateFeatures f ({
    slog."${deps.slog_stream."1.2.1".slog}".default = true;
    slog_extra."${deps.slog_stream."1.2.1".slog_extra}".default = true;
    slog_stream."1.2.1".default = (f.slog_stream."1.2.1".default or true);
    thread_local."${deps.slog_stream."1.2.1".thread_local}".default = true;
  }) [
    (features_.slog."${deps."slog_stream"."1.2.1"."slog"}" deps)
    (features_.slog_extra."${deps."slog_stream"."1.2.1"."slog_extra"}" deps)
    (features_.thread_local."${deps."slog_stream"."1.2.1"."thread_local"}" deps)
  ];


# end
# slog-term-1.5.0

  crates.slog_term."1.5.0" = deps: { features?(features_.slog_term."1.5.0" deps {}) }: buildRustCrate {
    crateName = "slog-term";
    version = "1.5.0";
    description = "Unix terminal drain and formatter for slog-rs";
    authors = [ "Dawid Ciężarkiewicz <dpc@dpc.pw>" ];
    sha256 = "0zq2kyvm7jhqj6sc09w540wqfrrpa46yxf9sgzq7jqpkr66wsiar";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
      (crates."chrono"."${deps."slog_term"."1.5.0"."chrono"}" deps)
      (crates."isatty"."${deps."slog_term"."1.5.0"."isatty"}" deps)
      (crates."slog"."${deps."slog_term"."1.5.0"."slog"}" deps)
      (crates."slog_stream"."${deps."slog_term"."1.5.0"."slog_stream"}" deps)
      (crates."thread_local"."${deps."slog_term"."1.5.0"."thread_local"}" deps)
    ]);
  };
  features_.slog_term."1.5.0" = deps: f: updateFeatures f ({
    chrono."${deps.slog_term."1.5.0".chrono}".default = true;
    isatty."${deps.slog_term."1.5.0".isatty}".default = true;
    slog."${deps.slog_term."1.5.0".slog}".default = true;
    slog_stream."${deps.slog_term."1.5.0".slog_stream}".default = true;
    slog_term."1.5.0".default = (f.slog_term."1.5.0".default or true);
    thread_local."${deps.slog_term."1.5.0".thread_local}".default = true;
  }) [
    (features_.chrono."${deps."slog_term"."1.5.0"."chrono"}" deps)
    (features_.isatty."${deps."slog_term"."1.5.0"."isatty"}" deps)
    (features_.slog."${deps."slog_term"."1.5.0"."slog"}" deps)
    (features_.slog_stream."${deps."slog_term"."1.5.0"."slog_stream"}" deps)
    (features_.thread_local."${deps."slog_term"."1.5.0"."thread_local"}" deps)
  ];


# end
# smallvec-0.6.7

  crates.smallvec."0.6.7" = deps: { features?(features_.smallvec."0.6.7" deps {}) }: buildRustCrate {
    crateName = "smallvec";
    version = "0.6.7";
    description = "'Small vector' optimization: store up to a small number of items on the stack";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "08ql2yi7ry08cqjl9n6vpb6x6zgqzwllzzk9pxj1143xwg503qcx";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
      (crates."unreachable"."${deps."smallvec"."0.6.7"."unreachable"}" deps)
    ]);
    features = mkFeatures (features."smallvec"."0.6.7" or {});
  };
  features_.smallvec."0.6.7" = deps: f: updateFeatures f (rec {
    smallvec = fold recursiveUpdate {} [
      { "0.6.7"."std" =
        (f.smallvec."0.6.7"."std" or false) ||
        (f.smallvec."0.6.7".default or false) ||
        (smallvec."0.6.7"."default" or false); }
      { "0.6.7".default = (f.smallvec."0.6.7".default or true); }
    ];
    unreachable."${deps.smallvec."0.6.7".unreachable}".default = true;
  }) [
    (features_.unreachable."${deps."smallvec"."0.6.7"."unreachable"}" deps)
  ];


# end
# stable_deref_trait-1.1.1

  crates.stable_deref_trait."1.1.1" = deps: { features?(features_.stable_deref_trait."1.1.1" deps {}) }: buildRustCrate {
    crateName = "stable_deref_trait";
    version = "1.1.1";
    description = "An unsafe marker trait for types like Box and Rc that dereference to a stable address even when moved, and hence can be used with libraries such as owning_ref and rental.\n";
    authors = [ "Robert Grosse <n210241048576@gmail.com>" ];
    sha256 = "1xy9slzslrzr31nlnw52sl1d820b09y61b7f13lqgsn8n7y0l4g8";
    features = mkFeatures (features."stable_deref_trait"."1.1.1" or {});
  };
  features_.stable_deref_trait."1.1.1" = deps: f: updateFeatures f (rec {
    stable_deref_trait = fold recursiveUpdate {} [
      { "1.1.1"."std" =
        (f.stable_deref_trait."1.1.1"."std" or false) ||
        (f.stable_deref_trait."1.1.1".default or false) ||
        (stable_deref_trait."1.1.1"."default" or false); }
      { "1.1.1".default = (f.stable_deref_trait."1.1.1".default or true); }
    ];
  }) [];


# end
# string-0.1.2

  crates.string."0.1.2" = deps: { features?(features_.string."0.1.2" deps {}) }: buildRustCrate {
    crateName = "string";
    version = "0.1.2";
    description = "A UTF-8 encoded string with configurable byte storage.";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1120qvf02aydqj0k3kpr8d7zybq0y5arnmgmfsdw75r8qwz75wc6";
  };
  features_.string."0.1.2" = deps: f: updateFeatures f ({
    string."0.1.2".default = (f.string."0.1.2".default or true);
  }) [];


# end
# strsim-0.6.0

  crates.strsim."0.6.0" = deps: { features?(features_.strsim."0.6.0" deps {}) }: buildRustCrate {
    crateName = "strsim";
    version = "0.6.0";
    description = "Implementations of string similarity metrics.\nIncludes Hamming, Levenshtein, Damerau-Levenshtein, Jaro, and Jaro-Winkler.\n";
    authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
    sha256 = "1lz85l6y68hr62lv4baww29yy7g8pg20dlr0lbaswxmmcb0wl7gd";
  };
  features_.strsim."0.6.0" = deps: f: updateFeatures f ({
    strsim."0.6.0".default = (f.strsim."0.6.0".default or true);
  }) [];


# end
# syn-0.11.11

  crates.syn."0.11.11" = deps: { features?(features_.syn."0.11.11" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.11.11";
    description = "Nom parser for Rust source code";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0yw8ng7x1dn5a6ykg0ib49y7r9nhzgpiq2989rqdp7rdz3n85502";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.syn."0.11.11".quote or false then [ (crates.quote."${deps."syn"."0.11.11".quote}" deps) ] else [])
      ++ (if features.syn."0.11.11".synom or false then [ (crates.synom."${deps."syn"."0.11.11".synom}" deps) ] else [])
      ++ (if features.syn."0.11.11".unicode-xid or false then [ (crates.unicode_xid."${deps."syn"."0.11.11".unicode_xid}" deps) ] else []));
    features = mkFeatures (features."syn"."0.11.11" or {});
  };
  features_.syn."0.11.11" = deps: f: updateFeatures f (rec {
    quote."${deps.syn."0.11.11".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "0.11.11"."parsing" =
        (f.syn."0.11.11"."parsing" or false) ||
        (f.syn."0.11.11".default or false) ||
        (syn."0.11.11"."default" or false); }
      { "0.11.11"."printing" =
        (f.syn."0.11.11"."printing" or false) ||
        (f.syn."0.11.11".default or false) ||
        (syn."0.11.11"."default" or false); }
      { "0.11.11"."quote" =
        (f.syn."0.11.11"."quote" or false) ||
        (f.syn."0.11.11".printing or false) ||
        (syn."0.11.11"."printing" or false); }
      { "0.11.11"."synom" =
        (f.syn."0.11.11"."synom" or false) ||
        (f.syn."0.11.11".parsing or false) ||
        (syn."0.11.11"."parsing" or false); }
      { "0.11.11"."unicode-xid" =
        (f.syn."0.11.11"."unicode-xid" or false) ||
        (f.syn."0.11.11".parsing or false) ||
        (syn."0.11.11"."parsing" or false); }
      { "0.11.11".default = (f.syn."0.11.11".default or true); }
    ];
    synom."${deps.syn."0.11.11".synom}".default = true;
    unicode_xid."${deps.syn."0.11.11".unicode_xid}".default = true;
  }) [
    (features_.quote."${deps."syn"."0.11.11"."quote"}" deps)
    (features_.synom."${deps."syn"."0.11.11"."synom"}" deps)
    (features_.unicode_xid."${deps."syn"."0.11.11"."unicode_xid"}" deps)
  ];


# end
# synom-0.11.3

  crates.synom."0.11.3" = deps: { features?(features_.synom."0.11.3" deps {}) }: buildRustCrate {
    crateName = "synom";
    version = "0.11.3";
    description = "Stripped-down Nom parser used by Syn";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1l6d1s9qjfp6ng2s2z8219igvlv7gyk8gby97sdykqc1r93d8rhc";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."synom"."0.11.3"."unicode_xid"}" deps)
    ]);
  };
  features_.synom."0.11.3" = deps: f: updateFeatures f ({
    synom."0.11.3".default = (f.synom."0.11.3".default or true);
    unicode_xid."${deps.synom."0.11.3".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."synom"."0.11.3"."unicode_xid"}" deps)
  ];


# end
# tar-0.4.13

  crates.tar."0.4.13" = deps: { features?(features_.tar."0.4.13" deps {}) }: buildRustCrate {
    crateName = "tar";
    version = "0.4.13";
    description = "A Rust implementation of a TAR file reader and writer. This library does not\ncurrently handle compression, but it is abstract over all I/O readers and\nwriters. Additionally, great lengths are taken to ensure that the entire\ncontents are never required to be entirely resident in memory all at once.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1m425d07h0i6h2vbpxnh067zmc16l9yr9bii17zxw4z2inkfyfc4";
    dependencies = mapFeatures features ([
      (crates."filetime"."${deps."tar"."0.4.13"."filetime"}" deps)
      (crates."libc"."${deps."tar"."0.4.13"."libc"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.tar."0.4.13".xattr or false then [ (crates.xattr."${deps."tar"."0.4.13".xattr}" deps) ] else [])) else []);
    features = mkFeatures (features."tar"."0.4.13" or {});
  };
  features_.tar."0.4.13" = deps: f: updateFeatures f (rec {
    filetime."${deps.tar."0.4.13".filetime}".default = true;
    libc."${deps.tar."0.4.13".libc}".default = true;
    tar = fold recursiveUpdate {} [
      { "0.4.13"."xattr" =
        (f.tar."0.4.13"."xattr" or false) ||
        (f.tar."0.4.13".default or false) ||
        (tar."0.4.13"."default" or false); }
      { "0.4.13".default = (f.tar."0.4.13".default or true); }
    ];
    xattr."${deps.tar."0.4.13".xattr}".default = true;
  }) [
    (features_.filetime."${deps."tar"."0.4.13"."filetime"}" deps)
    (features_.libc."${deps."tar"."0.4.13"."libc"}" deps)
    (features_.xattr."${deps."tar"."0.4.13"."xattr"}" deps)
  ];


# end
# tempfile-3.0.5

  crates.tempfile."3.0.5" = deps: { features?(features_.tempfile."3.0.5" deps {}) }: buildRustCrate {
    crateName = "tempfile";
    version = "3.0.5";
    description = "A library for managing temporary files and directories.\n";
    authors = [ "Steven Allen <steven@stebalien.com>" "The Rust Project Developers" "Ashley Mannix <ashleymannix@live.com.au>" "Jason White <jasonaw0@gmail.com>" ];
    sha256 = "11xc89br78ypk4g27v51lm2baz57gp6v555i3sxhrj9qlas2iqfl";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."tempfile"."3.0.5"."cfg_if"}" deps)
      (crates."rand"."${deps."tempfile"."3.0.5"."rand"}" deps)
      (crates."remove_dir_all"."${deps."tempfile"."3.0.5"."remove_dir_all"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."tempfile"."3.0.5"."redox_syscall"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."tempfile"."3.0.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."tempfile"."3.0.5"."winapi"}" deps)
    ]) else []);
  };
  features_.tempfile."3.0.5" = deps: f: updateFeatures f ({
    cfg_if."${deps.tempfile."3.0.5".cfg_if}".default = true;
    libc."${deps.tempfile."3.0.5".libc}".default = true;
    rand."${deps.tempfile."3.0.5".rand}".default = true;
    redox_syscall."${deps.tempfile."3.0.5".redox_syscall}".default = true;
    remove_dir_all."${deps.tempfile."3.0.5".remove_dir_all}".default = true;
    tempfile."3.0.5".default = (f.tempfile."3.0.5".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.tempfile."3.0.5".winapi}"."fileapi" = true; }
      { "${deps.tempfile."3.0.5".winapi}"."handleapi" = true; }
      { "${deps.tempfile."3.0.5".winapi}"."winbase" = true; }
      { "${deps.tempfile."3.0.5".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."tempfile"."3.0.5"."cfg_if"}" deps)
    (features_.rand."${deps."tempfile"."3.0.5"."rand"}" deps)
    (features_.remove_dir_all."${deps."tempfile"."3.0.5"."remove_dir_all"}" deps)
    (features_.redox_syscall."${deps."tempfile"."3.0.5"."redox_syscall"}" deps)
    (features_.libc."${deps."tempfile"."3.0.5"."libc"}" deps)
    (features_.winapi."${deps."tempfile"."3.0.5"."winapi"}" deps)
  ];


# end
# termion-1.5.1

  crates.termion."1.5.1" = deps: { features?(features_.termion."1.5.1" deps {}) }: buildRustCrate {
    crateName = "termion";
    version = "1.5.1";
    description = "A bindless library for manipulating terminals.";
    authors = [ "ticki <Ticki@users.noreply.github.com>" "gycos <alexandre.bury@gmail.com>" "IGI-111 <igi-111@protonmail.com>" ];
    sha256 = "02gq4vd8iws1f3gjrgrgpajsk2bk43nds5acbbb4s8dvrdvr8nf1";
    dependencies = (if !(kernel == "redox") then mapFeatures features ([
      (crates."libc"."${deps."termion"."1.5.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."termion"."1.5.1"."redox_syscall"}" deps)
      (crates."redox_termios"."${deps."termion"."1.5.1"."redox_termios"}" deps)
    ]) else []);
  };
  features_.termion."1.5.1" = deps: f: updateFeatures f ({
    libc."${deps.termion."1.5.1".libc}".default = true;
    redox_syscall."${deps.termion."1.5.1".redox_syscall}".default = true;
    redox_termios."${deps.termion."1.5.1".redox_termios}".default = true;
    termion."1.5.1".default = (f.termion."1.5.1".default or true);
  }) [
    (features_.libc."${deps."termion"."1.5.1"."libc"}" deps)
    (features_.redox_syscall."${deps."termion"."1.5.1"."redox_syscall"}" deps)
    (features_.redox_termios."${deps."termion"."1.5.1"."redox_termios"}" deps)
  ];


# end
# textwrap-0.9.0

  crates.textwrap."0.9.0" = deps: { features?(features_.textwrap."0.9.0" deps {}) }: buildRustCrate {
    crateName = "textwrap";
    version = "0.9.0";
    description = "Textwrap is a small library for word wrapping, indenting, and\ndedenting strings.\n\nYou can use it to format strings (such as help and error messages) for\ndisplay in commandline applications. It is designed to be efficient\nand handle Unicode characters correctly.\n";
    authors = [ "Martin Geisler <martin@geisler.net>" ];
    sha256 = "18jg79ndjlwndz01mlbh82kkr2arqm658yn5kwp65l5n1hz8w4yb";
    dependencies = mapFeatures features ([
      (crates."unicode_width"."${deps."textwrap"."0.9.0"."unicode_width"}" deps)
    ]);
  };
  features_.textwrap."0.9.0" = deps: f: updateFeatures f ({
    textwrap."0.9.0".default = (f.textwrap."0.9.0".default or true);
    unicode_width."${deps.textwrap."0.9.0".unicode_width}".default = true;
  }) [
    (features_.unicode_width."${deps."textwrap"."0.9.0"."unicode_width"}" deps)
  ];


# end
# thread-id-2.0.0

  crates.thread_id."2.0.0" = deps: { features?(features_.thread_id."2.0.0" deps {}) }: buildRustCrate {
    crateName = "thread-id";
    version = "2.0.0";
    description = "Get a unique thread ID";
    authors = [ "Ruud van Asseldonk <dev@veniogames.com>" ];
    sha256 = "06i3c8ckn97i5rp16civ2vpqbknlkx66dkrl070iw60nawi0kjc3";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."thread_id"."2.0.0"."kernel32_sys"}" deps)
      (crates."libc"."${deps."thread_id"."2.0.0"."libc"}" deps)
    ]);
  };
  features_.thread_id."2.0.0" = deps: f: updateFeatures f ({
    kernel32_sys."${deps.thread_id."2.0.0".kernel32_sys}".default = true;
    libc."${deps.thread_id."2.0.0".libc}".default = true;
    thread_id."2.0.0".default = (f.thread_id."2.0.0".default or true);
  }) [
    (features_.kernel32_sys."${deps."thread_id"."2.0.0"."kernel32_sys"}" deps)
    (features_.libc."${deps."thread_id"."2.0.0"."libc"}" deps)
  ];


# end
# thread_local-0.2.7

  crates.thread_local."0.2.7" = deps: { features?(features_.thread_local."0.2.7" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.2.7";
    description = "Per-object thread-local storage";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "19p0zrs24rdwjvpi10jig5ms3sxj00pv8shkr9cpddri8cdghqp7";
    dependencies = mapFeatures features ([
      (crates."thread_id"."${deps."thread_local"."0.2.7"."thread_id"}" deps)
    ]);
  };
  features_.thread_local."0.2.7" = deps: f: updateFeatures f ({
    thread_id."${deps.thread_local."0.2.7".thread_id}".default = true;
    thread_local."0.2.7".default = (f.thread_local."0.2.7".default or true);
  }) [
    (features_.thread_id."${deps."thread_local"."0.2.7"."thread_id"}" deps)
  ];


# end
# thread_local-0.3.4

  crates.thread_local."0.3.4" = deps: { features?(features_.thread_local."0.3.4" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.4";
    description = "Per-object thread-local storage";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "1y6cwyhhx2nkz4b3dziwhqdvgq830z8wjp32b40pjd8r0hxqv2jr";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."thread_local"."0.3.4"."lazy_static"}" deps)
      (crates."unreachable"."${deps."thread_local"."0.3.4"."unreachable"}" deps)
    ]);
  };
  features_.thread_local."0.3.4" = deps: f: updateFeatures f ({
    lazy_static."${deps.thread_local."0.3.4".lazy_static}".default = true;
    thread_local."0.3.4".default = (f.thread_local."0.3.4".default or true);
    unreachable."${deps.thread_local."0.3.4".unreachable}".default = true;
  }) [
    (features_.lazy_static."${deps."thread_local"."0.3.4"."lazy_static"}" deps)
    (features_.unreachable."${deps."thread_local"."0.3.4"."unreachable"}" deps)
  ];


# end
# time-0.1.38

  crates.time."0.1.38" = deps: { features?(features_.time."0.1.38" deps {}) }: buildRustCrate {
    crateName = "time";
    version = "0.1.38";
    description = "Utilities for working with time-related functions in Rust.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ws283vvz7c6jfiwn53rmc6kybapr4pjaahfxxrz232b0qzw7gcp";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."time"."0.1.38"."libc"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."time"."0.1.38"."redox_syscall"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."time"."0.1.38"."kernel32_sys"}" deps)
      (crates."winapi"."${deps."time"."0.1.38"."winapi"}" deps)
    ]) else []);
  };
  features_.time."0.1.38" = deps: f: updateFeatures f ({
    kernel32_sys."${deps.time."0.1.38".kernel32_sys}".default = true;
    libc."${deps.time."0.1.38".libc}".default = true;
    redox_syscall."${deps.time."0.1.38".redox_syscall}".default = true;
    time."0.1.38".default = (f.time."0.1.38".default or true);
    winapi."${deps.time."0.1.38".winapi}".default = true;
  }) [
    (features_.libc."${deps."time"."0.1.38"."libc"}" deps)
    (features_.redox_syscall."${deps."time"."0.1.38"."redox_syscall"}" deps)
    (features_.kernel32_sys."${deps."time"."0.1.38"."kernel32_sys"}" deps)
    (features_.winapi."${deps."time"."0.1.38"."winapi"}" deps)
  ];


# end
# tokio-0.1.7

  crates.tokio."0.1.7" = deps: { features?(features_.tokio."0.1.7" deps {}) }: buildRustCrate {
    crateName = "tokio";
    version = "0.1.7";
    description = "An event-driven, non-blocking I/O platform for writing asynchronous I/O\nbacked applications.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0d5fj90wk05m5vbd924irg1pl1d4fn86jjw5napzanh6vbwsnr66";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio"."0.1.7"."futures"}" deps)
      (crates."mio"."${deps."tokio"."0.1.7"."mio"}" deps)
      (crates."tokio_executor"."${deps."tokio"."0.1.7"."tokio_executor"}" deps)
      (crates."tokio_fs"."${deps."tokio"."0.1.7"."tokio_fs"}" deps)
      (crates."tokio_io"."${deps."tokio"."0.1.7"."tokio_io"}" deps)
      (crates."tokio_reactor"."${deps."tokio"."0.1.7"."tokio_reactor"}" deps)
      (crates."tokio_tcp"."${deps."tokio"."0.1.7"."tokio_tcp"}" deps)
      (crates."tokio_threadpool"."${deps."tokio"."0.1.7"."tokio_threadpool"}" deps)
      (crates."tokio_timer"."${deps."tokio"."0.1.7"."tokio_timer"}" deps)
      (crates."tokio_udp"."${deps."tokio"."0.1.7"."tokio_udp"}" deps)
    ]);
  };
  features_.tokio."0.1.7" = deps: f: updateFeatures f ({
    futures."${deps.tokio."0.1.7".futures}".default = true;
    mio."${deps.tokio."0.1.7".mio}".default = true;
    tokio."0.1.7".default = (f.tokio."0.1.7".default or true);
    tokio_executor."${deps.tokio."0.1.7".tokio_executor}".default = true;
    tokio_fs."${deps.tokio."0.1.7".tokio_fs}".default = true;
    tokio_io."${deps.tokio."0.1.7".tokio_io}".default = true;
    tokio_reactor."${deps.tokio."0.1.7".tokio_reactor}".default = true;
    tokio_tcp."${deps.tokio."0.1.7".tokio_tcp}".default = true;
    tokio_threadpool."${deps.tokio."0.1.7".tokio_threadpool}".default = true;
    tokio_timer."${deps.tokio."0.1.7".tokio_timer}".default = true;
    tokio_udp."${deps.tokio."0.1.7".tokio_udp}".default = true;
  }) [
    (features_.futures."${deps."tokio"."0.1.7"."futures"}" deps)
    (features_.mio."${deps."tokio"."0.1.7"."mio"}" deps)
    (features_.tokio_executor."${deps."tokio"."0.1.7"."tokio_executor"}" deps)
    (features_.tokio_fs."${deps."tokio"."0.1.7"."tokio_fs"}" deps)
    (features_.tokio_io."${deps."tokio"."0.1.7"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."tokio"."0.1.7"."tokio_reactor"}" deps)
    (features_.tokio_tcp."${deps."tokio"."0.1.7"."tokio_tcp"}" deps)
    (features_.tokio_threadpool."${deps."tokio"."0.1.7"."tokio_threadpool"}" deps)
    (features_.tokio_timer."${deps."tokio"."0.1.7"."tokio_timer"}" deps)
    (features_.tokio_udp."${deps."tokio"."0.1.7"."tokio_udp"}" deps)
  ];


# end
# tokio-codec-0.1.1

  crates.tokio_codec."0.1.1" = deps: { features?(features_.tokio_codec."0.1.1" deps {}) }: buildRustCrate {
    crateName = "tokio-codec";
    version = "0.1.1";
    description = "Utilities for encoding and decoding frames.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" "Bryan Burgers <bryan@burgers.io>" ];
    sha256 = "0jc9lik540zyj4chbygg1rjh37m3zax8pd4bwcrwjmi1v56qwi4h";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_codec"."0.1.1"."bytes"}" deps)
      (crates."futures"."${deps."tokio_codec"."0.1.1"."futures"}" deps)
      (crates."tokio_io"."${deps."tokio_codec"."0.1.1"."tokio_io"}" deps)
    ]);
  };
  features_.tokio_codec."0.1.1" = deps: f: updateFeatures f ({
    bytes."${deps.tokio_codec."0.1.1".bytes}".default = true;
    futures."${deps.tokio_codec."0.1.1".futures}".default = true;
    tokio_codec."0.1.1".default = (f.tokio_codec."0.1.1".default or true);
    tokio_io."${deps.tokio_codec."0.1.1".tokio_io}".default = true;
  }) [
    (features_.bytes."${deps."tokio_codec"."0.1.1"."bytes"}" deps)
    (features_.futures."${deps."tokio_codec"."0.1.1"."futures"}" deps)
    (features_.tokio_io."${deps."tokio_codec"."0.1.1"."tokio_io"}" deps)
  ];


# end
# tokio-executor-0.1.5

  crates.tokio_executor."0.1.5" = deps: { features?(features_.tokio_executor."0.1.5" deps {}) }: buildRustCrate {
    crateName = "tokio-executor";
    version = "0.1.5";
    description = "Future execution primitives\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "15j2ybs8w38gncgbxkvp2qsp6wl62ibi3rns0vlwggx7svmx4bf3";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_executor"."0.1.5"."futures"}" deps)
    ]);
  };
  features_.tokio_executor."0.1.5" = deps: f: updateFeatures f ({
    futures."${deps.tokio_executor."0.1.5".futures}".default = true;
    tokio_executor."0.1.5".default = (f.tokio_executor."0.1.5".default or true);
  }) [
    (features_.futures."${deps."tokio_executor"."0.1.5"."futures"}" deps)
  ];


# end
# tokio-fs-0.1.4

  crates.tokio_fs."0.1.4" = deps: { features?(features_.tokio_fs."0.1.4" deps {}) }: buildRustCrate {
    crateName = "tokio-fs";
    version = "0.1.4";
    description = "Filesystem API for Tokio.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "05bpc1p1apb4jfw18i84agwwar57zn07d7smqvslpzagd9b3sd31";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_fs"."0.1.4"."futures"}" deps)
      (crates."tokio_io"."${deps."tokio_fs"."0.1.4"."tokio_io"}" deps)
      (crates."tokio_threadpool"."${deps."tokio_fs"."0.1.4"."tokio_threadpool"}" deps)
    ]);
  };
  features_.tokio_fs."0.1.4" = deps: f: updateFeatures f ({
    futures."${deps.tokio_fs."0.1.4".futures}".default = true;
    tokio_fs."0.1.4".default = (f.tokio_fs."0.1.4".default or true);
    tokio_io."${deps.tokio_fs."0.1.4".tokio_io}".default = true;
    tokio_threadpool."${deps.tokio_fs."0.1.4".tokio_threadpool}".default = true;
  }) [
    (features_.futures."${deps."tokio_fs"."0.1.4"."futures"}" deps)
    (features_.tokio_io."${deps."tokio_fs"."0.1.4"."tokio_io"}" deps)
    (features_.tokio_threadpool."${deps."tokio_fs"."0.1.4"."tokio_threadpool"}" deps)
  ];


# end
# tokio-io-0.1.10

  crates.tokio_io."0.1.10" = deps: { features?(features_.tokio_io."0.1.10" deps {}) }: buildRustCrate {
    crateName = "tokio-io";
    version = "0.1.10";
    description = "Core I/O primitives for asynchronous I/O in Rust.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "14d65rqa5rb2msgkz2xn40cavs4m7f4qyi7vnfv98v7f10l9wlay";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_io"."0.1.10"."bytes"}" deps)
      (crates."futures"."${deps."tokio_io"."0.1.10"."futures"}" deps)
      (crates."log"."${deps."tokio_io"."0.1.10"."log"}" deps)
    ]);
  };
  features_.tokio_io."0.1.10" = deps: f: updateFeatures f ({
    bytes."${deps.tokio_io."0.1.10".bytes}".default = true;
    futures."${deps.tokio_io."0.1.10".futures}".default = true;
    log."${deps.tokio_io."0.1.10".log}".default = true;
    tokio_io."0.1.10".default = (f.tokio_io."0.1.10".default or true);
  }) [
    (features_.bytes."${deps."tokio_io"."0.1.10"."bytes"}" deps)
    (features_.futures."${deps."tokio_io"."0.1.10"."futures"}" deps)
    (features_.log."${deps."tokio_io"."0.1.10"."log"}" deps)
  ];


# end
# tokio-reactor-0.1.7

  crates.tokio_reactor."0.1.7" = deps: { features?(features_.tokio_reactor."0.1.7" deps {}) }: buildRustCrate {
    crateName = "tokio-reactor";
    version = "0.1.7";
    description = "Event loop that drives Tokio I/O resources.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1ssrc6gic43lachv7jk97jxzw609sgcsrkwi7chf96sn7nqrhj0z";
    dependencies = mapFeatures features ([
      (crates."crossbeam_utils"."${deps."tokio_reactor"."0.1.7"."crossbeam_utils"}" deps)
      (crates."futures"."${deps."tokio_reactor"."0.1.7"."futures"}" deps)
      (crates."lazy_static"."${deps."tokio_reactor"."0.1.7"."lazy_static"}" deps)
      (crates."log"."${deps."tokio_reactor"."0.1.7"."log"}" deps)
      (crates."mio"."${deps."tokio_reactor"."0.1.7"."mio"}" deps)
      (crates."num_cpus"."${deps."tokio_reactor"."0.1.7"."num_cpus"}" deps)
      (crates."parking_lot"."${deps."tokio_reactor"."0.1.7"."parking_lot"}" deps)
      (crates."slab"."${deps."tokio_reactor"."0.1.7"."slab"}" deps)
      (crates."tokio_executor"."${deps."tokio_reactor"."0.1.7"."tokio_executor"}" deps)
      (crates."tokio_io"."${deps."tokio_reactor"."0.1.7"."tokio_io"}" deps)
    ]);
  };
  features_.tokio_reactor."0.1.7" = deps: f: updateFeatures f ({
    crossbeam_utils."${deps.tokio_reactor."0.1.7".crossbeam_utils}".default = true;
    futures."${deps.tokio_reactor."0.1.7".futures}".default = true;
    lazy_static."${deps.tokio_reactor."0.1.7".lazy_static}".default = true;
    log."${deps.tokio_reactor."0.1.7".log}".default = true;
    mio."${deps.tokio_reactor."0.1.7".mio}".default = true;
    num_cpus."${deps.tokio_reactor."0.1.7".num_cpus}".default = true;
    parking_lot."${deps.tokio_reactor."0.1.7".parking_lot}".default = true;
    slab."${deps.tokio_reactor."0.1.7".slab}".default = true;
    tokio_executor."${deps.tokio_reactor."0.1.7".tokio_executor}".default = true;
    tokio_io."${deps.tokio_reactor."0.1.7".tokio_io}".default = true;
    tokio_reactor."0.1.7".default = (f.tokio_reactor."0.1.7".default or true);
  }) [
    (features_.crossbeam_utils."${deps."tokio_reactor"."0.1.7"."crossbeam_utils"}" deps)
    (features_.futures."${deps."tokio_reactor"."0.1.7"."futures"}" deps)
    (features_.lazy_static."${deps."tokio_reactor"."0.1.7"."lazy_static"}" deps)
    (features_.log."${deps."tokio_reactor"."0.1.7"."log"}" deps)
    (features_.mio."${deps."tokio_reactor"."0.1.7"."mio"}" deps)
    (features_.num_cpus."${deps."tokio_reactor"."0.1.7"."num_cpus"}" deps)
    (features_.parking_lot."${deps."tokio_reactor"."0.1.7"."parking_lot"}" deps)
    (features_.slab."${deps."tokio_reactor"."0.1.7"."slab"}" deps)
    (features_.tokio_executor."${deps."tokio_reactor"."0.1.7"."tokio_executor"}" deps)
    (features_.tokio_io."${deps."tokio_reactor"."0.1.7"."tokio_io"}" deps)
  ];


# end
# tokio-tcp-0.1.2

  crates.tokio_tcp."0.1.2" = deps: { features?(features_.tokio_tcp."0.1.2" deps {}) }: buildRustCrate {
    crateName = "tokio-tcp";
    version = "0.1.2";
    description = "TCP bindings for tokio.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0yvfwybqnyca24aj9as8rgydamjq0wrd9xbxxkjcasvsdmsv6z1d";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_tcp"."0.1.2"."bytes"}" deps)
      (crates."futures"."${deps."tokio_tcp"."0.1.2"."futures"}" deps)
      (crates."iovec"."${deps."tokio_tcp"."0.1.2"."iovec"}" deps)
      (crates."mio"."${deps."tokio_tcp"."0.1.2"."mio"}" deps)
      (crates."tokio_io"."${deps."tokio_tcp"."0.1.2"."tokio_io"}" deps)
      (crates."tokio_reactor"."${deps."tokio_tcp"."0.1.2"."tokio_reactor"}" deps)
    ]);
  };
  features_.tokio_tcp."0.1.2" = deps: f: updateFeatures f ({
    bytes."${deps.tokio_tcp."0.1.2".bytes}".default = true;
    futures."${deps.tokio_tcp."0.1.2".futures}".default = true;
    iovec."${deps.tokio_tcp."0.1.2".iovec}".default = true;
    mio."${deps.tokio_tcp."0.1.2".mio}".default = true;
    tokio_io."${deps.tokio_tcp."0.1.2".tokio_io}".default = true;
    tokio_reactor."${deps.tokio_tcp."0.1.2".tokio_reactor}".default = true;
    tokio_tcp."0.1.2".default = (f.tokio_tcp."0.1.2".default or true);
  }) [
    (features_.bytes."${deps."tokio_tcp"."0.1.2"."bytes"}" deps)
    (features_.futures."${deps."tokio_tcp"."0.1.2"."futures"}" deps)
    (features_.iovec."${deps."tokio_tcp"."0.1.2"."iovec"}" deps)
    (features_.mio."${deps."tokio_tcp"."0.1.2"."mio"}" deps)
    (features_.tokio_io."${deps."tokio_tcp"."0.1.2"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."tokio_tcp"."0.1.2"."tokio_reactor"}" deps)
  ];


# end
# tokio-threadpool-0.1.9

  crates.tokio_threadpool."0.1.9" = deps: { features?(features_.tokio_threadpool."0.1.9" deps {}) }: buildRustCrate {
    crateName = "tokio-threadpool";
    version = "0.1.9";
    description = "A task scheduler backed by a work-stealing thread pool.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0ipr0j79mhjjsvc0ma95sj07m0aiyq6rkwgvlalqwhinivl5d39g";
    dependencies = mapFeatures features ([
      (crates."crossbeam_deque"."${deps."tokio_threadpool"."0.1.9"."crossbeam_deque"}" deps)
      (crates."crossbeam_utils"."${deps."tokio_threadpool"."0.1.9"."crossbeam_utils"}" deps)
      (crates."futures"."${deps."tokio_threadpool"."0.1.9"."futures"}" deps)
      (crates."log"."${deps."tokio_threadpool"."0.1.9"."log"}" deps)
      (crates."num_cpus"."${deps."tokio_threadpool"."0.1.9"."num_cpus"}" deps)
      (crates."rand"."${deps."tokio_threadpool"."0.1.9"."rand"}" deps)
      (crates."tokio_executor"."${deps."tokio_threadpool"."0.1.9"."tokio_executor"}" deps)
    ]);
  };
  features_.tokio_threadpool."0.1.9" = deps: f: updateFeatures f ({
    crossbeam_deque."${deps.tokio_threadpool."0.1.9".crossbeam_deque}".default = true;
    crossbeam_utils."${deps.tokio_threadpool."0.1.9".crossbeam_utils}".default = true;
    futures."${deps.tokio_threadpool."0.1.9".futures}".default = true;
    log."${deps.tokio_threadpool."0.1.9".log}".default = true;
    num_cpus."${deps.tokio_threadpool."0.1.9".num_cpus}".default = true;
    rand."${deps.tokio_threadpool."0.1.9".rand}".default = true;
    tokio_executor."${deps.tokio_threadpool."0.1.9".tokio_executor}".default = true;
    tokio_threadpool."0.1.9".default = (f.tokio_threadpool."0.1.9".default or true);
  }) [
    (features_.crossbeam_deque."${deps."tokio_threadpool"."0.1.9"."crossbeam_deque"}" deps)
    (features_.crossbeam_utils."${deps."tokio_threadpool"."0.1.9"."crossbeam_utils"}" deps)
    (features_.futures."${deps."tokio_threadpool"."0.1.9"."futures"}" deps)
    (features_.log."${deps."tokio_threadpool"."0.1.9"."log"}" deps)
    (features_.num_cpus."${deps."tokio_threadpool"."0.1.9"."num_cpus"}" deps)
    (features_.rand."${deps."tokio_threadpool"."0.1.9"."rand"}" deps)
    (features_.tokio_executor."${deps."tokio_threadpool"."0.1.9"."tokio_executor"}" deps)
  ];


# end
# tokio-timer-0.2.5

  crates.tokio_timer."0.2.5" = deps: { features?(features_.tokio_timer."0.2.5" deps {}) }: buildRustCrate {
    crateName = "tokio-timer";
    version = "0.2.5";
    description = "Timer facilities for Tokio\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0jyhizvnpldkbqvqygrg0zd5zvfj9p0ywvjzf47iy632vq3qnwzm";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_timer"."0.2.5"."futures"}" deps)
      (crates."tokio_executor"."${deps."tokio_timer"."0.2.5"."tokio_executor"}" deps)
    ]);
  };
  features_.tokio_timer."0.2.5" = deps: f: updateFeatures f ({
    futures."${deps.tokio_timer."0.2.5".futures}".default = true;
    tokio_executor."${deps.tokio_timer."0.2.5".tokio_executor}".default = true;
    tokio_timer."0.2.5".default = (f.tokio_timer."0.2.5".default or true);
  }) [
    (features_.futures."${deps."tokio_timer"."0.2.5"."futures"}" deps)
    (features_.tokio_executor."${deps."tokio_timer"."0.2.5"."tokio_executor"}" deps)
  ];


# end
# tokio-udp-0.1.3

  crates.tokio_udp."0.1.3" = deps: { features?(features_.tokio_udp."0.1.3" deps {}) }: buildRustCrate {
    crateName = "tokio-udp";
    version = "0.1.3";
    description = "UDP bindings for tokio.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1g1x499vqvzwy7xfccr32vwymlx25zpmkx8ppqgifzqwrjnncajf";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_udp"."0.1.3"."bytes"}" deps)
      (crates."futures"."${deps."tokio_udp"."0.1.3"."futures"}" deps)
      (crates."log"."${deps."tokio_udp"."0.1.3"."log"}" deps)
      (crates."mio"."${deps."tokio_udp"."0.1.3"."mio"}" deps)
      (crates."tokio_codec"."${deps."tokio_udp"."0.1.3"."tokio_codec"}" deps)
      (crates."tokio_io"."${deps."tokio_udp"."0.1.3"."tokio_io"}" deps)
      (crates."tokio_reactor"."${deps."tokio_udp"."0.1.3"."tokio_reactor"}" deps)
    ]);
  };
  features_.tokio_udp."0.1.3" = deps: f: updateFeatures f ({
    bytes."${deps.tokio_udp."0.1.3".bytes}".default = true;
    futures."${deps.tokio_udp."0.1.3".futures}".default = true;
    log."${deps.tokio_udp."0.1.3".log}".default = true;
    mio."${deps.tokio_udp."0.1.3".mio}".default = true;
    tokio_codec."${deps.tokio_udp."0.1.3".tokio_codec}".default = true;
    tokio_io."${deps.tokio_udp."0.1.3".tokio_io}".default = true;
    tokio_reactor."${deps.tokio_udp."0.1.3".tokio_reactor}".default = true;
    tokio_udp."0.1.3".default = (f.tokio_udp."0.1.3".default or true);
  }) [
    (features_.bytes."${deps."tokio_udp"."0.1.3"."bytes"}" deps)
    (features_.futures."${deps."tokio_udp"."0.1.3"."futures"}" deps)
    (features_.log."${deps."tokio_udp"."0.1.3"."log"}" deps)
    (features_.mio."${deps."tokio_udp"."0.1.3"."mio"}" deps)
    (features_.tokio_codec."${deps."tokio_udp"."0.1.3"."tokio_codec"}" deps)
    (features_.tokio_io."${deps."tokio_udp"."0.1.3"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."tokio_udp"."0.1.3"."tokio_reactor"}" deps)
  ];


# end
# try-lock-0.2.2

  crates.try_lock."0.2.2" = deps: { features?(features_.try_lock."0.2.2" deps {}) }: buildRustCrate {
    crateName = "try-lock";
    version = "0.2.2";
    description = "A lightweight atomic lock.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1k8xc0jpbrmzp0fwghdh6pwzjb9xx2p8yy0xxnnb8065smc5fsrv";
  };
  features_.try_lock."0.2.2" = deps: f: updateFeatures f ({
    try_lock."0.2.2".default = (f.try_lock."0.2.2".default or true);
  }) [];


# end
# unicase-1.4.2

  crates.unicase."1.4.2" = deps: { features?(features_.unicase."1.4.2" deps {}) }: buildRustCrate {
    crateName = "unicase";
    version = "1.4.2";
    description = "A case-insensitive wrapper around strings.";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "0rbnhw2mnhcwrij3vczp0sl8zdfmvf2dlh8hly81kj7132kfj0mf";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."unicase"."1.4.2"."version_check"}" deps)
    ]);
    features = mkFeatures (features."unicase"."1.4.2" or {});
  };
  features_.unicase."1.4.2" = deps: f: updateFeatures f (rec {
    unicase = fold recursiveUpdate {} [
      { "1.4.2"."heapsize" =
        (f.unicase."1.4.2"."heapsize" or false) ||
        (f.unicase."1.4.2".heap_size or false) ||
        (unicase."1.4.2"."heap_size" or false); }
      { "1.4.2"."heapsize_plugin" =
        (f.unicase."1.4.2"."heapsize_plugin" or false) ||
        (f.unicase."1.4.2".heap_size or false) ||
        (unicase."1.4.2"."heap_size" or false); }
      { "1.4.2".default = (f.unicase."1.4.2".default or true); }
    ];
    version_check."${deps.unicase."1.4.2".version_check}".default = true;
  }) [
    (features_.version_check."${deps."unicase"."1.4.2"."version_check"}" deps)
  ];


# end
# unicase-2.1.0

  crates.unicase."2.1.0" = deps: { features?(features_.unicase."2.1.0" deps {}) }: buildRustCrate {
    crateName = "unicase";
    version = "2.1.0";
    description = "A case-insensitive wrapper around strings.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1zzn16hh8fdx5pnbbnl32q8m2mh4vpd1jm9pdcv969ik83dw4byp";
    build = "build.rs";

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."unicase"."2.1.0"."version_check"}" deps)
    ]);
    features = mkFeatures (features."unicase"."2.1.0" or {});
  };
  features_.unicase."2.1.0" = deps: f: updateFeatures f ({
    unicase."2.1.0".default = (f.unicase."2.1.0".default or true);
    version_check."${deps.unicase."2.1.0".version_check}".default = true;
  }) [
    (features_.version_check."${deps."unicase"."2.1.0"."version_check"}" deps)
  ];


# end
# unicode-bidi-0.3.4

  crates.unicode_bidi."0.3.4" = deps: { features?(features_.unicode_bidi."0.3.4" deps {}) }: buildRustCrate {
    crateName = "unicode-bidi";
    version = "0.3.4";
    description = "Implementation of the Unicode Bidirectional Algorithm";
    authors = [ "The Servo Project Developers" ];
    sha256 = "0lcd6jasrf8p9p0q20qyf10c6xhvw40m2c4rr105hbk6zy26nj1q";
    libName = "unicode_bidi";
    dependencies = mapFeatures features ([
      (crates."matches"."${deps."unicode_bidi"."0.3.4"."matches"}" deps)
    ]);
    features = mkFeatures (features."unicode_bidi"."0.3.4" or {});
  };
  features_.unicode_bidi."0.3.4" = deps: f: updateFeatures f (rec {
    matches."${deps.unicode_bidi."0.3.4".matches}".default = true;
    unicode_bidi = fold recursiveUpdate {} [
      { "0.3.4"."flame" =
        (f.unicode_bidi."0.3.4"."flame" or false) ||
        (f.unicode_bidi."0.3.4".flame_it or false) ||
        (unicode_bidi."0.3.4"."flame_it" or false); }
      { "0.3.4"."flamer" =
        (f.unicode_bidi."0.3.4"."flamer" or false) ||
        (f.unicode_bidi."0.3.4".flame_it or false) ||
        (unicode_bidi."0.3.4"."flame_it" or false); }
      { "0.3.4"."serde" =
        (f.unicode_bidi."0.3.4"."serde" or false) ||
        (f.unicode_bidi."0.3.4".with_serde or false) ||
        (unicode_bidi."0.3.4"."with_serde" or false); }
      { "0.3.4".default = (f.unicode_bidi."0.3.4".default or true); }
    ];
  }) [
    (features_.matches."${deps."unicode_bidi"."0.3.4"."matches"}" deps)
  ];


# end
# unicode-normalization-0.1.5

  crates.unicode_normalization."0.1.5" = deps: { features?(features_.unicode_normalization."0.1.5" deps {}) }: buildRustCrate {
    crateName = "unicode-normalization";
    version = "0.1.5";
    description = "This crate provides functions for normalization of\nUnicode strings, including Canonical and Compatible\nDecomposition and Recomposition, as described in\nUnicode Standard Annex #15.\n";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0hg29g86fca7b65mwk4sm5s838js6bqrl0gabadbazvbsgjam0j5";
  };
  features_.unicode_normalization."0.1.5" = deps: f: updateFeatures f ({
    unicode_normalization."0.1.5".default = (f.unicode_normalization."0.1.5".default or true);
  }) [];


# end
# unicode-width-0.1.4

  crates.unicode_width."0.1.4" = deps: { features?(features_.unicode_width."0.1.4" deps {}) }: buildRustCrate {
    crateName = "unicode-width";
    version = "0.1.4";
    description = "Determine displayed width of `char` and `str` types\naccording to Unicode Standard Annex #11 rules.\n";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "1rp7a04icn9y5c0lm74nrd4py0rdl0af8bhdwq7g478n1xifpifl";
    features = mkFeatures (features."unicode_width"."0.1.4" or {});
  };
  features_.unicode_width."0.1.4" = deps: f: updateFeatures f ({
    unicode_width."0.1.4".default = (f.unicode_width."0.1.4".default or true);
  }) [];


# end
# unicode-xid-0.0.4

  crates.unicode_xid."0.0.4" = deps: { features?(features_.unicode_xid."0.0.4" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.0.4";
    description = "Determine whether characters have the XID_Start\nor XID_Continue properties according to\nUnicode Standard Annex #31.\n";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1dc8wkkcd3s6534s5aw4lbjn8m67flkkbnajp5bl8408wdg8rh9v";
    features = mkFeatures (features."unicode_xid"."0.0.4" or {});
  };
  features_.unicode_xid."0.0.4" = deps: f: updateFeatures f ({
    unicode_xid."0.0.4".default = (f.unicode_xid."0.0.4".default or true);
  }) [];


# end
# unreachable-1.0.0

  crates.unreachable."1.0.0" = deps: { features?(features_.unreachable."1.0.0" deps {}) }: buildRustCrate {
    crateName = "unreachable";
    version = "1.0.0";
    description = "An unreachable code optimization hint in stable rust.";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1am8czbk5wwr25gbp2zr007744fxjshhdqjz9liz7wl4pnv3whcf";
    dependencies = mapFeatures features ([
      (crates."void"."${deps."unreachable"."1.0.0"."void"}" deps)
    ]);
  };
  features_.unreachable."1.0.0" = deps: f: updateFeatures f ({
    unreachable."1.0.0".default = (f.unreachable."1.0.0".default or true);
    void."${deps.unreachable."1.0.0".void}".default = (f.void."${deps.unreachable."1.0.0".void}".default or false);
  }) [
    (features_.void."${deps."unreachable"."1.0.0"."void"}" deps)
  ];


# end
# url-1.6.1

  crates.url."1.6.1" = deps: { features?(features_.url."1.6.1" deps {}) }: buildRustCrate {
    crateName = "url";
    version = "1.6.1";
    description = "URL library for Rust, based on the WHATWG URL Standard";
    authors = [ "The rust-url developers" ];
    sha256 = "1qsnhmxznzaxl068a3ksz69kwcz7ghvl4zflg9qj7lyw4bk9ma38";
    dependencies = mapFeatures features ([
      (crates."idna"."${deps."url"."1.6.1"."idna"}" deps)
      (crates."matches"."${deps."url"."1.6.1"."matches"}" deps)
      (crates."percent_encoding"."${deps."url"."1.6.1"."percent_encoding"}" deps)
    ]);
    features = mkFeatures (features."url"."1.6.1" or {});
  };
  features_.url."1.6.1" = deps: f: updateFeatures f (rec {
    idna."${deps.url."1.6.1".idna}".default = true;
    matches."${deps.url."1.6.1".matches}".default = true;
    percent_encoding."${deps.url."1.6.1".percent_encoding}".default = true;
    url = fold recursiveUpdate {} [
      { "1.6.1"."encoding" =
        (f.url."1.6.1"."encoding" or false) ||
        (f.url."1.6.1".query_encoding or false) ||
        (url."1.6.1"."query_encoding" or false); }
      { "1.6.1"."heapsize" =
        (f.url."1.6.1"."heapsize" or false) ||
        (f.url."1.6.1".heap_size or false) ||
        (url."1.6.1"."heap_size" or false); }
      { "1.6.1".default = (f.url."1.6.1".default or true); }
    ];
  }) [
    (features_.idna."${deps."url"."1.6.1"."idna"}" deps)
    (features_.matches."${deps."url"."1.6.1"."matches"}" deps)
    (features_.percent_encoding."${deps."url"."1.6.1"."percent_encoding"}" deps)
  ];


# end
# utf8-ranges-0.1.3

  crates.utf8_ranges."0.1.3" = deps: { features?(features_.utf8_ranges."0.1.3" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "0.1.3";
    description = "Convert ranges of Unicode codepoints to UTF-8 byte ranges.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1cj548a91a93j8375p78qikaiam548xh84cb0ck8y119adbmsvbp";
  };
  features_.utf8_ranges."0.1.3" = deps: f: updateFeatures f ({
    utf8_ranges."0.1.3".default = (f.utf8_ranges."0.1.3".default or true);
  }) [];


# end
# uuid-0.7.1

  crates.uuid."0.7.1" = deps: { features?(features_.uuid."0.7.1" deps {}) }: buildRustCrate {
    crateName = "uuid";
    version = "0.7.1";
    description = "A library to generate and parse UUIDs.";
    authors = [ "Ashley Mannix<ashleymannix@live.com.au>" "Christopher Armstrong" "Dylan DPC<dylan.dpc@gmail.com>" "Hunar Roop Kahlon<hunar.roop@gmail.com>" ];
    sha256 = "1wh5izr7bssf1j8y3cawj4yfr5pz4cfxgsjlk2gs1vccc848qpbj";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.uuid."0.7.1".rand or false then [ (crates.rand."${deps."uuid"."0.7.1".rand}" deps) ] else []));
    features = mkFeatures (features."uuid"."0.7.1" or {});
  };
  features_.uuid."0.7.1" = deps: f: updateFeatures f (rec {
    rand."${deps.uuid."0.7.1".rand}".default = true;
    uuid = fold recursiveUpdate {} [
      { "0.7.1"."byteorder" =
        (f.uuid."0.7.1"."byteorder" or false) ||
        (f.uuid."0.7.1".u128 or false) ||
        (uuid."0.7.1"."u128" or false); }
      { "0.7.1"."md5" =
        (f.uuid."0.7.1"."md5" or false) ||
        (f.uuid."0.7.1".v3 or false) ||
        (uuid."0.7.1"."v3" or false); }
      { "0.7.1"."nightly" =
        (f.uuid."0.7.1"."nightly" or false) ||
        (f.uuid."0.7.1".const_fn or false) ||
        (uuid."0.7.1"."const_fn" or false); }
      { "0.7.1"."rand" =
        (f.uuid."0.7.1"."rand" or false) ||
        (f.uuid."0.7.1".v3 or false) ||
        (uuid."0.7.1"."v3" or false) ||
        (f.uuid."0.7.1".v4 or false) ||
        (uuid."0.7.1"."v4" or false) ||
        (f.uuid."0.7.1".v5 or false) ||
        (uuid."0.7.1"."v5" or false); }
      { "0.7.1"."sha1" =
        (f.uuid."0.7.1"."sha1" or false) ||
        (f.uuid."0.7.1".v5 or false) ||
        (uuid."0.7.1"."v5" or false); }
      { "0.7.1"."std" =
        (f.uuid."0.7.1"."std" or false) ||
        (f.uuid."0.7.1".default or false) ||
        (uuid."0.7.1"."default" or false); }
      { "0.7.1".default = (f.uuid."0.7.1".default or true); }
    ];
  }) [
    (features_.rand."${deps."uuid"."0.7.1"."rand"}" deps)
  ];


# end
# vcpkg-0.2.2

  crates.vcpkg."0.2.2" = deps: { features?(features_.vcpkg."0.2.2" deps {}) }: buildRustCrate {
    crateName = "vcpkg";
    version = "0.2.2";
    description = "A library to find native dependencies in a vcpkg tree at build\ntime in order to be used in Cargo build scripts.\n";
    authors = [ "Jim McGrath <jimmc2@gmail.com>" ];
    sha256 = "1fl5j0ksnwrnsrf1b1a9lqbjgnajdipq0030vsbhx81mb7d9478a";
  };
  features_.vcpkg."0.2.2" = deps: f: updateFeatures f ({
    vcpkg."0.2.2".default = (f.vcpkg."0.2.2".default or true);
  }) [];


# end
# vec_map-0.8.0

  crates.vec_map."0.8.0" = deps: { features?(features_.vec_map."0.8.0" deps {}) }: buildRustCrate {
    crateName = "vec_map";
    version = "0.8.0";
    description = "A simple map based on a vector for small integer keys";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Jorge Aparicio <japaricious@gmail.com>" "Alexis Beingessner <a.beingessner@gmail.com>" "Brian Anderson <>" "tbu- <>" "Manish Goregaokar <>" "Aaron Turon <aturon@mozilla.com>" "Adolfo Ochagavía <>" "Niko Matsakis <>" "Steven Fackler <>" "Chase Southwood <csouth3@illinois.edu>" "Eduard Burtescu <>" "Florian Wilkens <>" "Félix Raimundo <>" "Tibor Benke <>" "Markus Siemens <markus@m-siemens.de>" "Josh Branchaud <jbranchaud@gmail.com>" "Huon Wilson <dbau.pp@gmail.com>" "Corey Farwell <coref@rwell.org>" "Aaron Liblong <>" "Nick Cameron <nrc@ncameron.org>" "Patrick Walton <pcwalton@mimiga.net>" "Felix S Klock II <>" "Andrew Paseltiner <apaseltiner@gmail.com>" "Sean McArthur <sean.monstar@gmail.com>" "Vadim Petrochenkov <>" ];
    sha256 = "07sgxp3cf1a4cxm9n3r27fcvqmld32bl2576mrcahnvm34j11xay";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."vec_map"."0.8.0" or {});
  };
  features_.vec_map."0.8.0" = deps: f: updateFeatures f (rec {
    vec_map = fold recursiveUpdate {} [
      { "0.8.0"."serde" =
        (f.vec_map."0.8.0"."serde" or false) ||
        (f.vec_map."0.8.0".eders or false) ||
        (vec_map."0.8.0"."eders" or false); }
      { "0.8.0"."serde_derive" =
        (f.vec_map."0.8.0"."serde_derive" or false) ||
        (f.vec_map."0.8.0".eders or false) ||
        (vec_map."0.8.0"."eders" or false); }
      { "0.8.0".default = (f.vec_map."0.8.0".default or true); }
    ];
  }) [];


# end
# version_check-0.1.3

  crates.version_check."0.1.3" = deps: { features?(features_.version_check."0.1.3" deps {}) }: buildRustCrate {
    crateName = "version_check";
    version = "0.1.3";
    description = "Tiny crate to check the version of the installed/running rustc.";
    authors = [ "Sergio Benitez <sb@sergio.bz>" ];
    sha256 = "0z635wdclv9bvafj11fpgndn7y79ibpsnc364pm61i1m4wwg8msg";
  };
  features_.version_check."0.1.3" = deps: f: updateFeatures f ({
    version_check."0.1.3".default = (f.version_check."0.1.3".default or true);
  }) [];


# end
# void-1.0.2

  crates.void."1.0.2" = deps: { features?(features_.void."1.0.2" deps {}) }: buildRustCrate {
    crateName = "void";
    version = "1.0.2";
    description = "The uninhabited void type for use in statically impossible cases.";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "0h1dm0dx8dhf56a83k68mijyxigqhizpskwxfdrs1drwv2cdclv3";
    features = mkFeatures (features."void"."1.0.2" or {});
  };
  features_.void."1.0.2" = deps: f: updateFeatures f (rec {
    void = fold recursiveUpdate {} [
      { "1.0.2"."std" =
        (f.void."1.0.2"."std" or false) ||
        (f.void."1.0.2".default or false) ||
        (void."1.0.2"."default" or false); }
      { "1.0.2".default = (f.void."1.0.2".default or true); }
    ];
  }) [];


# end
# want-0.0.6

  crates.want."0.0.6" = deps: { features?(features_.want."0.0.6" deps {}) }: buildRustCrate {
    crateName = "want";
    version = "0.0.6";
    description = "Detect when another Future wants a result.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "03cc2lndz531a4kgql1v9kppyb1yz2abcz5l52j1gg2nypmy3lh8";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."want"."0.0.6"."futures"}" deps)
      (crates."log"."${deps."want"."0.0.6"."log"}" deps)
      (crates."try_lock"."${deps."want"."0.0.6"."try_lock"}" deps)
    ]);
  };
  features_.want."0.0.6" = deps: f: updateFeatures f ({
    futures."${deps.want."0.0.6".futures}".default = true;
    log."${deps.want."0.0.6".log}".default = true;
    try_lock."${deps.want."0.0.6".try_lock}".default = true;
    want."0.0.6".default = (f.want."0.0.6".default or true);
  }) [
    (features_.futures."${deps."want"."0.0.6"."futures"}" deps)
    (features_.log."${deps."want"."0.0.6"."log"}" deps)
    (features_.try_lock."${deps."want"."0.0.6"."try_lock"}" deps)
  ];


# end
# winapi-0.2.8

  crates.winapi."0.2.8" = deps: { features?(features_.winapi."0.2.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.2.8";
    description = "Types and constants for WinAPI bindings. See README for list of crates providing function bindings.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
  };
  features_.winapi."0.2.8" = deps: f: updateFeatures f ({
    winapi."0.2.8".default = (f.winapi."0.2.8".default or true);
  }) [];


# end
# winapi-0.3.6

  crates.winapi."0.3.6" = deps: { features?(features_.winapi."0.3.6" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.6";
    description = "Raw FFI bindings for all of Windows API.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1d9jfp4cjd82sr1q4dgdlrkvm33zhhav9d7ihr0nivqbncr059m4";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.6"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.6"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.6" or {});
  };
  features_.winapi."0.3.6" = deps: f: updateFeatures f ({
    winapi."0.3.6".default = (f.winapi."0.3.6".default or true);
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.6".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.6".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.6"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.6"."winapi_x86_64_pc_windows_gnu"}" deps)
  ];


# end
# winapi-build-0.1.1

  crates.winapi_build."0.1.1" = deps: { features?(features_.winapi_build."0.1.1" deps {}) }: buildRustCrate {
    crateName = "winapi-build";
    version = "0.1.1";
    description = "Common code for build.rs in WinAPI -sys crates.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
    libName = "build";
  };
  features_.winapi_build."0.1.1" = deps: f: updateFeatures f ({
    winapi_build."0.1.1".default = (f.winapi_build."0.1.1".default or true);
  }) [];


# end
# winapi-i686-pc-windows-gnu-0.4.0

  crates.winapi_i686_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_i686_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-i686-pc-windows-gnu";
    version = "0.4.0";
    description = "Import libraries for the i686-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "05ihkij18r4gamjpxj4gra24514can762imjzlmak5wlzidplzrp";
    build = "build.rs";
  };
  features_.winapi_i686_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f ({
    winapi_i686_pc_windows_gnu."0.4.0".default = (f.winapi_i686_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# winapi-x86_64-pc-windows-gnu-0.4.0

  crates.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_x86_64_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-x86_64-pc-windows-gnu";
    version = "0.4.0";
    description = "Import libraries for the x86_64-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0n1ylmlsb8yg1v583i4xy0qmqg42275flvbc51hdqjjfjcl9vlbj";
    build = "build.rs";
  };
  features_.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f ({
    winapi_x86_64_pc_windows_gnu."0.4.0".default = (f.winapi_x86_64_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# ws2_32-sys-0.2.1

  crates.ws2_32_sys."0.2.1" = deps: { features?(features_.ws2_32_sys."0.2.1" deps {}) }: buildRustCrate {
    crateName = "ws2_32-sys";
    version = "0.2.1";
    description = "Contains function definitions for the Windows API library ws2_32. See winapi for types and constants.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1zpy9d9wk11sj17fczfngcj28w4xxjs3b4n036yzpy38dxp4f7kc";
    libName = "ws2_32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
    ]);
  };
  features_.ws2_32_sys."0.2.1" = deps: f: updateFeatures f ({
    winapi."${deps.ws2_32_sys."0.2.1".winapi}".default = true;
    winapi_build."${deps.ws2_32_sys."0.2.1".winapi_build}".default = true;
    ws2_32_sys."0.2.1".default = (f.ws2_32_sys."0.2.1".default or true);
  }) [
    (features_.winapi."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    (features_.winapi_build."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
  ];


# end
# xattr-0.1.11

  crates.xattr."0.1.11" = deps: { features?(features_.xattr."0.1.11" deps {}) }: buildRustCrate {
    crateName = "xattr";
    version = "0.1.11";
    description = "unix extended filesystem attributes";
    authors = [ "Steven Allen <steven@stebalien.com>" ];
    sha256 = "0v8wad18pdxv7242a7xs18i9hy00ih3vwajz7my05zbxx2ss01nx";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."xattr"."0.1.11"."libc"}" deps)
    ]);
    features = mkFeatures (features."xattr"."0.1.11" or {});
  };
  features_.xattr."0.1.11" = deps: f: updateFeatures f (rec {
    libc."${deps.xattr."0.1.11".libc}".default = true;
    xattr = fold recursiveUpdate {} [
      { "0.1.11"."unsupported" =
        (f.xattr."0.1.11"."unsupported" or false) ||
        (f.xattr."0.1.11".default or false) ||
        (xattr."0.1.11"."default" or false); }
      { "0.1.11".default = (f.xattr."0.1.11".default or true); }
    ];
  }) [
    (features_.libc."${deps."xattr"."0.1.11"."libc"}" deps)
  ];


# end
}

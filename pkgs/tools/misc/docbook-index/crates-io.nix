{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.7.6

  crates.aho_corasick."0.7.6" = deps: { features?(features_.aho_corasick."0.7.6" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.7.6";
    description = "Fast multiple substring searching.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1srdggg7iawz7rfyb79qfnz6vmzkgl6g6gabyd9ad6pbx7zzj8gz";
    libName = "aho_corasick";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.7.6"."memchr"}" deps)
    ]);
    features = mkFeatures (features."aho_corasick"."0.7.6" or {});
  };
  features_.aho_corasick."0.7.6" = deps: f: updateFeatures f (rec {
    aho_corasick = fold recursiveUpdate {} [
      { "0.7.6"."std" =
        (f.aho_corasick."0.7.6"."std" or false) ||
        (f.aho_corasick."0.7.6".default or false) ||
        (aho_corasick."0.7.6"."default" or false); }
      { "0.7.6".default = (f.aho_corasick."0.7.6".default or true); }
    ];
    memchr = fold recursiveUpdate {} [
      { "${deps.aho_corasick."0.7.6".memchr}"."use_std" =
        (f.memchr."${deps.aho_corasick."0.7.6".memchr}"."use_std" or false) ||
        (aho_corasick."0.7.6"."std" or false) ||
        (f."aho_corasick"."0.7.6"."std" or false); }
      { "${deps.aho_corasick."0.7.6".memchr}".default = (f.memchr."${deps.aho_corasick."0.7.6".memchr}".default or false); }
    ];
  }) [
    (features_.memchr."${deps."aho_corasick"."0.7.6"."memchr"}" deps)
  ];


# end
# ansi_term-0.11.0

  crates.ansi_term."0.11.0" = deps: { features?(features_.ansi_term."0.11.0" deps {}) }: buildRustCrate {
    crateName = "ansi_term";
    version = "0.11.0";
    description = "Library for ANSI terminal colours and styles (bold, underline)";
    authors = [ "ogham@bsago.me" "Ryan Scheel (Havvy) <ryan.havvy@gmail.com>" "Josh Triplett <josh@joshtriplett.org>" ];
    sha256 = "08fk0p2xvkqpmz3zlrwnf6l8sj2vngw464rvzspzp31sbgxbwm4v";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."ansi_term"."0.11.0"."winapi"}" deps)
    ]) else []);
  };
  features_.ansi_term."0.11.0" = deps: f: updateFeatures f (rec {
    ansi_term."0.11.0".default = (f.ansi_term."0.11.0".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.ansi_term."0.11.0".winapi}"."consoleapi" = true; }
      { "${deps.ansi_term."0.11.0".winapi}"."errhandlingapi" = true; }
      { "${deps.ansi_term."0.11.0".winapi}"."processenv" = true; }
      { "${deps.ansi_term."0.11.0".winapi}".default = true; }
    ];
  }) [
    (features_.winapi."${deps."ansi_term"."0.11.0"."winapi"}" deps)
  ];


# end
# atty-0.2.13

  crates.atty."0.2.13" = deps: { features?(features_.atty."0.2.13" deps {}) }: buildRustCrate {
    crateName = "atty";
    version = "0.2.13";
    description = "A simple interface for querying atty";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "0a1ii8h9fvvrq05bz7j135zjjz1sjz6n2invn2ngxqri0jxgmip2";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."atty"."0.2.13"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."atty"."0.2.13"."winapi"}" deps)
    ]) else []);
  };
  features_.atty."0.2.13" = deps: f: updateFeatures f (rec {
    atty."0.2.13".default = (f.atty."0.2.13".default or true);
    libc."${deps.atty."0.2.13".libc}".default = (f.libc."${deps.atty."0.2.13".libc}".default or false);
    winapi = fold recursiveUpdate {} [
      { "${deps.atty."0.2.13".winapi}"."consoleapi" = true; }
      { "${deps.atty."0.2.13".winapi}"."minwinbase" = true; }
      { "${deps.atty."0.2.13".winapi}"."minwindef" = true; }
      { "${deps.atty."0.2.13".winapi}"."processenv" = true; }
      { "${deps.atty."0.2.13".winapi}"."winbase" = true; }
      { "${deps.atty."0.2.13".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."atty"."0.2.13"."libc"}" deps)
    (features_.winapi."${deps."atty"."0.2.13"."winapi"}" deps)
  ];


# end
# bitflags-1.1.0

  crates.bitflags."1.1.0" = deps: { features?(features_.bitflags."1.1.0" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.1.0";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1iwa4jrqcf4lnbwl562a3lx3r0jkh1j88b219bsqvbm4sni67dyv";
    build = "build.rs";
    features = mkFeatures (features."bitflags"."1.1.0" or {});
  };
  features_.bitflags."1.1.0" = deps: f: updateFeatures f (rec {
    bitflags."1.1.0".default = (f.bitflags."1.1.0".default or true);
  }) [];


# end
# clap-2.33.0

  crates.clap."2.33.0" = deps: { features?(features_.clap."2.33.0" deps {}) }: buildRustCrate {
    crateName = "clap";
    version = "2.33.0";
    description = "A simple to use, efficient, and full-featured Command Line Argument Parser\n";
    authors = [ "Kevin K. <kbknapp@gmail.com>" ];
    sha256 = "054n9ngh6pkknpmd4acgdsp40iw6f5jzq8a4h2b76gnbvk6p5xjh";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."clap"."2.33.0"."bitflags"}" deps)
      (crates."textwrap"."${deps."clap"."2.33.0"."textwrap"}" deps)
      (crates."unicode_width"."${deps."clap"."2.33.0"."unicode_width"}" deps)
    ]
      ++ (if features.clap."2.33.0".atty or false then [ (crates.atty."${deps."clap"."2.33.0".atty}" deps) ] else [])
      ++ (if features.clap."2.33.0".strsim or false then [ (crates.strsim."${deps."clap"."2.33.0".strsim}" deps) ] else [])
      ++ (if features.clap."2.33.0".vec_map or false then [ (crates.vec_map."${deps."clap"."2.33.0".vec_map}" deps) ] else []))
      ++ (if !(kernel == "windows") then mapFeatures features ([
    ]
      ++ (if features.clap."2.33.0".ansi_term or false then [ (crates.ansi_term."${deps."clap"."2.33.0".ansi_term}" deps) ] else [])) else []);
    features = mkFeatures (features."clap"."2.33.0" or {});
  };
  features_.clap."2.33.0" = deps: f: updateFeatures f (rec {
    ansi_term."${deps.clap."2.33.0".ansi_term}".default = true;
    atty."${deps.clap."2.33.0".atty}".default = true;
    bitflags."${deps.clap."2.33.0".bitflags}".default = true;
    clap = fold recursiveUpdate {} [
      { "2.33.0"."ansi_term" =
        (f.clap."2.33.0"."ansi_term" or false) ||
        (f.clap."2.33.0".color or false) ||
        (clap."2.33.0"."color" or false); }
      { "2.33.0"."atty" =
        (f.clap."2.33.0"."atty" or false) ||
        (f.clap."2.33.0".color or false) ||
        (clap."2.33.0"."color" or false); }
      { "2.33.0"."clippy" =
        (f.clap."2.33.0"."clippy" or false) ||
        (f.clap."2.33.0".lints or false) ||
        (clap."2.33.0"."lints" or false); }
      { "2.33.0"."color" =
        (f.clap."2.33.0"."color" or false) ||
        (f.clap."2.33.0".default or false) ||
        (clap."2.33.0"."default" or false); }
      { "2.33.0"."strsim" =
        (f.clap."2.33.0"."strsim" or false) ||
        (f.clap."2.33.0".suggestions or false) ||
        (clap."2.33.0"."suggestions" or false); }
      { "2.33.0"."suggestions" =
        (f.clap."2.33.0"."suggestions" or false) ||
        (f.clap."2.33.0".default or false) ||
        (clap."2.33.0"."default" or false); }
      { "2.33.0"."term_size" =
        (f.clap."2.33.0"."term_size" or false) ||
        (f.clap."2.33.0".wrap_help or false) ||
        (clap."2.33.0"."wrap_help" or false); }
      { "2.33.0"."vec_map" =
        (f.clap."2.33.0"."vec_map" or false) ||
        (f.clap."2.33.0".default or false) ||
        (clap."2.33.0"."default" or false); }
      { "2.33.0"."yaml" =
        (f.clap."2.33.0"."yaml" or false) ||
        (f.clap."2.33.0".doc or false) ||
        (clap."2.33.0"."doc" or false); }
      { "2.33.0"."yaml-rust" =
        (f.clap."2.33.0"."yaml-rust" or false) ||
        (f.clap."2.33.0".yaml or false) ||
        (clap."2.33.0"."yaml" or false); }
      { "2.33.0".default = (f.clap."2.33.0".default or true); }
    ];
    strsim."${deps.clap."2.33.0".strsim}".default = true;
    textwrap = fold recursiveUpdate {} [
      { "${deps.clap."2.33.0".textwrap}"."term_size" =
        (f.textwrap."${deps.clap."2.33.0".textwrap}"."term_size" or false) ||
        (clap."2.33.0"."wrap_help" or false) ||
        (f."clap"."2.33.0"."wrap_help" or false); }
      { "${deps.clap."2.33.0".textwrap}".default = true; }
    ];
    unicode_width."${deps.clap."2.33.0".unicode_width}".default = true;
    vec_map."${deps.clap."2.33.0".vec_map}".default = true;
  }) [
    (features_.atty."${deps."clap"."2.33.0"."atty"}" deps)
    (features_.bitflags."${deps."clap"."2.33.0"."bitflags"}" deps)
    (features_.strsim."${deps."clap"."2.33.0"."strsim"}" deps)
    (features_.textwrap."${deps."clap"."2.33.0"."textwrap"}" deps)
    (features_.unicode_width."${deps."clap"."2.33.0"."unicode_width"}" deps)
    (features_.vec_map."${deps."clap"."2.33.0"."vec_map"}" deps)
    (features_.ansi_term."${deps."clap"."2.33.0"."ansi_term"}" deps)
  ];


# end
# docbook-index-0.1.5

  crates.docbook_index."0.1.5" = deps: { features?(features_.docbook_index."0.1.5" deps {}) }: buildRustCrate {
    crateName = "docbook-index";
    version = "0.1.5";
    description = "Index a DocBook project in to an elasticlunr-compatible JSON index,\nfor use in static-site XHTML sites.\n";
    authors = [ "Graham Christensen <graham@grahamc.com>" ];
    edition = "2018";
    sha256 = "1d8y6vkb5h0sdahkb1w9qx71qk32pjydzqrj2d8b6ysgq0ki0fxx";
    dependencies = mapFeatures features ([
      (crates."elasticlunr_rs"."${deps."docbook_index"."0.1.5"."elasticlunr_rs"}" deps)
      (crates."glob"."${deps."docbook_index"."0.1.5"."glob"}" deps)
      (crates."serde"."${deps."docbook_index"."0.1.5"."serde"}" deps)
      (crates."serde_json"."${deps."docbook_index"."0.1.5"."serde_json"}" deps)
      (crates."structopt"."${deps."docbook_index"."0.1.5"."structopt"}" deps)
      (crates."xml_rs"."${deps."docbook_index"."0.1.5"."xml_rs"}" deps)
    ]);
  };
  features_.docbook_index."0.1.5" = deps: f: updateFeatures f (rec {
    docbook_index."0.1.5".default = (f.docbook_index."0.1.5".default or true);
    elasticlunr_rs."${deps.docbook_index."0.1.5".elasticlunr_rs}".default = true;
    glob."${deps.docbook_index."0.1.5".glob}".default = true;
    serde = fold recursiveUpdate {} [
      { "${deps.docbook_index."0.1.5".serde}"."derive" = true; }
      { "${deps.docbook_index."0.1.5".serde}".default = true; }
    ];
    serde_json."${deps.docbook_index."0.1.5".serde_json}".default = true;
    structopt."${deps.docbook_index."0.1.5".structopt}".default = true;
    xml_rs."${deps.docbook_index."0.1.5".xml_rs}".default = true;
  }) [
    (features_.elasticlunr_rs."${deps."docbook_index"."0.1.5"."elasticlunr_rs"}" deps)
    (features_.glob."${deps."docbook_index"."0.1.5"."glob"}" deps)
    (features_.serde."${deps."docbook_index"."0.1.5"."serde"}" deps)
    (features_.serde_json."${deps."docbook_index"."0.1.5"."serde_json"}" deps)
    (features_.structopt."${deps."docbook_index"."0.1.5"."structopt"}" deps)
    (features_.xml_rs."${deps."docbook_index"."0.1.5"."xml_rs"}" deps)
  ];


# end
# elasticlunr-rs-2.3.6

  crates.elasticlunr_rs."2.3.6" = deps: { features?(features_.elasticlunr_rs."2.3.6" deps {}) }: buildRustCrate {
    crateName = "elasticlunr-rs";
    version = "2.3.6";
    description = "A partial port of elasticlunr.js to Rust";
    authors = [ "Matt Ickstadt <mattico8@gmail.com>" ];
    sha256 = "09yl0jql43hzlx1ypn1w9vg4961k48m55iff5f449vmqwhqpyay3";
    libName = "elasticlunr";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."elasticlunr_rs"."2.3.6"."lazy_static"}" deps)
      (crates."regex"."${deps."elasticlunr_rs"."2.3.6"."regex"}" deps)
      (crates."serde"."${deps."elasticlunr_rs"."2.3.6"."serde"}" deps)
      (crates."serde_derive"."${deps."elasticlunr_rs"."2.3.6"."serde_derive"}" deps)
      (crates."serde_json"."${deps."elasticlunr_rs"."2.3.6"."serde_json"}" deps)
      (crates."strum"."${deps."elasticlunr_rs"."2.3.6"."strum"}" deps)
      (crates."strum_macros"."${deps."elasticlunr_rs"."2.3.6"."strum_macros"}" deps)
    ]
      ++ (if features.elasticlunr_rs."2.3.6".rust-stemmers or false then [ (crates.rust_stemmers."${deps."elasticlunr_rs"."2.3.6".rust_stemmers}" deps) ] else []));
    features = mkFeatures (features."elasticlunr_rs"."2.3.6" or {});
  };
  features_.elasticlunr_rs."2.3.6" = deps: f: updateFeatures f (rec {
    elasticlunr_rs = fold recursiveUpdate {} [
      { "2.3.6"."bench" =
        (f.elasticlunr_rs."2.3.6"."bench" or false) ||
        (f.elasticlunr_rs."2.3.6".nightly or false) ||
        (elasticlunr_rs."2.3.6"."nightly" or false); }
      { "2.3.6"."da" =
        (f.elasticlunr_rs."2.3.6"."da" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."de" =
        (f.elasticlunr_rs."2.3.6"."de" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."du" =
        (f.elasticlunr_rs."2.3.6"."du" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."es" =
        (f.elasticlunr_rs."2.3.6"."es" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."fi" =
        (f.elasticlunr_rs."2.3.6"."fi" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."fr" =
        (f.elasticlunr_rs."2.3.6"."fr" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."it" =
        (f.elasticlunr_rs."2.3.6"."it" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."languages" =
        (f.elasticlunr_rs."2.3.6"."languages" or false) ||
        (f.elasticlunr_rs."2.3.6".default or false) ||
        (elasticlunr_rs."2.3.6"."default" or false); }
      { "2.3.6"."pt" =
        (f.elasticlunr_rs."2.3.6"."pt" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."ro" =
        (f.elasticlunr_rs."2.3.6"."ro" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."ru" =
        (f.elasticlunr_rs."2.3.6"."ru" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."rust-stemmers" =
        (f.elasticlunr_rs."2.3.6"."rust-stemmers" or false) ||
        (f.elasticlunr_rs."2.3.6".da or false) ||
        (elasticlunr_rs."2.3.6"."da" or false) ||
        (f.elasticlunr_rs."2.3.6".de or false) ||
        (elasticlunr_rs."2.3.6"."de" or false) ||
        (f.elasticlunr_rs."2.3.6".du or false) ||
        (elasticlunr_rs."2.3.6"."du" or false) ||
        (f.elasticlunr_rs."2.3.6".es or false) ||
        (elasticlunr_rs."2.3.6"."es" or false) ||
        (f.elasticlunr_rs."2.3.6".fi or false) ||
        (elasticlunr_rs."2.3.6"."fi" or false) ||
        (f.elasticlunr_rs."2.3.6".fr or false) ||
        (elasticlunr_rs."2.3.6"."fr" or false) ||
        (f.elasticlunr_rs."2.3.6".it or false) ||
        (elasticlunr_rs."2.3.6"."it" or false) ||
        (f.elasticlunr_rs."2.3.6".pt or false) ||
        (elasticlunr_rs."2.3.6"."pt" or false) ||
        (f.elasticlunr_rs."2.3.6".ro or false) ||
        (elasticlunr_rs."2.3.6"."ro" or false) ||
        (f.elasticlunr_rs."2.3.6".ru or false) ||
        (elasticlunr_rs."2.3.6"."ru" or false) ||
        (f.elasticlunr_rs."2.3.6".sv or false) ||
        (elasticlunr_rs."2.3.6"."sv" or false) ||
        (f.elasticlunr_rs."2.3.6".tr or false) ||
        (elasticlunr_rs."2.3.6"."tr" or false); }
      { "2.3.6"."sv" =
        (f.elasticlunr_rs."2.3.6"."sv" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6"."tr" =
        (f.elasticlunr_rs."2.3.6"."tr" or false) ||
        (f.elasticlunr_rs."2.3.6".languages or false) ||
        (elasticlunr_rs."2.3.6"."languages" or false); }
      { "2.3.6".default = (f.elasticlunr_rs."2.3.6".default or true); }
    ];
    lazy_static."${deps.elasticlunr_rs."2.3.6".lazy_static}".default = true;
    regex."${deps.elasticlunr_rs."2.3.6".regex}".default = true;
    rust_stemmers."${deps.elasticlunr_rs."2.3.6".rust_stemmers}".default = true;
    serde."${deps.elasticlunr_rs."2.3.6".serde}".default = true;
    serde_derive."${deps.elasticlunr_rs."2.3.6".serde_derive}".default = true;
    serde_json."${deps.elasticlunr_rs."2.3.6".serde_json}".default = true;
    strum."${deps.elasticlunr_rs."2.3.6".strum}".default = true;
    strum_macros."${deps.elasticlunr_rs."2.3.6".strum_macros}".default = true;
  }) [
    (features_.lazy_static."${deps."elasticlunr_rs"."2.3.6"."lazy_static"}" deps)
    (features_.regex."${deps."elasticlunr_rs"."2.3.6"."regex"}" deps)
    (features_.rust_stemmers."${deps."elasticlunr_rs"."2.3.6"."rust_stemmers"}" deps)
    (features_.serde."${deps."elasticlunr_rs"."2.3.6"."serde"}" deps)
    (features_.serde_derive."${deps."elasticlunr_rs"."2.3.6"."serde_derive"}" deps)
    (features_.serde_json."${deps."elasticlunr_rs"."2.3.6"."serde_json"}" deps)
    (features_.strum."${deps."elasticlunr_rs"."2.3.6"."strum"}" deps)
    (features_.strum_macros."${deps."elasticlunr_rs"."2.3.6"."strum_macros"}" deps)
  ];


# end
# glob-0.3.0

  crates.glob."0.3.0" = deps: { features?(features_.glob."0.3.0" deps {}) }: buildRustCrate {
    crateName = "glob";
    version = "0.3.0";
    description = "Support for matching file paths against Unix shell style patterns.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1b3dc2686xnrpxwx4nd3w06f9qs433w6xmmzq6jb76hh95dwwqb2";
  };
  features_.glob."0.3.0" = deps: f: updateFeatures f (rec {
    glob."0.3.0".default = (f.glob."0.3.0".default or true);
  }) [];


# end
# heck-0.3.1

  crates.heck."0.3.1" = deps: { features?(features_.heck."0.3.1" deps {}) }: buildRustCrate {
    crateName = "heck";
    version = "0.3.1";
    description = "heck is a case conversion library.";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1q7vmnlh62kls6cvkfhbcacxkawaznaqa5wwm9dg1xkcza846c3d";
    dependencies = mapFeatures features ([
      (crates."unicode_segmentation"."${deps."heck"."0.3.1"."unicode_segmentation"}" deps)
    ]);
  };
  features_.heck."0.3.1" = deps: f: updateFeatures f (rec {
    heck."0.3.1".default = (f.heck."0.3.1".default or true);
    unicode_segmentation."${deps.heck."0.3.1".unicode_segmentation}".default = true;
  }) [
    (features_.unicode_segmentation."${deps."heck"."0.3.1"."unicode_segmentation"}" deps)
  ];


# end
# itoa-0.4.4

  crates.itoa."0.4.4" = deps: { features?(features_.itoa."0.4.4" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.4";
    description = "Fast functions for printing integer primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1fqc34xzzl2spfdawxd9awhzl0fwf1y6y4i94l8bq8rfrzd90awl";
    features = mkFeatures (features."itoa"."0.4.4" or {});
  };
  features_.itoa."0.4.4" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.4"."std" =
        (f.itoa."0.4.4"."std" or false) ||
        (f.itoa."0.4.4".default or false) ||
        (itoa."0.4.4"."default" or false); }
      { "0.4.4".default = (f.itoa."0.4.4".default or true); }
    ];
  }) [];


# end
# lazy_static-1.4.0

  crates.lazy_static."1.4.0" = deps: { features?(features_.lazy_static."1.4.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.4.0";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "13h6sdghdcy7vcqsm2gasfw3qg7ssa0fl3sw7lq6pdkbk52wbyfr";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.4.0" or {});
  };
  features_.lazy_static."1.4.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.4.0"."spin" =
        (f.lazy_static."1.4.0"."spin" or false) ||
        (f.lazy_static."1.4.0".spin_no_std or false) ||
        (lazy_static."1.4.0"."spin_no_std" or false); }
      { "1.4.0".default = (f.lazy_static."1.4.0".default or true); }
    ];
  }) [];


# end
# libc-0.2.62

  crates.libc."0.2.62" = deps: { features?(features_.libc."0.2.62" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.62";
    description = "Raw FFI bindings to platform libraries like libc.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1vsb4pyn6gl6sri6cv5hin5wjfgk7lk2bshzmxb1xnkckjhz4gbx";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.62" or {});
  };
  features_.libc."0.2.62" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.62"."align" =
        (f.libc."0.2.62"."align" or false) ||
        (f.libc."0.2.62".rustc-dep-of-std or false) ||
        (libc."0.2.62"."rustc-dep-of-std" or false); }
      { "0.2.62"."rustc-std-workspace-core" =
        (f.libc."0.2.62"."rustc-std-workspace-core" or false) ||
        (f.libc."0.2.62".rustc-dep-of-std or false) ||
        (libc."0.2.62"."rustc-dep-of-std" or false); }
      { "0.2.62"."std" =
        (f.libc."0.2.62"."std" or false) ||
        (f.libc."0.2.62".default or false) ||
        (libc."0.2.62"."default" or false) ||
        (f.libc."0.2.62".use_std or false) ||
        (libc."0.2.62"."use_std" or false); }
      { "0.2.62".default = (f.libc."0.2.62".default or true); }
    ];
  }) [];


# end
# memchr-2.2.1

  crates.memchr."2.2.1" = deps: { features?(features_.memchr."2.2.1" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.2.1";
    description = "Safe interface to memchr.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "1mj5z8lhz6jbapslpq8a39pwcsl1p0jmgp7wgcj7nv4pcqhya7a0";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.2.1" or {});
  };
  features_.memchr."2.2.1" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.2.1"."use_std" =
        (f.memchr."2.2.1"."use_std" or false) ||
        (f.memchr."2.2.1".default or false) ||
        (memchr."2.2.1"."default" or false); }
      { "2.2.1".default = (f.memchr."2.2.1".default or true); }
    ];
  }) [];


# end
# proc-macro-error-0.2.6

  crates.proc_macro_error."0.2.6" = deps: { features?(features_.proc_macro_error."0.2.6" deps {}) }: buildRustCrate {
    crateName = "proc-macro-error";
    version = "0.2.6";
    description = "Drop-in replacement to panics in proc-macros";
    authors = [ "CreepySkeleton <creepy-skeleton@yandex.ru>" ];
    edition = "2018";
    sha256 = "0jvxpc2g64ww40179nalqhwlc906qbskdn9j58v34q3d5f6yl9wj";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."proc_macro_error"."0.2.6"."proc_macro2"}" deps)
      (crates."quote"."${deps."proc_macro_error"."0.2.6"."quote"}" deps)
      (crates."syn"."${deps."proc_macro_error"."0.2.6"."syn"}" deps)
    ]);
    features = mkFeatures (features."proc_macro_error"."0.2.6" or {});
  };
  features_.proc_macro_error."0.2.6" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.proc_macro_error."0.2.6".proc_macro2}".default = true;
    proc_macro_error."0.2.6".default = (f.proc_macro_error."0.2.6".default or true);
    quote."${deps.proc_macro_error."0.2.6".quote}".default = true;
    syn."${deps.proc_macro_error."0.2.6".syn}".default = true;
  }) [
    (features_.proc_macro2."${deps."proc_macro_error"."0.2.6"."proc_macro2"}" deps)
    (features_.quote."${deps."proc_macro_error"."0.2.6"."quote"}" deps)
    (features_.syn."${deps."proc_macro_error"."0.2.6"."syn"}" deps)
  ];


# end
# proc-macro2-0.4.30

  crates.proc_macro2."0.4.30" = deps: { features?(features_.proc_macro2."0.4.30" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.4.30";
    description = "A stable implementation of the upcoming new `proc_macro` API. Comes with an\noption, off by default, to also reimplement itself in terms of the upstream\nunstable API.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0iifv51wrm6r4r2gghw6rray3nv53zcap355bbz1nsmbhj5s09b9";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."0.4.30"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."0.4.30" or {});
  };
  features_.proc_macro2."0.4.30" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "0.4.30"."proc-macro" =
        (f.proc_macro2."0.4.30"."proc-macro" or false) ||
        (f.proc_macro2."0.4.30".default or false) ||
        (proc_macro2."0.4.30"."default" or false); }
      { "0.4.30".default = (f.proc_macro2."0.4.30".default or true); }
    ];
    unicode_xid."${deps.proc_macro2."0.4.30".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.4.30"."unicode_xid"}" deps)
  ];


# end
# proc-macro2-1.0.3

  crates.proc_macro2."1.0.3" = deps: { features?(features_.proc_macro2."1.0.3" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "1.0.3";
    description = "A stable implementation of the upcoming new `proc_macro` API. Comes with an\noption, off by default, to also reimplement itself in terms of the upstream\nunstable API.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0qv29h6pz6n0b4qi8w240l3xppsw26bk5ga2vcjk3nhji0nsplwk";
    libName = "proc_macro2";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."1.0.3"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."1.0.3" or {});
  };
  features_.proc_macro2."1.0.3" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "1.0.3"."proc-macro" =
        (f.proc_macro2."1.0.3"."proc-macro" or false) ||
        (f.proc_macro2."1.0.3".default or false) ||
        (proc_macro2."1.0.3"."default" or false); }
      { "1.0.3".default = (f.proc_macro2."1.0.3".default or true); }
    ];
    unicode_xid."${deps.proc_macro2."1.0.3".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."1.0.3"."unicode_xid"}" deps)
  ];


# end
# quote-0.6.13

  crates.quote."0.6.13" = deps: { features?(features_.quote."0.6.13" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.6.13";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1hrvsin40i4q8swrhlj9057g7nsp0lg02h8zbzmgz14av9mzv8g8";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.6.13"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.6.13" or {});
  };
  features_.quote."0.6.13" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.6.13".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.6.13".proc_macro2}"."proc-macro" or false) ||
        (quote."0.6.13"."proc-macro" or false) ||
        (f."quote"."0.6.13"."proc-macro" or false); }
      { "${deps.quote."0.6.13".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.6.13".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.6.13"."proc-macro" =
        (f.quote."0.6.13"."proc-macro" or false) ||
        (f.quote."0.6.13".default or false) ||
        (quote."0.6.13"."default" or false); }
      { "0.6.13".default = (f.quote."0.6.13".default or true); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.6.13"."proc_macro2"}" deps)
  ];


# end
# quote-1.0.2

  crates.quote."1.0.2" = deps: { features?(features_.quote."1.0.2" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "1.0.2";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "0r7030w7dymarn92gjgm02hsm04fwsfs6f1l20wdqiyrm9z8rs5q";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."1.0.2"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."1.0.2" or {});
  };
  features_.quote."1.0.2" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."1.0.2".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."1.0.2".proc_macro2}"."proc-macro" or false) ||
        (quote."1.0.2"."proc-macro" or false) ||
        (f."quote"."1.0.2"."proc-macro" or false); }
      { "${deps.quote."1.0.2".proc_macro2}".default = (f.proc_macro2."${deps.quote."1.0.2".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "1.0.2"."proc-macro" =
        (f.quote."1.0.2"."proc-macro" or false) ||
        (f.quote."1.0.2".default or false) ||
        (quote."1.0.2"."default" or false); }
      { "1.0.2".default = (f.quote."1.0.2".default or true); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."1.0.2"."proc_macro2"}" deps)
  ];


# end
# regex-1.3.1

  crates.regex."1.3.1" = deps: { features?(features_.regex."1.3.1" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.3.1";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0508b01q7iwky5gzp1cc3lpz6al1qam8skgcvkfgxr67nikiz7jn";
    dependencies = mapFeatures features ([
      (crates."regex_syntax"."${deps."regex"."1.3.1"."regex_syntax"}" deps)
    ]
      ++ (if features.regex."1.3.1".aho-corasick or false then [ (crates.aho_corasick."${deps."regex"."1.3.1".aho_corasick}" deps) ] else [])
      ++ (if features.regex."1.3.1".memchr or false then [ (crates.memchr."${deps."regex"."1.3.1".memchr}" deps) ] else [])
      ++ (if features.regex."1.3.1".thread_local or false then [ (crates.thread_local."${deps."regex"."1.3.1".thread_local}" deps) ] else []));
    features = mkFeatures (features."regex"."1.3.1" or {});
  };
  features_.regex."1.3.1" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.3.1".aho_corasick}".default = true;
    memchr."${deps.regex."1.3.1".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.3.1"."aho-corasick" =
        (f.regex."1.3.1"."aho-corasick" or false) ||
        (f.regex."1.3.1".perf-literal or false) ||
        (regex."1.3.1"."perf-literal" or false); }
      { "1.3.1"."memchr" =
        (f.regex."1.3.1"."memchr" or false) ||
        (f.regex."1.3.1".perf-literal or false) ||
        (regex."1.3.1"."perf-literal" or false); }
      { "1.3.1"."pattern" =
        (f.regex."1.3.1"."pattern" or false) ||
        (f.regex."1.3.1".unstable or false) ||
        (regex."1.3.1"."unstable" or false); }
      { "1.3.1"."perf" =
        (f.regex."1.3.1"."perf" or false) ||
        (f.regex."1.3.1".default or false) ||
        (regex."1.3.1"."default" or false); }
      { "1.3.1"."perf-cache" =
        (f.regex."1.3.1"."perf-cache" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."perf-dfa" =
        (f.regex."1.3.1"."perf-dfa" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."perf-inline" =
        (f.regex."1.3.1"."perf-inline" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."perf-literal" =
        (f.regex."1.3.1"."perf-literal" or false) ||
        (f.regex."1.3.1".perf or false) ||
        (regex."1.3.1"."perf" or false); }
      { "1.3.1"."std" =
        (f.regex."1.3.1"."std" or false) ||
        (f.regex."1.3.1".default or false) ||
        (regex."1.3.1"."default" or false) ||
        (f.regex."1.3.1".use_std or false) ||
        (regex."1.3.1"."use_std" or false); }
      { "1.3.1"."thread_local" =
        (f.regex."1.3.1"."thread_local" or false) ||
        (f.regex."1.3.1".perf-cache or false) ||
        (regex."1.3.1"."perf-cache" or false); }
      { "1.3.1"."unicode" =
        (f.regex."1.3.1"."unicode" or false) ||
        (f.regex."1.3.1".default or false) ||
        (regex."1.3.1"."default" or false); }
      { "1.3.1"."unicode-age" =
        (f.regex."1.3.1"."unicode-age" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-bool" =
        (f.regex."1.3.1"."unicode-bool" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-case" =
        (f.regex."1.3.1"."unicode-case" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-gencat" =
        (f.regex."1.3.1"."unicode-gencat" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-perl" =
        (f.regex."1.3.1"."unicode-perl" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-script" =
        (f.regex."1.3.1"."unicode-script" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1"."unicode-segment" =
        (f.regex."1.3.1"."unicode-segment" or false) ||
        (f.regex."1.3.1".unicode or false) ||
        (regex."1.3.1"."unicode" or false); }
      { "1.3.1".default = (f.regex."1.3.1".default or true); }
    ];
    regex_syntax = fold recursiveUpdate {} [
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-age" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-age" or false) ||
        (regex."1.3.1"."unicode-age" or false) ||
        (f."regex"."1.3.1"."unicode-age" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-bool" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-bool" or false) ||
        (regex."1.3.1"."unicode-bool" or false) ||
        (f."regex"."1.3.1"."unicode-bool" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-case" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-case" or false) ||
        (regex."1.3.1"."unicode-case" or false) ||
        (f."regex"."1.3.1"."unicode-case" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-gencat" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-gencat" or false) ||
        (regex."1.3.1"."unicode-gencat" or false) ||
        (f."regex"."1.3.1"."unicode-gencat" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-perl" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-perl" or false) ||
        (regex."1.3.1"."unicode-perl" or false) ||
        (f."regex"."1.3.1"."unicode-perl" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-script" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-script" or false) ||
        (regex."1.3.1"."unicode-script" or false) ||
        (f."regex"."1.3.1"."unicode-script" or false); }
      { "${deps.regex."1.3.1".regex_syntax}"."unicode-segment" =
        (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}"."unicode-segment" or false) ||
        (regex."1.3.1"."unicode-segment" or false) ||
        (f."regex"."1.3.1"."unicode-segment" or false); }
      { "${deps.regex."1.3.1".regex_syntax}".default = (f.regex_syntax."${deps.regex."1.3.1".regex_syntax}".default or false); }
    ];
    thread_local."${deps.regex."1.3.1".thread_local}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.3.1"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.3.1"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.3.1"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.3.1"."thread_local"}" deps)
  ];


# end
# regex-syntax-0.6.12

  crates.regex_syntax."0.6.12" = deps: { features?(features_.regex_syntax."0.6.12" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.6.12";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1lqhddhwzpgq8zfkxhm241n7g4m3yc11fb4098dkgawbxvybr53v";
    features = mkFeatures (features."regex_syntax"."0.6.12" or {});
  };
  features_.regex_syntax."0.6.12" = deps: f: updateFeatures f (rec {
    regex_syntax = fold recursiveUpdate {} [
      { "0.6.12"."unicode" =
        (f.regex_syntax."0.6.12"."unicode" or false) ||
        (f.regex_syntax."0.6.12".default or false) ||
        (regex_syntax."0.6.12"."default" or false); }
      { "0.6.12"."unicode-age" =
        (f.regex_syntax."0.6.12"."unicode-age" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-bool" =
        (f.regex_syntax."0.6.12"."unicode-bool" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-case" =
        (f.regex_syntax."0.6.12"."unicode-case" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-gencat" =
        (f.regex_syntax."0.6.12"."unicode-gencat" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-perl" =
        (f.regex_syntax."0.6.12"."unicode-perl" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-script" =
        (f.regex_syntax."0.6.12"."unicode-script" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12"."unicode-segment" =
        (f.regex_syntax."0.6.12"."unicode-segment" or false) ||
        (f.regex_syntax."0.6.12".unicode or false) ||
        (regex_syntax."0.6.12"."unicode" or false); }
      { "0.6.12".default = (f.regex_syntax."0.6.12".default or true); }
    ];
  }) [];


# end
# rust-stemmers-1.1.0

  crates.rust_stemmers."1.1.0" = deps: { features?(features_.rust_stemmers."1.1.0" deps {}) }: buildRustCrate {
    crateName = "rust-stemmers";
    version = "1.1.0";
    description = "A rust implementation of some popular snowball stemming algorithms";
    authors = [ "Jakob Demler <jdemler@curry-software.com>" "CurrySoftware <info@curry-software.com>" ];
    sha256 = "1slxrh81fa3qxwvrspxsvpzsbdn6xbgcg7aqjq9jfsv6vyv8ri3b";
    dependencies = mapFeatures features ([
      (crates."serde"."${deps."rust_stemmers"."1.1.0"."serde"}" deps)
      (crates."serde_derive"."${deps."rust_stemmers"."1.1.0"."serde_derive"}" deps)
    ]);
  };
  features_.rust_stemmers."1.1.0" = deps: f: updateFeatures f (rec {
    rust_stemmers."1.1.0".default = (f.rust_stemmers."1.1.0".default or true);
    serde."${deps.rust_stemmers."1.1.0".serde}".default = true;
    serde_derive."${deps.rust_stemmers."1.1.0".serde_derive}".default = true;
  }) [
    (features_.serde."${deps."rust_stemmers"."1.1.0"."serde"}" deps)
    (features_.serde_derive."${deps."rust_stemmers"."1.1.0"."serde_derive"}" deps)
  ];


# end
# ryu-1.0.0

  crates.ryu."1.0.0" = deps: { features?(features_.ryu."1.0.0" deps {}) }: buildRustCrate {
    crateName = "ryu";
    version = "1.0.0";
    description = "Fast floating point to string conversion";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0hysqba7hi31xw1jka8jh7qb4m9fx5l6vik55wpc3rpsg46cwgbf";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ryu"."1.0.0" or {});
  };
  features_.ryu."1.0.0" = deps: f: updateFeatures f (rec {
    ryu."1.0.0".default = (f.ryu."1.0.0".default or true);
  }) [];


# end
# serde-1.0.101

  crates.serde."1.0.101" = deps: { features?(features_.serde."1.0.101" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.101";
    description = "A generic serialization/deserialization framework";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0sacv3njx99yr8gxsl80cy1h98b9vd1pv6aa8ncbnk0pys8r82vn";
    build = "build.rs";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.serde."1.0.101".serde_derive or false then [ (crates.serde_derive."${deps."serde"."1.0.101".serde_derive}" deps) ] else []));
    features = mkFeatures (features."serde"."1.0.101" or {});
  };
  features_.serde."1.0.101" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.101"."serde_derive" =
        (f.serde."1.0.101"."serde_derive" or false) ||
        (f.serde."1.0.101".derive or false) ||
        (serde."1.0.101"."derive" or false); }
      { "1.0.101"."std" =
        (f.serde."1.0.101"."std" or false) ||
        (f.serde."1.0.101".default or false) ||
        (serde."1.0.101"."default" or false); }
      { "1.0.101".default = (f.serde."1.0.101".default or true); }
    ];
    serde_derive."${deps.serde."1.0.101".serde_derive}".default = true;
  }) [
    (features_.serde_derive."${deps."serde"."1.0.101"."serde_derive"}" deps)
  ];


# end
# serde_derive-1.0.101

  crates.serde_derive."1.0.101" = deps: { features?(features_.serde_derive."1.0.101" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.101";
    description = "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "093x99qff1ihjmy32fp1gxp66qh0nni349j20y3w0h33wqk19dr0";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.101"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.101"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.101"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.101" or {});
  };
  features_.serde_derive."1.0.101" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.101".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.101".quote}".default = true;
    serde_derive."1.0.101".default = (f.serde_derive."1.0.101".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.101".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.101".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.101"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.101"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.101"."syn"}" deps)
  ];


# end
# serde_json-1.0.40

  crates.serde_json."1.0.40" = deps: { features?(features_.serde_json."1.0.40" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.40";
    description = "A JSON serialization file format";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1wf8lkisjvyg4ghp2fwm3ysymjy66l030l8d7p6033wiayfzpyh3";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.40"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.40"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.40"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.40" or {});
  };
  features_.serde_json."1.0.40" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.40".itoa}".default = true;
    ryu."${deps.serde_json."1.0.40".ryu}".default = true;
    serde."${deps.serde_json."1.0.40".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.40"."indexmap" =
        (f.serde_json."1.0.40"."indexmap" or false) ||
        (f.serde_json."1.0.40".preserve_order or false) ||
        (serde_json."1.0.40"."preserve_order" or false); }
      { "1.0.40".default = (f.serde_json."1.0.40".default or true); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.40"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.40"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.40"."serde"}" deps)
  ];


# end
# strsim-0.8.0

  crates.strsim."0.8.0" = deps: { features?(features_.strsim."0.8.0" deps {}) }: buildRustCrate {
    crateName = "strsim";
    version = "0.8.0";
    description = "Implementations of string similarity metrics.\nIncludes Hamming, Levenshtein, OSA, Damerau-Levenshtein, Jaro, and Jaro-Winkler.\n";
    authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
    sha256 = "0d3jsdz22wgjyxdakqnvdgmwjdvkximz50d9zfk4qlalw635qcvy";
  };
  features_.strsim."0.8.0" = deps: f: updateFeatures f (rec {
    strsim."0.8.0".default = (f.strsim."0.8.0".default or true);
  }) [];


# end
# structopt-0.3.1

  crates.structopt."0.3.1" = deps: { features?(features_.structopt."0.3.1" deps {}) }: buildRustCrate {
    crateName = "structopt";
    version = "0.3.1";
    description = "Parse command line argument by defining a struct.";
    authors = [ "Guillaume Pinot <texitoi@texitoi.eu>" "others" ];
    edition = "2018";
    sha256 = "0dc55l2lzihlq7978pxi1m1f5fcad6v5ffkci6vvj0668jn57grz";
    dependencies = mapFeatures features ([
      (crates."clap"."${deps."structopt"."0.3.1"."clap"}" deps)
      (crates."structopt_derive"."${deps."structopt"."0.3.1"."structopt_derive"}" deps)
    ]);
    features = mkFeatures (features."structopt"."0.3.1" or {});
  };
  features_.structopt."0.3.1" = deps: f: updateFeatures f (rec {
    clap = fold recursiveUpdate {} [
      { "${deps.structopt."0.3.1".clap}"."color" =
        (f.clap."${deps.structopt."0.3.1".clap}"."color" or false) ||
        (structopt."0.3.1"."color" or false) ||
        (f."structopt"."0.3.1"."color" or false); }
      { "${deps.structopt."0.3.1".clap}"."debug" =
        (f.clap."${deps.structopt."0.3.1".clap}"."debug" or false) ||
        (structopt."0.3.1"."debug" or false) ||
        (f."structopt"."0.3.1"."debug" or false); }
      { "${deps.structopt."0.3.1".clap}"."default" =
        (f.clap."${deps.structopt."0.3.1".clap}"."default" or false) ||
        (structopt."0.3.1"."default" or false) ||
        (f."structopt"."0.3.1"."default" or false); }
      { "${deps.structopt."0.3.1".clap}"."doc" =
        (f.clap."${deps.structopt."0.3.1".clap}"."doc" or false) ||
        (structopt."0.3.1"."doc" or false) ||
        (f."structopt"."0.3.1"."doc" or false); }
      { "${deps.structopt."0.3.1".clap}"."lints" =
        (f.clap."${deps.structopt."0.3.1".clap}"."lints" or false) ||
        (structopt."0.3.1"."lints" or false) ||
        (f."structopt"."0.3.1"."lints" or false); }
      { "${deps.structopt."0.3.1".clap}"."no_cargo" =
        (f.clap."${deps.structopt."0.3.1".clap}"."no_cargo" or false) ||
        (structopt."0.3.1"."no_cargo" or false) ||
        (f."structopt"."0.3.1"."no_cargo" or false); }
      { "${deps.structopt."0.3.1".clap}"."suggestions" =
        (f.clap."${deps.structopt."0.3.1".clap}"."suggestions" or false) ||
        (structopt."0.3.1"."suggestions" or false) ||
        (f."structopt"."0.3.1"."suggestions" or false); }
      { "${deps.structopt."0.3.1".clap}"."wrap_help" =
        (f.clap."${deps.structopt."0.3.1".clap}"."wrap_help" or false) ||
        (structopt."0.3.1"."wrap_help" or false) ||
        (f."structopt"."0.3.1"."wrap_help" or false); }
      { "${deps.structopt."0.3.1".clap}"."yaml" =
        (f.clap."${deps.structopt."0.3.1".clap}"."yaml" or false) ||
        (structopt."0.3.1"."yaml" or false) ||
        (f."structopt"."0.3.1"."yaml" or false); }
      { "${deps.structopt."0.3.1".clap}".default = (f.clap."${deps.structopt."0.3.1".clap}".default or false); }
    ];
    structopt."0.3.1".default = (f.structopt."0.3.1".default or true);
    structopt_derive = fold recursiveUpdate {} [
      { "${deps.structopt."0.3.1".structopt_derive}"."paw" =
        (f.structopt_derive."${deps.structopt."0.3.1".structopt_derive}"."paw" or false) ||
        (structopt."0.3.1"."paw" or false) ||
        (f."structopt"."0.3.1"."paw" or false); }
      { "${deps.structopt."0.3.1".structopt_derive}".default = true; }
    ];
  }) [
    (features_.clap."${deps."structopt"."0.3.1"."clap"}" deps)
    (features_.structopt_derive."${deps."structopt"."0.3.1"."structopt_derive"}" deps)
  ];


# end
# structopt-derive-0.3.1

  crates.structopt_derive."0.3.1" = deps: { features?(features_.structopt_derive."0.3.1" deps {}) }: buildRustCrate {
    crateName = "structopt-derive";
    version = "0.3.1";
    description = "Parse command line argument by defining a struct, derive crate.";
    authors = [ "Guillaume Pinot <texitoi@texitoi.eu>" ];
    edition = "2018";
    sha256 = "1pmaj5qz4dxiizaanbirk6a7w2zl5b5j0hn5gywrlrhwlyjll8hz";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."heck"."${deps."structopt_derive"."0.3.1"."heck"}" deps)
      (crates."proc_macro_error"."${deps."structopt_derive"."0.3.1"."proc_macro_error"}" deps)
      (crates."proc_macro2"."${deps."structopt_derive"."0.3.1"."proc_macro2"}" deps)
      (crates."quote"."${deps."structopt_derive"."0.3.1"."quote"}" deps)
      (crates."syn"."${deps."structopt_derive"."0.3.1"."syn"}" deps)
    ]);
    features = mkFeatures (features."structopt_derive"."0.3.1" or {});
  };
  features_.structopt_derive."0.3.1" = deps: f: updateFeatures f (rec {
    heck."${deps.structopt_derive."0.3.1".heck}".default = true;
    proc_macro2."${deps.structopt_derive."0.3.1".proc_macro2}".default = true;
    proc_macro_error."${deps.structopt_derive."0.3.1".proc_macro_error}".default = true;
    quote."${deps.structopt_derive."0.3.1".quote}".default = true;
    structopt_derive."0.3.1".default = (f.structopt_derive."0.3.1".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.structopt_derive."0.3.1".syn}"."full" = true; }
      { "${deps.structopt_derive."0.3.1".syn}".default = true; }
    ];
  }) [
    (features_.heck."${deps."structopt_derive"."0.3.1"."heck"}" deps)
    (features_.proc_macro_error."${deps."structopt_derive"."0.3.1"."proc_macro_error"}" deps)
    (features_.proc_macro2."${deps."structopt_derive"."0.3.1"."proc_macro2"}" deps)
    (features_.quote."${deps."structopt_derive"."0.3.1"."quote"}" deps)
    (features_.syn."${deps."structopt_derive"."0.3.1"."syn"}" deps)
  ];


# end
# strum-0.15.0

  crates.strum."0.15.0" = deps: { features?(features_.strum."0.15.0" deps {}) }: buildRustCrate {
    crateName = "strum";
    version = "0.15.0";
    description = "Helpful macros for working with enums and strings";
    authors = [ "Peter Glotfelty <peglotfe@microsoft.com>" ];
    sha256 = "09xk2knmfxmwsgh302dcv3znm3rlj87zyb5xv5blki3053qbdbz8";
  };
  features_.strum."0.15.0" = deps: f: updateFeatures f (rec {
    strum."0.15.0".default = (f.strum."0.15.0".default or true);
  }) [];


# end
# strum_macros-0.15.0

  crates.strum_macros."0.15.0" = deps: { features?(features_.strum_macros."0.15.0" deps {}) }: buildRustCrate {
    crateName = "strum_macros";
    version = "0.15.0";
    description = "Helpful macros for working with enums and strings";
    authors = [ "Peter Glotfelty <peglotfe@microsoft.com>" ];
    sha256 = "1wfqcbkkqf541rxswp780d136bvyhg3b829gia570096fkm534sf";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."heck"."${deps."strum_macros"."0.15.0"."heck"}" deps)
      (crates."proc_macro2"."${deps."strum_macros"."0.15.0"."proc_macro2"}" deps)
      (crates."quote"."${deps."strum_macros"."0.15.0"."quote"}" deps)
      (crates."syn"."${deps."strum_macros"."0.15.0"."syn"}" deps)
    ]);
    features = mkFeatures (features."strum_macros"."0.15.0" or {});
  };
  features_.strum_macros."0.15.0" = deps: f: updateFeatures f (rec {
    heck."${deps.strum_macros."0.15.0".heck}".default = true;
    proc_macro2."${deps.strum_macros."0.15.0".proc_macro2}".default = true;
    quote."${deps.strum_macros."0.15.0".quote}".default = true;
    strum_macros."0.15.0".default = (f.strum_macros."0.15.0".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.strum_macros."0.15.0".syn}"."extra-traits" = true; }
      { "${deps.strum_macros."0.15.0".syn}"."parsing" = true; }
      { "${deps.strum_macros."0.15.0".syn}".default = true; }
    ];
  }) [
    (features_.heck."${deps."strum_macros"."0.15.0"."heck"}" deps)
    (features_.proc_macro2."${deps."strum_macros"."0.15.0"."proc_macro2"}" deps)
    (features_.quote."${deps."strum_macros"."0.15.0"."quote"}" deps)
    (features_.syn."${deps."strum_macros"."0.15.0"."syn"}" deps)
  ];


# end
# syn-0.15.44

  crates.syn."0.15.44" = deps: { features?(features_.syn."0.15.44" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.15.44";
    description = "Parser for Rust source code";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "09v11h141grmsnamd5j14mn8vpnfng6p60kdmsm8akz9m0qn7s1n";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.15.44"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.15.44"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.15.44".quote or false then [ (crates.quote."${deps."syn"."0.15.44".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.15.44" or {});
  };
  features_.syn."0.15.44" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.15.44".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.15.44".proc_macro2}"."proc-macro" or false) ||
        (syn."0.15.44"."proc-macro" or false) ||
        (f."syn"."0.15.44"."proc-macro" or false); }
      { "${deps.syn."0.15.44".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.15.44".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.15.44".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.15.44".quote}"."proc-macro" or false) ||
        (syn."0.15.44"."proc-macro" or false) ||
        (f."syn"."0.15.44"."proc-macro" or false); }
      { "${deps.syn."0.15.44".quote}".default = (f.quote."${deps.syn."0.15.44".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.15.44"."clone-impls" =
        (f.syn."0.15.44"."clone-impls" or false) ||
        (f.syn."0.15.44".default or false) ||
        (syn."0.15.44"."default" or false); }
      { "0.15.44"."derive" =
        (f.syn."0.15.44"."derive" or false) ||
        (f.syn."0.15.44".default or false) ||
        (syn."0.15.44"."default" or false); }
      { "0.15.44"."parsing" =
        (f.syn."0.15.44"."parsing" or false) ||
        (f.syn."0.15.44".default or false) ||
        (syn."0.15.44"."default" or false); }
      { "0.15.44"."printing" =
        (f.syn."0.15.44"."printing" or false) ||
        (f.syn."0.15.44".default or false) ||
        (syn."0.15.44"."default" or false); }
      { "0.15.44"."proc-macro" =
        (f.syn."0.15.44"."proc-macro" or false) ||
        (f.syn."0.15.44".default or false) ||
        (syn."0.15.44"."default" or false); }
      { "0.15.44"."quote" =
        (f.syn."0.15.44"."quote" or false) ||
        (f.syn."0.15.44".printing or false) ||
        (syn."0.15.44"."printing" or false); }
      { "0.15.44".default = (f.syn."0.15.44".default or true); }
    ];
    unicode_xid."${deps.syn."0.15.44".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.15.44"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.15.44"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.15.44"."unicode_xid"}" deps)
  ];


# end
# syn-1.0.5

  crates.syn."1.0.5" = deps: { features?(features_.syn."1.0.5" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "1.0.5";
    description = "Parser for Rust source code";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "08qbk425r8c4q4rrpq1q9wkd3v3bji8nlfaxj8v4l7lkpjkh0xgs";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."1.0.5"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."1.0.5"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."1.0.5".quote or false then [ (crates.quote."${deps."syn"."1.0.5".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."1.0.5" or {});
  };
  features_.syn."1.0.5" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."1.0.5".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."1.0.5".proc_macro2}"."proc-macro" or false) ||
        (syn."1.0.5"."proc-macro" or false) ||
        (f."syn"."1.0.5"."proc-macro" or false); }
      { "${deps.syn."1.0.5".proc_macro2}".default = (f.proc_macro2."${deps.syn."1.0.5".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."1.0.5".quote}"."proc-macro" =
        (f.quote."${deps.syn."1.0.5".quote}"."proc-macro" or false) ||
        (syn."1.0.5"."proc-macro" or false) ||
        (f."syn"."1.0.5"."proc-macro" or false); }
      { "${deps.syn."1.0.5".quote}".default = (f.quote."${deps.syn."1.0.5".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "1.0.5"."clone-impls" =
        (f.syn."1.0.5"."clone-impls" or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5"."derive" =
        (f.syn."1.0.5"."derive" or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5"."parsing" =
        (f.syn."1.0.5"."parsing" or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5"."printing" =
        (f.syn."1.0.5"."printing" or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5"."proc-macro" =
        (f.syn."1.0.5"."proc-macro" or false) ||
        (f.syn."1.0.5".default or false) ||
        (syn."1.0.5"."default" or false); }
      { "1.0.5"."quote" =
        (f.syn."1.0.5"."quote" or false) ||
        (f.syn."1.0.5".printing or false) ||
        (syn."1.0.5"."printing" or false); }
      { "1.0.5".default = (f.syn."1.0.5".default or true); }
    ];
    unicode_xid."${deps.syn."1.0.5".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."1.0.5"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."1.0.5"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."1.0.5"."unicode_xid"}" deps)
  ];


# end
# textwrap-0.11.0

  crates.textwrap."0.11.0" = deps: { features?(features_.textwrap."0.11.0" deps {}) }: buildRustCrate {
    crateName = "textwrap";
    version = "0.11.0";
    description = "Textwrap is a small library for word wrapping, indenting, and\ndedenting strings.\n\nYou can use it to format strings (such as help and error messages) for\ndisplay in commandline applications. It is designed to be efficient\nand handle Unicode characters correctly.\n";
    authors = [ "Martin Geisler <martin@geisler.net>" ];
    sha256 = "0s25qh49n7kjayrdj4q3v0jk0jc6vy88rdw0bvgfxqlscpqpxi7d";
    dependencies = mapFeatures features ([
      (crates."unicode_width"."${deps."textwrap"."0.11.0"."unicode_width"}" deps)
    ]);
  };
  features_.textwrap."0.11.0" = deps: f: updateFeatures f (rec {
    textwrap."0.11.0".default = (f.textwrap."0.11.0".default or true);
    unicode_width."${deps.textwrap."0.11.0".unicode_width}".default = true;
  }) [
    (features_.unicode_width."${deps."textwrap"."0.11.0"."unicode_width"}" deps)
  ];


# end
# thread_local-0.3.6

  crates.thread_local."0.3.6" = deps: { features?(features_.thread_local."0.3.6" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.6";
    description = "Per-object thread-local storage";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "02rksdwjmz2pw9bmgbb4c0bgkbq5z6nvg510sq1s6y2j1gam0c7i";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
    ]);
  };
  features_.thread_local."0.3.6" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.thread_local."0.3.6".lazy_static}".default = true;
    thread_local."0.3.6".default = (f.thread_local."0.3.6".default or true);
  }) [
    (features_.lazy_static."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
  ];


# end
# unicode-segmentation-1.3.0

  crates.unicode_segmentation."1.3.0" = deps: { features?(features_.unicode_segmentation."1.3.0" deps {}) }: buildRustCrate {
    crateName = "unicode-segmentation";
    version = "1.3.0";
    description = "This crate provides Grapheme Cluster, Word and Sentence boundaries\naccording to Unicode Standard Annex #29 rules.\n";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0jnns99wpjjpqzdn9jiplsr003rr41i95c008jb4inccb3avypp0";
    features = mkFeatures (features."unicode_segmentation"."1.3.0" or {});
  };
  features_.unicode_segmentation."1.3.0" = deps: f: updateFeatures f (rec {
    unicode_segmentation."1.3.0".default = (f.unicode_segmentation."1.3.0".default or true);
  }) [];


# end
# unicode-width-0.1.6

  crates.unicode_width."0.1.6" = deps: { features?(features_.unicode_width."0.1.6" deps {}) }: buildRustCrate {
    crateName = "unicode-width";
    version = "0.1.6";
    description = "Determine displayed width of `char` and `str` types\naccording to Unicode Standard Annex #11 rules.\n";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "1mss965j7d8pv7z7zg6qfkcb7lyhxkxvbh8akzr4xxxx3vzazwsi";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."unicode_width"."0.1.6" or {});
  };
  features_.unicode_width."0.1.6" = deps: f: updateFeatures f (rec {
    unicode_width = fold recursiveUpdate {} [
      { "0.1.6"."compiler_builtins" =
        (f.unicode_width."0.1.6"."compiler_builtins" or false) ||
        (f.unicode_width."0.1.6".rustc-dep-of-std or false) ||
        (unicode_width."0.1.6"."rustc-dep-of-std" or false); }
      { "0.1.6"."core" =
        (f.unicode_width."0.1.6"."core" or false) ||
        (f.unicode_width."0.1.6".rustc-dep-of-std or false) ||
        (unicode_width."0.1.6"."rustc-dep-of-std" or false); }
      { "0.1.6"."std" =
        (f.unicode_width."0.1.6"."std" or false) ||
        (f.unicode_width."0.1.6".rustc-dep-of-std or false) ||
        (unicode_width."0.1.6"."rustc-dep-of-std" or false); }
      { "0.1.6".default = (f.unicode_width."0.1.6".default or true); }
    ];
  }) [];


# end
# unicode-xid-0.1.0

  crates.unicode_xid."0.1.0" = deps: { features?(features_.unicode_xid."0.1.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.1.0";
    description = "Determine whether characters have the XID_Start\nor XID_Continue properties according to\nUnicode Standard Annex #31.\n";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "05wdmwlfzxhq3nhsxn6wx4q8dhxzzfb9szsz6wiw092m1rjj01zj";
    features = mkFeatures (features."unicode_xid"."0.1.0" or {});
  };
  features_.unicode_xid."0.1.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.1.0".default = (f.unicode_xid."0.1.0".default or true);
  }) [];


# end
# unicode-xid-0.2.0

  crates.unicode_xid."0.2.0" = deps: { features?(features_.unicode_xid."0.2.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.2.0";
    description = "Determine whether characters have the XID_Start\nor XID_Continue properties according to\nUnicode Standard Annex #31.\n";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1c85gb3p3qhbjvfyjb31m06la4f024jx319k10ig7n47dz2fk8v7";
    features = mkFeatures (features."unicode_xid"."0.2.0" or {});
  };
  features_.unicode_xid."0.2.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.2.0".default = (f.unicode_xid."0.2.0".default or true);
  }) [];


# end
# vec_map-0.8.1

  crates.vec_map."0.8.1" = deps: { features?(features_.vec_map."0.8.1" deps {}) }: buildRustCrate {
    crateName = "vec_map";
    version = "0.8.1";
    description = "A simple map based on a vector for small integer keys";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Jorge Aparicio <japaricious@gmail.com>" "Alexis Beingessner <a.beingessner@gmail.com>" "Brian Anderson <>" "tbu- <>" "Manish Goregaokar <>" "Aaron Turon <aturon@mozilla.com>" "Adolfo Ochagavía <>" "Niko Matsakis <>" "Steven Fackler <>" "Chase Southwood <csouth3@illinois.edu>" "Eduard Burtescu <>" "Florian Wilkens <>" "Félix Raimundo <>" "Tibor Benke <>" "Markus Siemens <markus@m-siemens.de>" "Josh Branchaud <jbranchaud@gmail.com>" "Huon Wilson <dbau.pp@gmail.com>" "Corey Farwell <coref@rwell.org>" "Aaron Liblong <>" "Nick Cameron <nrc@ncameron.org>" "Patrick Walton <pcwalton@mimiga.net>" "Felix S Klock II <>" "Andrew Paseltiner <apaseltiner@gmail.com>" "Sean McArthur <sean.monstar@gmail.com>" "Vadim Petrochenkov <>" ];
    sha256 = "1jj2nrg8h3l53d43rwkpkikq5a5x15ms4rf1rw92hp5lrqhi8mpi";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."vec_map"."0.8.1" or {});
  };
  features_.vec_map."0.8.1" = deps: f: updateFeatures f (rec {
    vec_map = fold recursiveUpdate {} [
      { "0.8.1"."serde" =
        (f.vec_map."0.8.1"."serde" or false) ||
        (f.vec_map."0.8.1".eders or false) ||
        (vec_map."0.8.1"."eders" or false); }
      { "0.8.1".default = (f.vec_map."0.8.1".default or true); }
    ];
  }) [];


# end
# winapi-0.3.8

  crates.winapi."0.3.8" = deps: { features?(features_.winapi."0.3.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.8";
    description = "Raw FFI bindings for all of Windows API.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "084ialbgww1vxry341fmkg5crgpvab3w52ahx1wa54yqjgym0vxs";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.8"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.8"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.8" or {});
  };
  features_.winapi."0.3.8" = deps: f: updateFeatures f (rec {
    winapi = fold recursiveUpdate {} [
      { "0.3.8"."impl-debug" =
        (f.winapi."0.3.8"."impl-debug" or false) ||
        (f.winapi."0.3.8".debug or false) ||
        (winapi."0.3.8"."debug" or false); }
      { "0.3.8".default = (f.winapi."0.3.8".default or true); }
    ];
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.8".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.8".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_x86_64_pc_windows_gnu"}" deps)
  ];


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
  features_.winapi_i686_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
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
  features_.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
    winapi_x86_64_pc_windows_gnu."0.4.0".default = (f.winapi_x86_64_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# xml-rs-0.8.0

  crates.xml_rs."0.8.0" = deps: { features?(features_.xml_rs."0.8.0" deps {}) }: buildRustCrate {
    crateName = "xml-rs";
    version = "0.8.0";
    description = "An XML library in pure Rust";
    authors = [ "Vladimir Matveev <vladimir.matweev@gmail.com>" ];
    sha256 = "1l3g4wmbz611jwx2a1ni4jyj0ffnls3s7a7rbdn6c763k85k7zs5";
    libPath = "src/lib.rs";
    libName = "xml";
    crateBin =
      [{  name = "xml-analyze";  path = "src/analyze.rs"; }];
  };
  features_.xml_rs."0.8.0" = deps: f: updateFeatures f (rec {
    xml_rs."0.8.0".default = (f.xml_rs."0.8.0".default or true);
  }) [];


# end
}

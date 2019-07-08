{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.7.4

  crates.aho_corasick."0.7.4" = deps: { features?(features_.aho_corasick."0.7.4" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.7.4";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1njpvqirz7rpbc7w07a5w5fk294w23zks28d89g46mr57j6pffy5";
    libName = "aho_corasick";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.7.4"."memchr"}" deps)
    ]);
    features = mkFeatures (features."aho_corasick"."0.7.4" or {});
  };
  features_.aho_corasick."0.7.4" = deps: f: updateFeatures f (rec {
    aho_corasick = fold recursiveUpdate {} [
      { "0.7.4".default = (f.aho_corasick."0.7.4".default or true); }
      { "0.7.4".std =
        (f.aho_corasick."0.7.4".std or false) ||
        (f.aho_corasick."0.7.4".default or false) ||
        (aho_corasick."0.7.4"."default" or false); }
    ];
    memchr = fold recursiveUpdate {} [
      { "${deps.aho_corasick."0.7.4".memchr}"."use_std" =
        (f.memchr."${deps.aho_corasick."0.7.4".memchr}"."use_std" or false) ||
        (aho_corasick."0.7.4"."std" or false) ||
        (f."aho_corasick"."0.7.4"."std" or false); }
      { "${deps.aho_corasick."0.7.4".memchr}".default = (f.memchr."${deps.aho_corasick."0.7.4".memchr}".default or false); }
    ];
  }) [
    (features_.memchr."${deps."aho_corasick"."0.7.4"."memchr"}" deps)
  ];


# end
# docbook-index-0.1.2

  crates.docbook_index."0.1.2" = deps: { features?(features_.docbook_index."0.1.2" deps {}) }: buildRustCrate {
    crateName = "docbook-index";
    version = "0.1.2";
    authors = [ "Graham Christensen <graham@grahamc.com>" ];
    edition = "2018";
    sha256 = "1iy8gjavq589rc2ccgavzjhvib7d8xkwm95rbii4jgf7ll1c23r3";
    dependencies = mapFeatures features ([
      (crates."elasticlunr_rs"."${deps."docbook_index"."0.1.2"."elasticlunr_rs"}" deps)
      (crates."glob"."${deps."docbook_index"."0.1.2"."glob"}" deps)
      (crates."xml_rs"."${deps."docbook_index"."0.1.2"."xml_rs"}" deps)
    ]);
  };
  features_.docbook_index."0.1.2" = deps: f: updateFeatures f (rec {
    docbook_index."0.1.2".default = (f.docbook_index."0.1.2".default or true);
    elasticlunr_rs."${deps.docbook_index."0.1.2".elasticlunr_rs}".default = true;
    glob."${deps.docbook_index."0.1.2".glob}".default = true;
    xml_rs."${deps.docbook_index."0.1.2".xml_rs}".default = true;
  }) [
    (features_.elasticlunr_rs."${deps."docbook_index"."0.1.2"."elasticlunr_rs"}" deps)
    (features_.glob."${deps."docbook_index"."0.1.2"."glob"}" deps)
    (features_.xml_rs."${deps."docbook_index"."0.1.2"."xml_rs"}" deps)
  ];


# end
# elasticlunr-rs-2.3.5

  crates.elasticlunr_rs."2.3.5" = deps: { features?(features_.elasticlunr_rs."2.3.5" deps {}) }: buildRustCrate {
    crateName = "elasticlunr-rs";
    version = "2.3.5";
    authors = [ "Matt Ickstadt <mattico8@gmail.com>" ];
    sha256 = "1yk1vwnjnwnbrqa0hbbsjwm34wm25ffnnnzp4a9lfpspmyyc4vc8";
    libName = "elasticlunr";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."elasticlunr_rs"."2.3.5"."lazy_static"}" deps)
      (crates."regex"."${deps."elasticlunr_rs"."2.3.5"."regex"}" deps)
      (crates."serde"."${deps."elasticlunr_rs"."2.3.5"."serde"}" deps)
      (crates."serde_derive"."${deps."elasticlunr_rs"."2.3.5"."serde_derive"}" deps)
      (crates."serde_json"."${deps."elasticlunr_rs"."2.3.5"."serde_json"}" deps)
      (crates."strum"."${deps."elasticlunr_rs"."2.3.5"."strum"}" deps)
      (crates."strum_macros"."${deps."elasticlunr_rs"."2.3.5"."strum_macros"}" deps)
    ]
      ++ (if features.elasticlunr_rs."2.3.5".rust-stemmers or false then [ (crates.rust_stemmers."${deps."elasticlunr_rs"."2.3.5".rust_stemmers}" deps) ] else []));
    features = mkFeatures (features."elasticlunr_rs"."2.3.5" or {});
  };
  features_.elasticlunr_rs."2.3.5" = deps: f: updateFeatures f (rec {
    elasticlunr_rs = fold recursiveUpdate {} [
      { "2.3.5".bench =
        (f.elasticlunr_rs."2.3.5".bench or false) ||
        (f.elasticlunr_rs."2.3.5".nightly or false) ||
        (elasticlunr_rs."2.3.5"."nightly" or false); }
      { "2.3.5".da =
        (f.elasticlunr_rs."2.3.5".da or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".de =
        (f.elasticlunr_rs."2.3.5".de or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".default = (f.elasticlunr_rs."2.3.5".default or true); }
      { "2.3.5".du =
        (f.elasticlunr_rs."2.3.5".du or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".es =
        (f.elasticlunr_rs."2.3.5".es or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".fi =
        (f.elasticlunr_rs."2.3.5".fi or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".fr =
        (f.elasticlunr_rs."2.3.5".fr or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".it =
        (f.elasticlunr_rs."2.3.5".it or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".languages =
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (f.elasticlunr_rs."2.3.5".default or false) ||
        (elasticlunr_rs."2.3.5"."default" or false); }
      { "2.3.5".pt =
        (f.elasticlunr_rs."2.3.5".pt or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".ro =
        (f.elasticlunr_rs."2.3.5".ro or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".ru =
        (f.elasticlunr_rs."2.3.5".ru or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".rust-stemmers =
        (f.elasticlunr_rs."2.3.5".rust-stemmers or false) ||
        (f.elasticlunr_rs."2.3.5".da or false) ||
        (elasticlunr_rs."2.3.5"."da" or false) ||
        (f.elasticlunr_rs."2.3.5".de or false) ||
        (elasticlunr_rs."2.3.5"."de" or false) ||
        (f.elasticlunr_rs."2.3.5".du or false) ||
        (elasticlunr_rs."2.3.5"."du" or false) ||
        (f.elasticlunr_rs."2.3.5".es or false) ||
        (elasticlunr_rs."2.3.5"."es" or false) ||
        (f.elasticlunr_rs."2.3.5".fi or false) ||
        (elasticlunr_rs."2.3.5"."fi" or false) ||
        (f.elasticlunr_rs."2.3.5".fr or false) ||
        (elasticlunr_rs."2.3.5"."fr" or false) ||
        (f.elasticlunr_rs."2.3.5".it or false) ||
        (elasticlunr_rs."2.3.5"."it" or false) ||
        (f.elasticlunr_rs."2.3.5".pt or false) ||
        (elasticlunr_rs."2.3.5"."pt" or false) ||
        (f.elasticlunr_rs."2.3.5".ro or false) ||
        (elasticlunr_rs."2.3.5"."ro" or false) ||
        (f.elasticlunr_rs."2.3.5".ru or false) ||
        (elasticlunr_rs."2.3.5"."ru" or false) ||
        (f.elasticlunr_rs."2.3.5".sv or false) ||
        (elasticlunr_rs."2.3.5"."sv" or false) ||
        (f.elasticlunr_rs."2.3.5".tr or false) ||
        (elasticlunr_rs."2.3.5"."tr" or false); }
      { "2.3.5".sv =
        (f.elasticlunr_rs."2.3.5".sv or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
      { "2.3.5".tr =
        (f.elasticlunr_rs."2.3.5".tr or false) ||
        (f.elasticlunr_rs."2.3.5".languages or false) ||
        (elasticlunr_rs."2.3.5"."languages" or false); }
    ];
    lazy_static."${deps.elasticlunr_rs."2.3.5".lazy_static}".default = true;
    regex."${deps.elasticlunr_rs."2.3.5".regex}".default = true;
    rust_stemmers."${deps.elasticlunr_rs."2.3.5".rust_stemmers}".default = true;
    serde."${deps.elasticlunr_rs."2.3.5".serde}".default = true;
    serde_derive."${deps.elasticlunr_rs."2.3.5".serde_derive}".default = true;
    serde_json."${deps.elasticlunr_rs."2.3.5".serde_json}".default = true;
    strum."${deps.elasticlunr_rs."2.3.5".strum}".default = true;
    strum_macros."${deps.elasticlunr_rs."2.3.5".strum_macros}".default = true;
  }) [
    (features_.lazy_static."${deps."elasticlunr_rs"."2.3.5"."lazy_static"}" deps)
    (features_.regex."${deps."elasticlunr_rs"."2.3.5"."regex"}" deps)
    (features_.rust_stemmers."${deps."elasticlunr_rs"."2.3.5"."rust_stemmers"}" deps)
    (features_.serde."${deps."elasticlunr_rs"."2.3.5"."serde"}" deps)
    (features_.serde_derive."${deps."elasticlunr_rs"."2.3.5"."serde_derive"}" deps)
    (features_.serde_json."${deps."elasticlunr_rs"."2.3.5"."serde_json"}" deps)
    (features_.strum."${deps."elasticlunr_rs"."2.3.5"."strum"}" deps)
    (features_.strum_macros."${deps."elasticlunr_rs"."2.3.5"."strum_macros"}" deps)
  ];


# end
# glob-0.3.0

  crates.glob."0.3.0" = deps: { features?(features_.glob."0.3.0" deps {}) }: buildRustCrate {
    crateName = "glob";
    version = "0.3.0";
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
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1fqc34xzzl2spfdawxd9awhzl0fwf1y6y4i94l8bq8rfrzd90awl";
    features = mkFeatures (features."itoa"."0.4.4" or {});
  };
  features_.itoa."0.4.4" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.4".default = (f.itoa."0.4.4".default or true); }
      { "0.4.4".std =
        (f.itoa."0.4.4".std or false) ||
        (f.itoa."0.4.4".default or false) ||
        (itoa."0.4.4"."default" or false); }
    ];
  }) [];


# end
# lazy_static-1.3.0

  crates.lazy_static."1.3.0" = deps: { features?(features_.lazy_static."1.3.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.3.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1vv47va18ydk7dx5paz88g3jy1d3lwbx6qpxkbj8gyfv770i4b1y";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.3.0" or {});
  };
  features_.lazy_static."1.3.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.3.0".default = (f.lazy_static."1.3.0".default or true); }
      { "1.3.0".spin =
        (f.lazy_static."1.3.0".spin or false) ||
        (f.lazy_static."1.3.0".spin_no_std or false) ||
        (lazy_static."1.3.0"."spin_no_std" or false); }
    ];
  }) [];


# end
# memchr-2.2.0

  crates.memchr."2.2.0" = deps: { features?(features_.memchr."2.2.0" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.2.0";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "11vwg8iig9jyjxq3n1cq15g29ikzw5l7ar87md54k1aisjs0997p";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.2.0" or {});
  };
  features_.memchr."2.2.0" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.2.0".default = (f.memchr."2.2.0".default or true); }
      { "2.2.0".use_std =
        (f.memchr."2.2.0".use_std or false) ||
        (f.memchr."2.2.0".default or false) ||
        (memchr."2.2.0"."default" or false); }
    ];
  }) [];


# end
# proc-macro2-0.4.30

  crates.proc_macro2."0.4.30" = deps: { features?(features_.proc_macro2."0.4.30" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.4.30";
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
      { "0.4.30".default = (f.proc_macro2."0.4.30".default or true); }
      { "0.4.30".proc-macro =
        (f.proc_macro2."0.4.30".proc-macro or false) ||
        (f.proc_macro2."0.4.30".default or false) ||
        (proc_macro2."0.4.30"."default" or false); }
    ];
    unicode_xid."${deps.proc_macro2."0.4.30".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.4.30"."unicode_xid"}" deps)
  ];


# end
# quote-0.6.12

  crates.quote."0.6.12" = deps: { features?(features_.quote."0.6.12" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.6.12";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1ckd2d2sy0hrwrqcr47dn0n3hyh7ygpc026l8xaycccyg27mihv9";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.6.12"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.6.12" or {});
  };
  features_.quote."0.6.12" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.6.12".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.6.12".proc_macro2}"."proc-macro" or false) ||
        (quote."0.6.12"."proc-macro" or false) ||
        (f."quote"."0.6.12"."proc-macro" or false); }
      { "${deps.quote."0.6.12".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.6.12".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.6.12".default = (f.quote."0.6.12".default or true); }
      { "0.6.12".proc-macro =
        (f.quote."0.6.12".proc-macro or false) ||
        (f.quote."0.6.12".default or false) ||
        (quote."0.6.12"."default" or false); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.6.12"."proc_macro2"}" deps)
  ];


# end
# regex-1.1.9

  crates.regex."1.1.9" = deps: { features?(features_.regex."1.1.9" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.1.9";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1rfrdsd2ba9s1vwwr9rpc3lzj390nz7wy8v537p86wkq8wqlwmb5";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."1.1.9"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."1.1.9"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."1.1.9"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."1.1.9"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."1.1.9"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."1.1.9" or {});
  };
  features_.regex."1.1.9" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.1.9".aho_corasick}".default = true;
    memchr."${deps.regex."1.1.9".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.1.9".default = (f.regex."1.1.9".default or true); }
      { "1.1.9".pattern =
        (f.regex."1.1.9".pattern or false) ||
        (f.regex."1.1.9".unstable or false) ||
        (regex."1.1.9"."unstable" or false); }
      { "1.1.9".use_std =
        (f.regex."1.1.9".use_std or false) ||
        (f.regex."1.1.9".default or false) ||
        (regex."1.1.9"."default" or false); }
    ];
    regex_syntax."${deps.regex."1.1.9".regex_syntax}".default = true;
    thread_local."${deps.regex."1.1.9".thread_local}".default = true;
    utf8_ranges."${deps.regex."1.1.9".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.1.9"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.1.9"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.1.9"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.1.9"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."1.1.9"."utf8_ranges"}" deps)
  ];


# end
# regex-syntax-0.6.8

  crates.regex_syntax."0.6.8" = deps: { features?(features_.regex_syntax."0.6.8" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.6.8";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0vkbgyh9hb7alzjw0fp6whcgyyp44q69gyhn81brkl11cj6fi1dy";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.6.8"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.6.8" = deps: f: updateFeatures f (rec {
    regex_syntax."0.6.8".default = (f.regex_syntax."0.6.8".default or true);
    ucd_util."${deps.regex_syntax."0.6.8".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.6.8"."ucd_util"}" deps)
  ];


# end
# rust-stemmers-1.1.0

  crates.rust_stemmers."1.1.0" = deps: { features?(features_.rust_stemmers."1.1.0" deps {}) }: buildRustCrate {
    crateName = "rust-stemmers";
    version = "1.1.0";
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
# serde-1.0.94

  crates.serde."1.0.94" = deps: { features?(features_.serde."1.0.94" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.94";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1qk7sk8xcjlj832ia5ahkas536kz06s3y0h70rqqji6srgl716f6";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.94" or {});
  };
  features_.serde."1.0.94" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.94".default = (f.serde."1.0.94".default or true); }
      { "1.0.94".serde_derive =
        (f.serde."1.0.94".serde_derive or false) ||
        (f.serde."1.0.94".derive or false) ||
        (serde."1.0.94"."derive" or false); }
      { "1.0.94".std =
        (f.serde."1.0.94".std or false) ||
        (f.serde."1.0.94".default or false) ||
        (serde."1.0.94"."default" or false); }
      { "1.0.94".unstable =
        (f.serde."1.0.94".unstable or false) ||
        (f.serde."1.0.94".alloc or false) ||
        (serde."1.0.94"."alloc" or false); }
    ];
  }) [];


# end
# serde_derive-1.0.94

  crates.serde_derive."1.0.94" = deps: { features?(features_.serde_derive."1.0.94" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.94";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "07s8pyjbdbs5891rbkwvgr6dgk9vbkg9gppnajbhz7nxmpkhgrx4";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.94"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.94"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.94"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.94" or {});
  };
  features_.serde_derive."1.0.94" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.94".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.94".quote}".default = true;
    serde_derive."1.0.94".default = (f.serde_derive."1.0.94".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.94".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.94".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.94"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.94"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.94"."syn"}" deps)
  ];


# end
# serde_json-1.0.40

  crates.serde_json."1.0.40" = deps: { features?(features_.serde_json."1.0.40" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.40";
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
      { "1.0.40".default = (f.serde_json."1.0.40".default or true); }
      { "1.0.40".indexmap =
        (f.serde_json."1.0.40".indexmap or false) ||
        (f.serde_json."1.0.40".preserve_order or false) ||
        (serde_json."1.0.40"."preserve_order" or false); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.40"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.40"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.40"."serde"}" deps)
  ];


# end
# strum-0.15.0

  crates.strum."0.15.0" = deps: { features?(features_.strum."0.15.0" deps {}) }: buildRustCrate {
    crateName = "strum";
    version = "0.15.0";
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
# syn-0.15.39

  crates.syn."0.15.39" = deps: { features?(features_.syn."0.15.39" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.15.39";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0n5mv317yghjcgzm0ik9racfjx8srhwfgazm6y80wgmkfpwz8myy";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.15.39"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.15.39"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.15.39".quote or false then [ (crates.quote."${deps."syn"."0.15.39".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.15.39" or {});
  };
  features_.syn."0.15.39" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.15.39".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.15.39".proc_macro2}"."proc-macro" or false) ||
        (syn."0.15.39"."proc-macro" or false) ||
        (f."syn"."0.15.39"."proc-macro" or false); }
      { "${deps.syn."0.15.39".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.15.39".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.15.39".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.15.39".quote}"."proc-macro" or false) ||
        (syn."0.15.39"."proc-macro" or false) ||
        (f."syn"."0.15.39"."proc-macro" or false); }
      { "${deps.syn."0.15.39".quote}".default = (f.quote."${deps.syn."0.15.39".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.15.39".clone-impls =
        (f.syn."0.15.39".clone-impls or false) ||
        (f.syn."0.15.39".default or false) ||
        (syn."0.15.39"."default" or false); }
      { "0.15.39".default = (f.syn."0.15.39".default or true); }
      { "0.15.39".derive =
        (f.syn."0.15.39".derive or false) ||
        (f.syn."0.15.39".default or false) ||
        (syn."0.15.39"."default" or false); }
      { "0.15.39".parsing =
        (f.syn."0.15.39".parsing or false) ||
        (f.syn."0.15.39".default or false) ||
        (syn."0.15.39"."default" or false); }
      { "0.15.39".printing =
        (f.syn."0.15.39".printing or false) ||
        (f.syn."0.15.39".default or false) ||
        (syn."0.15.39"."default" or false); }
      { "0.15.39".proc-macro =
        (f.syn."0.15.39".proc-macro or false) ||
        (f.syn."0.15.39".default or false) ||
        (syn."0.15.39"."default" or false); }
      { "0.15.39".quote =
        (f.syn."0.15.39".quote or false) ||
        (f.syn."0.15.39".printing or false) ||
        (syn."0.15.39"."printing" or false); }
    ];
    unicode_xid."${deps.syn."0.15.39".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.15.39"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.15.39"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.15.39"."unicode_xid"}" deps)
  ];


# end
# thread_local-0.3.6

  crates.thread_local."0.3.6" = deps: { features?(features_.thread_local."0.3.6" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.6";
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
# ucd-util-0.1.3

  crates.ucd_util."0.1.3" = deps: { features?(features_.ucd_util."0.1.3" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1n1qi3jywq5syq90z9qd8qzbn58pcjgv1sx4sdmipm4jf9zanz15";
  };
  features_.ucd_util."0.1.3" = deps: f: updateFeatures f (rec {
    ucd_util."0.1.3".default = (f.ucd_util."0.1.3".default or true);
  }) [];


# end
# unicode-segmentation-1.3.0

  crates.unicode_segmentation."1.3.0" = deps: { features?(features_.unicode_segmentation."1.3.0" deps {}) }: buildRustCrate {
    crateName = "unicode-segmentation";
    version = "1.3.0";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0jnns99wpjjpqzdn9jiplsr003rr41i95c008jb4inccb3avypp0";
    features = mkFeatures (features."unicode_segmentation"."1.3.0" or {});
  };
  features_.unicode_segmentation."1.3.0" = deps: f: updateFeatures f (rec {
    unicode_segmentation."1.3.0".default = (f.unicode_segmentation."1.3.0".default or true);
  }) [];


# end
# unicode-xid-0.1.0

  crates.unicode_xid."0.1.0" = deps: { features?(features_.unicode_xid."0.1.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.1.0";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "05wdmwlfzxhq3nhsxn6wx4q8dhxzzfb9szsz6wiw092m1rjj01zj";
    features = mkFeatures (features."unicode_xid"."0.1.0" or {});
  };
  features_.unicode_xid."0.1.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.1.0".default = (f.unicode_xid."0.1.0".default or true);
  }) [];


# end
# utf8-ranges-1.0.3

  crates.utf8_ranges."1.0.3" = deps: { features?(features_.utf8_ranges."1.0.3" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0nkh73y241czrxagm77qz20qcfn3h54a6v9cpvc7wjzwkaaqkswp";
  };
  features_.utf8_ranges."1.0.3" = deps: f: updateFeatures f (rec {
    utf8_ranges."1.0.3".default = (f.utf8_ranges."1.0.3".default or true);
  }) [];


# end
# xml-rs-0.8.0

  crates.xml_rs."0.8.0" = deps: { features?(features_.xml_rs."0.8.0" deps {}) }: buildRustCrate {
    crateName = "xml-rs";
    version = "0.8.0";
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

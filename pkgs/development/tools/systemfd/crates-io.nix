{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.6.4

  crates.aho_corasick."0.6.4" = deps: { features?(features_.aho_corasick."0.6.4" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.4";
    description = "Fast multiple substring searching with finite state machines.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "189v919mp6rzzgjp1khpn4zlq8ls81gh43x1lmc8kbkagdlpq888";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.6.4"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.6.4" = deps: f: updateFeatures f (rec {
    aho_corasick."0.6.4".default = (f.aho_corasick."0.6.4".default or true);
    memchr."${deps.aho_corasick."0.6.4".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.6.4"."memchr"}" deps)
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
# atty-0.2.10

  crates.atty."0.2.10" = deps: { features?(features_.atty."0.2.10" deps {}) }: buildRustCrate {
    crateName = "atty";
    version = "0.2.10";
    description = "A simple interface for querying atty";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "1h26lssj8rwaz0xhwwm5a645r49yly211amfmd243m3m0jl49i2c";
    dependencies = (if kernel == "redox" then mapFeatures features ([
      (crates."termion"."${deps."atty"."0.2.10"."termion"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."atty"."0.2.10"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."atty"."0.2.10"."winapi"}" deps)
    ]) else []);
  };
  features_.atty."0.2.10" = deps: f: updateFeatures f (rec {
    atty."0.2.10".default = (f.atty."0.2.10".default or true);
    libc."${deps.atty."0.2.10".libc}".default = (f.libc."${deps.atty."0.2.10".libc}".default or false);
    termion."${deps.atty."0.2.10".termion}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.atty."0.2.10".winapi}"."consoleapi" = true; }
      { "${deps.atty."0.2.10".winapi}"."minwinbase" = true; }
      { "${deps.atty."0.2.10".winapi}"."minwindef" = true; }
      { "${deps.atty."0.2.10".winapi}"."processenv" = true; }
      { "${deps.atty."0.2.10".winapi}"."winbase" = true; }
      { "${deps.atty."0.2.10".winapi}".default = true; }
    ];
  }) [
    (features_.termion."${deps."atty"."0.2.10"."termion"}" deps)
    (features_.libc."${deps."atty"."0.2.10"."libc"}" deps)
    (features_.winapi."${deps."atty"."0.2.10"."winapi"}" deps)
  ];


# end
# backtrace-0.3.7

  crates.backtrace."0.3.7" = deps: { features?(features_.backtrace."0.3.7" deps {}) }: buildRustCrate {
    crateName = "backtrace";
    version = "0.3.7";
    description = "A library to acquire a stack trace (backtrace) at runtime in a Rust program.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
    sha256 = "00zzcgacv516dlhxkrdw4c8vsx3bwkkdrrzi5pnxrhpd87ambjwn";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."backtrace"."0.3.7"."cfg_if"}" deps)
      (crates."rustc_demangle"."${deps."backtrace"."0.3.7"."rustc_demangle"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "fuchsia") && !(kernel == "emscripten") && !(kernel == "darwin") && !(kernel == "ios") then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.7".backtrace-sys or false then [ (crates.backtrace_sys."${deps."backtrace"."0.3.7".backtrace_sys}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."backtrace"."0.3.7"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.7".winapi or false then [ (crates.winapi."${deps."backtrace"."0.3.7".winapi}" deps) ] else [])) else []);
    features = mkFeatures (features."backtrace"."0.3.7" or {});
  };
  features_.backtrace."0.3.7" = deps: f: updateFeatures f (rec {
    backtrace = fold recursiveUpdate {} [
      { "0.3.7"."addr2line" =
        (f.backtrace."0.3.7"."addr2line" or false) ||
        (f.backtrace."0.3.7".gimli-symbolize or false) ||
        (backtrace."0.3.7"."gimli-symbolize" or false); }
      { "0.3.7"."backtrace-sys" =
        (f.backtrace."0.3.7"."backtrace-sys" or false) ||
        (f.backtrace."0.3.7".libbacktrace or false) ||
        (backtrace."0.3.7"."libbacktrace" or false); }
      { "0.3.7"."coresymbolication" =
        (f.backtrace."0.3.7"."coresymbolication" or false) ||
        (f.backtrace."0.3.7".default or false) ||
        (backtrace."0.3.7"."default" or false); }
      { "0.3.7"."dbghelp" =
        (f.backtrace."0.3.7"."dbghelp" or false) ||
        (f.backtrace."0.3.7".default or false) ||
        (backtrace."0.3.7"."default" or false); }
      { "0.3.7"."dladdr" =
        (f.backtrace."0.3.7"."dladdr" or false) ||
        (f.backtrace."0.3.7".default or false) ||
        (backtrace."0.3.7"."default" or false); }
      { "0.3.7"."findshlibs" =
        (f.backtrace."0.3.7"."findshlibs" or false) ||
        (f.backtrace."0.3.7".gimli-symbolize or false) ||
        (backtrace."0.3.7"."gimli-symbolize" or false); }
      { "0.3.7"."gimli" =
        (f.backtrace."0.3.7"."gimli" or false) ||
        (f.backtrace."0.3.7".gimli-symbolize or false) ||
        (backtrace."0.3.7"."gimli-symbolize" or false); }
      { "0.3.7"."libbacktrace" =
        (f.backtrace."0.3.7"."libbacktrace" or false) ||
        (f.backtrace."0.3.7".default or false) ||
        (backtrace."0.3.7"."default" or false); }
      { "0.3.7"."libunwind" =
        (f.backtrace."0.3.7"."libunwind" or false) ||
        (f.backtrace."0.3.7".default or false) ||
        (backtrace."0.3.7"."default" or false); }
      { "0.3.7"."memmap" =
        (f.backtrace."0.3.7"."memmap" or false) ||
        (f.backtrace."0.3.7".gimli-symbolize or false) ||
        (backtrace."0.3.7"."gimli-symbolize" or false); }
      { "0.3.7"."object" =
        (f.backtrace."0.3.7"."object" or false) ||
        (f.backtrace."0.3.7".gimli-symbolize or false) ||
        (backtrace."0.3.7"."gimli-symbolize" or false); }
      { "0.3.7"."rustc-serialize" =
        (f.backtrace."0.3.7"."rustc-serialize" or false) ||
        (f.backtrace."0.3.7".serialize-rustc or false) ||
        (backtrace."0.3.7"."serialize-rustc" or false); }
      { "0.3.7"."serde" =
        (f.backtrace."0.3.7"."serde" or false) ||
        (f.backtrace."0.3.7".serialize-serde or false) ||
        (backtrace."0.3.7"."serialize-serde" or false); }
      { "0.3.7"."serde_derive" =
        (f.backtrace."0.3.7"."serde_derive" or false) ||
        (f.backtrace."0.3.7".serialize-serde or false) ||
        (backtrace."0.3.7"."serialize-serde" or false); }
      { "0.3.7"."winapi" =
        (f.backtrace."0.3.7"."winapi" or false) ||
        (f.backtrace."0.3.7".dbghelp or false) ||
        (backtrace."0.3.7"."dbghelp" or false); }
      { "0.3.7".default = (f.backtrace."0.3.7".default or true); }
    ];
    backtrace_sys."${deps.backtrace."0.3.7".backtrace_sys}".default = true;
    cfg_if."${deps.backtrace."0.3.7".cfg_if}".default = true;
    libc."${deps.backtrace."0.3.7".libc}".default = true;
    rustc_demangle."${deps.backtrace."0.3.7".rustc_demangle}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.7".winapi}"."dbghelp" = true; }
      { "${deps.backtrace."0.3.7".winapi}"."minwindef" = true; }
      { "${deps.backtrace."0.3.7".winapi}"."processthreadsapi" = true; }
      { "${deps.backtrace."0.3.7".winapi}"."std" = true; }
      { "${deps.backtrace."0.3.7".winapi}"."winnt" = true; }
      { "${deps.backtrace."0.3.7".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."backtrace"."0.3.7"."cfg_if"}" deps)
    (features_.rustc_demangle."${deps."backtrace"."0.3.7"."rustc_demangle"}" deps)
    (features_.backtrace_sys."${deps."backtrace"."0.3.7"."backtrace_sys"}" deps)
    (features_.libc."${deps."backtrace"."0.3.7"."libc"}" deps)
    (features_.winapi."${deps."backtrace"."0.3.7"."winapi"}" deps)
  ];


# end
# backtrace-sys-0.1.16

  crates.backtrace_sys."0.1.16" = deps: { features?(features_.backtrace_sys."0.1.16" deps {}) }: buildRustCrate {
    crateName = "backtrace-sys";
    version = "0.1.16";
    description = "Bindings to the libbacktrace gcc library\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1cn2c8q3dn06crmnk0p62czkngam4l8nf57wy33nz1y5g25pszwy";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."backtrace_sys"."0.1.16"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."backtrace_sys"."0.1.16"."cc"}" deps)
    ]);
  };
  features_.backtrace_sys."0.1.16" = deps: f: updateFeatures f (rec {
    backtrace_sys."0.1.16".default = (f.backtrace_sys."0.1.16".default or true);
    cc."${deps.backtrace_sys."0.1.16".cc}".default = true;
    libc."${deps.backtrace_sys."0.1.16".libc}".default = true;
  }) [
    (features_.libc."${deps."backtrace_sys"."0.1.16"."libc"}" deps)
    (features_.cc."${deps."backtrace_sys"."0.1.16"."cc"}" deps)
  ];


# end
# bitflags-1.0.3

  crates.bitflags."1.0.3" = deps: { features?(features_.bitflags."1.0.3" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.0.3";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "162p4w4h1ad76awq6b5yivmls3d50m9cl27d8g588lsps6g8s5rw";
    features = mkFeatures (features."bitflags"."1.0.3" or {});
  };
  features_.bitflags."1.0.3" = deps: f: updateFeatures f (rec {
    bitflags."1.0.3".default = (f.bitflags."1.0.3".default or true);
  }) [];


# end
# byteorder-1.2.3

  crates.byteorder."1.2.3" = deps: { features?(features_.byteorder."1.2.3" deps {}) }: buildRustCrate {
    crateName = "byteorder";
    version = "1.2.3";
    description = "Library for reading/writing numbers in big-endian and little-endian.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1xghv5f5rydzsam8lnfqhfk090i8a1knb77ikbs0ik44bvrw2ij3";
    features = mkFeatures (features."byteorder"."1.2.3" or {});
  };
  features_.byteorder."1.2.3" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "1.2.3"."std" =
        (f.byteorder."1.2.3"."std" or false) ||
        (f.byteorder."1.2.3".default or false) ||
        (byteorder."1.2.3"."default" or false); }
      { "1.2.3".default = (f.byteorder."1.2.3".default or true); }
    ];
  }) [];


# end
# bytes-0.4.7

  crates.bytes."0.4.7" = deps: { features?(features_.bytes."0.4.7" deps {}) }: buildRustCrate {
    crateName = "bytes";
    version = "0.4.7";
    description = "Types and traits for working with bytes";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1icr74r099d0c0a2q1pz51182z7911g92h2j60al351kz78dzv3f";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."bytes"."0.4.7"."byteorder"}" deps)
      (crates."iovec"."${deps."bytes"."0.4.7"."iovec"}" deps)
    ]);
  };
  features_.bytes."0.4.7" = deps: f: updateFeatures f (rec {
    byteorder."${deps.bytes."0.4.7".byteorder}".default = true;
    bytes."0.4.7".default = (f.bytes."0.4.7".default or true);
    iovec."${deps.bytes."0.4.7".iovec}".default = true;
  }) [
    (features_.byteorder."${deps."bytes"."0.4.7"."byteorder"}" deps)
    (features_.iovec."${deps."bytes"."0.4.7"."iovec"}" deps)
  ];


# end
# cc-1.0.15

  crates.cc."1.0.15" = deps: { features?(features_.cc."1.0.15" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.15";
    description = "A build-time dependency for Cargo build scripts to assist in invoking the native\nC compiler to compile native C code into a static archive to be linked into Rust\ncode.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1zmcv4zf888byhay2qakqlc9b8snhy5ccfs35zb6flywmlj8f2c0";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.15" or {});
  };
  features_.cc."1.0.15" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.15"."rayon" =
        (f.cc."1.0.15"."rayon" or false) ||
        (f.cc."1.0.15".parallel or false) ||
        (cc."1.0.15"."parallel" or false); }
      { "1.0.15".default = (f.cc."1.0.15".default or true); }
    ];
  }) [];


# end
# cfg-if-0.1.3

  crates.cfg_if."0.1.3" = deps: { features?(features_.cfg_if."0.1.3" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.3";
    description = "A macro to ergonomically define an item depending on a large number of #[cfg]\nparameters. Structured like an if-else chain, the first matching branch is the\nitem that gets emitted.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0hphfz5qg40gr5p18gmgy2rzkqj019lii3n0dy3s0a6lnl9106k6";
  };
  features_.cfg_if."0.1.3" = deps: f: updateFeatures f (rec {
    cfg_if."0.1.3".default = (f.cfg_if."0.1.3".default or true);
  }) [];


# end
# clap-2.31.2

  crates.clap."2.31.2" = deps: { features?(features_.clap."2.31.2" deps {}) }: buildRustCrate {
    crateName = "clap";
    version = "2.31.2";
    description = "A simple to use, efficient, and full featured  Command Line Argument Parser\n";
    authors = [ "Kevin K. <kbknapp@gmail.com>" ];
    sha256 = "0r24ziw85a8y1sf2l21y4mvv5qan3rjafcshpyfsjfadqfxsij72";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."clap"."2.31.2"."bitflags"}" deps)
      (crates."textwrap"."${deps."clap"."2.31.2"."textwrap"}" deps)
      (crates."unicode_width"."${deps."clap"."2.31.2"."unicode_width"}" deps)
    ]
      ++ (if features.clap."2.31.2".atty or false then [ (crates.atty."${deps."clap"."2.31.2".atty}" deps) ] else [])
      ++ (if features.clap."2.31.2".strsim or false then [ (crates.strsim."${deps."clap"."2.31.2".strsim}" deps) ] else [])
      ++ (if features.clap."2.31.2".vec_map or false then [ (crates.vec_map."${deps."clap"."2.31.2".vec_map}" deps) ] else []))
      ++ (if !(kernel == "windows") then mapFeatures features ([
    ]
      ++ (if features.clap."2.31.2".ansi_term or false then [ (crates.ansi_term."${deps."clap"."2.31.2".ansi_term}" deps) ] else [])) else []);
    features = mkFeatures (features."clap"."2.31.2" or {});
  };
  features_.clap."2.31.2" = deps: f: updateFeatures f (rec {
    ansi_term."${deps.clap."2.31.2".ansi_term}".default = true;
    atty."${deps.clap."2.31.2".atty}".default = true;
    bitflags."${deps.clap."2.31.2".bitflags}".default = true;
    clap = fold recursiveUpdate {} [
      { "2.31.2"."ansi_term" =
        (f.clap."2.31.2"."ansi_term" or false) ||
        (f.clap."2.31.2".color or false) ||
        (clap."2.31.2"."color" or false); }
      { "2.31.2"."atty" =
        (f.clap."2.31.2"."atty" or false) ||
        (f.clap."2.31.2".color or false) ||
        (clap."2.31.2"."color" or false); }
      { "2.31.2"."clippy" =
        (f.clap."2.31.2"."clippy" or false) ||
        (f.clap."2.31.2".lints or false) ||
        (clap."2.31.2"."lints" or false); }
      { "2.31.2"."color" =
        (f.clap."2.31.2"."color" or false) ||
        (f.clap."2.31.2".default or false) ||
        (clap."2.31.2"."default" or false); }
      { "2.31.2"."strsim" =
        (f.clap."2.31.2"."strsim" or false) ||
        (f.clap."2.31.2".suggestions or false) ||
        (clap."2.31.2"."suggestions" or false); }
      { "2.31.2"."suggestions" =
        (f.clap."2.31.2"."suggestions" or false) ||
        (f.clap."2.31.2".default or false) ||
        (clap."2.31.2"."default" or false); }
      { "2.31.2"."term_size" =
        (f.clap."2.31.2"."term_size" or false) ||
        (f.clap."2.31.2".wrap_help or false) ||
        (clap."2.31.2"."wrap_help" or false); }
      { "2.31.2"."vec_map" =
        (f.clap."2.31.2"."vec_map" or false) ||
        (f.clap."2.31.2".default or false) ||
        (clap."2.31.2"."default" or false); }
      { "2.31.2"."yaml" =
        (f.clap."2.31.2"."yaml" or false) ||
        (f.clap."2.31.2".doc or false) ||
        (clap."2.31.2"."doc" or false); }
      { "2.31.2"."yaml-rust" =
        (f.clap."2.31.2"."yaml-rust" or false) ||
        (f.clap."2.31.2".yaml or false) ||
        (clap."2.31.2"."yaml" or false); }
      { "2.31.2".default = (f.clap."2.31.2".default or true); }
    ];
    strsim."${deps.clap."2.31.2".strsim}".default = true;
    textwrap = fold recursiveUpdate {} [
      { "${deps.clap."2.31.2".textwrap}"."term_size" =
        (f.textwrap."${deps.clap."2.31.2".textwrap}"."term_size" or false) ||
        (clap."2.31.2"."wrap_help" or false) ||
        (f."clap"."2.31.2"."wrap_help" or false); }
      { "${deps.clap."2.31.2".textwrap}".default = true; }
    ];
    unicode_width."${deps.clap."2.31.2".unicode_width}".default = true;
    vec_map."${deps.clap."2.31.2".vec_map}".default = true;
  }) [
    (features_.atty."${deps."clap"."2.31.2"."atty"}" deps)
    (features_.bitflags."${deps."clap"."2.31.2"."bitflags"}" deps)
    (features_.strsim."${deps."clap"."2.31.2"."strsim"}" deps)
    (features_.textwrap."${deps."clap"."2.31.2"."textwrap"}" deps)
    (features_.unicode_width."${deps."clap"."2.31.2"."unicode_width"}" deps)
    (features_.vec_map."${deps."clap"."2.31.2"."vec_map"}" deps)
    (features_.ansi_term."${deps."clap"."2.31.2"."ansi_term"}" deps)
  ];


# end
# clicolors-control-0.2.0

  crates.clicolors_control."0.2.0" = deps: { features?(features_.clicolors_control."0.2.0" deps {}) }: buildRustCrate {
    crateName = "clicolors-control";
    version = "0.2.0";
    description = "A common utility library to control CLI colorization";
    authors = [ "Armin Ronacher <armin.ronacher@active-4.com>" ];
    sha256 = "0p1fbs7k70h58ycahmin7b87c0xn6lc94xmh9jw4gxi40mnrvdkp";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."clicolors_control"."0.2.0"."lazy_static"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."clicolors_control"."0.2.0"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."clicolors_control"."0.2.0"."kernel32_sys"}" deps)
      (crates."winapi"."${deps."clicolors_control"."0.2.0"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."clicolors_control"."0.2.0" or {});
  };
  features_.clicolors_control."0.2.0" = deps: f: updateFeatures f (rec {
    clicolors_control = fold recursiveUpdate {} [
      { "0.2.0"."terminal_autoconfig" =
        (f.clicolors_control."0.2.0"."terminal_autoconfig" or false) ||
        (f.clicolors_control."0.2.0".default or false) ||
        (clicolors_control."0.2.0"."default" or false); }
      { "0.2.0".default = (f.clicolors_control."0.2.0".default or true); }
    ];
    kernel32_sys."${deps.clicolors_control."0.2.0".kernel32_sys}".default = true;
    lazy_static."${deps.clicolors_control."0.2.0".lazy_static}".default = true;
    libc."${deps.clicolors_control."0.2.0".libc}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.clicolors_control."0.2.0".winapi}"."consoleapi" = true; }
      { "${deps.clicolors_control."0.2.0".winapi}"."handleapi" = true; }
      { "${deps.clicolors_control."0.2.0".winapi}"."processenv" = true; }
      { "${deps.clicolors_control."0.2.0".winapi}"."winbase" = true; }
      { "${deps.clicolors_control."0.2.0".winapi}".default = true; }
    ];
  }) [
    (features_.lazy_static."${deps."clicolors_control"."0.2.0"."lazy_static"}" deps)
    (features_.libc."${deps."clicolors_control"."0.2.0"."libc"}" deps)
    (features_.kernel32_sys."${deps."clicolors_control"."0.2.0"."kernel32_sys"}" deps)
    (features_.winapi."${deps."clicolors_control"."0.2.0"."winapi"}" deps)
  ];


# end
# console-0.6.1

  crates.console."0.6.1" = deps: { features?(features_.console."0.6.1" deps {}) }: buildRustCrate {
    crateName = "console";
    version = "0.6.1";
    description = "A terminal and console abstraction for Rust";
    authors = [ "Armin Ronacher <armin.ronacher@active-4.com>" ];
    sha256 = "0h46m3nlx7m2pmc1ia2nlbl8d1vp46kqh2c82hx9ckjag68g4zdl";
    dependencies = mapFeatures features ([
      (crates."clicolors_control"."${deps."console"."0.6.1"."clicolors_control"}" deps)
      (crates."lazy_static"."${deps."console"."0.6.1"."lazy_static"}" deps)
      (crates."libc"."${deps."console"."0.6.1"."libc"}" deps)
      (crates."parking_lot"."${deps."console"."0.6.1"."parking_lot"}" deps)
      (crates."regex"."${deps."console"."0.6.1"."regex"}" deps)
      (crates."unicode_width"."${deps."console"."0.6.1"."unicode_width"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."termios"."${deps."console"."0.6.1"."termios"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."console"."0.6.1"."winapi"}" deps)
    ]) else []);
  };
  features_.console."0.6.1" = deps: f: updateFeatures f (rec {
    clicolors_control."${deps.console."0.6.1".clicolors_control}".default = true;
    console."0.6.1".default = (f.console."0.6.1".default or true);
    lazy_static."${deps.console."0.6.1".lazy_static}".default = true;
    libc."${deps.console."0.6.1".libc}".default = true;
    parking_lot."${deps.console."0.6.1".parking_lot}".default = true;
    regex."${deps.console."0.6.1".regex}".default = true;
    termios."${deps.console."0.6.1".termios}".default = true;
    unicode_width."${deps.console."0.6.1".unicode_width}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.console."0.6.1".winapi}"."consoleapi" = true; }
      { "${deps.console."0.6.1".winapi}"."processenv" = true; }
      { "${deps.console."0.6.1".winapi}"."winbase" = true; }
      { "${deps.console."0.6.1".winapi}"."wincon" = true; }
      { "${deps.console."0.6.1".winapi}"."winuser" = true; }
      { "${deps.console."0.6.1".winapi}".default = true; }
    ];
  }) [
    (features_.clicolors_control."${deps."console"."0.6.1"."clicolors_control"}" deps)
    (features_.lazy_static."${deps."console"."0.6.1"."lazy_static"}" deps)
    (features_.libc."${deps."console"."0.6.1"."libc"}" deps)
    (features_.parking_lot."${deps."console"."0.6.1"."parking_lot"}" deps)
    (features_.regex."${deps."console"."0.6.1"."regex"}" deps)
    (features_.unicode_width."${deps."console"."0.6.1"."unicode_width"}" deps)
    (features_.termios."${deps."console"."0.6.1"."termios"}" deps)
    (features_.winapi."${deps."console"."0.6.1"."winapi"}" deps)
  ];


# end
# failure-0.1.1

  crates.failure."0.1.1" = deps: { features?(features_.failure."0.1.1" deps {}) }: buildRustCrate {
    crateName = "failure";
    version = "0.1.1";
    description = "Experimental error handling abstraction.";
    authors = [ "Without Boats <boats@mozilla.com>" ];
    sha256 = "0gf9cmkm9kc163sszgjksqp5pcgj689lnf2104nn4h4is18nhigk";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.failure."0.1.1".backtrace or false then [ (crates.backtrace."${deps."failure"."0.1.1".backtrace}" deps) ] else [])
      ++ (if features.failure."0.1.1".failure_derive or false then [ (crates.failure_derive."${deps."failure"."0.1.1".failure_derive}" deps) ] else []));
    features = mkFeatures (features."failure"."0.1.1" or {});
  };
  features_.failure."0.1.1" = deps: f: updateFeatures f (rec {
    backtrace."${deps.failure."0.1.1".backtrace}".default = true;
    failure = fold recursiveUpdate {} [
      { "0.1.1"."backtrace" =
        (f.failure."0.1.1"."backtrace" or false) ||
        (f.failure."0.1.1".std or false) ||
        (failure."0.1.1"."std" or false); }
      { "0.1.1"."derive" =
        (f.failure."0.1.1"."derive" or false) ||
        (f.failure."0.1.1".default or false) ||
        (failure."0.1.1"."default" or false); }
      { "0.1.1"."failure_derive" =
        (f.failure."0.1.1"."failure_derive" or false) ||
        (f.failure."0.1.1".derive or false) ||
        (failure."0.1.1"."derive" or false); }
      { "0.1.1"."std" =
        (f.failure."0.1.1"."std" or false) ||
        (f.failure."0.1.1".default or false) ||
        (failure."0.1.1"."default" or false); }
      { "0.1.1".default = (f.failure."0.1.1".default or true); }
    ];
    failure_derive."${deps.failure."0.1.1".failure_derive}".default = true;
  }) [
    (features_.backtrace."${deps."failure"."0.1.1"."backtrace"}" deps)
    (features_.failure_derive."${deps."failure"."0.1.1"."failure_derive"}" deps)
  ];


# end
# failure_derive-0.1.1

  crates.failure_derive."0.1.1" = deps: { features?(features_.failure_derive."0.1.1" deps {}) }: buildRustCrate {
    crateName = "failure_derive";
    version = "0.1.1";
    description = "derives for the failure crate";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1w895q4pbyx3rwnhgjwfcayk9ghbi166wc1c3553qh8zkbz52k8i";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."quote"."${deps."failure_derive"."0.1.1"."quote"}" deps)
      (crates."syn"."${deps."failure_derive"."0.1.1"."syn"}" deps)
      (crates."synstructure"."${deps."failure_derive"."0.1.1"."synstructure"}" deps)
    ]);
    features = mkFeatures (features."failure_derive"."0.1.1" or {});
  };
  features_.failure_derive."0.1.1" = deps: f: updateFeatures f (rec {
    failure_derive = fold recursiveUpdate {} [
      { "0.1.1"."std" =
        (f.failure_derive."0.1.1"."std" or false) ||
        (f.failure_derive."0.1.1".default or false) ||
        (failure_derive."0.1.1"."default" or false); }
      { "0.1.1".default = (f.failure_derive."0.1.1".default or true); }
    ];
    quote."${deps.failure_derive."0.1.1".quote}".default = true;
    syn."${deps.failure_derive."0.1.1".syn}".default = true;
    synstructure."${deps.failure_derive."0.1.1".synstructure}".default = true;
  }) [
    (features_.quote."${deps."failure_derive"."0.1.1"."quote"}" deps)
    (features_.syn."${deps."failure_derive"."0.1.1"."syn"}" deps)
    (features_.synstructure."${deps."failure_derive"."0.1.1"."synstructure"}" deps)
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
  features_.fuchsia_zircon."0.3.3" = deps: f: updateFeatures f (rec {
    bitflags."${deps.fuchsia_zircon."0.3.3".bitflags}".default = true;
    fuchsia_zircon."0.3.3".default = (f.fuchsia_zircon."0.3.3".default or true);
    fuchsia_zircon_sys."${deps.fuchsia_zircon."0.3.3".fuchsia_zircon_sys}".default = true;
  }) [
    (features_.bitflags."${deps."fuchsia_zircon"."0.3.3"."bitflags"}" deps)
    (features_.fuchsia_zircon_sys."${deps."fuchsia_zircon"."0.3.3"."fuchsia_zircon_sys"}" deps)
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
  features_.fuchsia_zircon_sys."0.3.3" = deps: f: updateFeatures f (rec {
    fuchsia_zircon_sys."0.3.3".default = (f.fuchsia_zircon_sys."0.3.3".default or true);
  }) [];


# end
# gcc-0.3.54

  crates.gcc."0.3.54" = deps: { features?(features_.gcc."0.3.54" deps {}) }: buildRustCrate {
    crateName = "gcc";
    version = "0.3.54";
    description = "A build-time dependency for Cargo build scripts to assist in invoking the native\nC compiler to compile native C code into a static archive to be linked into Rust\ncode.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "07a5i47r8achc6gxsba3ga17h9gnh4b9a2cak8vjg4hx62aajkr4";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."gcc"."0.3.54" or {});
  };
  features_.gcc."0.3.54" = deps: f: updateFeatures f (rec {
    gcc = fold recursiveUpdate {} [
      { "0.3.54"."rayon" =
        (f.gcc."0.3.54"."rayon" or false) ||
        (f.gcc."0.3.54".parallel or false) ||
        (gcc."0.3.54"."parallel" or false); }
      { "0.3.54".default = (f.gcc."0.3.54".default or true); }
    ];
  }) [];


# end
# iovec-0.1.2

  crates.iovec."0.1.2" = deps: { features?(features_.iovec."0.1.2" deps {}) }: buildRustCrate {
    crateName = "iovec";
    version = "0.1.2";
    description = "Portable buffer type for scatter/gather I/O operations\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0vjymmb7wj4v4kza5jjn48fcdb85j3k37y7msjl3ifz0p9yiyp2r";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."iovec"."0.1.2"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."iovec"."0.1.2"."winapi"}" deps)
    ]) else []);
  };
  features_.iovec."0.1.2" = deps: f: updateFeatures f (rec {
    iovec."0.1.2".default = (f.iovec."0.1.2".default or true);
    libc."${deps.iovec."0.1.2".libc}".default = true;
    winapi."${deps.iovec."0.1.2".winapi}".default = true;
  }) [
    (features_.libc."${deps."iovec"."0.1.2"."libc"}" deps)
    (features_.winapi."${deps."iovec"."0.1.2"."winapi"}" deps)
  ];


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
  features_.kernel32_sys."0.2.2" = deps: f: updateFeatures f (rec {
    kernel32_sys."0.2.2".default = (f.kernel32_sys."0.2.2".default or true);
    winapi."${deps.kernel32_sys."0.2.2".winapi}".default = true;
    winapi_build."${deps.kernel32_sys."0.2.2".winapi_build}".default = true;
  }) [
    (features_.winapi."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    (features_.winapi_build."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
  ];


# end
# lazy_static-0.2.11

  crates.lazy_static."0.2.11" = deps: { features?(features_.lazy_static."0.2.11" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "0.2.11";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1x6871cvpy5b96yv4c7jvpq316fp5d4609s9py7qk6cd6x9k34vm";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."0.2.11" or {});
  };
  features_.lazy_static."0.2.11" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "0.2.11"."compiletest_rs" =
        (f.lazy_static."0.2.11"."compiletest_rs" or false) ||
        (f.lazy_static."0.2.11".compiletest or false) ||
        (lazy_static."0.2.11"."compiletest" or false); }
      { "0.2.11"."nightly" =
        (f.lazy_static."0.2.11"."nightly" or false) ||
        (f.lazy_static."0.2.11".spin_no_std or false) ||
        (lazy_static."0.2.11"."spin_no_std" or false); }
      { "0.2.11"."spin" =
        (f.lazy_static."0.2.11"."spin" or false) ||
        (f.lazy_static."0.2.11".spin_no_std or false) ||
        (lazy_static."0.2.11"."spin_no_std" or false); }
      { "0.2.11".default = (f.lazy_static."0.2.11".default or true); }
    ];
  }) [];


# end
# lazy_static-1.0.0

  crates.lazy_static."1.0.0" = deps: { features?(features_.lazy_static."1.0.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.0.0";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "0wfvqyr2nvx2mbsrscg5y7gfa9skhb8p72ayanl8vl49pw24v4fh";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.0.0" or {});
  };
  features_.lazy_static."1.0.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.0.0"."compiletest_rs" =
        (f.lazy_static."1.0.0"."compiletest_rs" or false) ||
        (f.lazy_static."1.0.0".compiletest or false) ||
        (lazy_static."1.0.0"."compiletest" or false); }
      { "1.0.0"."nightly" =
        (f.lazy_static."1.0.0"."nightly" or false) ||
        (f.lazy_static."1.0.0".spin_no_std or false) ||
        (lazy_static."1.0.0"."spin_no_std" or false); }
      { "1.0.0"."spin" =
        (f.lazy_static."1.0.0"."spin" or false) ||
        (f.lazy_static."1.0.0".spin_no_std or false) ||
        (lazy_static."1.0.0"."spin_no_std" or false); }
      { "1.0.0".default = (f.lazy_static."1.0.0".default or true); }
    ];
  }) [];


# end
# libc-0.2.40

  crates.libc."0.2.40" = deps: { features?(features_.libc."0.2.40" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.40";
    description = "A library for types and bindings to native C functions often found in libc or\nother common platform libraries.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1xfc39237ldzgr8x8wcflgdr8zssi3wif7g2zxc02d94gzkjsw83";
    features = mkFeatures (features."libc"."0.2.40" or {});
  };
  features_.libc."0.2.40" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.40"."use_std" =
        (f.libc."0.2.40"."use_std" or false) ||
        (f.libc."0.2.40".default or false) ||
        (libc."0.2.40"."default" or false); }
      { "0.2.40".default = (f.libc."0.2.40".default or true); }
    ];
  }) [];


# end
# memchr-2.0.1

  crates.memchr."2.0.1" = deps: { features?(features_.memchr."2.0.1" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.0.1";
    description = "Safe interface to memchr.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "0ls2y47rjwapjdax6bp974gdp06ggm1v8d1h69wyydmh1nhgm5gr";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.memchr."2.0.1".libc or false then [ (crates.libc."${deps."memchr"."2.0.1".libc}" deps) ] else []));
    features = mkFeatures (features."memchr"."2.0.1" or {});
  };
  features_.memchr."2.0.1" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "${deps.memchr."2.0.1".libc}"."use_std" =
        (f.libc."${deps.memchr."2.0.1".libc}"."use_std" or false) ||
        (memchr."2.0.1"."use_std" or false) ||
        (f."memchr"."2.0.1"."use_std" or false); }
      { "${deps.memchr."2.0.1".libc}".default = (f.libc."${deps.memchr."2.0.1".libc}".default or false); }
    ];
    memchr = fold recursiveUpdate {} [
      { "2.0.1"."libc" =
        (f.memchr."2.0.1"."libc" or false) ||
        (f.memchr."2.0.1".default or false) ||
        (memchr."2.0.1"."default" or false) ||
        (f.memchr."2.0.1".use_std or false) ||
        (memchr."2.0.1"."use_std" or false); }
      { "2.0.1"."use_std" =
        (f.memchr."2.0.1"."use_std" or false) ||
        (f.memchr."2.0.1".default or false) ||
        (memchr."2.0.1"."default" or false); }
      { "2.0.1".default = (f.memchr."2.0.1".default or true); }
    ];
  }) [
    (features_.libc."${deps."memchr"."2.0.1"."libc"}" deps)
  ];


# end
# nix-0.10.0

  crates.nix."0.10.0" = deps: { features?(features_.nix."0.10.0" deps {}) }: buildRustCrate {
    crateName = "nix";
    version = "0.10.0";
    description = "Rust friendly bindings to *nix APIs";
    authors = [ "The nix-rust Project Developers" ];
    sha256 = "0ghrbjlc1l21pmldwaz5b5m72xs0m05y1zq5ljlnymn61vbzxsny";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."nix"."0.10.0"."bitflags"}" deps)
      (crates."bytes"."${deps."nix"."0.10.0"."bytes"}" deps)
      (crates."cfg_if"."${deps."nix"."0.10.0"."cfg_if"}" deps)
      (crates."libc"."${deps."nix"."0.10.0"."libc"}" deps)
      (crates."void"."${deps."nix"."0.10.0"."void"}" deps)
    ])
      ++ (if kernel == "dragonfly" then mapFeatures features ([
]) else []);
  };
  features_.nix."0.10.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.nix."0.10.0".bitflags}".default = true;
    bytes."${deps.nix."0.10.0".bytes}".default = (f.bytes."${deps.nix."0.10.0".bytes}".default or false);
    cfg_if."${deps.nix."0.10.0".cfg_if}".default = true;
    libc."${deps.nix."0.10.0".libc}".default = true;
    nix."0.10.0".default = (f.nix."0.10.0".default or true);
    void."${deps.nix."0.10.0".void}".default = true;
  }) [
    (features_.bitflags."${deps."nix"."0.10.0"."bitflags"}" deps)
    (features_.bytes."${deps."nix"."0.10.0"."bytes"}" deps)
    (features_.cfg_if."${deps."nix"."0.10.0"."cfg_if"}" deps)
    (features_.libc."${deps."nix"."0.10.0"."libc"}" deps)
    (features_.void."${deps."nix"."0.10.0"."void"}" deps)
  ];


# end
# owning_ref-0.3.3

  crates.owning_ref."0.3.3" = deps: { features?(features_.owning_ref."0.3.3" deps {}) }: buildRustCrate {
    crateName = "owning_ref";
    version = "0.3.3";
    description = "A library for creating references that carry their owner with them.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "13ivn0ydc0hf957ix0f5si9nnplzzykbr70hni1qz9m19i9kvmrh";
    dependencies = mapFeatures features ([
      (crates."stable_deref_trait"."${deps."owning_ref"."0.3.3"."stable_deref_trait"}" deps)
    ]);
  };
  features_.owning_ref."0.3.3" = deps: f: updateFeatures f (rec {
    owning_ref."0.3.3".default = (f.owning_ref."0.3.3".default or true);
    stable_deref_trait."${deps.owning_ref."0.3.3".stable_deref_trait}".default = true;
  }) [
    (features_.stable_deref_trait."${deps."owning_ref"."0.3.3"."stable_deref_trait"}" deps)
  ];


# end
# parking_lot-0.5.5

  crates.parking_lot."0.5.5" = deps: { features?(features_.parking_lot."0.5.5" deps {}) }: buildRustCrate {
    crateName = "parking_lot";
    version = "0.5.5";
    description = "More compact and efficient implementations of the standard synchronization primitives.";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0balxl593apy0l70z6dzk6c0r9707hgw2c9yav5asjc87dj6fx7l";
    dependencies = mapFeatures features ([
      (crates."parking_lot_core"."${deps."parking_lot"."0.5.5"."parking_lot_core"}" deps)
    ]
      ++ (if features.parking_lot."0.5.5".owning_ref or false then [ (crates.owning_ref."${deps."parking_lot"."0.5.5".owning_ref}" deps) ] else []));
    features = mkFeatures (features."parking_lot"."0.5.5" or {});
  };
  features_.parking_lot."0.5.5" = deps: f: updateFeatures f (rec {
    owning_ref."${deps.parking_lot."0.5.5".owning_ref}".default = true;
    parking_lot = fold recursiveUpdate {} [
      { "0.5.5"."owning_ref" =
        (f.parking_lot."0.5.5"."owning_ref" or false) ||
        (f.parking_lot."0.5.5".default or false) ||
        (parking_lot."0.5.5"."default" or false); }
      { "0.5.5".default = (f.parking_lot."0.5.5".default or true); }
    ];
    parking_lot_core = fold recursiveUpdate {} [
      { "${deps.parking_lot."0.5.5".parking_lot_core}"."deadlock_detection" =
        (f.parking_lot_core."${deps.parking_lot."0.5.5".parking_lot_core}"."deadlock_detection" or false) ||
        (parking_lot."0.5.5"."deadlock_detection" or false) ||
        (f."parking_lot"."0.5.5"."deadlock_detection" or false); }
      { "${deps.parking_lot."0.5.5".parking_lot_core}"."nightly" =
        (f.parking_lot_core."${deps.parking_lot."0.5.5".parking_lot_core}"."nightly" or false) ||
        (parking_lot."0.5.5"."nightly" or false) ||
        (f."parking_lot"."0.5.5"."nightly" or false); }
      { "${deps.parking_lot."0.5.5".parking_lot_core}".default = true; }
    ];
  }) [
    (features_.owning_ref."${deps."parking_lot"."0.5.5"."owning_ref"}" deps)
    (features_.parking_lot_core."${deps."parking_lot"."0.5.5"."parking_lot_core"}" deps)
  ];


# end
# parking_lot_core-0.2.14

  crates.parking_lot_core."0.2.14" = deps: { features?(features_.parking_lot_core."0.2.14" deps {}) }: buildRustCrate {
    crateName = "parking_lot_core";
    version = "0.2.14";
    description = "An advanced API for creating custom synchronization primitives.";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0giypb8ckkpi34p14nfk4b19c7przj4jxs95gs7x2v5ncmi0y286";
    dependencies = mapFeatures features ([
      (crates."rand"."${deps."parking_lot_core"."0.2.14"."rand"}" deps)
      (crates."smallvec"."${deps."parking_lot_core"."0.2.14"."smallvec"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."parking_lot_core"."0.2.14"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."parking_lot_core"."0.2.14"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."parking_lot_core"."0.2.14" or {});
  };
  features_.parking_lot_core."0.2.14" = deps: f: updateFeatures f (rec {
    libc."${deps.parking_lot_core."0.2.14".libc}".default = true;
    parking_lot_core = fold recursiveUpdate {} [
      { "0.2.14"."backtrace" =
        (f.parking_lot_core."0.2.14"."backtrace" or false) ||
        (f.parking_lot_core."0.2.14".deadlock_detection or false) ||
        (parking_lot_core."0.2.14"."deadlock_detection" or false); }
      { "0.2.14"."petgraph" =
        (f.parking_lot_core."0.2.14"."petgraph" or false) ||
        (f.parking_lot_core."0.2.14".deadlock_detection or false) ||
        (parking_lot_core."0.2.14"."deadlock_detection" or false); }
      { "0.2.14"."thread-id" =
        (f.parking_lot_core."0.2.14"."thread-id" or false) ||
        (f.parking_lot_core."0.2.14".deadlock_detection or false) ||
        (parking_lot_core."0.2.14"."deadlock_detection" or false); }
      { "0.2.14".default = (f.parking_lot_core."0.2.14".default or true); }
    ];
    rand."${deps.parking_lot_core."0.2.14".rand}".default = true;
    smallvec."${deps.parking_lot_core."0.2.14".smallvec}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.parking_lot_core."0.2.14".winapi}"."errhandlingapi" = true; }
      { "${deps.parking_lot_core."0.2.14".winapi}"."handleapi" = true; }
      { "${deps.parking_lot_core."0.2.14".winapi}"."minwindef" = true; }
      { "${deps.parking_lot_core."0.2.14".winapi}"."ntstatus" = true; }
      { "${deps.parking_lot_core."0.2.14".winapi}"."winbase" = true; }
      { "${deps.parking_lot_core."0.2.14".winapi}"."winerror" = true; }
      { "${deps.parking_lot_core."0.2.14".winapi}"."winnt" = true; }
      { "${deps.parking_lot_core."0.2.14".winapi}".default = true; }
    ];
  }) [
    (features_.rand."${deps."parking_lot_core"."0.2.14"."rand"}" deps)
    (features_.smallvec."${deps."parking_lot_core"."0.2.14"."smallvec"}" deps)
    (features_.libc."${deps."parking_lot_core"."0.2.14"."libc"}" deps)
    (features_.winapi."${deps."parking_lot_core"."0.2.14"."winapi"}" deps)
  ];


# end
# quote-0.3.15

  crates.quote."0.3.15" = deps: { features?(features_.quote."0.3.15" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.3.15";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "09il61jv4kd1360spaj46qwyl21fv1qz18fsv2jra8wdnlgl5jsg";
  };
  features_.quote."0.3.15" = deps: f: updateFeatures f (rec {
    quote."0.3.15".default = (f.quote."0.3.15".default or true);
  }) [];


# end
# rand-0.4.2

  crates.rand."0.4.2" = deps: { features?(features_.rand."0.4.2" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.4.2";
    description = "Random number generators and other randomness functionality.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0h8pkg23wb67i8904sm76iyr1jlmhklb85vbpz9c9191a24xzkfm";
    dependencies = (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."rand"."0.4.2"."fuchsia_zircon"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.4.2".libc or false then [ (crates.libc."${deps."rand"."0.4.2".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand"."0.4.2"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."rand"."0.4.2" or {});
  };
  features_.rand."0.4.2" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.rand."0.4.2".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.4.2".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.4.2"."i128_support" =
        (f.rand."0.4.2"."i128_support" or false) ||
        (f.rand."0.4.2".nightly or false) ||
        (rand."0.4.2"."nightly" or false); }
      { "0.4.2"."libc" =
        (f.rand."0.4.2"."libc" or false) ||
        (f.rand."0.4.2".std or false) ||
        (rand."0.4.2"."std" or false); }
      { "0.4.2"."std" =
        (f.rand."0.4.2"."std" or false) ||
        (f.rand."0.4.2".default or false) ||
        (rand."0.4.2"."default" or false); }
      { "0.4.2".default = (f.rand."0.4.2".default or true); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.4.2".winapi}"."minwindef" = true; }
      { "${deps.rand."0.4.2".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.4.2".winapi}"."profileapi" = true; }
      { "${deps.rand."0.4.2".winapi}"."winnt" = true; }
      { "${deps.rand."0.4.2".winapi}".default = true; }
    ];
  }) [
    (features_.fuchsia_zircon."${deps."rand"."0.4.2"."fuchsia_zircon"}" deps)
    (features_.libc."${deps."rand"."0.4.2"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.4.2"."winapi"}" deps)
  ];


# end
# redox_syscall-0.1.37

  crates.redox_syscall."0.1.37" = deps: { features?(features_.redox_syscall."0.1.37" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.37";
    description = "A Rust library to access raw Redox system calls";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "0qa0jl9cr3qp80an8vshp2mcn8rzvwiavs1398hq1vsjw7pc3h2v";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.37" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.37".default = (f.redox_syscall."0.1.37".default or true);
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
  features_.redox_termios."0.1.1" = deps: f: updateFeatures f (rec {
    redox_syscall."${deps.redox_termios."0.1.1".redox_syscall}".default = true;
    redox_termios."0.1.1".default = (f.redox_termios."0.1.1".default or true);
  }) [
    (features_.redox_syscall."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
  ];


# end
# regex-0.2.11

  crates.regex."0.2.11" = deps: { features?(features_.regex."0.2.11" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.2.11";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0r50cymxdqp0fv1dxd22mjr6y32q450nwacd279p9s7lh0cafijj";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."0.2.11"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."0.2.11"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."0.2.11"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."0.2.11"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."0.2.11" or {});
  };
  features_.regex."0.2.11" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."0.2.11".aho_corasick}".default = true;
    memchr."${deps.regex."0.2.11".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "0.2.11"."pattern" =
        (f.regex."0.2.11"."pattern" or false) ||
        (f.regex."0.2.11".unstable or false) ||
        (regex."0.2.11"."unstable" or false); }
      { "0.2.11".default = (f.regex."0.2.11".default or true); }
    ];
    regex_syntax."${deps.regex."0.2.11".regex_syntax}".default = true;
    thread_local."${deps.regex."0.2.11".thread_local}".default = true;
    utf8_ranges."${deps.regex."0.2.11".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."0.2.11"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."0.2.11"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."0.2.11"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."0.2.11"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
  ];


# end
# regex-1.0.0

  crates.regex."1.0.0" = deps: { features?(features_.regex."1.0.0" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.0.0";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1wynl7jmf6l2fnsayw1bzfh7km4wwqnqfpi8anj7wbhdk17i6j6b";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."1.0.0"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."1.0.0"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."1.0.0"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."1.0.0"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."1.0.0"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."1.0.0" or {});
  };
  features_.regex."1.0.0" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.0.0".aho_corasick}".default = true;
    memchr."${deps.regex."1.0.0".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.0.0"."pattern" =
        (f.regex."1.0.0"."pattern" or false) ||
        (f.regex."1.0.0".unstable or false) ||
        (regex."1.0.0"."unstable" or false); }
      { "1.0.0"."use_std" =
        (f.regex."1.0.0"."use_std" or false) ||
        (f.regex."1.0.0".default or false) ||
        (regex."1.0.0"."default" or false); }
      { "1.0.0".default = (f.regex."1.0.0".default or true); }
    ];
    regex_syntax."${deps.regex."1.0.0".regex_syntax}".default = true;
    thread_local."${deps.regex."1.0.0".thread_local}".default = true;
    utf8_ranges."${deps.regex."1.0.0".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.0.0"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.0.0"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.0.0"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.0.0"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."1.0.0"."utf8_ranges"}" deps)
  ];


# end
# regex-syntax-0.5.6

  crates.regex_syntax."0.5.6" = deps: { features?(features_.regex_syntax."0.5.6" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.5.6";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "10vf3r34bgjnbrnqd5aszn35bjvm8insw498l1vjy8zx5yms3427";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.5.6" = deps: f: updateFeatures f (rec {
    regex_syntax."0.5.6".default = (f.regex_syntax."0.5.6".default or true);
    ucd_util."${deps.regex_syntax."0.5.6".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
  ];


# end
# regex-syntax-0.6.0

  crates.regex_syntax."0.6.0" = deps: { features?(features_.regex_syntax."0.6.0" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.6.0";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1zlaq3y1zbiqilxbh0471bizcs4p14b58nqr815w3ssyam169cy6";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.6.0"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.6.0" = deps: f: updateFeatures f (rec {
    regex_syntax."0.6.0".default = (f.regex_syntax."0.6.0".default or true);
    ucd_util."${deps.regex_syntax."0.6.0".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.6.0"."ucd_util"}" deps)
  ];


# end
# rustc-demangle-0.1.8

  crates.rustc_demangle."0.1.8" = deps: { features?(features_.rustc_demangle."0.1.8" deps {}) }: buildRustCrate {
    crateName = "rustc-demangle";
    version = "0.1.8";
    description = "Rust compiler symbol demangling.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0xn5l86qfwngmdsjbglj30wh37zplvch96jl9raysl3k06gkkv3c";
  };
  features_.rustc_demangle."0.1.8" = deps: f: updateFeatures f (rec {
    rustc_demangle."0.1.8".default = (f.rustc_demangle."0.1.8".default or true);
  }) [];


# end
# smallvec-0.6.1

  crates.smallvec."0.6.1" = deps: { features?(features_.smallvec."0.6.1" deps {}) }: buildRustCrate {
    crateName = "smallvec";
    version = "0.6.1";
    description = "'Small vector' optimization: store up to a small number of items on the stack";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "16m07xh67xcdpwjkbzbv9d7visxmz4fb4a8jfcrsrf333w7vkl1g";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."smallvec"."0.6.1" or {});
  };
  features_.smallvec."0.6.1" = deps: f: updateFeatures f (rec {
    smallvec = fold recursiveUpdate {} [
      { "0.6.1"."std" =
        (f.smallvec."0.6.1"."std" or false) ||
        (f.smallvec."0.6.1".default or false) ||
        (smallvec."0.6.1"."default" or false); }
      { "0.6.1".default = (f.smallvec."0.6.1".default or true); }
    ];
  }) [];


# end
# socket2-0.3.5

  crates.socket2."0.3.5" = deps: { features?(features_.socket2."0.3.5" deps {}) }: buildRustCrate {
    crateName = "socket2";
    version = "0.3.5";
    description = "Utilities for handling networking sockets with a maximal amount of configuration\npossible intended.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0bi6z6qvra16rwm3lk7xz4aakvcmmak6fpdmra1v7ccp40bss0kf";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."cfg_if"."${deps."socket2"."0.3.5"."cfg_if"}" deps)
      (crates."libc"."${deps."socket2"."0.3.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."socket2"."0.3.5"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."socket2"."0.3.5" or {});
  };
  features_.socket2."0.3.5" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.socket2."0.3.5".cfg_if}".default = true;
    libc."${deps.socket2."0.3.5".libc}".default = true;
    socket2."0.3.5".default = (f.socket2."0.3.5".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.socket2."0.3.5".winapi}"."handleapi" = true; }
      { "${deps.socket2."0.3.5".winapi}"."minwindef" = true; }
      { "${deps.socket2."0.3.5".winapi}"."ws2def" = true; }
      { "${deps.socket2."0.3.5".winapi}"."ws2ipdef" = true; }
      { "${deps.socket2."0.3.5".winapi}"."ws2tcpip" = true; }
      { "${deps.socket2."0.3.5".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."socket2"."0.3.5"."cfg_if"}" deps)
    (features_.libc."${deps."socket2"."0.3.5"."libc"}" deps)
    (features_.winapi."${deps."socket2"."0.3.5"."winapi"}" deps)
  ];


# end
# stable_deref_trait-1.0.0

  crates.stable_deref_trait."1.0.0" = deps: { features?(features_.stable_deref_trait."1.0.0" deps {}) }: buildRustCrate {
    crateName = "stable_deref_trait";
    version = "1.0.0";
    description = "An unsafe marker trait for types like Box and Rc that dereference to a stable address even when moved, and hence can be used with libraries such as owning_ref and rental.\n";
    authors = [ "Robert Grosse <n210241048576@gmail.com>" ];
    sha256 = "0ya5fms9qdwkd52d3a111w4vcz18j4rbfx4p88z44116cqd6cczr";
    features = mkFeatures (features."stable_deref_trait"."1.0.0" or {});
  };
  features_.stable_deref_trait."1.0.0" = deps: f: updateFeatures f (rec {
    stable_deref_trait = fold recursiveUpdate {} [
      { "1.0.0"."std" =
        (f.stable_deref_trait."1.0.0"."std" or false) ||
        (f.stable_deref_trait."1.0.0".default or false) ||
        (stable_deref_trait."1.0.0"."default" or false); }
      { "1.0.0".default = (f.stable_deref_trait."1.0.0".default or true); }
    ];
  }) [];


# end
# strsim-0.7.0

  crates.strsim."0.7.0" = deps: { features?(features_.strsim."0.7.0" deps {}) }: buildRustCrate {
    crateName = "strsim";
    version = "0.7.0";
    description = "Implementations of string similarity metrics.\nIncludes Hamming, Levenshtein, OSA, Damerau-Levenshtein, Jaro, and Jaro-Winkler.\n";
    authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
    sha256 = "0fy0k5f2705z73mb3x9459bpcvrx4ky8jpr4zikcbiwan4bnm0iv";
  };
  features_.strsim."0.7.0" = deps: f: updateFeatures f (rec {
    strsim."0.7.0".default = (f.strsim."0.7.0".default or true);
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
  features_.synom."0.11.3" = deps: f: updateFeatures f (rec {
    synom."0.11.3".default = (f.synom."0.11.3".default or true);
    unicode_xid."${deps.synom."0.11.3".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."synom"."0.11.3"."unicode_xid"}" deps)
  ];


# end
# synstructure-0.6.1

  crates.synstructure."0.6.1" = deps: { features?(features_.synstructure."0.6.1" deps {}) }: buildRustCrate {
    crateName = "synstructure";
    version = "0.6.1";
    description = "expand_substructure-like helpers for syn macros 1.1 derive macros";
    authors = [ "Michael Layzell <michael@thelayzells.com>" ];
    sha256 = "1xnyw58va9zcqi4vvpnmpllacdj2a0mvy0cbd698izmr4qs92xlk";
    dependencies = mapFeatures features ([
      (crates."quote"."${deps."synstructure"."0.6.1"."quote"}" deps)
      (crates."syn"."${deps."synstructure"."0.6.1"."syn"}" deps)
    ]);
    features = mkFeatures (features."synstructure"."0.6.1" or {});
  };
  features_.synstructure."0.6.1" = deps: f: updateFeatures f (rec {
    quote."${deps.synstructure."0.6.1".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.synstructure."0.6.1".syn}"."visit" = true; }
      { "${deps.synstructure."0.6.1".syn}".default = true; }
    ];
    synstructure."0.6.1".default = (f.synstructure."0.6.1".default or true);
  }) [
    (features_.quote."${deps."synstructure"."0.6.1"."quote"}" deps)
    (features_.syn."${deps."synstructure"."0.6.1"."syn"}" deps)
  ];


# end
# systemfd-0.3.0

  crates.systemfd."0.3.0" = deps: { features?(features_.systemfd."0.3.0" deps {}) }: buildRustCrate {
    crateName = "systemfd";
    version = "0.3.0";
    description = "A convenient helper for passing sockets into another process.  Best to be combined with listenfd and cargo-watch.";
    authors = [ "Armin Ronacher <armin.ronacher@active-4.com>" ];
    sha256 = "0dpckgb0afyzhbv8lccgzmw5yczpfcdsdlqsfncn1vcxvcf0yb5i";
    dependencies = mapFeatures features ([
      (crates."clap"."${deps."systemfd"."0.3.0"."clap"}" deps)
      (crates."console"."${deps."systemfd"."0.3.0"."console"}" deps)
      (crates."failure"."${deps."systemfd"."0.3.0"."failure"}" deps)
      (crates."failure_derive"."${deps."systemfd"."0.3.0"."failure_derive"}" deps)
      (crates."lazy_static"."${deps."systemfd"."0.3.0"."lazy_static"}" deps)
      (crates."libc"."${deps."systemfd"."0.3.0"."libc"}" deps)
      (crates."regex"."${deps."systemfd"."0.3.0"."regex"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."nix"."${deps."systemfd"."0.3.0"."nix"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."socket2"."${deps."systemfd"."0.3.0"."socket2"}" deps)
      (crates."uuid"."${deps."systemfd"."0.3.0"."uuid"}" deps)
      (crates."winapi"."${deps."systemfd"."0.3.0"."winapi"}" deps)
    ]) else []);
  };
  features_.systemfd."0.3.0" = deps: f: updateFeatures f (rec {
    clap."${deps.systemfd."0.3.0".clap}".default = true;
    console."${deps.systemfd."0.3.0".console}".default = true;
    failure."${deps.systemfd."0.3.0".failure}".default = true;
    failure_derive."${deps.systemfd."0.3.0".failure_derive}".default = true;
    lazy_static."${deps.systemfd."0.3.0".lazy_static}".default = true;
    libc."${deps.systemfd."0.3.0".libc}".default = true;
    nix."${deps.systemfd."0.3.0".nix}".default = true;
    regex."${deps.systemfd."0.3.0".regex}".default = true;
    socket2."${deps.systemfd."0.3.0".socket2}".default = true;
    systemfd."0.3.0".default = (f.systemfd."0.3.0".default or true);
    uuid = fold recursiveUpdate {} [
      { "${deps.systemfd."0.3.0".uuid}"."v4" = true; }
      { "${deps.systemfd."0.3.0".uuid}".default = true; }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.systemfd."0.3.0".winapi}"."winsock2" = true; }
      { "${deps.systemfd."0.3.0".winapi}".default = true; }
    ];
  }) [
    (features_.clap."${deps."systemfd"."0.3.0"."clap"}" deps)
    (features_.console."${deps."systemfd"."0.3.0"."console"}" deps)
    (features_.failure."${deps."systemfd"."0.3.0"."failure"}" deps)
    (features_.failure_derive."${deps."systemfd"."0.3.0"."failure_derive"}" deps)
    (features_.lazy_static."${deps."systemfd"."0.3.0"."lazy_static"}" deps)
    (features_.libc."${deps."systemfd"."0.3.0"."libc"}" deps)
    (features_.regex."${deps."systemfd"."0.3.0"."regex"}" deps)
    (features_.nix."${deps."systemfd"."0.3.0"."nix"}" deps)
    (features_.socket2."${deps."systemfd"."0.3.0"."socket2"}" deps)
    (features_.uuid."${deps."systemfd"."0.3.0"."uuid"}" deps)
    (features_.winapi."${deps."systemfd"."0.3.0"."winapi"}" deps)
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
  features_.termion."1.5.1" = deps: f: updateFeatures f (rec {
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
# termios-0.2.2

  crates.termios."0.2.2" = deps: { features?(features_.termios."0.2.2" deps {}) }: buildRustCrate {
    crateName = "termios";
    version = "0.2.2";
    description = "Safe bindings for the termios library.";
    authors = [ "David Cuddeback <david.cuddeback@gmail.com>" ];
    sha256 = "0hjy4idvcapx9i6qbhf5536aqnf6rqk2aaj424sfwy7qhv6xmcx3";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."termios"."0.2.2"."libc"}" deps)
    ]);
  };
  features_.termios."0.2.2" = deps: f: updateFeatures f (rec {
    libc."${deps.termios."0.2.2".libc}".default = true;
    termios."0.2.2".default = (f.termios."0.2.2".default or true);
  }) [
    (features_.libc."${deps."termios"."0.2.2"."libc"}" deps)
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
  features_.textwrap."0.9.0" = deps: f: updateFeatures f (rec {
    textwrap."0.9.0".default = (f.textwrap."0.9.0".default or true);
    unicode_width."${deps.textwrap."0.9.0".unicode_width}".default = true;
  }) [
    (features_.unicode_width."${deps."textwrap"."0.9.0"."unicode_width"}" deps)
  ];


# end
# thread_local-0.3.5

  crates.thread_local."0.3.5" = deps: { features?(features_.thread_local."0.3.5" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.5";
    description = "Per-object thread-local storage";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0mkp0sp91aqsk7brgygai4igv751r1754rsxn37mig3ag5rx8np6";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."thread_local"."0.3.5"."lazy_static"}" deps)
      (crates."unreachable"."${deps."thread_local"."0.3.5"."unreachable"}" deps)
    ]);
  };
  features_.thread_local."0.3.5" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.thread_local."0.3.5".lazy_static}".default = true;
    thread_local."0.3.5".default = (f.thread_local."0.3.5".default or true);
    unreachable."${deps.thread_local."0.3.5".unreachable}".default = true;
  }) [
    (features_.lazy_static."${deps."thread_local"."0.3.5"."lazy_static"}" deps)
    (features_.unreachable."${deps."thread_local"."0.3.5"."unreachable"}" deps)
  ];


# end
# ucd-util-0.1.1

  crates.ucd_util."0.1.1" = deps: { features?(features_.ucd_util."0.1.1" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.1";
    description = "A small utility library for working with the Unicode character database.\n";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "02a8h3siipx52b832xc8m8rwasj6nx9jpiwfldw8hp6k205hgkn0";
  };
  features_.ucd_util."0.1.1" = deps: f: updateFeatures f (rec {
    ucd_util."0.1.1".default = (f.ucd_util."0.1.1".default or true);
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
  features_.unicode_width."0.1.4" = deps: f: updateFeatures f (rec {
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
  features_.unicode_xid."0.0.4" = deps: f: updateFeatures f (rec {
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
  features_.unreachable."1.0.0" = deps: f: updateFeatures f (rec {
    unreachable."1.0.0".default = (f.unreachable."1.0.0".default or true);
    void."${deps.unreachable."1.0.0".void}".default = (f.void."${deps.unreachable."1.0.0".void}".default or false);
  }) [
    (features_.void."${deps."unreachable"."1.0.0"."void"}" deps)
  ];


# end
# utf8-ranges-1.0.0

  crates.utf8_ranges."1.0.0" = deps: { features?(features_.utf8_ranges."1.0.0" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.0";
    description = "Convert ranges of Unicode codepoints to UTF-8 byte ranges.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0rzmqprwjv9yp1n0qqgahgm24872x6c0xddfym5pfndy7a36vkn0";
  };
  features_.utf8_ranges."1.0.0" = deps: f: updateFeatures f (rec {
    utf8_ranges."1.0.0".default = (f.utf8_ranges."1.0.0".default or true);
  }) [];


# end
# uuid-0.6.3

  crates.uuid."0.6.3" = deps: { features?(features_.uuid."0.6.3" deps {}) }: buildRustCrate {
    crateName = "uuid";
    version = "0.6.3";
    description = "A library to generate and parse UUIDs.\n";
    authors = [ "Ashley Mannix<ashleymannix@live.com.au>" "Christopher Armstrong" "Dylan DPC<dylan.dpc@gmail.com>" "Hunar Roop Kahlon<hunar.roop@gmail.com>" ];
    sha256 = "1kjp5xglhab4saaikn95zn3mr4zja7484pv307cb5bxm2sawb8p6";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."uuid"."0.6.3"."cfg_if"}" deps)
    ]
      ++ (if features.uuid."0.6.3".rand or false then [ (crates.rand."${deps."uuid"."0.6.3".rand}" deps) ] else []));
    features = mkFeatures (features."uuid"."0.6.3" or {});
  };
  features_.uuid."0.6.3" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.uuid."0.6.3".cfg_if}".default = true;
    rand."${deps.uuid."0.6.3".rand}".default = true;
    uuid = fold recursiveUpdate {} [
      { "0.6.3"."md5" =
        (f.uuid."0.6.3"."md5" or false) ||
        (f.uuid."0.6.3".v3 or false) ||
        (uuid."0.6.3"."v3" or false); }
      { "0.6.3"."rand" =
        (f.uuid."0.6.3"."rand" or false) ||
        (f.uuid."0.6.3".v3 or false) ||
        (uuid."0.6.3"."v3" or false) ||
        (f.uuid."0.6.3".v4 or false) ||
        (uuid."0.6.3"."v4" or false) ||
        (f.uuid."0.6.3".v5 or false) ||
        (uuid."0.6.3"."v5" or false); }
      { "0.6.3"."serde" =
        (f.uuid."0.6.3"."serde" or false) ||
        (f.uuid."0.6.3".playground or false) ||
        (uuid."0.6.3"."playground" or false); }
      { "0.6.3"."sha1" =
        (f.uuid."0.6.3"."sha1" or false) ||
        (f.uuid."0.6.3".v5 or false) ||
        (uuid."0.6.3"."v5" or false); }
      { "0.6.3"."std" =
        (f.uuid."0.6.3"."std" or false) ||
        (f.uuid."0.6.3".default or false) ||
        (uuid."0.6.3"."default" or false) ||
        (f.uuid."0.6.3".use_std or false) ||
        (uuid."0.6.3"."use_std" or false); }
      { "0.6.3"."v1" =
        (f.uuid."0.6.3"."v1" or false) ||
        (f.uuid."0.6.3".playground or false) ||
        (uuid."0.6.3"."playground" or false); }
      { "0.6.3"."v3" =
        (f.uuid."0.6.3"."v3" or false) ||
        (f.uuid."0.6.3".playground or false) ||
        (uuid."0.6.3"."playground" or false); }
      { "0.6.3"."v4" =
        (f.uuid."0.6.3"."v4" or false) ||
        (f.uuid."0.6.3".playground or false) ||
        (uuid."0.6.3"."playground" or false); }
      { "0.6.3"."v5" =
        (f.uuid."0.6.3"."v5" or false) ||
        (f.uuid."0.6.3".playground or false) ||
        (uuid."0.6.3"."playground" or false); }
      { "0.6.3".default = (f.uuid."0.6.3".default or true); }
    ];
  }) [
    (features_.cfg_if."${deps."uuid"."0.6.3"."cfg_if"}" deps)
    (features_.rand."${deps."uuid"."0.6.3"."rand"}" deps)
  ];


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
# winapi-0.2.8

  crates.winapi."0.2.8" = deps: { features?(features_.winapi."0.2.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.2.8";
    description = "Types and constants for WinAPI bindings. See README for list of crates providing function bindings.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
  };
  features_.winapi."0.2.8" = deps: f: updateFeatures f (rec {
    winapi."0.2.8".default = (f.winapi."0.2.8".default or true);
  }) [];


# end
# winapi-0.3.4

  crates.winapi."0.3.4" = deps: { features?(features_.winapi."0.3.4" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.4";
    description = "Raw FFI bindings for all of Windows API.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1qbrf5dcnd8j36cawby5d9r5vx07r0l4ryf672pfncnp8895k9lx";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.4"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.4"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.4" or {});
  };
  features_.winapi."0.3.4" = deps: f: updateFeatures f (rec {
    winapi."0.3.4".default = (f.winapi."0.3.4".default or true);
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.4".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.4".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.4"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.4"."winapi_x86_64_pc_windows_gnu"}" deps)
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
  features_.winapi_build."0.1.1" = deps: f: updateFeatures f (rec {
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
}

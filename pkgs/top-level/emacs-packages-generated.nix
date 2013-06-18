{ buildEmacsPackage, fetchurl, otherPackages }:
with otherPackages; rec {
  # Python TDD minor mode
  abl-mode = buildEmacsPackage {
    name = "abl-mode-0.9.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/abl-mode-0.9.0.el";
      sha256 = "1s3370nc0ipjcaw1ncdd4qra8a0i259pi60j173x9q1xlxcvq1ij";
    };
  
    deps = [  ];
  };

  # auto-complete-mode source for Japanese 
  ac-ja = buildEmacsPackage {
    name = "ac-ja-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ac-ja-0.0.1.el";
      sha256 = "1na219925hmxqsmxs18dlj33fvkmki7c9mnmhhk914qxwmayhsff";
    };
  
    deps = [  ];
  };

  # auto-complete sources for Clojure using nrepl completions
  ac-nrepl = buildEmacsPackage {
    name = "ac-nrepl-0.18";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ac-nrepl-0.18.el";
      sha256 = "1ln127mjcskdajnrb91c7pwk1rc8zzydx6lxliphfh37rgp1bqzk";
    };
  
    deps = [ nrepl auto-complete ];
  };

  # An auto-complete source using slime completions
  ac-slime = buildEmacsPackage {
    name = "ac-slime-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ac-slime-0.3.el";
      sha256 = "1ij163c6f5vaz0jrlshiwpzlnlfbrf3jgnafk0mdrqmym3nq0naf";
    };
  
    deps = [  ];
  };

  # a quick cursor location minor mode for emacs -*- coding: utf-8-unix -*-
  ace-jump-mode = buildEmacsPackage {
    name = "ace-jump-mode-2.0.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ace-jump-mode-2.0.0.0.el";
      sha256 = "1spm6axg6ar5ql4hzh5kfij07i41fq91nnna0kqqhl1fn708h61l";
    };
  
    deps = [  ];
  };

  # Interface to ack-like source code search tools
  ack = buildEmacsPackage {
    name = "ack-1.2";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/ack-1.2.tar";
      sha256 = "0nnbghypyn8r8als4lsvmnl9n4rf9pq6ljvamv4n17pk9xc1g2l3";
    };
  
    deps = [  ];
  };

  # Yet another front-end for ack
  ack-and-a-half = buildEmacsPackage {
    name = "ack-and-a-half-1.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ack-and-a-half-1.1.3.el";
      sha256 = "0cvg3zx6a8w5dw6ia2sllrkiwihc23c39df7w0gy1640wg0w5xl7";
    };
  
    deps = [  ];
  };

  # Smart line-wrapping with wrap-prefix
  adaptive-wrap = buildEmacsPackage {
    name = "adaptive-wrap-0.2";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/adaptive-wrap-0.2.el";
      sha256 = "12ff0r4ihmgs02p9ys7j87667pbw6mifs0zz5vnnv3ycbw4l30dy";
    };
  
    deps = [  ];
  };

  # a major-mode for editing AsciiDoc files in Emacs
  adoc-mode = buildEmacsPackage {
    name = "adoc-mode-0.6.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/adoc-mode-0.6.2.el";
      sha256 = "1a5l3rg43sx4yqkn94x9mczf0iyymzagfxh0g141arj5pfxmilgg";
    };
  
    deps = [ markup-faces ];
  };

  # Implementation of AES
  aes = buildEmacsPackage {
    name = "aes-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/aes-0.5.el";
      sha256 = "0grzikw48zfsfzp3rvzjfvw9w47b1f52z0m64miha0gl6jxwcryn";
    };
  
    deps = [  ];
  };

  # A front-end for ag ('the silver searcher'), the C ack replacement.
  ag = buildEmacsPackage {
    name = "ag-0.20";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ag-0.20.el";
      sha256 = "1w8psdmhqhpngv2mawjf0hjjrs4k5m3d1s1i000rir70byr49ny6";
    };
  
    deps = [  ];
  };

  # Alberto's Emacs interface for Mercurial (Hg)
  ahg = buildEmacsPackage {
    name = "ahg-0.99";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ahg-0.99.el";
      sha256 = "14zjyw2bspkdfxw66pyr8b64ipwb27sw853ah295d4l4aq2q3v7c";
    };
  
    deps = [  ];
  };

  # Space align various Clojure forms 
  align-cljlet = buildEmacsPackage {
    name = "align-cljlet-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/align-cljlet-0.3.el";
      sha256 = "0dqc796n36s72n6gxsrsr7cnxwcb81hkgflnbvvp11igr1xb82pi";
    };
  
    deps = [ clojure-mode ];
  };

  # Edit all lines matching a given regexp
  all = buildEmacsPackage {
    name = "all-1.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/all-1.0.el";
      sha256 = "17h4cp0xnh08szh3snbmn1mqq2smgqkn45bq7v0cpsxq1i301hi3";
    };
  
    deps = [  ];
  };

  # increase frame transparency
  alpha = buildEmacsPackage {
    name = "alpha-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/alpha-1.0.el";
      sha256 = "0z9h5hc01qjp3ifai0xwqvxiqw1i561mhgdy5j1c4g0rrkhg2waz";
    };
  
    deps = [  ];
  };

  # anaphoric macros providing implicit temp variables
  anaphora = buildEmacsPackage {
    name = "anaphora-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anaphora-0.1.0.el";
      sha256 = "026k0z5g30q2sfyb52pxflx76jnr9g63387bj4ivnl2nyla6zyiq";
    };
  
    deps = [  ];
  };

  # Minor mode for Android application development
  android-mode = buildEmacsPackage {
    name = "android-mode-0.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/android-mode-0.2.1.el";
      sha256 = "1lm0fd790w6flqy5kjq9xqniv2ks9sm7nkkkb8yllk6gcz5fim38";
    };
  
    deps = [  ];
  };

  # Yasnippets for AngularJS
  angular-snippets = buildEmacsPackage {
    name = "angular-snippets-0.2.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/angular-snippets-0.2.3.tar";
      sha256 = "0i68g58040c5gzxgzij9ixqmrhbp3f93vv0f8bqhf27pciq6gqlr";
    };
  
    deps = [ s dash ];
  };

  # open anything / QuickSilver-like candidate-selection framework
  anything = buildEmacsPackage {
    name = "anything-1.287";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-1.287.el";
      sha256 = "0nc6129qmknavp1sfl3whg6slwvc79zgvxjmvcs7yabqjpinkrxf";
    };
  
    deps = [  ];
  };

  # anything-sources and some utilities for GNU R.
  anything-R = buildEmacsPackage {
    name = "anything-R-0.1.2010";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-R-0.1.2010.el";
      sha256 = "1wfv7fmgnv1hvxsh16b1ijy4dw6jkiji9rx8j2w20vm8nxhj816g";
    };
  
    deps = [  ];
  };

  # completion with anything
  anything-complete = buildEmacsPackage {
    name = "anything-complete-1.86";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-complete-1.86.el";
      sha256 = "0g0ph7f89ql07d7z25n0c2dx6j4gbjy9imzdf5wnchfdl8p0n1bb";
    };
  
    deps = [  ];
  };

  # Predefined configurations for `anything.el'
  anything-config = buildEmacsPackage {
    name = "anything-config-0.4.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-config-0.4.1.el";
      sha256 = "1ncxpmks60yqfc2g42fmnr0qgn6l4g4klsgwyxxj0igrw4ma20hs";
    };
  
    deps = [  ];
  };

  # anything-sources for el-swank-fuzzy.el
  anything-el-swank-fuzzy = buildEmacsPackage {
    name = "anything-el-swank-fuzzy-0.1.2009";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-el-swank-fuzzy-0.1.2009.el";
      sha256 = "0dnbxm99sx2rv71s90sybrzww4w4qjx4iav91v2a8r5ir1yj41ci";
    };
  
    deps = [  ];
  };

  # Extension functions for anything.el
  anything-extension = buildEmacsPackage {
    name = "anything-extension-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-extension-0.2.el";
      sha256 = "12gmim9nq838hsw09kl6nq7v6k3a3ssvlkc8gydyxga77qj8fvin";
    };
  
    deps = [  ];
  };

  # Exuberant ctags anything.el interface
  anything-exuberant-ctags = buildEmacsPackage {
    name = "anything-exuberant-ctags-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-exuberant-ctags-0.1.2.el";
      sha256 = "0z8iz1953j183m2vb7pf5zll5ylb4dajjn5khxp29lg1ysy1az2s";
    };
  
    deps = [  ];
  };

  # Show git files in anything
  anything-git = buildEmacsPackage {
    name = "anything-git-1.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-git-1.1.1.el";
      sha256 = "0z5nz45mnwy2wgs1863rx016i1n4yy01bjhmqkhs3lqrxpr4p0gj";
    };
  
    deps = [  ];
  };

  # Quick listing of:
  anything-git-goto = buildEmacsPackage {
    name = "anything-git-goto-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-git-goto-0.1.0.el";
      sha256 = "03nckrpbnqzh79rn5k08nz844k0hmf9yqqb9rb1fjx0w73478c91";
    };
  
    deps = [  ];
  };

  #  Ipython anything
  anything-ipython = buildEmacsPackage {
    name = "anything-ipython-0.1.2009";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-ipython-0.1.2009.el";
      sha256 = "0jk5ivb0cimqhbvfx1j4gj9galc9r4ki6984qrhcp9kfpbvgypaz";
    };
  
    deps = [  ];
  };

  # Humane match plug-in for anything
  anything-match-plugin = buildEmacsPackage {
    name = "anything-match-plugin-1.27";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-match-plugin-1.27.el";
      sha256 = "0wg5pprwk8c8ai3vj5zpcvrhkq0c3dxmzmh1nb5pvbclkibd400n";
    };
  
    deps = [  ];
  };

  # obsolete functions of anything
  anything-obsolete = buildEmacsPackage {
    name = "anything-obsolete-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-obsolete-0.1.el";
      sha256 = "1s7g9ll1ib5n7s4vbdkpwykk00nhp3d6ycrq9r2faqbczrzj1yy7";
    };
  
    deps = [  ];
  };

  # Show selection in buffer for anything completion
  anything-show-completion = buildEmacsPackage {
    name = "anything-show-completion-20091119";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/anything-show-completion-20091119.el";
      sha256 = "1z8ncdhnjx2s7mp6h8ichg87qpqdc2rv4aakg60k0hhzlaiqj6yj";
    };
  
    deps = [  ];
  };

  # major mode for editing Apache configuration files
  apache-mode = buildEmacsPackage {
    name = "apache-mode-2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/apache-mode-2.0.el";
      sha256 = "0c252y95n24048hzp31dlq5py3s7ak32z9sxibkr18gr7sbsi03i";
    };
  
    deps = [  ];
  };

  # major mode for editing AppleScript source
  applescript-mode = buildEmacsPackage {
    name = "applescript-mode-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/applescript-mode-1.1.el";
      sha256 = "1y0v5nr9f9wfiijchmwsin7ifshzs14ybd0ps83023n9cq776kjr";
    };
  
    deps = [  ];
  };

  # Emacs interface to APT (Debian package management)
  apt-utils = buildEmacsPackage {
    name = "apt-utils-1.212";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/apt-utils-1.212.el";
      sha256 = "19lylar8mfrmv9y1pgqd9i81m1qdwgvnwn3m3ibsb8a7bvsmpf33";
    };
  
    deps = [  ];
  };

  # Ido commands for apt-utils
  apt-utils-ido = buildEmacsPackage {
    name = "apt-utils-ido-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/apt-utils-ido-0.2.el";
      sha256 = "1r230yrkg234qcahzr91m0mka5dq3ml44qmzjbgb7p5pski89h44";
    };
  
    deps = [ apt-utils ];
  };

  # ASCII code display.
  ascii = buildEmacsPackage {
    name = "ascii-3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ascii-3.1.el";
      sha256 = "0dc6nmlsfnc9p24lq0ynlnzs6ccx8i2my39b45akpq587q2nwkqq";
    };
  
    deps = [  ];
  };

  # Integrated environment for *TeX*
  auctex = buildEmacsPackage {
    name = "auctex-11.86";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/auctex-11.86.tar";
      sha256 = "07042990pgms02aq3fpymh23bdi7pjp1mkqv1b52hw5z9vjnbj60";
    };
  
    deps = [  ];
  };

  # Auto Completion for GNU Emacs
  auto-complete = buildEmacsPackage {
    name = "auto-complete-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/auto-complete-1.4.tar";
      sha256 = "0xx1dm4wxvcmyibjlc7lshmqgnic8j57kyfgswm54ssnjj6h8khk";
    };
  
    deps = [ popup ];
  };

  # Automatic highlighting current symbol minor mode
  auto-highlight-symbol = buildEmacsPackage {
    name = "auto-highlight-symbol-1.55";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/auto-highlight-symbol-1.55.el";
      sha256 = "1dacp9ylj7rjczcn6rfzp419rc3a1pi35y7mkjdkz12hv107vln9";
    };
  
    deps = [  ];
  };

  # Auto indent Minor mode
  auto-indent-mode = buildEmacsPackage {
    name = "auto-indent-mode-0.99";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/auto-indent-mode-0.99.el";
      sha256 = "0wcr4h6k90hfy96pdvsvqs1s9z1n6nacik7vd2mpnr06lyvzlfb1";
    };
  
    deps = [  ];
  };

  # Automagically pair braces and quotes like TextMate
  autopair = buildEmacsPackage {
    name = "autopair-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/autopair-0.3.el";
      sha256 = "1wspnf8win5pl1wa5jcxwi7w65cw6727c54gip518153mfb8cgdv";
    };
  
    deps = [  ];
  };

  # Run AWK interactively on region!
  awk-it = buildEmacsPackage {
    name = "awk-it-0.76";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/awk-it-0.76.el";
      sha256 = "1vps0xk5pjc3z9sb75ajmz26163wjj2ccglg48g1mv8al79kn6kp";
    };
  
    deps = [  ];
  };

  # Core Emacs configuration. This should be the minimum in every emacs config.
  babcore = buildEmacsPackage {
    name = "babcore-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/babcore-0.0.2.el";
      sha256 = "0phi0i828900rmv7hcarzyw67farrcrrv5r9bggag35s9jv8nxjy";
    };
  
    deps = [  ];
  };

  # Visual navigation through mark rings
  back-button = buildEmacsPackage {
    name = "back-button-0.6.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/back-button-0.6.4.el";
      sha256 = "06pvb88jx1vz8fa24nx3aagphy0yylsj937h5gbzh0sda7jx2ahn";
    };
  
    deps = [ nav-flash smartrep ucs-utils persistent-soft pcache ];
  };

  # A better way to browse /var/log/messages files
  backtrace-mode = buildEmacsPackage {
    name = "backtrace-mode-0.0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/backtrace-mode-0.0.10.el";
      sha256 = "0160gphyla1dsqb385avijwnqraj9z8a9b25jas3kwyzpdhrn08q";
    };
  
    deps = [  ];
  };

  # A modern list library for Emacs
  bang = buildEmacsPackage {
    name = "bang-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bang-0.1.0.el";
      sha256 = "1hbabgp2mni2bhpxf51cm26b8xsnmckvif9g0ya17ilzh53av550";
    };
  
    deps = [  ];
  };

  # package used to switch block cursor to a bar
  bar-cursor = buildEmacsPackage {
    name = "bar-cursor-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bar-cursor-1.1.el";
      sha256 = "18qq3df9d3m8zxpgyavrxg4rc3hw1064hyfshfw924slxpikjsq4";
    };
  
    deps = [  ];
  };

  # major mode for editing ESRI batch scrips
  batch-mode = buildEmacsPackage {
    name = "batch-mode-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/batch-mode-1.0.el";
      sha256 = "04rqysads3b974wdb3qjrn56wmlv69qdwzx8w9r9lhqvgymkb16m";
    };
  
    deps = [  ];
  };

  # Major mode for writing BBCode markup
  bbcode-mode = buildEmacsPackage {
    name = "bbcode-mode-1.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bbcode-mode-1.1.0.el";
      sha256 = "0svsrw4v3q30llvryzkf0ir7q6zv244l2d633wgnbnfh8cvgyamw";
    };
  
    deps = [  ];
  };

  # Extra commands for BBDB
  bbdb-ext = buildEmacsPackage {
    name = "bbdb-ext-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bbdb-ext-0.1.el";
      sha256 = "09gz07snyxka90myhif2j03za8g0fk1wg30b92shpgwx7sidkkx6";
    };
  
    deps = [ bbdb ];
  };

  # Fixing weird quirks and poor defaults
  better-defaults = buildEmacsPackage {
    name = "better-defaults-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/better-defaults-0.1.2.el";
      sha256 = "18zql45jrwsq4dvqwdracgi5zvm21pvff1w4lh0ng4xhmq9njyl7";
    };
  
    deps = [  ];
  };

  # A simple bigint package for emacs
  bigint = buildEmacsPackage {
    name = "bigint-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bigint-1.0.0.el";
      sha256 = "1wzbnkvw7fcaqnafpsbb3r2rj4v1vrq3b9cpc59cddplplig6cac";
    };
  
    deps = [  ];
  };

  # Help get Bitlbee (http://www.bitlbee.org) up and running
  bitlbee = buildEmacsPackage {
    name = "bitlbee-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bitlbee-1.0.el";
      sha256 = "0lmix9clcwwcnaf21m9flkiminc81kgnd9cf8vj07gwxbj6s9an2";
    };
  
    deps = [  ];
  };

  # Shorten URLs using the bitly.com shortener service
  bitly = buildEmacsPackage {
    name = "bitly-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bitly-1.0.el";
      sha256 = "077lhyy2pyvqkz6jd3fb15x5d3rirz9ac9p9ibjnxgi3fq4l795y";
    };
  
    deps = [  ];
  };

  # Visible bookmarks in buffer.
  bm = buildEmacsPackage {
    name = "bm-1.53";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bm-1.53.el";
      sha256 = "1kcnf24zc3whnplghsv8d2aag0i30ymxgsy1hcva6zryypqvsj0l";
    };
  
    deps = [  ];
  };

  # Bookmark Plus
  bookmark-plus = buildEmacsPackage {
    name = "bookmark-plus-20111214";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bookmark+-20111214.tar";
      sha256 = "1r2ag8b74a8szd7q7rzylvy6xhff5abc6nrpz1nljs96i0sczi5p";
    };
  
    deps = [  ];
  };

  # Quote text with a semi-box.
  boxquote = buildEmacsPackage {
    name = "boxquote-1.23";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/boxquote-1.23.el";
      sha256 = "08pd4sim2k3n0vdsd3nv8gyamiwpnijia7ldk3113g6jdlm6jvs9";
    };
  
    deps = [  ];
  };

  # interactively insert items from kill-ring -*- coding: utf-8 -*-
  browse-kill-ring = buildEmacsPackage {
    name = "browse-kill-ring-1.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/browse-kill-ring-1.3.1.el";
      sha256 = "0j9ddhm436cpd1dbwmpsqr6l7pj6nxp2vp6x569kz04v8h8kcn9g";
    };
  
    deps = [  ];
  };

  # Context-sensitive external browse URL or Internet search
  browse-url-dwim = buildEmacsPackage {
    name = "browse-url-dwim-0.6.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/browse-url-dwim-0.6.4.el";
      sha256 = "11976fa5sakr07cj9ks5y5ma44qvy0ym1kb44fsdid1gx8ag22i9";
    };
  
    deps = [ string-utils ];
  };

  # Extensions to emacs buffer-selection library (bs.el)
  bs-ext = buildEmacsPackage {
    name = "bs-ext-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bs-ext-0.2.el";
      sha256 = "15j74bki5ycgwqm995rnpc3h5c18l60c4isbkdhzs3ywipkdlzc9";
    };
  
    deps = [  ];
  };

  # swap buffers between windows
  buffer-move = buildEmacsPackage {
    name = "buffer-move-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/buffer-move-0.4.el";
      sha256 = "102v18zbr9l2zdj4wijjan0dnnla5zbm0pscj54zd6vkhddxdckp";
    };
  
    deps = [  ];
  };

  # Enhanced intelligent switch-to-other-buffer replacement.
  buffer-stack = buildEmacsPackage {
    name = "buffer-stack-1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/buffer-stack-1.5.el";
      sha256 = "0ziv3ahzi5z1124hcbk4rxdma68k99ixrzxs18nyzsffnl1sg441";
    };
  
    deps = [  ];
  };

  # Buffer-manipulation utility functions
  buffer-utils = buildEmacsPackage {
    name = "buffer-utils-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/buffer-utils-0.0.3.el";
      sha256 = "12c9ckz44hbg587rwakrndfjsa9rayax6n3wmy21p94ap5q95zfd";
    };
  
    deps = [  ];
  };

  # A simple presentation tool for Emacs.
  bufshow = buildEmacsPackage {
    name = "bufshow-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bufshow-0.1.0.tar";
      sha256 = "0ycb2hnnjiv60gpvpl383pdipai0f1wx5cgp9kkp9dwqgf3nyyi8";
    };
  
    deps = [  ];
  };

  # Automatically set `bug-reference-url-format' in Github repositories.
  bug-reference-github = buildEmacsPackage {
    name = "bug-reference-github-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/bug-reference-github-0.1.0.el";
      sha256 = "05x4kix4sajhsjbf7g6s9y1mp3rj0kpqfvv2ibgkf5zbvmm1dhxb";
    };
  
    deps = [  ];
  };

  # Client for Jenkins
  butler = buildEmacsPackage {
    name = "butler-0.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/butler-0.1.3.el";
      sha256 = "062vp30kw04yd48n6z216r413x97111v998l13gh4wh5lda9ncig";
    };
  
    deps = [ web ];
  };

  # Clickable text defined by regular expression
  button-lock = buildEmacsPackage {
    name = "button-lock-0.9.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/button-lock-0.9.10.el";
      sha256 = "0wpr5zvc74qwcky2mrz26g3y3ll7z92j5zmiz1mqysdk7vg18lhg";
    };
  
    deps = [  ];
  };

  # helpful description of the arguments to C functions
  c-eldoc = buildEmacsPackage {
    name = "c-eldoc-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/c-eldoc-0.5.el";
      sha256 = "0jn2y2afg0l8vyd01jwm3q2wpwzhm2k19bk3c5r21k9nzl0gvpkk";
    };
  
    deps = [  ];
  };

  # implementation of a hash table whose key-value pairs expire
  cache = buildEmacsPackage {
    name = "cache-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cache-0.1.el";
      sha256 = "1icdaxa3r6d156fbn3ay9sbkr5syxsddpbjx40v1qf1f6syplyf6";
    };
  
    deps = [  ];
  };

  # Minor mode for Cacoo : http://cacoo.com
  cacoo = buildEmacsPackage {
    name = "cacoo-2.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cacoo-2.1.2.tar";
      sha256 = "170d0zgjk2f0idajgpyyz2g2m2pkn4cwdfxkfw5jpbmrf6w11n0n";
    };
  
    deps = [ concurrent ];
  };

  # edit Google calendar for calfw.el.
  calfw-gcal = buildEmacsPackage {
    name = "calfw-gcal-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/calfw-gcal-0.0.1.el";
      sha256 = "00539a506ysq6k886h28wawpq3ylgn7b9gqsnrcia7s5pkjawnsn";
    };
  
    deps = [  ];
  };

  # OCaml code editing commands for Emacs
  caml = buildEmacsPackage {
    name = "caml-3.12.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/caml-3.12.0.1.tar";
      sha256 = "0n491hcv7vagym6z7azn4rzvrbrmd3mdhqi9sgkkchgclm989p36";
    };
  
    deps = [  ];
  };

  # Fast input methods for LaTeX environments and math
  cdlatex = buildEmacsPackage {
    name = "cdlatex-4.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cdlatex-4.0.el";
      sha256 = "01123yi1zi60yzhj7vlsg4q7ynshfklhm5q53y5gzyx1nz65pm4r";
    };
  
    deps = [  ];
  };

  # Center the text in a fixed-width column
  center-text = buildEmacsPackage {
    name = "center-text-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/center-text-0.8.el";
      sha256 = "101x842z9cnyzzvs1yjian53ywgfv3nhx9b930knqkacah9rfpb8";
    };
  
    deps = [  ];
  };

  # cursor stays vertically centered
  centered-cursor-mode = buildEmacsPackage {
    name = "centered-cursor-mode-0.5.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/centered-cursor-mode-0.5.1.el";
      sha256 = "1xmps537lmkxncwzv4c4flkxj8aabrk898mmvx29mqkaq3wcg5yy";
    };
  
    deps = [  ];
  };

  # Unicode table for Emacs
  charmap = buildEmacsPackage {
    name = "charmap-0.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/charmap-0.0.0.el";
      sha256 = "0v2qfqkbkgz7gks9wnd17i15i5rl3prrljhrb8pbwgslhy68p7v5";
    };
  
    deps = [  ];
  };

  # Scheme-mode extensions for Chicken Scheme
  chicken-scheme = buildEmacsPackage {
    name = "chicken-scheme-1.0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/chicken-scheme-1.0.6.el";
      sha256 = "1ja6z0mzjggfdh3jxyn6yd0r8f458xwv2iv122x8j15a3ah4a5gq";
    };
  
    deps = [  ];
  };

  # Client for IRC in Emacs
  circe = buildEmacsPackage {
    name = "circe-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/circe-1.2.tar";
      sha256 = "1a7yr1jjp2syk1xqxzakj68wr6h68n7a9jxcv81f2cv26yznf7pb";
    };
  
    deps = [ lui lcs ];
  };

  # Major mode for editing Citrus files
  citrus-mode = buildEmacsPackage {
    name = "citrus-mode-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/citrus-mode-0.0.2.el";
      sha256 = "1yhw1dfmb9089pw78r398y3b5wq0bpvpvv1ys00nrv0bq2fsqpf2";
    };
  
    deps = [  ];
  };

  # CL format routine.
  cl-format = buildEmacsPackage {
    name = "cl-format-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cl-format-1.1.tar";
      sha256 = "06llzymdppy0s53cvrkz6sc0n3768h97rsspqdj8zy0khyxgqyrw";
    };
  
    deps = [  ];
  };

  # Properly prefixed CL functions and macros
  cl-lib = buildEmacsPackage {
    name = "cl-lib-0.3";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/cl-lib-0.3.el";
      sha256 = "1k7wkm7xf918ivgvf0mk8m18y66z07xjg8lhrh43v3byibhc75kd";
    };
  
    deps = [  ];
  };

  # Show tooltip with function documentation at point
  clippy = buildEmacsPackage {
    name = "clippy-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clippy-1.0.el";
      sha256 = "02xryf3gvm3rkfy29d5hrm486dby0z3c9jcqnlp96mkqswy5zzya";
    };
  
    deps = [ pos-tip ];
  };

  # Major mode for editing CLIPS code and REPL
  clips-mode = buildEmacsPackage {
    name = "clips-mode-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clips-mode-0.6.tar";
      sha256 = "05fjqj992c7hkhbn469i60cfxadwdfs9ayz1skf92nakzp6l43jg";
    };
  
    deps = [  ];
  };

  # basic Major mode (clj) for Clojure code
  clj-mode = buildEmacsPackage {
    name = "clj-mode-0.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clj-mode-0.9.el";
      sha256 = "0cgkdsw26nnjxbd77a69f8sp94qjp53q00zannagjvlwdck39yn5";
    };
  
    deps = [  ];
  };

  # A collection of clojure refactoring functions
  clj-refactor = buildEmacsPackage {
    name = "clj-refactor-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clj-refactor-0.2.0.el";
      sha256 = "0r2256pjw0pxv3273a04fcdjfpid9i13rdh0p0c8kqvdwvd5prj4";
    };
  
    deps = [ s dash yasnippet ];
  };

  # eldoc mode for clojure
  cljdoc = buildEmacsPackage {
    name = "cljdoc-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cljdoc-0.1.0.el";
      sha256 = "1kaq15z98mrd3lvs454w7spv9yi4mis5kpql9apx7z5hx38yxc25";
    };
  
    deps = [  ];
  };

  # A minor mode for the ClojureScript 'lein cljsbuild' command
  cljsbuild-mode = buildEmacsPackage {
    name = "cljsbuild-mode-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cljsbuild-mode-0.2.0.el";
      sha256 = "07wlhilnlw6invk79f1xi3sl3dgqvnnr7ylbi1gccqvnhcygsd5n";
    };
  
    deps = [  ];
  };

  # Major mode for Clojure code
  clojure-mode = buildEmacsPackage {
    name = "clojure-mode-2.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clojure-mode-2.1.0.el";
      sha256 = "03s0xzvz2hkaa8ay330hhd69awi5vgzdk3abjz48qa6sy62fsgn4";
    };
  
    deps = [  ];
  };

  # Extends project-mode for Clojure projects
  clojure-project-mode = buildEmacsPackage {
    name = "clojure-project-mode-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clojure-project-mode-1.0.el";
      sha256 = "1siwq3l2ppd0kr5dcipj1p63h0ylgrcrjgary070z8rghwxhvc0f";
    };
  
    deps = [ project-mode ];
  };

  # Minor mode for Clojure tests
  clojure-test-mode = buildEmacsPackage {
    name = "clojure-test-mode-2.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clojure-test-mode-2.1.0.el";
      sha256 = "0xwikwsri6c0yrrvms7rlaalw6rlcdf9yqk6h5aina9sadc2ifwz";
    };
  
    deps = [ clojure-mode nrepl ];
  };

  # Major mode for ClojureScript code
  clojurescript-mode = buildEmacsPackage {
    name = "clojurescript-mode-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/clojurescript-mode-0.5.el";
      sha256 = "076xfphcdkv9wyznwb4jmagdvw3hjnb1smfadsfbmjhwvbz0r30s";
    };
  
    deps = [  ];
  };

  # minor mode for the Closure Linter
  closure-lint-mode = buildEmacsPackage {
    name = "closure-lint-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/closure-lint-mode-0.1.el";
      sha256 = "1nbbxgd2lgy91iv3b9rphr0x6dwm3cml1vscs1apkgk2fxb1jw76";
    };
  
    deps = [  ];
  };

  # highlighting for google closure templates
  closure-template-html-mode = buildEmacsPackage {
    name = "closure-template-html-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/closure-template-html-mode-0.1.el";
      sha256 = "1v7av18m9nrl5jx8ypn304wmz2y5byd0m24d620v65849438nz2i";
    };
  
    deps = [  ];
  };

  # Wrapper for CodeMirror-style Emacs modes
  cm-mode = buildEmacsPackage {
    name = "cm-mode-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cm-mode-0.1.0.el";
      sha256 = "0f6b7mdjwig4zw1yijbz6dcfs94w5gs3x5ijsiv2ibxdyzp19aix";
    };
  
    deps = [  ];
  };

  # major-mode for editing CMake sources
  cmake-mode = buildEmacsPackage {
    name = "cmake-mode-20110824";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cmake-mode-20110824.el";
      sha256 = "10l38aidic740rbbkh5lilazjlnxi0k97wa9ihm37p74qgksdipq";
    };
  
    deps = [  ];
  };

  # Integrates CMake build process with Emacs
  cmake-project = buildEmacsPackage {
    name = "cmake-project-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cmake-project-0.6.el";
      sha256 = "0pd7pcbgy6rp4k9w3xk6gf12rfsjzs91d1ymsnig440s8zynlf2m";
    };
  
    deps = [  ];
  };

  # Navigate code with headers embedded in comments.  -*- mode: Emacs-Lisp; lexical-binding: t; -*
  code-headers = buildEmacsPackage {
    name = "code-headers-0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/code-headers-0.7.el";
      sha256 = "1w6s18aw9fc0jin785pndnzmkz5iij1f9h1gqjdq1gny6insvc0y";
    };
  
    deps = [  ];
  };

  # Major mode for CoffeeScript files
  coffee-mode = buildEmacsPackage {
    name = "coffee-mode-0.4.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/coffee-mode-0.4.1.tar";
      sha256 = "08dgmkq45h1h5xf1jhk6ry89r443nb64c4x2i8ggz6pr5fsxrpbf";
    };
  
    deps = [  ];
  };

  # Highlight the current column.
  col-highlight = buildEmacsPackage {
    name = "col-highlight-22.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/col-highlight-22.0.el";
      sha256 = "0kvgfpl5jwjal4ldn4i9p77xg43rqjv3ll0mhcd9rxmkg417c5zh";
    };
  
    deps = [ vline ];
  };

  # add colors to file completion
  color-file-completion = buildEmacsPackage {
    name = "color-file-completion-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-file-completion-1.0.1.el";
      sha256 = "0wsbj19x10qvlkc2dgjnm615aa6nhnyzjyw2p7xb743zf21xay9g";
    };
  
    deps = [  ];
  };

  # install color themes
  color-theme = buildEmacsPackage {
    name = "color-theme-6.5.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-6.5.5.el";
      sha256 = "118rszcambbkgn38lmrz6k2wrwx5mb5ljyyxkpnxpkrbxdb6b7jx";
    };
  
    deps = [  ];
  };

  # Active theme inspired by jEdit theme of the same name
  color-theme-active = buildEmacsPackage {
    name = "color-theme-active-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-active-0.0.1.el";
      sha256 = "0lvx9378jvmqp1qx631ms1hi1wxgm0n1jhpcl8ivv0qb719r8ipv";
    };
  
    deps = [ color-theme ];
  };

  # A dark color theme for GNU Emacs.
  color-theme-actress = buildEmacsPackage {
    name = "color-theme-actress-0.2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-actress-0.2.2.el";
      sha256 = "17y0cc8d52nd639f8b4a32gwwmk7sv6ay1y514c6r0s11x8hajn7";
    };
  
    deps = [ color-theme ];
  };

  # Blackboard Colour Theme for Emacs.
  color-theme-blackboard = buildEmacsPackage {
    name = "color-theme-blackboard-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-blackboard-0.0.2.el";
      sha256 = "0asglmxdxfrcnk80742vmwid2q589g7my4mv1h673jrk2xsmskc7";
    };
  
    deps = [ color-theme ];
  };

  # Install color-themes by buffer.
  color-theme-buffer-local = buildEmacsPackage {
    name = "color-theme-buffer-local-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-buffer-local-0.0.2.el";
      sha256 = "145acyl251a21z8p9s9iq74lk7qsqfwdz1hsgd7cy46817by6ryk";
    };
  
    deps = [  ];
  };

  # Cobalt Color Theme for Emacs
  color-theme-cobalt = buildEmacsPackage {
    name = "color-theme-cobalt-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-cobalt-0.0.2.el";
      sha256 = "1lgh8hknaqbhq7xc7lasws78ymyhbcl7qiij0c791z85miclkp6m";
    };
  
    deps = [ color-theme ];
  };

  # Colorful Obsolescence theme designed for partially transparent windows
  color-theme-colorful-obsolescence = buildEmacsPackage {
    name = "color-theme-colorful-obsolescence-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-colorful-obsolescence-0.0.1.el";
      sha256 = "16gybafk3wf6r125n1rg9yycl0zjhv8qsprk6as35i1cyv96kahs";
    };
  
    deps = [ color-theme ];
  };

  # A black and green color theme for Emacs.
  color-theme-complexity = buildEmacsPackage {
    name = "color-theme-complexity-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-complexity-0.1.0.el";
      sha256 = "07s9j48iw4310xk1k5qnbjg4jzl7z20djxqv2pivkwn1dnb2kckp";
    };
  
    deps = [ color-theme ];
  };

  # color theme of dawn and night.
  color-theme-dawn-night = buildEmacsPackage {
    name = "color-theme-dawn-night-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-dawn-night-1.0.el";
      sha256 = "14r386b9a9r900pfcrlswa4q0vwmbwwz2kkp9byj453675ig3r2v";
    };
  
    deps = [  ];
  };

  # A black and green color theme for Emacs.
  color-theme-dg = buildEmacsPackage {
    name = "color-theme-dg-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-dg-0.1.0.el";
      sha256 = "13mhdv0qqg125yr03akv10a3933v0v51s3r12fk8d49wycnp4yld";
    };
  
    deps = [ color-theme ];
  };

  # Dpaste color theme for GNU Emacs.
  color-theme-dpaste = buildEmacsPackage {
    name = "color-theme-dpaste-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-dpaste-0.0.1.el";
      sha256 = "0l3j6nnlszf5abrldslcydggckqdq7pi2zvcan58hk50a5d98ajq";
    };
  
    deps = [ color-theme ];
  };

  # Eclipse color theme for GNU Emacs.
  color-theme-eclipse = buildEmacsPackage {
    name = "color-theme-eclipse-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-eclipse-0.0.2.el";
      sha256 = "19rzcccqz5bc1adfaa8l4pgzrl706ws0zqxmdhx0y8wqrrffy2gj";
    };
  
    deps = [ color-theme ];
  };

  # Color-theme revert to emacs colors
  color-theme-emacs-revert-theme = buildEmacsPackage {
    name = "color-theme-emacs-revert-theme-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-emacs-revert-theme-0.1.el";
      sha256 = "153728k12ccdlapik8iws5jd2i20lw19wmvmcqp1s0l3ds2fdq36";
    };
  
    deps = [  ];
  };

  # Github color theme for GNU Emacs.
  color-theme-github = buildEmacsPackage {
    name = "color-theme-github-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-github-0.0.3.el";
      sha256 = "1mj5zyk76ydmg4dkmki9q9ii3l64l0rr4pcpnb9hd8m49zvwp146";
    };
  
    deps = [ color-theme ];
  };

  # Gruber Darker color theme for Emacs by Jason Blevins
  color-theme-gruber-darker = buildEmacsPackage {
    name = "color-theme-gruber-darker-1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-gruber-darker-1.el";
      sha256 = "1fd83fyfrd8sbayrhbwfbsnxkbfhbx2alladz426q5pl4mzz16d8";
    };
  
    deps = [ color-theme ];
  };

  # Heroku color theme
  color-theme-heroku = buildEmacsPackage {
    name = "color-theme-heroku-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-heroku-1.0.0.el";
      sha256 = "0hcpfbnmvn7y78s7qx1wqan1h5a3kzw0pkvakrljkya2xkbxc4kf";
    };
  
    deps = [  ];
  };

  # pastel color theme 
  color-theme-ir-black = buildEmacsPackage {
    name = "color-theme-ir-black-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-ir-black-1.0.1.el";
      sha256 = "183k5ww6rx9vp5xl0rfzpv9gihg0qk70gx831wi836x97p7m5dsc";
    };
  
    deps = [ color-theme ];
  };

  # The real color theme functions
  color-theme-library = buildEmacsPackage {
    name = "color-theme-library-0.0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-library-0.0.10.el";
      sha256 = "09w1d8fcm53mp7q6a9wmqbp9m0x8zx41rs5r2c9vhq5zkypagjsf";
    };
  
    deps = [ color-theme ];
  };

  # Molokai color theme by Lloyd
  color-theme-molokai = buildEmacsPackage {
    name = "color-theme-molokai-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-molokai-0.1.el";
      sha256 = "1qj0y8p3jydg2zxmnws4xxslw1hn21n5s42i7skz2nby6ik751s8";
    };
  
    deps = [  ];
  };

  # Monokai Color Theme for Emacs.
  color-theme-monokai = buildEmacsPackage {
    name = "color-theme-monokai-0.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-monokai-0.0.5.el";
      sha256 = "0apx17vysv0ixiymn3kg4bmpx9psj2s0rvmda5mivf3zjr0z9h99";
    };
  
    deps = [ color-theme ];
  };

  # Railscasts color theme for GNU Emacs.
  color-theme-railscasts = buildEmacsPackage {
    name = "color-theme-railscasts-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-railscasts-0.0.2.el";
      sha256 = "0x665mq5bbf57sfz0ifldyp06pjxwgkbvk8ckgqqa6i7k0gqbs37";
    };
  
    deps = [ color-theme ];
  };

  # A version of Ethan Schoonover's Solarized themes
  color-theme-sanityinc-solarized = buildEmacsPackage {
    name = "color-theme-sanityinc-solarized-2.25";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-sanityinc-solarized-2.25.tar";
      sha256 = "1q6bjk5a7alwcmlcpng6n8lvsjzzwmqzc0m1sw2srp0cgw47s1xw";
    };
  
    deps = [  ];
  };

  # A version of Chris Kempson's various Tomorrow themes
  color-theme-sanityinc-tomorrow = buildEmacsPackage {
    name = "color-theme-sanityinc-tomorrow-1.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-sanityinc-tomorrow-1.10.tar";
      sha256 = "0kb6s3jnpmhy0sz84sx0d7blpsqs7n0vb0zszn70xsl68ipjg0sr";
    };
  
    deps = [  ];
  };

  # Solarized themes for Emacs
  color-theme-solarized = buildEmacsPackage {
    name = "color-theme-solarized-20120301";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-solarized-20120301.tar";
      sha256 = "136nvqalhic32552cr8fgls32d6z8ci1324mm35zpsan1sggy8lw";
    };
  
    deps = [  ];
  };

  # Tango palette color theme for GNU Emacs.
  color-theme-tango = buildEmacsPackage {
    name = "color-theme-tango-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-tango-0.0.2.el";
      sha256 = "1i2yw1d9dzmbh48r13n2b93n6bk8nwr1r0is1mxf34j3ykgpw10r";
    };
  
    deps = [ color-theme ];
  };

  # Tango Palette color theme for Emacs.
  color-theme-tangotango = buildEmacsPackage {
    name = "color-theme-tangotango-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-tangotango-0.0.2.el";
      sha256 = "1lwzx6sshv065cyqn9x9m70irwihzc1qjria9c7pkj5j0vmldmll";
    };
  
    deps = [ color-theme ];
  };

  # Twilight Colour Theme for Emacs.
  color-theme-twilight = buildEmacsPackage {
    name = "color-theme-twilight-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-twilight-0.1.el";
      sha256 = "0vs9kl78y1dv7lr8bjz22lj6nby6ykpgiai2d4rp063c77fkimw7";
    };
  
    deps = [  ];
  };

  # Color theme VIM insert mode
  color-theme-vim-insert-mode = buildEmacsPackage {
    name = "color-theme-vim-insert-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-vim-insert-mode-0.1.el";
      sha256 = "186la7hygn1c2x1g79ylz5827wsf74gy61qcn2v6333kf86588zm";
    };
  
    deps = [  ];
  };

  # The wombat color theme for Emacs.
  color-theme-wombat = buildEmacsPackage {
    name = "color-theme-wombat-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-wombat-0.0.1.el";
      sha256 = "091y9qvgxdajlh6d0n8vm2cj9hajlnvrz208441zyl3xdf0893mz";
    };
  
    deps = [ color-theme ];
  };

  # wombat with improvements and many more faces
  color-theme-wombat-plus = buildEmacsPackage {
    name = "color-theme-wombat-plus-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-wombat+-0.0.2.el";
      sha256 = "1kxzsw4qphmz2mk4syyfdih2mka34xrply0mv36xirdg5ndzmrnx";
    };
  
    deps = [ color-theme ];
  };

  # convert color themes to X11 resource settings
  color-theme-x = buildEmacsPackage {
    name = "color-theme-x-1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/color-theme-x-1.3.el";
      sha256 = "1nqzv40jmhfcrprhn249yp7isdl6djzs9pjfp7mv522qwji6pqyc";
    };
  
    deps = [  ];
  };

  # Toggle regions of the buffer with different text snippets
  colour-region = buildEmacsPackage {
    name = "colour-region-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/colour-region-0.4.el";
      sha256 = "033qmmxj04bx9a2k3f7l15ynr062lfzcys2jak0r9b9ygsg8awbx";
    };
  
    deps = [  ];
  };

  # -*- lexical-binding: t; -*-
  combinators = buildEmacsPackage {
    name = "combinators-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/combinators-0.0.1.el";
      sha256 = "137v6v3vrb8rz5479mm94wf3dzw5nh95m6f3savd7pypidxg09jk";
    };
  
    deps = [  ];
  };

  # Track command frequencies
  command-frequency = buildEmacsPackage {
    name = "command-frequency-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/command-frequency-1.1.el";
      sha256 = "05n3gm660lf2bjmhfg7xmca4f7i3hw1r2gj5n2l5ndghn7fzaxxj";
    };
  
    deps = [  ];
  };

  # Track frequency of commands executed in emacs
  command-stats = buildEmacsPackage {
    name = "command-stats-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/command-stats-0.1.el";
      sha256 = "0r4injna20irjci9awgnakx08jgihhfaslm0phhkb94pyqksnnff";
    };
  
    deps = [  ];
  };

  # Modular in-buffer completion framework
  company = buildEmacsPackage {
    name = "company-0.6.10";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/company-0.6.10.tar";
      sha256 = "1n7rk33l5z1jdfli79ll36k50klqj487yw7i5c2n01prvh41m5r3";
    };
  
    deps = [  ];
  };

  # company-mode completion back-end for CMake
  company-cmake = buildEmacsPackage {
    name = "company-cmake-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/company-cmake-0.1.el";
      sha256 = "0gpqamzq27rfqd4mdb0dr6sb864psxd913nzrm988m0pxcsjmvms";
    };
  
    deps = [ company ];
  };

  # Concurrent utility functions for emacs lisp
  concurrent = buildEmacsPackage {
    name = "concurrent-0.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/concurrent-0.3.1.el";
      sha256 = "1bf5c7jr3f41b30l8qp92yjxbb6ffna6zh2m8gd4jk78pvnmp2vp";
    };
  
    deps = [ deferred ];
  };

  # config-block is utility for individual settings (e.g. .emacs).
  config-block = buildEmacsPackage {
    name = "config-block-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/config-block-0.0.1.el";
      sha256 = "16ibxj71gw44yvp567y476250zcpg1dsppgb5jwjn8vnl80bbwl6";
    };
  
    deps = [  ];
  };

  # Confluence major mode
  confluence = buildEmacsPackage {
    name = "confluence-1.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/confluence-1.6.tar";
      sha256 = "0z787kia5xpfbdm4aw6d5xl5rnmw5a27fsqkdjvmjxfafl33iqry";
    };
  
    deps = [ xml-rpc ];
  };

  # Like caps-lock, but for your control key.  Give your pinky a rest!
  control-lock = buildEmacsPackage {
    name = "control-lock-1.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/control-lock-1.1.2.el";
      sha256 = "0rnvbfkxri54sr0qnqdf3fvav48qrj0r3xcsh49hm9zkxv7vrpps";
    };
  
    deps = [  ];
  };

  # run cppcheck putting hits in a grep buffer
  cppcheck = buildEmacsPackage {
    name = "cppcheck-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cppcheck-1.0.el";
      sha256 = "0sx38v7x62nkyxvvxp7yfmkmafzl3yp3041pcmp74v4vqgzfhr90";
    };
  
    deps = [  ];
  };

  # Easy real time C++ syntax check and intellisense if you use CMake.
  cpputils-cmake = buildEmacsPackage {
    name = "cpputils-cmake-0.3.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cpputils-cmake-0.3.0.tar";
      sha256 = "1xfjf74fqykjll82sym9vkfzc9mfp12v9ixyx7lzj4c1ks9s78kv";
    };
  
    deps = [  ];
  };

  # A parser for the Creole Wiki language
  creole = buildEmacsPackage {
    name = "creole-0.9.20130602";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/creole-0.9.20130602.el";
      sha256 = "1r8vc908bhxhgb7p0s7g0lh4ckia8mzdr95r44mi3cad89fwvi9g";
    };
  
    deps = [ noflet ];
  };

  # a markup mode for creole
  creole-mode = buildEmacsPackage {
    name = "creole-mode-0.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/creole-mode-0.0.5.el";
      sha256 = "150xzq5fd23z336zzkk1zk5f2ayf6w7g2yl4m8cdn3kq4zpxg3kz";
    };
  
    deps = [  ];
  };

  # Mode for editing crontab files
  crontab-mode = buildEmacsPackage {
    name = "crontab-mode-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/crontab-mode-1.2.el";
      sha256 = "0nyr51yvncsp3c9rhv3hnpahpna69cfrx8ygah0hififr1nwbc1j";
    };
  
    deps = [  ];
  };

  # Highlight the current line and column.
  crosshairs = buildEmacsPackage {
    name = "crosshairs-22.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/crosshairs-22.0.el";
      sha256 = "1jr8k76pp50pi8ni2xg2mh4agbzvd11fawsz8f63s1kjm2vancfx";
    };
  
    deps = [  ];
  };

  # Cryptol major mode for Emacs
  cryptol-mode = buildEmacsPackage {
    name = "cryptol-mode-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cryptol-mode-0.0.2.el";
      sha256 = "049z06nayvzmnzim79jqwlj1j5z2yfi4mivp19scpdlzdg9cjgkb";
    };
  
    deps = [  ];
  };

  # C# mode derived mode
  csharp-mode = buildEmacsPackage {
    name = "csharp-mode-0.8.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/csharp-mode-0.8.6.el";
      sha256 = "0gvpv8gpmkcz1061gsykbjnhvawx240kiczfy5zcviqhmh23wk7x";
    };
  
    deps = [  ];
  };

  # major mode for editing comma-separated value files
  csv-mode = buildEmacsPackage {
    name = "csv-mode-1.50";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/csv-mode-1.50.el";
      sha256 = "11gy3m1chf1ywaq53gqrf546017pwqnk1l0d59s9jmyb70slacrm";
    };
  
    deps = [  ];
  };

  # Table component for Emacs Lisp
  ctable = buildEmacsPackage {
    name = "ctable-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ctable-0.1.1.el";
      sha256 = "114w4f0i91yax0s6ij97czplar70if0l642ylnagzcilj5h7l746";
    };
  
    deps = [  ];
  };

  # auto update TAGS in parent directory using exuberant-ctags -*- coding:utf-8 -*-
  ctags-update = buildEmacsPackage {
    name = "ctags-update-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ctags-update-0.1.2.el";
      sha256 = "0nhr7mkza76cjpkk689w2vbmx1illpv0w2fh9kd8w9j56b8v7c0n";
    };
  
    deps = [  ];
  };

  # Enhanced Font lock support for custom defined types.
  ctypes = buildEmacsPackage {
    name = "ctypes-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ctypes-1.2.el";
      sha256 = "1n5vb333rzlwc3slb5z9yfa62a7i9vm8qf95lkh467i9v6hbkqgc";
    };
  
    deps = [  ];
  };

  # CUPS features for Emacs
  cups = buildEmacsPackage {
    name = "cups-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cups-0.1.el";
      sha256 = "1cp7f8c5gy63qww17zi8cq7j3y91vw4zksmg968ibn2ybwrhlhq5";
    };
  
    deps = [  ];
  };

  # Track and insert current Pivotal Tracker
  current-story = buildEmacsPackage {
    name = "current-story-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/current-story-0.1.0.el";
      sha256 = "1n090wxcd6xpncsha7h0wpfvys8ykxz1r7q162jqhwxqxk3zqj90";
    };
  
    deps = [  ];
  };

  # Change cursor dynamically, depending on the context.
  cursor-chg = buildEmacsPackage {
    name = "cursor-chg-20.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cursor-chg-20.1.el";
      sha256 = "1c1z3xr0bbrq1qs4qhq7lab0w1ispcpikbjs0b2inhccq6kijpqf";
    };
  
    deps = [  ];
  };

  # Cycle buffers code by Martin Pohlack, inspired by
  cycbuf = buildEmacsPackage {
    name = "cycbuf-0.5.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cycbuf-0.5.0.el";
      sha256 = "1xcwpwrz056685f6wfvcy5r75pa4hw6khg1jm2qzm6vyl8zikakf";
    };
  
    deps = [  ];
  };

  # Teach EMACS about cygwin styles and mount points.
  cygwin-mount = buildEmacsPackage {
    name = "cygwin-mount-2001";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/cygwin-mount-2001.el";
      sha256 = "0mngncmgjiqxkkp6ddy21y0djzvjsgiwbv9r3ndmjpq4frv8dwqr";
    };
  
    deps = [  ];
  };

  # D Programming Language mode for (X)Emacs
  d-mode = buildEmacsPackage {
    name = "d-mode-2.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/d-mode-2.0.4.tar";
      sha256 = "1v4ki9xl9bglqmmrm8ksy47j6qzad5j8k8pr4sdgsdyiz6540blx";
    };
  
    deps = [  ];
  };

  # Major mode for editing Dart files
  dart-mode = buildEmacsPackage {
    name = "dart-mode-0.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dart-mode-0.9.el";
      sha256 = "0s769gsnpfiywha3jaihm430r1ivjzx9lij7c41w9qv5wiya6krl";
    };
  
    deps = [  ];
  };

  # A modern list library for Emacs
  dash = buildEmacsPackage {
    name = "dash-1.4.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dash-1.4.0.el";
      sha256 = "0hysj8y4nz72yxxfqbaajbvchh0xjc7maz5x6k9spx4c9zvjdbx5";
    };
  
    deps = [  ];
  };

  # A database for EmacsLisp  -*- lexical-binding: t -*-
  db = buildEmacsPackage {
    name = "db-0.0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/db-0.0.6.el";
      sha256 = "1n01kmszi8bpn5lihr20h0dx41mfanimh4y2hdl2x6q1cbz0r6my";
    };
  
    deps = [ kv ];
  };

  # A PostgreSQL adapter for emacs-db
  db-pg = buildEmacsPackage {
    name = "db-pg-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/db-pg-0.0.3.el";
      sha256 = "0xzl6p7949inm5a21msqli8602jkbx7sb9q44144dda8cqn2grhs";
    };
  
    deps = [ pg db ];
  };

  # SOAP library to access debbugs servers
  debbugs = buildEmacsPackage {
    name = "debbugs-0.4";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/debbugs-0.4.tar";
      sha256 = "1gk19nxx6i0rqnl8gdb1hfr411anvagngbylpn090s01b8z8whh5";
    };
  
    deps = [  ];
  };

  # A very simple minor mode for dedicated buffers
  dedicated = buildEmacsPackage {
    name = "dedicated-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dedicated-1.0.0.el";
      sha256 = "0lgm1cazhcr06qyi6z599dgcvhw06hahzrlmrxpy89glq6r2dwvw";
    };
  
    deps = [  ];
  };

  # Emacs 24 theme with the Answer to The Ultimate Question
  deep-thought-theme = buildEmacsPackage {
    name = "deep-thought-theme-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/deep-thought-theme-0.1.1.el";
      sha256 = "142wafq7ybsbakc0xjk2kwxm014csx5xk4cbaddyfn9yd4w7xl15";
    };
  
    deps = [  ];
  };

  # a templating tool. Fill new files with default content.
  defaultcontent = buildEmacsPackage {
    name = "defaultcontent-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/defaultcontent-1.4.el";
      sha256 = "01fp5xd75ll66780ar87aiflc309gl4ncklgdc3s4gc6mv8fwv72";
    };
  
    deps = [  ];
  };

  # Simple asynchronous functions for emacs lisp
  deferred = buildEmacsPackage {
    name = "deferred-0.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/deferred-0.3.1.el";
      sha256 = "1g288by4cjyz7yvyxxdhxmimnbhca7v44wlgklkpn1xh6idql8li";
    };
  
    deps = [  ];
  };

  # quickly browse, filter, and edit plain text notes
  deft = buildEmacsPackage {
    name = "deft-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/deft-0.3.el";
      sha256 = "1w8vcigncy1mcbwafpvi07k57prpx12zk2lgx8c0ls800fzl18pi";
    };
  
    deps = [  ];
  };

  # Yet Another `describe-bindings' with `anything'.
  descbinds-anything = buildEmacsPackage {
    name = "descbinds-anything-1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/descbinds-anything-1.5.el";
      sha256 = "049xdx3xwahki4r8nqqvn46r2k42a0zkb8i5a5lj5987kh9zbp71";
    };
  
    deps = [ anything ];
  };

  # save partial status of Emacs when killed
  desktop = buildEmacsPackage {
    name = "desktop-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/desktop-0.1.el";
      sha256 = "0yiqna5lgdy10kdpkzgg91c9s3c3bp7z8fz4ppl911b81wz0kj59";
    };
  
    deps = [  ];
  };

  # Keep a central registry of desktop files
  desktop-registry = buildEmacsPackage {
    name = "desktop-registry-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/desktop-registry-1.0.0.el";
      sha256 = "1qpz38yxzmxxkfpfpgkm219j04xyy206ra6qlgss0l4w3p2m7sck";
    };
  
    deps = [  ];
  };

  # A minor mode using the diatheke command-line Bible tool
  diatheke = buildEmacsPackage {
    name = "diatheke-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/diatheke-1.0.el";
      sha256 = "1bbxfnr6gv51yx4hxigb8hjzbbwlgqz691xqqkis73dmxzxs599b";
    };
  
    deps = [  ];
  };

  # Dictionary data structure
  dict-tree = buildEmacsPackage {
    name = "dict-tree-0.12.8";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/dict-tree-0.12.8.el";
      sha256 = "08jaifqaq9cfz1z4fr4ib9l6lbx4x60q7d6gajx1cdhh18x6nys5";
    };
  
    deps = [ trie tNFA heap ];
  };

  # Highlight uncommitted changes -*- lexical-binding: t -*-
  diff-hl = buildEmacsPackage {
    name = "diff-hl-1.4.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/diff-hl-1.4.6.el";
      sha256 = "1lrvrq7jmr2al9584d5kaggdbp2fh4pd176g5dhjq4dx4qr3cxyi";
    };
  
    deps = [ cl-lib ];
  };

  # Diminished modes are minor modes with no modeline display
  diminish = buildEmacsPackage {
    name = "diminish-0.44";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/diminish-0.44.el";
      sha256 = "1616nd202q82ci76mca46n8pi8l4navv6yrrfvmkyzj7mvyp49gn";
    };
  
    deps = [  ];
  };

  # Compare and sync directories.
  dircmp = buildEmacsPackage {
    name = "dircmp-1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dircmp-1.el";
      sha256 = "13gf50dib44y045yvyk994f54rc1wl512hcpsrnhmmzbzq2lvq7j";
    };
  
    deps = [  ];
  };

  # Extensions to Dired.
  dired-plus = buildEmacsPackage {
    name = "dired-plus-21.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dired+-21.2.el";
      sha256 = "0vwignbgy6hra428y6zr5syld7xasm05cvjzxw9g7qr0akwfd1rh";
    };
  
    deps = [  ];
  };

  # make file details hide-able in dired
  dired-details = buildEmacsPackage {
    name = "dired-details-1.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dired-details-1.3.1.el";
      sha256 = "0mwnh6vxwjrckvhkid7zvrbp9hcjnjxszhic79wkqcij3p3ayzx3";
    };
  
    deps = [  ];
  };

  # Enhancements to library `dired-details+.el'.
  dired-details-plus = buildEmacsPackage {
    name = "dired-details-plus-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dired-details+-1.0.el";
      sha256 = "1f05pribj7ili17zryimgk4ngksy2ybdap8mkg9ihsh5cvcwkzll";
    };
  
    deps = [  ];
  };

  # Find duplicate files and display them in a dired buffer
  dired-dups = buildEmacsPackage {
    name = "dired-dups-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dired-dups-0.3.el";
      sha256 = "05ndlgq6fkl47xriwazavq0njkipxdfxkyz14h11gj0wp5qg9vgi";
    };
  
    deps = [  ];
  };

  # Edit Filename At Point in a dired buffer
  dired-efap = buildEmacsPackage {
    name = "dired-efap-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dired-efap-0.8.el";
      sha256 = "0jzl4i9fdl7rmgrjk8kvagksv9ixkg3dpia1mh58zzrp2151kyh1";
    };
  
    deps = [  ];
  };

  # reuse the current dired buffer to visit another directory
  dired-single = buildEmacsPackage {
    name = "dired-single-1.7.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dired-single-1.7.0.el";
      sha256 = "03msif37vpb8jj53cpvnl6fw6zyqp0p7y1ib442w5pa3wwymz2mm";
    };
  
    deps = [  ];
  };

  # Emacs wrapper for DisPass
  dispass = buildEmacsPackage {
    name = "dispass-1.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dispass-1.1.2.el";
      sha256 = "1a9a2zb6hqb5p5wzjlxbb3cii3q8w9mz7s562xlf4xlds0293hbd";
    };
  
    deps = [  ];
  };

  # minor mode for editing Apertium XML dictionary files
  dix = buildEmacsPackage {
    name = "dix-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dix-0.1.0.el";
      sha256 = "12vzcl52alppnhv63pmcfzmxcqd82qljddfzm66w44mi9j4xvbgw";
    };
  
    deps = [  ];
  };

  # A more pleasant way to manage your project's subprocesses in Emacs.
  dizzee = buildEmacsPackage {
    name = "dizzee-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dizzee-0.1.1.tar";
      sha256 = "0c053cqa3lrhv73hy6nv5l58mplsxwsg8kb8gr0qk4qim5n204a6";
    };
  
    deps = [  ];
  };

  # Custom face theme for Emacs
  django-theme = buildEmacsPackage {
    name = "django-theme-1.3.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/django-theme-1.3.0.el";
      sha256 = "0206g6jf98wzzkkd3ywvzzpqg2694hdibd2jscjjjibrhjbqm28p";
    };
  
    deps = [  ];
  };

  # Edit and view Djvu files via djvused
  djvu = buildEmacsPackage {
    name = "djvu-0.5";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/djvu-0.5.el";
      sha256 = "1wpyv4ismfsz5hfaj75j3h3nni1mnk33czhw3rd45cf32a2zkqsj";
    };
  
    deps = [  ];
  };

  # a major mode for editing dna sequences
  dna-mode = buildEmacsPackage {
    name = "dna-mode-1.44";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dna-mode-1.44.el";
      sha256 = "1bxjj8439a8c5d3vqkqg6361sqs4148i741n9ld0isnr92d2jsvl";
    };
  
    deps = [  ];
  };

  # convenient editing of in-code documentation
  doc-mode = buildEmacsPackage {
    name = "doc-mode-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/doc-mode-0.2.el";
      sha256 = "19limsk59g152yl93n6zqsxcdvlp2216fpkz135xb37jnsqj9n72";
    };
  
    deps = [  ];
  };

  # Info-like viewer for DocBook
  docbook = buildEmacsPackage {
    name = "docbook-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/docbook-0.1.el";
      sha256 = "01x0g8dhw65mzp9mk6qhx9p2bsvkw96hz1awrrf2ji17sp8hd1v6";
    };
  
    deps = [  ];
  };

  # Generation of tags documentation in Doxygen syntax
  doctags = buildEmacsPackage {
    name = "doctags-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/doctags-0.1.el";
      sha256 = "1515s7v83d13gfsy8j332l66mmalmsdygrmbmcglf3cvv3b44851";
    };
  
    deps = [  ];
  };

  # minor mode to repeat typing or commands
  dot-mode = buildEmacsPackage {
    name = "dot-mode-1.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dot-mode-1.12.el";
      sha256 = "0dmid407jl3wxmfjfhrwz9hxk9yv5670ykrxz4zck4n86r4mj9jv";
    };
  
    deps = [  ];
  };

  # dot access embedded alists
  dotassoc = buildEmacsPackage {
    name = "dotassoc-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dotassoc-0.0.1.el";
      sha256 = "1x6advyrc6z4crpg2axazr16fvhisdxlmrmawm75n2nslxsd97fw";
    };
  
    deps = [  ];
  };

  # Emacs integration for dpaste.com
  dpaste = buildEmacsPackage {
    name = "dpaste-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dpaste-0.2.el";
      sha256 = "0mggja92psbzkcp5jsl3pc0xpqg8zyhdcg3gcb776zzdpa2gsr2s";
    };
  
    deps = [  ];
  };

  # Emacs mode to paste to dpaste.de
  dpaste_de = buildEmacsPackage {
    name = "dpaste_de-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dpaste_de-0.1.el";
      sha256 = "04qb0f9c2qznxh3k9qc9yca0yjr8mrlfv62ni8k3q7ixr7yf3s95";
    };
  
    deps = [ web ];
  };

  # Drag stuff (lines, words, region, etc...) around
  drag-stuff = buildEmacsPackage {
    name = "drag-stuff-0.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/drag-stuff-0.0.4.el";
      sha256 = "1gwjinrg528hv49lwh4i03z4adln3ibg166j1rxbv189zsvm7sxj";
    };
  
    deps = [  ];
  };

  # Emacs backend for dropbox
  dropbox = buildEmacsPackage {
    name = "dropbox-0.9.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dropbox-0.9.1.el";
      sha256 = "0z1klqxa79hcag214bli4966g74qwsv7za4achs7kcxz9xkh51ji";
    };
  
    deps = [ json oauth ];
  };

  # Drop-down menu interface
  dropdown-list = buildEmacsPackage {
    name = "dropdown-list-1.45";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dropdown-list-1.45.el";
      sha256 = "1q1kbsyq7ar1qhy5bxwzvl34v60rbfhhv876l76vfia0riax147n";
    };
  
    deps = [  ];
  };

  # Advanced minor mode for Drupal development
  drupal-mode = buildEmacsPackage {
    name = "drupal-mode-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/drupal-mode-0.2.0.tar";
      sha256 = "1zdxrb9k42s0pijwmlf351idhwf38kkj59w975wl5j48sjd4a0i3";
    };
  
    deps = [ php-mode ];
  };

  # Aspell extra dictionary for Drupal
  drupal-spell = buildEmacsPackage {
    name = "drupal-spell-0.2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/drupal-spell-0.2.2.tar";
      sha256 = "1zg0ab5hq6k4x2lzyvs9ampipfjh6xp7ld97n5qjmgdy3kpjkamy";
    };
  
    deps = [  ];
  };

  # Subversion interface
  dsvn = buildEmacsPackage {
    name = "dsvn-922257";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dsvn-922257.el";
      sha256 = "1cmvnx5fhz1qbl0nyz1z7jp3xzaiyi7rdc228za36y7if03k2340";
    };
  
    deps = [  ];
  };

  # Adapt to foreign indentation offsets
  dtrt-indent = buildEmacsPackage {
    name = "dtrt-indent-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dtrt-indent-0.2.0.el";
      sha256 = "18wyr0qwdhv6piq6pwn3a2nbvxacjhjixs9pjyhsq419mlmh3z5k";
    };
  
    deps = [  ];
  };

  # A bucket of tricks for Clojure and Slime.
  durendal = buildEmacsPackage {
    name = "durendal-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/durendal-0.2.el";
      sha256 = "0l5lrga89c3yvk51rxxqj2rs7700dz9nvzjvj98rc0jizdrpx5ap";
    };
  
    deps = [ clojure-mode slime paredit ];
  };

  # Set faces based on available fonts
  dynamic-fonts = buildEmacsPackage {
    name = "dynamic-fonts-0.6.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/dynamic-fonts-0.6.2.el";
      sha256 = "0vls4yn6y8qvifcr6f34ij4hj5paz8wa48fb3mrrcyb7fg27n2zl";
    };
  
    deps = [ font-utils persistent-soft pcache ];
  };

  # Emacs Code Browser
  ecb = buildEmacsPackage {
    name = "ecb-2.40";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ecb-2.40.tar";
      sha256 = "17mq8313j4bxiffwv7443g2yazc2yn1nvs83a1qlfcxa58ly6lsc";
    };
  
    deps = [  ];
  };

  # Emacs Code Browser CVS snapshot
  ecb-snapshot = buildEmacsPackage {
    name = "ecb-snapshot-20120830";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ecb-snapshot-20120830.tar";
      sha256 = "0hsm4k2n5qg8dqr7r6d2brzdr7s654i47flsydd6w35imjvy1hnp";
    };
  
    deps = [  ];
  };

  # Emacs Database Interface
  edbi = buildEmacsPackage {
    name = "edbi-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/edbi-0.1.1.tar";
      sha256 = "1cmdy8n3kj92xdjrb6s95ych7b950i6bzg438w6rry1hnqv1yvwj";
    };
  
    deps = [ concurrent ctable epc ];
  };

  # Extensions for Edebug
  edebug-x = buildEmacsPackage {
    name = "edebug-x-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/edebug-x-1.2.el";
      sha256 = "1cs2nxipzh6k7mw5j4damc5snkdfxw8l3w541x2yxv8x437x7mkm";
    };
  
    deps = [ dash ];
  };

  # Emacs Does Interactive Prolog
  ediprolog = buildEmacsPackage {
    name = "ediprolog-1.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/ediprolog-1.0.el";
      sha256 = "03rb0gcciyib50nmb6kldmakgj2wx5spypbxys0l3vhp1zwkm66w";
    };
  
    deps = [  ];
  };

  # edit a single list
  edit-list = buildEmacsPackage {
    name = "edit-list-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/edit-list-0.4.el";
      sha256 = "04h69n4x85rzxl743zdrj9gmphz7xr8s7aad3p58l3i78b9w6dq3";
    };
  
    deps = [  ];
  };

  # EditorConfig Emacs extension
  editorconfig = buildEmacsPackage {
    name = "editorconfig-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/editorconfig-0.2.el";
      sha256 = "0wj9vz666cmfwmnl9b7lidsic73vzyri10abkwzv2n6dwjnk1pfj";
    };
  
    deps = [  ];
  };

  # Egison editing mode
  egison-mode = buildEmacsPackage {
    name = "egison-mode-0.1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/egison-mode-0.1.4.el";
      sha256 = "10rc977v036p6m34h5ds7k12sin2py1a7pg6q9rkasyxccq4ahw2";
    };
  
    deps = [  ];
  };

  # tuamshu's emacs basic configure
  eh-basic = buildEmacsPackage {
    name = "eh-basic-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eh-basic-0.0.2.tar";
      sha256 = "0ygll13yx8ibr2rh9kzv30mrpklsl5qg4zpc06fiw5a2kylhnf7x";
    };
  
    deps = [ starter-kit browse-kill-ring ];
  };

  # tuamshu's emacs functions
  eh-functions = buildEmacsPackage {
    name = "eh-functions-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eh-functions-0.0.1.tar";
      sha256 = "062bwn55jfhf14kcfjkpfacwfqjfjamy6ql3s60i93wdm7hcw61y";
    };
  
    deps = [ starter-kit ];
  };

  # tuamshu's gnus configure
  eh-gnus = buildEmacsPackage {
    name = "eh-gnus-0.0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eh-gnus-0.0.6.tar";
      sha256 = "0bsxr9lyqj8ify88r0nkrmalvm4lqjpd7w3p71wsiv2dzw0hiark";
    };
  
    deps = [  ];
  };

  # tuamshu's emacs keybindings
  eh-keybindings = buildEmacsPackage {
    name = "eh-keybindings-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eh-keybindings-0.0.1.tar";
      sha256 = "1ppfrsrx4z6s4rih2q9phibfnvsk6nkxgpi0hirzwqrg1k12wcnp";
    };
  
    deps = [ eh-functions starter-kit-bindings ];
  };

  # Enhanced Implememntation of Emacs Interpreted Objects
  eieio = buildEmacsPackage {
    name = "eieio-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eieio-1.4.tar";
      sha256 = "0flrmqg60lfh59q9rmwzka5x1ss3kqw1bralf31hywg535pnj56g";
    };
  
    deps = [  ];
  };

  # Emacs Image Manipulation Package
  eimp = buildEmacsPackage {
    name = "eimp-1.4.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eimp-1.4.0.el";
      sha256 = "0bzi9afbppnjhkaqbpx9v38c4kcy5bkm2j0d3nzh7bby13j1kxls";
    };
  
    deps = [  ];
  };

  # Automatically create Emacs-Lisp Yasnippets
  el-autoyas = buildEmacsPackage {
    name = "el-autoyas-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/el-autoyas-0.5.el";
      sha256 = "01id7dk098jm5rn38a5frzzfg49r82n2n0380vc8fiq8crpbb1fm";
    };
  
    deps = [  ];
  };

  # ruby's rspec like syntax test frame work
  el-spec = buildEmacsPackage {
    name = "el-spec-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/el-spec-0.2.el";
      sha256 = "0gzbnbvdw60563dysplpz2ckcva3dwfcka8a3wqg5ssnax3vy2q7";
    };
  
    deps = [  ];
  };

  # fuzzy symbol completion.
  el-swank-fuzzy = buildEmacsPackage {
    name = "el-swank-fuzzy-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/el-swank-fuzzy-0.1.el";
      sha256 = "175g5h7w430m06sghcgmzshr736v29ksdmjrbpg51zq8mjrxrbds";
    };
  
    deps = [  ];
  };

  # Emacs-lisp extensions.
  el-x = buildEmacsPackage {
    name = "el-x-0.2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/el-x-0.2.2.tar";
      sha256 = "07yk714nz2by6vaqi5457y5k32dan2mwz4wgfwi9829l0mnyx7p5";
    };
  
    deps = [ cl-lib ];
  };

  # Enable eldoc support when minibuffer is in use.
  eldoc-eval = buildEmacsPackage {
    name = "eldoc-eval-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/eldoc-eval-0.1.el";
      sha256 = "1mnhxdsn9h43iq941yqmg92v3hbzwyg7acqfnz14q5g52bnagg19";
    };
  
    deps = [  ];
  };

  # running leiningen commands from emacs
  elein = buildEmacsPackage {
    name = "elein-0.2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elein-0.2.2.el";
      sha256 = "1b84rick9n11vrl969yn5d7wk3yqf8x3w1x4845brz6v9xwsap17";
    };
  
    deps = [  ];
  };

  # Faster emacs startup through byte-compiling.
  elisp-cache = buildEmacsPackage {
    name = "elisp-cache-1.15";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elisp-cache-1.15.el";
      sha256 = "0bxphrjzyhgdbkj27w8l1b5k84jqxwx95kjmr0x0ifal2d0hmqr1";
    };
  
    deps = [  ];
  };

  # Parse depend libraries of elisp file.
  elisp-depend = buildEmacsPackage {
    name = "elisp-depend-1.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elisp-depend-1.0.2.el";
      sha256 = "14b97dnq35zwbivr2jsx4g26apql69j3mj9vw9vkigqh6nab48qw";
    };
  
    deps = [  ];
  };

  # Make M-. and M-, work in elisp like they do in slime
  elisp-slime-nav = buildEmacsPackage {
    name = "elisp-slime-nav-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elisp-slime-nav-0.6.el";
      sha256 = "032w5xnmylyswysg40yyzh60ma8ljhh77fcxi2knh7fnma2v18in";
    };
  
    deps = [ cl-lib ];
  };

  # Emacs integration for Elixir's elixir-mix
  elixir-mix = buildEmacsPackage {
    name = "elixir-mix-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elixir-mix-0.0.2.el";
      sha256 = "011z6x2c36b46xcycsq72h3diqzicn84v498y25h5frjiddnizpj";
    };
  
    deps = [  ];
  };

  # Major mode for editing Elixir files
  elixir-mode = buildEmacsPackage {
    name = "elixir-mode-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elixir-mode-1.0.0.el";
      sha256 = "0hq7mckhk1lw4qmw103cwxz36m7j3dmsf1qwx8raj2a7glqyslia";
    };
  
    deps = [  ];
  };

  # The Emacs webserver.
  elnode = buildEmacsPackage {
    name = "elnode-0.9.9.7.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elnode-0.9.9.7.2.tar";
      sha256 = "16ahz3sbbh6mm0l9yn4wkpypxhwxm6ghpjsynjvx7hcq3ijlrspd";
    };
  
    deps = [ web dash s creole fakir db kv ];
  };

  # Handy functions for inspecting and comparing package archives
  elpa-audit = buildEmacsPackage {
    name = "elpa-audit-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elpa-audit-0.4.el";
      sha256 = "0irql4kfs1jp3x5fwpmsbj62aaijpkrvi1f1xnvhlcpqxbi97wdd";
    };
  
    deps = [  ];
  };

  # package archive builder
  elpakit = buildEmacsPackage {
    name = "elpakit-1.0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elpakit-1.0.6.el";
      sha256 = "0s4ak89jw4h8iicb57vzk1l4s1i46560m18cjwblgjsnzrvm1jv1";
    };
  
    deps = [ anaphora dash ];
  };

  # Emacs Lisp Python Environment
  elpy = buildEmacsPackage {
    name = "elpy-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elpy-1.0.tar";
      sha256 = "09slhbmhf2lag99511nqgl5y8bzy7vgv5qi9q88pc2gd0z703djy";
    };
  
    deps = [ auto-complete fuzzy yasnippet virtualenv highlight-indentation find-file-in-project idomenu nose iedit ];
  };

  # Android application development tools for Emacs
  emacs-droid = buildEmacsPackage {
    name = "emacs-droid-0.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/emacs-droid-0.0.0.el";
      sha256 = "1wf6cv7x5sk669qhjgllbki5jy1vizmkjniymch835l60swq9zl5";
    };
  
    deps = [  ];
  };

  # tiling windows for emacs
  emacsd-tile = buildEmacsPackage {
    name = "emacsd-tile-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/emacsd-tile-0.1.el";
      sha256 = "1g8xzffj5awpy54gdk83q9qmbvf1f572bajl8y5vx23xcvqjhbmb";
    };
  
    deps = [  ];
  };

  # Interact with tmux
  emamux = buildEmacsPackage {
    name = "emamux-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/emamux-0.1.el";
      sha256 = "00dih4y2kd65fh8kcmsr8gsfp7b7xn6zy85bwjrks1vml94wdy2y";
    };
  
    deps = [  ];
  };

  # Extra functions for emms-mark-mode and emms-tag-edit-mode
  emms-mark-ext = buildEmacsPackage {
    name = "emms-mark-ext-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/emms-mark-ext-0.3.el";
      sha256 = "02nzfmp1bdv179bmc5gh41s4ng8rvrfwlypxcqrm4r89m7p44xrv";
    };
  
    deps = [ emms ];
  };

  # Casual game, like a brainy Pac-Man
  emstar = buildEmacsPackage {
    name = "emstar-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/emstar-1.4.tar";
      sha256 = "0vwfycawmd0qxr97bxwx6b6i3nghhjrnfar653f1bw5p3z7vg6d6";
    };
  
    deps = [  ];
  };

  # Enclose cursor within punctuation pairs
  enclose = buildEmacsPackage {
    name = "enclose-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/enclose-0.0.2.el";
      sha256 = "07iigiry8h23sgpvydyrg06c4ainmd1zdpa84hk0f11c7n4fgp8g";
    };
  
    deps = [  ];
  };

  # The Emacs Network Client
  enwc = buildEmacsPackage {
    name = "enwc-1.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/enwc-1.0.tar";
      sha256 = "19mjkcgnacygzwm5dsayrwpbzfxadp9kdmmghrk1vir2hwixgv8y";
    };
  
    deps = [  ];
  };

  # A RPC stack for the Emacs Lisp
  epc = buildEmacsPackage {
    name = "epc-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/epc-0.1.1.el";
      sha256 = "099vqzdckxfqi2m89cx8ywj16sq7rxyz53fmgqv4z171xg43az9z";
    };
  
    deps = [ concurrent ctable ];
  };

  # Minor mode to visualize epoch timestamps
  epoch-view = buildEmacsPackage {
    name = "epoch-view-0.0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/epoch-view-0.0.1.el";
      sha256 = "1wy25ryyg9f4v83qjym2pwip6g9mszhqkf5a080z0yl47p71avfx";
    };
  
    deps = [  ];
  };

  # ERC nick highlighter that ignores uniquifying chars when colorizing
  erc-hl-nicks = buildEmacsPackage {
    name = "erc-hl-nicks-1.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/erc-hl-nicks-1.3.1.el";
      sha256 = "0pg6zmyrpvd4bfb8724bffmnsgb1r2r66krcsqxzcnzzrqczn9nk";
    };
  
    deps = [  ];
  };

  # Flexible ERC notifications
  ercn = buildEmacsPackage {
    name = "ercn-1.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ercn-1.0.2.el";
      sha256 = "1z18h8iajbfpakw5xi9kqk9cy2mppbslw1bp6i4p9c7wywazcdxp";
    };
  
    deps = [  ];
  };

  # eredis, a Redis client in emacs lisp
  eredis = buildEmacsPackage {
    name = "eredis-0.5.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eredis-0.5.0.el";
      sha256 = "0m4cm6vp6yr8pfvmxrzh4q7qfbxh0ximi2rb2avkrvnjk054bg1k";
    };
  
    deps = [  ];
  };

  # Emacs-Lisp refactoring utilities
  erefactor = buildEmacsPackage {
    name = "erefactor-0.6.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/erefactor-0.6.10.el";
      sha256 = "10w5x8ssk99969qkyr3dlllldbxcar01sf79p2b8xsm43c30l093";
    };
  
    deps = [  ];
  };

  # Major modes for editing and running Erlang
  erlang = buildEmacsPackage {
    name = "erlang-2.4.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/erlang-2.4.1.el";
      sha256 = "03csz8nii9yzzr50w17y1qhmbc50xcp3pbrspkxnyrl6siqrx85j";
    };
  
    deps = [  ];
  };

  # Emacs Lisp Regression Testing
  ert = buildEmacsPackage {
    name = "ert-0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ert-0.el";
      sha256 = "01j5ps26ff90aw16vxjmb6jhaj7fv3sfal7311ydny37z0jmbl3a";
    };
  
    deps = [  ];
  };

  # Staging area for experimental extensions to ERT
  ert-x = buildEmacsPackage {
    name = "ert-x-0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ert-x-0.el";
      sha256 = "1ci5s2fmi401i2hh62xnjcvgp9719wr5rgs481lfkxhl4yml5n1m";
    };
  
    deps = [ ert ];
  };

  # An updated manual for Eshell.
  eshell-manual = buildEmacsPackage {
    name = "eshell-manual-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eshell-manual-0.0.2.tar";
      sha256 = "0zwgpr5lfhlkzvibv491c482q56ib9q15fp91p4v95hrzbp1wfqn";
    };
  
    deps = [  ];
  };

  # Emacs Search Kit - An easy way to find files and/or strings in a project
  esk = buildEmacsPackage {
    name = "esk-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/esk-0.1.tar";
      sha256 = "0q0bcr14bi4zy3z03akhm6wpizl9kpavaigjd8hx6ddfiqm63jvh";
    };
  
    deps = [  ];
  };

  # Edit and interact with statistical programs like R, S-Plus, SAS, Stata and JAGS
  ess = buildEmacsPackage {
    name = "ess-5.14";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ess-5.14.tar";
      sha256 = "0ampfq8dqi3ygkgbsx2zksx4pf89037bl06iqpk0bpr4gyz1i34p";
    };
  
    deps = [  ];
  };

  # Ess Smart Underscore
  ess-smart-underscore = buildEmacsPackage {
    name = "ess-smart-underscore-0.79";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ess-smart-underscore-0.79.el";
      sha256 = "054md2bqjn285iiq5h0hll4afbdlkdk1qllz6bv0yh46axcjn526";
    };
  
    deps = [  ];
  };

  # the Emacs StartUp Profiler (ESUP)
  esup = buildEmacsPackage {
    name = "esup-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/esup-0.3.el";
      sha256 = "1l6064dwrgy8vyf3vv8wws0vj28vpa5czkw1ymbl7adacmmgc24n";
    };
  
    deps = [  ];
  };

  # Handle HTML with lists.
  esxml = buildEmacsPackage {
    name = "esxml-0.3.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/esxml-0.3.0.tar";
      sha256 = "0b4dyb1385m2fh59jisssj1zc30i129ikjyvnnh4h26fgsadzrpy";
    };
  
    deps = [ db ];
  };

  # Select from multiple tags
  etags-select = buildEmacsPackage {
    name = "etags-select-1.13";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/etags-select-1.13.el";
      sha256 = "0kvjpx0w2miwlz8jgcgb1n44s0zvlmbxykhjfpkl03lvv36d79wl";
    };
  
    deps = [  ];
  };

  # Set tags table(s) based on current file
  etags-table = buildEmacsPackage {
    name = "etags-table-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/etags-table-1.1.el";
      sha256 = "0w0ffh9rxfysla49cyjbllarnrw1vp4kc83qnw2bx77cb31i7slm";
    };
  
    deps = [  ];
  };

  # Evernote client for Emacs
  evernote-mode = buildEmacsPackage {
    name = "evernote-mode-0.41";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/evernote-mode-0.41.tar";
      sha256 = "0kbzhmf9d7160qw8kbzl2kjm80b1rhgnmhdlj91b5a11iv2a2gll";
    };
  
    deps = [  ];
  };

  # Bridge to MS Windows desktop-search engine Everything
  everything = buildEmacsPackage {
    name = "everything-0.1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/everything-0.1.5.el";
      sha256 = "00c86ibm4v5nd5nc9b8r10hhskkh786wlffr86xx5c7jaxksnll6";
    };
  
    deps = [  ];
  };

  # Major-mode for editing eviews program files
  eviews = buildEmacsPackage {
    name = "eviews-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/eviews-0.1.el";
      sha256 = "1ymvlk1hg8f4xbpi4ffg5y3v7n4rzkp8i7cklmpv85fi200fkj6i";
    };
  
    deps = [  ];
  };

  # Extensible Vi layer for Emacs.
  evil = buildEmacsPackage {
    name = "evil-1.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/evil-1.0.5.tar";
      sha256 = "13w0fikkql479xndy39hi199my4qm5l34y0dyx4p9p4wma0a7qi5";
    };
  
    deps = [ undo-tree ];
  };

  # let there be <leader>
  evil-leader = buildEmacsPackage {
    name = "evil-leader-0.3.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/evil-leader-0.3.3.el";
      sha256 = "1x1i26ywzzcjbambd9hxydhbjdr58d4hydxfgx7miiici63bakwa";
    };
  
    deps = [ evil ];
  };

  # Comment/uncomment lines efficiently. Like Nerd Commenter in Vim
  evil-nerd-commenter = buildEmacsPackage {
    name = "evil-nerd-commenter-0.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/evil-nerd-commenter-0.0.5.tar";
      sha256 = "04s5bj1vjj4fycl19q1hgbslgzzs0fbjvdg7hml2ljkp229r42jn";
    };
  
    deps = [  ];
  };

  # increment/decrement numbers like in vim
  evil-numbers = buildEmacsPackage {
    name = "evil-numbers-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/evil-numbers-0.3.el";
      sha256 = "1rlhp38bnw5y2xnw8csrb0qvbjwc05brgg4f968a3r1vjnrllc44";
    };
  
    deps = [  ];
  };

  # Paredit support for evil keybindings
  evil-paredit = buildEmacsPackage {
    name = "evil-paredit-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/evil-paredit-0.0.1.el";
      sha256 = "1d0wzyc5x2kib8n1sva06saa9hy37hmls3xcxgqg9c0b3gn8vmnp";
    };
  
    deps = [ evil paredit ];
  };

  # Make Emacs use the $PATH set up by the user's shell
  exec-path-from-shell = buildEmacsPackage {
    name = "exec-path-from-shell-1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/exec-path-from-shell-1.5.el";
      sha256 = "0gpbf4cqj17gsa5bf3f53zx1jn9yfa3yq510d9l6wp5f3aknin8a";
    };
  
    deps = [  ];
  };

  # Increase selected region by semantic units.
  expand-region = buildEmacsPackage {
    name = "expand-region-0.8.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/expand-region-0.8.0.tar";
      sha256 = "1y06vq0dic3gc7rm9f7w6gqsplldjchfj71b32ih38baqayixz35";
    };
  
    deps = [  ];
  };

  # Minor mode for expectations tests
  expectations-mode = buildEmacsPackage {
    name = "expectations-mode-0.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/expectations-mode-0.0.4.el";
      sha256 = "1adg7p05ncg34i906fmkypjyymgggrx5f0yi8h8lhsaj9nyp7aq0";
    };
  
    deps = [ nrepl clojure-mode ];
  };

  # Alternatives to `message'
  express = buildEmacsPackage {
    name = "express-0.5.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/express-0.5.12.el";
      sha256 = "088qp05bxid2ws4pwbl0kgddzinsm6zl23q1vr7l4l2xnrg34ch3";
    };
  
    deps = [ string-utils ];
  };

  # R drag and Drop
  extend-dnd = buildEmacsPackage {
    name = "extend-dnd-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/extend-dnd-0.5.el";
      sha256 = "0l81piwlg6n69n5xna2k24xi6wnm0vpzs0q5ckchhh7hzhhw39f0";
    };
  
    deps = [  ];
  };

  # Parse and browse f90 interfaces
  f90-interface-browser = buildEmacsPackage {
    name = "f90-interface-browser-1.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/f90-interface-browser-1.1.el";
      sha256 = "0mf32w2bgc6b43k0r4a11bywprj7y3rvl21i0ry74v425r6hc3is";
    };
  
    deps = [  ];
  };

  # fakeing bits of Emacs -*- lexical-binding: t -*-
  fakir = buildEmacsPackage {
    name = "fakir-0.1.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fakir-0.1.6.el";
      sha256 = "150p5sflndg7x7vx0jpk9wr065lh05clbvpv21qxgj30q0d5mbqv";
    };
  
    deps = [ noflet dash ];
  };

  # Major mode for programming with the Fancy language.
  fancy-mode = buildEmacsPackage {
    name = "fancy-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fancy-mode-0.1.el";
      sha256 = "0h5b16xjcpf7rsprh6qjd4as4w2l7i4ss30v4vzxxf5fz12rf93n";
    };
  
    deps = [  ];
  };

  # Fast navigation and editing routines.
  fastnav = buildEmacsPackage {
    name = "fastnav-1.0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fastnav-1.0.7.el";
      sha256 = "1x12phkp2n039lq5rc14cvamhn69xxmhkwfw3kki96dp2lhp4kxr";
    };
  
    deps = [  ];
  };

  # Major mode for editing Gherkin (i.e. Cucumber) user stories
  feature-mode = buildEmacsPackage {
    name = "feature-mode-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/feature-mode-0.4.tar";
      sha256 = "1gk7x4h9lp35na3slc5p132m6skz1r1jz7f9627fw6c31qcrqzzj";
    };
  
    deps = [  ];
  };

  # A major mode for the Fetchnotes note taking service
  fetchmacs = buildEmacsPackage {
    name = "fetchmacs-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fetchmacs-1.0.1.el";
      sha256 = "01yy6x6h27xfsxyw3zpc1kx9av3s3jplcbfgq4yd40mqpk0dnrcm";
    };
  
    deps = [  ];
  };

  # Show FIXME/TODO/BUG(...) in special face only in comments and strings
  fic-ext-mode = buildEmacsPackage {
    name = "fic-ext-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fic-ext-mode-0.1.el";
      sha256 = "145yvlqgs5gzl6qix8xkr7d0xi4db2p49fjs2miwhdqqgvw2dqhl";
    };
  
    deps = [  ];
  };

  # Graphically indicate the fill column
  fill-column-indicator = buildEmacsPackage {
    name = "fill-column-indicator-1.83";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fill-column-indicator-1.83.el";
      sha256 = "14hm2rsr1iqcd5vn7cw6lscisfz83s5ks08lsdsnrpfd2lywvx02";
    };
  
    deps = [  ];
  };

  # Utility to find files in a git repo
  find-file-in-git-repo = buildEmacsPackage {
    name = "find-file-in-git-repo-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/find-file-in-git-repo-0.1.2.el";
      sha256 = "1s0yv7b7nrc25rh0nzw4m458b75frbi9rlhnb7x21hgyy77cbn6a";
    };
  
    deps = [  ];
  };

  # Find files in a project quickly.
  find-file-in-project = buildEmacsPackage {
    name = "find-file-in-project-3.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/find-file-in-project-3.2.el";
      sha256 = "010s49n6mm82nwz9i4aq4x5w8d8in83sfhjwypq62b527i0dvq9a";
    };
  
    deps = [  ];
  };

  # Quickly find files in a git, mercurial or other repository
  find-file-in-repository = buildEmacsPackage {
    name = "find-file-in-repository-1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/find-file-in-repository-1.3.el";
      sha256 = "0wnadrl61wxrmw7zkbg0qkr05gyf8cs9xpmmc1qr70rgm5d9p0ib";
    };
  
    deps = [  ];
  };

  # An emacs mode to find things fast and move around in a project quickly
  find-things-fast = buildEmacsPackage {
    name = "find-things-fast-20111123";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/find-things-fast-20111123.tar";
      sha256 = "1z5ql1llvgp97bpzrrm4ns5irdlskc8paq9r2xpk237bh4ya3x82";
    };
  
    deps = [  ];
  };

  # Breadth-first file-finding facility for (X)Emacs
  findr = buildEmacsPackage {
    name = "findr-0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/findr-0.7.el";
      sha256 = "18s55vqqsi58332aa5rvyzvn5zxsnyra6923wx2wxjq2vghxflsd";
    };
  
    deps = [  ];
  };

  # Fuzzy finder for files in a project.
  fiplr = buildEmacsPackage {
    name = "fiplr-0.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fiplr-0.1.3.el";
      sha256 = "1imvlas2yc7yxwz2vbj6mvfpzf4nw3p4218pjrvzhpapx3ag2sgf";
    };
  
    deps = [  ];
  };

  # Quickly navigate to FIXME notices in code
  fixmee = buildEmacsPackage {
    name = "fixmee-0.8.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fixmee-0.8.2.el";
      sha256 = "1c1cc1y17044qqk16dqbiq42fryp000ih2jpipix58p1w34b6p2s";
    };
  
    deps = [ button-lock nav-flash back-button smartrep string-utils tabulated-list ];
  };

  # Automatically insert pair braces and quotes, insertion conditions & actions are highly customizable.
  flex-autopair = buildEmacsPackage {
    name = "flex-autopair-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flex-autopair-0.3.el";
      sha256 = "1h1irmfrn87rx5f3z6kfmn6ns0312klv7xan4nskdvg409kd91ip";
    };
  
    deps = [  ];
  };

  # use flymake with jshint on js code, on Windows
  fly-jshint-wsh = buildEmacsPackage {
    name = "fly-jshint-wsh-2.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fly-jshint-wsh-2.0.3.el";
      sha256 = "174p4cskdb6zfdil8zjkjywj0fk33wiyncbrz36yh0v82a3ima6p";
    };
  
    deps = [ flymake ];
  };

  # On-the-fly syntax checking (Flymake done right)
  flycheck = buildEmacsPackage {
    name = "flycheck-0.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flycheck-0.12.tar";
      sha256 = "0n4plynhm8qm5xlsdbikmqhk9jqmqx8vjn8d6pvr8jcw5vkxan05";
    };
  
    deps = [ s dash cl-lib  ];
  };

  # Change mode line color with Flycheck status -*- lexical-binding: t -*-
  flycheck-color-mode-line = buildEmacsPackage {
    name = "flycheck-color-mode-line-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flycheck-color-mode-line-0.2.el";
      sha256 = "117r5h5ykmkb7jnv6i4blry7qqrpd72yw9x55p9pd4p77mg785gw";
    };
  
    deps = [ flycheck dash  ];
  };

  # a universal on-the-fly syntax checker
  flymake = buildEmacsPackage {
    name = "flymake-0.4.16";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-0.4.16.el";
      sha256 = "06l7vq68qzwnki6v7lzvn06m7m3irm81isgjplxw9crhq2wv3y69";
    };
  
    deps = [  ];
  };

  # Flymake reloaded with useful checkers
  flymake-checkers = buildEmacsPackage {
    name = "flymake-checkers-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-checkers-0.3.el";
      sha256 = "1sjgizb3lnx6s6bskb7ip2vv14hmgmcl13glyzzjp49yqshby7iv";
    };
  
    deps = [  ];
  };

  # A flymake handler for coffee script
  flymake-coffee = buildEmacsPackage {
    name = "flymake-coffee-0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-coffee-0.10.el";
      sha256 = "0s64hfgsdabwdah6ba1c7101nsh5p2vw3zbx00gz1ypfxx2v6x4k";
    };
  
    deps = [ flymake-easy ];
  };

  # Flymake support for css using csslint
  flymake-css = buildEmacsPackage {
    name = "flymake-css-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-css-0.3.el";
      sha256 = "1lgr7gdkhjy6jq1ybjminb8dc3d95q72hna51crjygyba6ycxavr";
    };
  
    deps = [ flymake-easy ];
  };

  # making flymake work with CSSLint
  flymake-csslint = buildEmacsPackage {
    name = "flymake-csslint-1.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-csslint-1.1.0.tar";
      sha256 = "0km64dkfnvrpfal9s6vccpk021brhgai6yz709r4bf5slcxqixqb";
    };
  
    deps = [ flymake ];
  };

  # Show flymake messages in the minibuffer after delay
  flymake-cursor = buildEmacsPackage {
    name = "flymake-cursor-1.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-cursor-1.0.2.tar";
      sha256 = "1s4wpndm8i4lq5m89gjmrl3371l0a69y7n6hfcs2khcb0w2fl5dh";
    };
  
    deps = [ flymake ];
  };

  # A flymake handler for d-mode files
  flymake-d = buildEmacsPackage {
    name = "flymake-d-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-d-0.1.el";
      sha256 = "01fmf16lmbghpm1kpykfw5h7nrbhgk0mz9r91bhkwc1q8s4hpiwj";
    };
  
    deps = [  ];
  };

  # Helpers for easily building flymake checkers
  flymake-easy = buildEmacsPackage {
    name = "flymake-easy-0.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-easy-0.9.el";
      sha256 = "1xdg2g9yf2agbpcnmishvzg078lk1330i37ks36k74yr7m0ivzmc";
    };
  
    deps = [  ];
  };

  # A flymake handler for elixir-mode .ex files.     
  flymake-elixir = buildEmacsPackage {
    name = "flymake-elixir-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-elixir-0.4.el";
      sha256 = "1552k68l5cbldvfkl2569ziarf5b3vi3cxa27jp0lm2pq4d5bl03";
    };
  
    deps = [  ];
  };

  # use flymake with js code, on Windows
  flymake-for-jslint-for-wsh = buildEmacsPackage {
    name = "flymake-for-jslint-for-wsh-1.3.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-for-jslint-for-wsh-1.3.0.el";
      sha256 = "0hjvwjwlsn51dwl7d896fidyxdi998030di8rwnr9665d656kf75";
    };
  
    deps = [ flymake ];
  };

  # A flymake handler for go-mode files
  flymake-go = buildEmacsPackage {
    name = "flymake-go-2013.3.14";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-go-2013.3.14.el";
      sha256 = "05v8ibm4y7192r0c5cw6y2y3zs02rh5ff74kq89f87bi2nl5rsk5";
    };
  
    deps = [ flymake ];
  };

  # A flymake handler for haml files
  flymake-haml = buildEmacsPackage {
    name = "flymake-haml-0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-haml-0.7.el";
      sha256 = "0islbq47dw56sjg6y2a4lcazs0khmz8nj0f0789dvssk5fp5wz4i";
    };
  
    deps = [ flymake-easy ];
  };

  # Syntax-check haskell-mode using both ghc and hlint
  flymake-haskell-multi = buildEmacsPackage {
    name = "flymake-haskell-multi-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-haskell-multi-0.3.tar";
      sha256 = "0ac7dk7r7b1cz1yh27d5f3a4fny4vszb0di14g3k55iaxrwlxjy2";
    };
  
    deps = [ flymake-easy ];
  };

  # A flymake handler for haskell-mode files using hlint
  flymake-hlint = buildEmacsPackage {
    name = "flymake-hlint-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-hlint-0.2.el";
      sha256 = "0vwfxrq00risjzpzs9hxxc8rj50bzgy5q0al7a3ly7lljgsjfmrr";
    };
  
    deps = [ flymake-easy ];
  };

  # making flymake work with JSHint
  flymake-jshint = buildEmacsPackage {
    name = "flymake-jshint-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-jshint-1.0.el";
      sha256 = "0p7dlcdx2064whz947kh6mlpx61605kxyzrjsn4rn9a86vah88pb";
    };
  
    deps = [  ];
  };

  # A flymake handler for javascript using jslint
  flymake-jslint = buildEmacsPackage {
    name = "flymake-jslint-0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-jslint-0.10.el";
      sha256 = "0y0sdnryvlb2w98xy85bwlq45li8cv7b2l4x7jpxhfn2dzcsfyfk";
    };
  
    deps = [ flymake-easy ];
  };

  # A flymake handler for json using jsonlint
  flymake-json = buildEmacsPackage {
    name = "flymake-json-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-json-0.1.el";
      sha256 = "1gd8p4dsy9k8srvk83p0lrms45fzdx8dzd5j4pmwjv6dhhsa7x1b";
    };
  
    deps = [ flymake-easy ];
  };

  # Flymake handler for LESS stylesheets (lesscss.org)
  flymake-less = buildEmacsPackage {
    name = "flymake-less-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-less-0.2.el";
      sha256 = "1ry0pg4ssxq83bsffsrlzwgs472ybxbdxksmwdx73w079vapp7f1";
    };
  
    deps = [ less-css-mode ];
  };

  # Flymake for Lua
  flymake-lua = buildEmacsPackage {
    name = "flymake-lua-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-lua-1.0.el";
      sha256 = "133nqy7hsw9g5wydnbqmn7d4xyfw9l9q1brz3frfcd1b8j072pgm";
    };
  
    deps = [  ];
  };

  # Flymake handler for Perl to invoke Perl::Critic
  flymake-perlcritic = buildEmacsPackage {
    name = "flymake-perlcritic-1.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-perlcritic-1.0.3.tar";
      sha256 = "1mlw3drzkbg9n1rd85kqd39qz89p7ipd7266dnq2130v0xkd62gg";
    };
  
    deps = [ flymake ];
  };

  # A flymake handler for php-mode files
  flymake-php = buildEmacsPackage {
    name = "flymake-php-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-php-0.5.el";
      sha256 = "0azrjn23wcyp095scwnw0rxhixkillg13c148p231ds12rfnrd6n";
    };
  
    deps = [ flymake-easy ];
  };

  # Flymake handler for PHP to invoke PHP-CodeSniffer
  flymake-phpcs = buildEmacsPackage {
    name = "flymake-phpcs-1.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-phpcs-1.0.5.tar";
      sha256 = "0hsx8qfypgssmixxwl2lxwyczl401i93laindbnsa0sbki4q050f";
    };
  
    deps = [ flymake ];
  };

  # A flymake handler for python-mode files using pyflakes (or flake8)
  flymake-python-pyflakes = buildEmacsPackage {
    name = "flymake-python-pyflakes-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-python-pyflakes-0.8.el";
      sha256 = "1l3pvly4znl3k0jc6k2xpf5nzdc72vvl6gfl73x5lykp73qmflnp";
    };
  
    deps = [ flymake-easy ];
  };

  # A flymake handler for ruby-mode files
  flymake-ruby = buildEmacsPackage {
    name = "flymake-ruby-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-ruby-0.8.el";
      sha256 = "1m8qaq8h7a3pq2x0cjqi3yi25b9iqcvphxgzfhgx4ahx4c2lm2lb";
    };
  
    deps = [ flymake-easy ];
  };

  # Flymake handler for sass files
  flymake-sass = buildEmacsPackage {
    name = "flymake-sass-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-sass-0.6.el";
      sha256 = "0541dxmmxi17fbbnzgfrsziggnf5zi3lf39llldx6a9jz9y4y1ml";
    };
  
    deps = [ flymake-easy ];
  };

  # A flymake syntax-checker for shell scripts
  flymake-shell = buildEmacsPackage {
    name = "flymake-shell-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-shell-0.8.el";
      sha256 = "14a258nwa7z22wh78n1yavx9sxllf7qx8alm7drysi4dzcrjm77a";
    };
  
    deps = [ flymake-easy ];
  };

  # A flymake handler for tuareg-mode files
  flymake-tuareg = buildEmacsPackage {
    name = "flymake-tuareg-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flymake-tuareg-0.1.tar";
      sha256 = "0ry1x433hk0awdwzkjp803hvvybjjndxbyc1db9kkyf3ll4lpi4j";
    };
  
    deps = [  ];
  };

  # Flymake for PHP via PHP-CodeSniffer
  flyphpcs = buildEmacsPackage {
    name = "flyphpcs-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flyphpcs-1.0.1.el";
      sha256 = "19h5iwj5r50axa7yzwg624631zdq5v049an8s9y9058v1rd8p9n4";
    };
  
    deps = [  ];
  };

  # Improve flyspell responsiveness using idle timers
  flyspell-lazy = buildEmacsPackage {
    name = "flyspell-lazy-0.6.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/flyspell-lazy-0.6.4.el";
      sha256 = "187yw1ynn31yd28rnzcxh03nsk1jgn4hjp6jz7drqbkfjir13n4s";
    };
  
    deps = [  ];
  };

  # follow mode for compilation/output buffers
  fm = buildEmacsPackage {
    name = "fm-20130612.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fm-20130612.1.el";
      sha256 = "0jml2yakxnd981080zig177gxgzjjksf2191byn6im2wik0i3a3y";
    };
  
    deps = [  ];
  };

  # Unified user interface for Emacs folding modes
  fold-dwim = buildEmacsPackage {
    name = "fold-dwim-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fold-dwim-1.2.el";
      sha256 = "14az8h2j1pj428v0c5byim6v37hhlcs217ifhkyqff7r97v9f0pk";
    };
  
    deps = [  ];
  };

  # Fold DWIM bound to org key-strokes.
  fold-dwim-org = buildEmacsPackage {
    name = "fold-dwim-org-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fold-dwim-org-0.2.el";
      sha256 = "1kym4f00084jkn7njwrydsf7ihsp8c4r12556i96i81555783gc4";
    };
  
    deps = [ fold-dwim ];
  };

  # Just fold this region please
  fold-this = buildEmacsPackage {
    name = "fold-this-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fold-this-0.1.0.el";
      sha256 = "0nl98p4pqvjl1042pilcr3rs0a1ciyy1ax5m1pslcvnnmdib9m8b";
    };
  
    deps = [  ];
  };

  # Utility functions for working with fonts
  font-utils = buildEmacsPackage {
    name = "font-utils-0.6.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/font-utils-0.6.8.el";
      sha256 = "0gqhmmvdy70hakrlwvgcinxxx5ac9k5zcf63h19c6s8jjmiir7h9";
    };
  
    deps = [ persistent-soft pcache ];
  };

  # Minor mode that assigns a unique number to each frame for easy switching
  frame-tag = buildEmacsPackage {
    name = "frame-tag-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/frame-tag-0.1.0.el";
      sha256 = "0d06j13c54xf9wxxdfabnxwsyivfx4axc1r213mvd8i8ngxmzs90";
    };
  
    deps = [  ];
  };

  # change the size of frames in Emacs
  framesize = buildEmacsPackage {
    name = "framesize-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/framesize-0.0.1.el";
      sha256 = "0w8z0lc90yq7s2ywcny4737kpqz9xkkg1vvl934imf8nl7pmfl8k";
    };
  
    deps = [ key-chord ];
  };

  # Another frontend of subversion.
  fsvn = buildEmacsPackage {
    name = "fsvn-0.9.13";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fsvn-0.9.13.tar";
      sha256 = "0b2nfa6l1zf83yx9gk9ww5nqjll10jzlh7b1rdnbb7v272nlina8";
    };
  
    deps = [  ];
  };

  # a front-end for ack
  full-ack = buildEmacsPackage {
    name = "full-ack-0.2.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/full-ack-0.2.3.el";
      sha256 = "1m6wz2n6y9s0v66n3r2i991a97xl28ixayrb413zkyxv7fmar6jy";
    };
  
    deps = [  ];
  };

  # fullscreen window support for Emacs
  fullscreen-mode = buildEmacsPackage {
    name = "fullscreen-mode-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fullscreen-mode-0.0.1.el";
      sha256 = "0bql0dbqxvijsmg1nr6zmrqsq7fc2zzr32y9kyr70kvkmb6s8wra";
    };
  
    deps = [  ];
  };

  # Friendly URL retrieval
  furl = buildEmacsPackage {
    name = "furl-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/furl-0.0.2.el";
      sha256 = "1g9j3sdcll1nliahsz5im46ln71s42ybam1mfs7a3kj8c7z69swf";
    };
  
    deps = [  ];
  };

  # Fuzzy Matching
  fuzzy = buildEmacsPackage {
    name = "fuzzy-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fuzzy-0.1.el";
      sha256 = "0y12i73ldj4brg1p41xrpf8gz3jmp2qv02889sjp04851kb57r17";
    };
  
    deps = [  ];
  };

  # select indent-tabs-mode and format code automatically.
  fuzzy-format = buildEmacsPackage {
    name = "fuzzy-format-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fuzzy-format-0.1.1.el";
      sha256 = "1v0qxa5bjygmb5alpd44vigsbqc0npi9rli5r251bdrphlvyz3db";
    };
  
    deps = [  ];
  };

  # fuzzy matching
  fuzzy-match = buildEmacsPackage {
    name = "fuzzy-match-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/fuzzy-match-1.4.el";
      sha256 = "08al5ljj0cj1cnmczd1pvgqvd84ipmp92gr3rnjjw9ih73qi4yax";
    };
  
    deps = [  ];
  };

  # Gather string in buffer.
  gather = buildEmacsPackage {
    name = "gather-1.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gather-1.0.4.el";
      sha256 = "0fwm07n55v95ynjsmv19j201f5nzsbkcnbinapx5fm5mp7y3c2lx";
    };
  
    deps = [  ];
  };

  # GCCSense client for Emacs
  gccsense = buildEmacsPackage {
    name = "gccsense-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gccsense-0.2.el";
      sha256 = "0zbd9zm4yh6bgw0har222vrss88pp50bzz26fkmp7s2g15v9wbbh";
    };
  
    deps = [  ];
  };

  # A remote debugging environment for Emacs.
  geben = buildEmacsPackage {
    name = "geben-0.26";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/geben-0.26.tar";
      sha256 = "066rfbcw6k5kbzz9k7m81lzbp8wpbgsbbl3j25c1wgr4m1z6n1xn";
    };
  
    deps = [  ];
  };

  # GNU Emacs and Scheme talk to each other
  geiser = buildEmacsPackage {
    name = "geiser-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/geiser-0.4.tar";
      sha256 = "1my1xgrjk0q0m8bdr4ik09za6kc3fff56gylkiinh0favclhkd34";
    };
  
    deps = [  ];
  };

  # A package to help you lazy-load everything
  generate-autoloads = buildEmacsPackage {
    name = "generate-autoloads-0.0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/generate-autoloads-0.0.10.el";
      sha256 = "1c5jvl7m4xj8wfyd1xnqcyb2qxcp8wcp36a3nbbr0n03bwqgi5wi";
    };
  
    deps = [  ];
  };

  # GNU Global source code tagging system
  ggtags = buildEmacsPackage {
    name = "ggtags-0.6.6";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/ggtags-0.6.6.el";
      sha256 = "1b2gc3lrkx6lc6g6601fv9cr0qw9mx7l2q0pvl9sqsa184kfs1c7";
    };
  
    deps = [  ];
  };

  # A GitHub library for Emacs
  gh = buildEmacsPackage {
    name = "gh-0.7.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gh-0.7.2.tar";
      sha256 = "15b0vppw9mqaniab1jilfnrw2mj2sw7d8d8nhq2a3fk1y842rw86";
    };
  
    deps = [ eieio pcache logito ];
  };

  # Happy Haskell programming on Emacs
  ghc = buildEmacsPackage {
    name = "ghc-1.10.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ghc-1.10.2.tar";
      sha256 = "1rid3z3d6736if52bvh1cfbymrnmsjd47dpsm91x4zwhpgz61813";
    };
  
    deps = [ haskell-mode ];
  };

  # Completion for GHCi commands in inferior-haskell buffers -*- lexical-binding: t; -*-
  ghci-completion = buildEmacsPackage {
    name = "ghci-completion-0.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ghci-completion-0.1.3.el";
      sha256 = "08b0kvf23l89hsf3czc4hb30h1rilx52v0k1vxw1sjaj9180a1kh";
    };
  
    deps = [  ];
  };

  # The XMMS2 interface we all love! Check out http://gimmeplayer.org for more info.
  gimme = buildEmacsPackage {
    name = "gimme-2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gimme-2.1.tar";
      sha256 = "092x8fwaniv2wy7z01qx0dzifcpg79wyg2f0b16whn4s8448pbn0";
    };
  
    deps = [  ];
  };

  # Emacs integration for gist.github.com
  gist = buildEmacsPackage {
    name = "gist-1.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gist-1.1.1.el";
      sha256 = "1zdkxynxyl2b1zmg30h4cznd0l2fgv7ql82l6jha7nkl19lmdfc5";
    };
  
    deps = [ eieio gh tabulated-list ];
  };

  # Emacs Minor mode to automatically commit and push
  git-auto-commit-mode = buildEmacsPackage {
    name = "git-auto-commit-mode-4.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/git-auto-commit-mode-4.2.1.el";
      sha256 = "06qcwdv35nr5ghyq36vk4c9nh333cam4qvg9v7f6xrk4mbfjryqx";
    };
  
    deps = [  ];
  };

  # Major mode for editing git commit messages
  git-commit = buildEmacsPackage {
    name = "git-commit-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/git-commit-0.1.el";
      sha256 = "1ai18fsdkagfbfpcc9fgm6y8va121naq594zgarlv6ll9wlx5qx6";
    };
  
    deps = [  ];
  };

  # Major mode for editing git commit messages -*- lexical-binding: t; -*-
  git-commit-mode = buildEmacsPackage {
    name = "git-commit-mode-0.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/git-commit-mode-0.12.el";
      sha256 = "0m0p3jg69nskk3hpk22qixm0axxa3dn32yj7dhdgq799g9wpg7pm";
    };
  
    deps = [  ];
  };

  # Port of Sublime Text plugin GitGutter
  git-gutter = buildEmacsPackage {
    name = "git-gutter-0.42";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/git-gutter-0.42.el";
      sha256 = "0b52mv5yj5fp4nwijl7id0l3y43q63xys3bgmrl8mvqz55qdhhqq";
    };
  
    deps = [  ];
  };

  # Fringe version of git-gutter.el
  git-gutter-fringe = buildEmacsPackage {
    name = "git-gutter-fringe-0.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/git-gutter-fringe-0.12.el";
      sha256 = "0xramcvibkq6wm539dy8bs6k4h81qn6nlhpc4pcdkib95kms3s8g";
    };
  
    deps = [ git-gutter fringe-helper ];
  };

  # Major mode for editing .gitconfig files -*- lexical-binding: t; -*-
  gitconfig-mode = buildEmacsPackage {
    name = "gitconfig-mode-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gitconfig-mode-0.3.el";
      sha256 = "1vd4q07fq31dshra3qd8cbm1sdi66p2hr8rlpaj14r7lkqki73yf";
    };
  
    deps = [  ];
  };

  # View the file you're editing on GitHub
  github-browse-file = buildEmacsPackage {
    name = "github-browse-file-0.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/github-browse-file-0.2.1.el";
      sha256 = "0xls3kn4ygk3lr2ll398ha0c9l2p1gfdgysv7w7drwnrnsbcncyn";
    };
  
    deps = [  ];
  };

  # Github color theme for GNU Emacs 24
  github-theme = buildEmacsPackage {
    name = "github-theme-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/github-theme-0.0.3.el";
      sha256 = "0dlay1h73mjz8klbvf7apfvnj9hasm0zlw0g2x0h39slb2d782iq";
    };
  
    deps = [  ];
  };

  # Major mode for editing .gitconfig files
  gitignore-mode = buildEmacsPackage {
    name = "gitignore-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gitignore-mode-0.1.el";
      sha256 = "1zqmsfkcnnfm2hb2js7k8wpvndhj19498p3fmgapqndazxdc3qnn";
    };
  
    deps = [  ];
  };

  # vc-mode extension for fast git interaction
  gitty = buildEmacsPackage {
    name = "gitty-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gitty-1.0.el";
      sha256 = "0pqagkwm7wnwvl0pfyg19fy7b7cgca3jhs4sxyv6h0s5ki36w5aq";
    };
  
    deps = [  ];
  };

  # Emacs interface to Gnome nmcli command
  gnomenm = buildEmacsPackage {
    name = "gnomenm-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gnomenm-0.0.3.el";
      sha256 = "0k543484zjyv6gq9v1dakb89l231bxkh0pay2ky2f4npa8idgv9h";
    };
  
    deps = [  ];
  };

  # Play a game of Go against gnugo
  gnugo = buildEmacsPackage {
    name = "gnugo-2.2.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gnugo-2.2.12.el";
      sha256 = "09cm8l78f291ybqr6qvvjwr39rr7qkl7jgcmqcma3c333b8ximmh";
    };
  
    deps = [  ];
  };

  # drive gnuplot from within emacs
  gnuplot = buildEmacsPackage {
    name = "gnuplot-0.6.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gnuplot-0.6.0.el";
      sha256 = "0f7v057vc0walhsn9nga9ibpp7ag5hjk00sa94lsk1kl7cx4k409";
    };
  
    deps = [  ];
  };

  # Adding per-message notes in gnus summary buffer
  gnusnotes = buildEmacsPackage {
    name = "gnusnotes-0.9.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gnusnotes-0.9.2.el";
      sha256 = "1q1m28d986p8sjgqy349ny721kixjg4p05ngw065xsbib7dafzk3";
    };
  
    deps = [  ];
  };

  # Major mode for the Go programming language.
  go-mode = buildEmacsPackage {
    name = "go-mode-12869";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/go-mode-12869.tar";
      sha256 = "1pczils2ki0ffx1r7ckfmzvvrxf6bg684lqc4alz7a8f8h3nqdwm";
    };
  
    deps = [  ];
  };

  # Paste to play.golang.org
  go-play = buildEmacsPackage {
    name = "go-play-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/go-play-0.0.1.el";
      sha256 = "072dx755vyl3x71nd45pbliwyzvmdygj2sk8wxbd4jy6g6n0bmx1";
    };
  
    deps = [  ];
  };

  # Emacs interface to Google Translate
  google-translate = buildEmacsPackage {
    name = "google-translate-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/google-translate-0.4.el";
      sha256 = "1aqbrkazh0k3s7dxb0bwanj15ifxrdv8v4qndqiv2p1j7xll7ff4";
    };
  
    deps = [  ];
  };

  # easily access and navigate Gopher servers
  gopher = buildEmacsPackage {
    name = "gopher-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gopher-0.0.2.el";
      sha256 = "1i70h8mkskxxpm9mq263lhmscpzq5q01rlrc015z292l670azp6h";
    };
  
    deps = [  ];
  };

  # Move point through buffer-undo-list positions -*-unibyte: t; coding: iso-8859-1;-*-
  goto-last-change = buildEmacsPackage {
    name = "goto-last-change-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/goto-last-change-1.2.el";
      sha256 = "1sfb2vd1k71v0qbfdp0f0m1crmd5fh4n1dp1jdz42vzb8z1d1l49";
    };
  
    deps = [  ];
  };

  # Add Google Plus markup to a piece of code
  gplusify = buildEmacsPackage {
    name = "gplusify-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gplusify-1.0.el";
      sha256 = "06aqk6isk0vv5vvccygmdcsw9w5dpn4x02gxz6sq569vdm7p01zs";
    };
  
    deps = [  ];
  };

  # minor-mode that adds some Grails project management to a grails project
  grails-mode = buildEmacsPackage {
    name = "grails-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/grails-mode-0.1.el";
      sha256 = "0bma414vrrir3wq78iypc8vdl0xmbzwm5jzfvv2qx2jz89c39wnx";
    };
  
    deps = [  ];
  };

  # Mode for the dot-language used by graphviz (att).
  graphviz-dot-mode = buildEmacsPackage {
    name = "graphviz-dot-mode-0.3.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/graphviz-dot-mode-0.3.7.el";
      sha256 = "1c7299xyp4q3g9ain4idlygbh73vfvkdh7cbwfs495y424rccmvx";
    };
  
    deps = [  ];
  };

  # HTTP request lib with flexible callback dispatch
  grapnel = buildEmacsPackage {
    name = "grapnel-0.5.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/grapnel-0.5.1.el";
      sha256 = "0bjdyj8sx4mnqza1snzmwidj0jh81w11vd1gjrxp7fqyfnyc4vl7";
    };
  
    deps = [  ];
  };

  # manages multiple search results buffers for grep.el
  grep-a-lot = buildEmacsPackage {
    name = "grep-a-lot-1.0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/grep-a-lot-1.0.6.el";
      sha256 = "0kb7bgxgw47mlkayyxhxl49nb36xvmq3q1lvi2ldzxlmjjmmvqfx";
    };
  
    deps = [  ];
  };

  # auto grep word under cursor
  grep-o-matic = buildEmacsPackage {
    name = "grep-o-matic-1.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/grep-o-matic-1.0.4.el";
      sha256 = "0isnmphsq9li6nx7n84c9pkmpiqs9jzs80vsxsydxwjlkxlr0gdb";
    };
  
    deps = [  ];
  };

  # run grin and grind (python replacements for grep and find) putting hits in a grep buffer
  grin = buildEmacsPackage {
    name = "grin-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/grin-1.0.el";
      sha256 = "10c7gwm06whnkfrgwddl05hcc40kj6yi2dck0nvax115d2hsbpgd";
    };
  
    deps = [  ];
  };

  # Groovy mode derived mode
  groovy-mode = buildEmacsPackage {
    name = "groovy-mode-201203310931";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/groovy-mode-201203310931.el";
      sha256 = "14jcpjnd121kb652vayfycy3gpar35m0rpp1d6flc18jhdpnyamb";
    };
  
    deps = [  ];
  };

  # Simple Growl notifications for Emacs and Mac OS X
  grr = buildEmacsPackage {
    name = "grr-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/grr-1.0.0.el";
      sha256 = "19ybfh4n1s97667zqly04v1hsrqqlgqcr4fv39xzdz5rxqjx854x";
    };
  
    deps = [  ];
  };

  # Gruber Darker color theme for Emacs 24.
  gruber-darker-theme = buildEmacsPackage {
    name = "gruber-darker-theme-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gruber-darker-theme-0.4.el";
      sha256 = "1d5bvvryqa9windkjqcf9dmpph8mm346gp658mqg1qqjzs2zwxcy";
    };
  
    deps = [  ];
  };

  # gtags facility for Emacs
  gtags = buildEmacsPackage {
    name = "gtags-3.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/gtags-3.3.el";
      sha256 = "0jk93qls5q9w76ifwaj5dzs2nqkj16a6x1mwsmjy7nvfmkllcknf";
    };
  
    deps = [  ];
  };

  # Automatically determine c-basic-offset
  guess-offset = buildEmacsPackage {
    name = "guess-offset-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/guess-offset-0.1.1.el";
      sha256 = "0971c3y2gk6gwbzadsxwkqw1l8x6hgqvkkds0l5rs9jj5lryd4kq";
    };
  
    deps = [  ];
  };

  # Guile Scheme editing mode
  guile-scheme = buildEmacsPackage {
    name = "guile-scheme-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/guile-scheme-0.1.el";
      sha256 = "0bk43fbj8cl78kswxypbw4kz89x7iczgrmkyxiv18ksyp9mlxh5i";
    };
  
    deps = [  ];
  };

  # Become an Emacs guru
  guru-mode = buildEmacsPackage {
    name = "guru-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/guru-mode-0.1.el";
      sha256 = "0w3s1fvhkw0s25ms706d3vy4nfchmf1krc8vmrzj5h7x4c18w466";
    };
  
    deps = [  ];
  };

  # Access the hackernews aggregator from Emacs
  hackernews = buildEmacsPackage {
    name = "hackernews-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hackernews-0.1.tar";
      sha256 = "03133l0vm2y5442i4il7b8jzfim89093mpv76svy6370s0ddjddk";
    };
  
    deps = [ json ];
  };

  # Major mode for editing Haml files
  haml-mode = buildEmacsPackage {
    name = "haml-mode-3.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/haml-mode-3.1.0.el";
      sha256 = "11nirgldvg36wmfyb4h0bpgzj7kaaif75w5zzsixvn9a1di76wr2";
    };
  
    deps = [ ruby-mode ];
  };

  # A major mode for editing Handlebars files.
  handlebars-mode = buildEmacsPackage {
    name = "handlebars-mode-1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/handlebars-mode-1.3.el";
      sha256 = "0bcb83p3ms56bh8aajiicfslisz132w57pishk648asrbyf45n6h";
    };
  
    deps = [  ];
  };

  # Add Handlebars contextual indenting support to sgml-mode
  handlebars-sgml-mode = buildEmacsPackage {
    name = "handlebars-sgml-mode-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/handlebars-sgml-mode-0.1.0.el";
      sha256 = "1i1lvc8djfv4pzysbjlf1lf4sg4xkim2s9d41a6hsavqcaff2w8q";
    };
  
    deps = [  ];
  };

  # Disable arrow keys + optionally backspace and return
  hardcore-mode = buildEmacsPackage {
    name = "hardcore-mode-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hardcore-mode-1.0.0.el";
      sha256 = "1qs4i3wjd6jsr24fj8d6d4d07yazjcfpxwaqlbikkkg2cbj159a7";
    };
  
    deps = [  ];
  };

  # Protect against clobbering user-writable files
  hardhat = buildEmacsPackage {
    name = "hardhat-0.3.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hardhat-0.3.6.el";
      sha256 = "1afms6cvi1f5yp792w96xy5x8bhg1lxmvni1r4sjk73fdjb0pg6p";
    };
  
    deps = [ ignoramus ];
  };

  # A Haskell editing mode
  haskell-mode = buildEmacsPackage {
    name = "haskell-mode-13.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/haskell-mode-13.6.tar";
      sha256 = "0673yx3bd1yz71ih1fhwbgmx5a6zr8f376ck518gw0jx7g2hympj";
    };
  
    deps = [  ];
  };

  # Emacs client for hastebin (http://hastebin.com/about.md)
  haste = buildEmacsPackage {
    name = "haste-1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/haste-1.el";
      sha256 = "1cydbcwrfhbmd33qky55xsp0248d3cwp6cvkm6v2jsx1wpicapbz";
    };
  
    deps = [ json ];
  };

  # An Emacs major mode for haXe
  haxe-mode = buildEmacsPackage {
    name = "haxe-mode-0.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/haxe-mode-0.3.1.el";
      sha256 = "1vn0nrrglzqd5dqgdsfs3f90xgwbasgb7v68qp6bqh92ran8gils";
    };
  
    deps = [  ];
  };

  # Support for creation and update of file headers.
  header2 = buildEmacsPackage {
    name = "header2-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/header2-21.0.el";
      sha256 = "0lvcgbwqndbfayndcvw431m0nhpdg8fk34hjp4mzkbfqf4kdjn27";
    };
  
    deps = [  ];
  };

  # Heap (a.k.a. priority queue) data structure
  heap = buildEmacsPackage {
    name = "heap-0.3";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/heap-0.3.el";
      sha256 = "1347s06nv88zyhmbimvn13f13d1r147kn6kric1ki6n382zbw6k6";
    };
  
    deps = [  ];
  };

  # the silver search with helm interface
  helm-ag = buildEmacsPackage {
    name = "helm-ag-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/helm-ag-0.4.el";
      sha256 = "0bnrrx55n28kfpxlk95r51wqhjxgzx6hv0mpjxw20431c31zzivd";
    };
  
    deps = [ helm ];
  };

  # GNU GLOBAL helm interface
  helm-gtags = buildEmacsPackage {
    name = "helm-gtags-0.9.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/helm-gtags-0.9.2.el";
      sha256 = "1chb5cci2i5ygrj39jnsb3cfwnikf9rsipkmgvjiwgmgpd1qaavi";
    };
  
    deps = [ helm ];
  };

  # Helm integration for Projectile
  helm-projectile = buildEmacsPackage {
    name = "helm-projectile-0.9.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/helm-projectile-0.9.1.el";
      sha256 = "0lh11a9vqpa983wwggm28f9gwd0z15bqzzjx22dqcg159vr4nmfh";
    };
  
    deps = [ helm projectile ];
  };

  # Interface to Heroku apps.
  heroku = buildEmacsPackage {
    name = "heroku-1.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/heroku-1.1.0.el";
      sha256 = "0byndz2glaww18my2bf7qqznzcziik3sf4a0m4gq5wjnpg9r59km";
    };
  
    deps = [  ];
  };

  # Functions to manipulate colors, including RGB hex strings.
  hexrgb = buildEmacsPackage {
    name = "hexrgb-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hexrgb-21.0.el";
      sha256 = "0ff87h8j4iwfk47791ffh5cm2j2iysiqbw19dbn7advqbhnv70xa";
    };
  
    deps = [  ];
  };

  # Hide/show comments in code.
  hide-comnt = buildEmacsPackage {
    name = "hide-comnt-40";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hide-comnt-40.tar";
      sha256 = "0l98vcfw3pbvqjjj7s5p5mgmzfc1fgn57vmharrn8brfaklw3s7z";
    };
  
    deps = [  ];
  };

  # Add markers to the fringe for regions foldable by hideshow.el
  hideshowvis = buildEmacsPackage {
    name = "hideshowvis-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hideshowvis-0.5.el";
      sha256 = "0xmh1k4a3klz18rjvmfqyn858mhnxqqwxs4z8jnvpy044xs9mh74";
    };
  
    deps = [  ];
  };

  # Highlighting commands.
  highlight = buildEmacsPackage {
    name = "highlight-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/highlight-21.0.el";
      sha256 = "0cryvy3qqjfq2zfl4fwbjjnr9gpxxrswpgslpsm9pxvip7wcwn6s";
    };
  
    deps = [  ];
  };

  # highlight characters beyond column 80
  highlight-80-plus = buildEmacsPackage {
    name = "highlight-80-plus-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/highlight-80+-1.0.el";
      sha256 = "0qk8wa7lpcr77jdvngc5ffbim629qqips0d2qcgf7al89qgchkxr";
    };
  
    deps = [  ];
  };

  # Highlight escape sequences -*- lexical-binding: t -*-
  highlight-escape-sequences = buildEmacsPackage {
    name = "highlight-escape-sequences-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/highlight-escape-sequences-0.1.el";
      sha256 = "0k6yc510g8bcqjxzkm9ig768xjbr03pz68i46cgva1gggcy3hq6k";
    };
  
    deps = [  ];
  };

  # Function for highlighting indentation
  highlight-indentation = buildEmacsPackage {
    name = "highlight-indentation-0.5.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/highlight-indentation-0.5.0.el";
      sha256 = "0izdpfgy6rx05s7s4ayxz01pa5rmiyz0wfxwf8gcqd3dirg3jsmr";
    };
  
    deps = [  ];
  };

  # highlight surrounding parentheses
  highlight-parentheses = buildEmacsPackage {
    name = "highlight-parentheses-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/highlight-parentheses-1.0.1.el";
      sha256 = "1ma7ndv8vhfcly06jrm1xgbz3j748m96aspsmkgyh6vk03k8ykw5";
    };
  
    deps = [  ];
  };

  # automatic and manual symbol highlighting
  highlight-symbol = buildEmacsPackage {
    name = "highlight-symbol-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/highlight-symbol-1.1.el";
      sha256 = "1xww0q6p199nxws5mqdi1s18m3wbsvs3zzgxhnxjqb3iiymxicsc";
    };
  
    deps = [  ];
  };

  # minor mode to highlight current line in buffer
  highline = buildEmacsPackage {
    name = "highline-7.2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/highline-7.2.2.el";
      sha256 = "05xrsy4z8nffv7fz5gbxyzsybqs28da5zq8m2nby640ywg6459gw";
    };
  
    deps = [  ];
  };

  # Hippie expand try function using ghc's completion function.
  hippie-expand-haskell = buildEmacsPackage {
    name = "hippie-expand-haskell-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hippie-expand-haskell-0.0.1.el";
      sha256 = "16lcc5zp5wywpywmrnlx7xwc6yaknj7639d4wgmm3j88q07ykj3g";
    };
  
    deps = [  ];
  };

  # Hook slime's completion into hippie-expand
  hippie-expand-slime = buildEmacsPackage {
    name = "hippie-expand-slime-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hippie-expand-slime-0.1.el";
      sha256 = "1pp8y0ik4xmhw3p583yzb80c7kp1h0xyrbwl96nizk649xj15h1a";
    };
  
    deps = [  ];
  };

  # Special treatment for namespace prefixes in hippie-expand
  hippie-namespace = buildEmacsPackage {
    name = "hippie-namespace-0.5.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hippie-namespace-0.5.6.el";
      sha256 = "0b81pn0n98gjskg66mh24k07hd4n6lp45jpybafxk2vhgdd89dms";
    };
  
    deps = [  ];
  };

  # Hive SQL mode extension
  hive = buildEmacsPackage {
    name = "hive-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hive-0.1.1.el";
      sha256 = "0622sfka2yf0ipc2gx3fg36kmgl253fc92fkndavrwbnd23pv4gs";
    };
  
    deps = [ sql ];
  };

  # import some vim's key bindings
  hjkl-mode = buildEmacsPackage {
    name = "hjkl-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hjkl-mode-0.1.tar";
      sha256 = "0f9prakr7s22m9ar0sd7j1m5fprff0d6vlr2hkrh8miipd9d9ans";
    };
  
    deps = [ key-chord ];
  };

  # Extensions to hl-line.el.
  hl-line-plus = buildEmacsPackage {
    name = "hl-line-plus-22.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hl-line+-22.0.el";
      sha256 = "1n0cxvclz1h1ziykcvdmli8si70jqv5sl65ap35lk77isbpjpid1";
    };
  
    deps = [  ];
  };

  # highlight a sentence based on customizable face
  hl-sentence = buildEmacsPackage {
    name = "hl-sentence-2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hl-sentence-2.el";
      sha256 = "1z3apya76yi5rh1xsn5a8smxcf2z1x94li0zi13mhxpn03bn8mkb";
    };
  
    deps = [  ];
  };

  # highlight the current sexp
  hl-sexp = buildEmacsPackage {
    name = "hl-sexp-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hl-sexp-1.0.0.el";
      sha256 = "1i8wkvi1k8pkp6h4lvva9msdrbpxxjcf92hs4iglgd9p9cw12mnd";
    };
  
    deps = [  ];
  };

  # Extension for linum.el to highlight current line number
  hlinum = buildEmacsPackage {
    name = "hlinum-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hlinum-1.0.el";
      sha256 = "0lixb84lv92jhgr1r2d378k5i1kv53shwfg4pn2f1z7609iwavj9";
    };
  
    deps = [  ];
  };

  # The missing hash table library for Emacs
  ht = buildEmacsPackage {
    name = "ht-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ht-0.8.el";
      sha256 = "0746i6vm27mr7yhx1mw1vdi727ygrbqqf9dk64arnzdx2wy646vg";
    };
  
    deps = [  ];
  };

  # Insert <script src=".."> for popular JavaScript libraries
  html-script-src = buildEmacsPackage {
    name = "html-script-src-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/html-script-src-0.0.2.el";
      sha256 = "03zqcv7b57gn17ixvr8cqbdq7hdgcgd3gdx8b8p3j8inhjdmvaki";
    };
  
    deps = [  ];
  };

  # htmlise a buffer/source tree with optional hyperlinks
  htmlfontify = buildEmacsPackage {
    name = "htmlfontify-0.21";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/htmlfontify-0.21.el";
      sha256 = "036c1acdfsg1ykixpwgqlg409gnr6mmlkhld9w8jn3d14y8ai5z0";
    };
  
    deps = [  ];
  };

  # Convert buffer text and decorations to HTML.
  htmlize = buildEmacsPackage {
    name = "htmlize-1.39";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/htmlize-1.39.el";
      sha256 = "0qvgwi2dxb96m9b88l9ny3cfli9vc19p63bc04kgsfkpx0jl5asi";
    };
  
    deps = [  ];
  };

  # send & twiddle & resend HTTP requests
  http-twiddle = buildEmacsPackage {
    name = "http-twiddle-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/http-twiddle-1.0.el";
      sha256 = "0lbzfy3j9m67k15pqpqdkj3mvk1r2ijzwq95a9ms08agv3wwmifm";
    };
  
    deps = [  ];
  };

  # explains the meaning of an HTTP status code
  httpcode = buildEmacsPackage {
    name = "httpcode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/httpcode-0.1.el";
      sha256 = "0m2yqr11gmp8jj2v6aw2jjb202ywdvlzckhpn5ix5vjy8ifa6an7";
    };
  
    deps = [  ];
  };

  # HTTP/1.0 web server for emacs
  httpd = buildEmacsPackage {
    name = "httpd-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/httpd-1.0.1.el";
      sha256 = "0579vfyarnjqchg5mglwqzfp5fa7g5g377c0wlgjps0acjdjnvis";
    };
  
    deps = [  ];
  };

  # hungry delete minor mode
  hungry-delete = buildEmacsPackage {
    name = "hungry-delete-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/hungry-delete-1.0.el";
      sha256 = "03wwc78ffqp8m0l14s3sz76k9v5qcq9ksl9sskdlvilyqnvrwm4h";
    };
  
    deps = [  ];
  };

  # chainsaw powered logging
  huskie = buildEmacsPackage {
    name = "huskie-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/huskie-0.0.2.el";
      sha256 = "0fgmdpj08bb03fr3g8a0ggaklw37c0lql39i5cbir690dz2qb7fh";
    };
  
    deps = [ anaphora ];
  };

  # Group ibuffer's list by VC project, or show VC status
  ibuffer-vc = buildEmacsPackage {
    name = "ibuffer-vc-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ibuffer-vc-0.6.el";
      sha256 = "17lbrqnh8zb5yk7wpn7ma6cask046rljg89n8p2nwrc90rbdxx43";
    };
  
    deps = [ cl-lib ];
  };

  # Extensions to `icomplete.el'.
  icomplete-plus = buildEmacsPackage {
    name = "icomplete-plus-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/icomplete+-21.0.el";
      sha256 = "1m4c49wwl2nx4967rf4zhk2dc5sxpri3jz47h86pr30k6sc5hr81";
    };
  
    deps = [  ];
  };

  # highlight the word the point is on
  idle-highlight = buildEmacsPackage {
    name = "idle-highlight-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/idle-highlight-1.0.el";
      sha256 = "1ca7ypwl75w6204azz0lf2lj8pw6fq75083q84cv4zjan3sygn4z";
    };
  
    deps = [  ];
  };

  # highlight the word the point is on
  idle-highlight-mode = buildEmacsPackage {
    name = "idle-highlight-mode-1.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/idle-highlight-mode-1.1.2.el";
      sha256 = "14a3j55lrdiigq8c1kh7a4kywyk40yrqyz1z5rrv41m8dvj4hxyh";
    };
  
    deps = [  ];
  };

  # load elisp libraries while Emacs is idle
  idle-require = buildEmacsPackage {
    name = "idle-require-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/idle-require-1.0.el";
      sha256 = "0x32jymqafx13idknzlcsf12882hrsnkn7a1cbgdpg6dwb8d7kvr";
    };
  
    deps = [  ];
  };

  # A better flex (fuzzy) algorithm for Ido.
  ido-better-flex = buildEmacsPackage {
    name = "ido-better-flex-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ido-better-flex-0.0.2.el";
      sha256 = "00h45i46qqsqj5cgavgsbmkdzcckfygm2kn1pbz5qpn59bimxgx3";
    };
  
    deps = [  ];
  };

  # Load-library alternative using ido-completing-read
  ido-load-library = buildEmacsPackage {
    name = "ido-load-library-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ido-load-library-0.1.2.el";
      sha256 = "1im1g53jibgbib7ci5hpx04jafv7bf5brx9367lcxavb2m1k8v9a";
    };
  
    deps = [ persistent-soft pcache ];
  };

  # Use ido (nearly) everywhere.
  ido-ubiquitous = buildEmacsPackage {
    name = "ido-ubiquitous-1.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ido-ubiquitous-1.6.el";
      sha256 = "04fa9bhm7mjx94fnhwc4yjsj2wnj4jp5jsrh7f5mkx3p24fds9rr";
    };
  
    deps = [  ];
  };

  # Use Ido to answer yes-or-no questions
  ido-yes-or-no = buildEmacsPackage {
    name = "ido-yes-or-no-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ido-yes-or-no-1.1.el";
      sha256 = "0h6fwiqc14bfx91ndhi49kriayqgaqm656mfpj0hdx6mhncbds6z";
    };
  
    deps = [ ido ];
  };

  # imenu tag selection with ido
  idomenu = buildEmacsPackage {
    name = "idomenu-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/idomenu-0.1.el";
      sha256 = "0hlsm1z15rrckgzdy4v0xvas1whns2q6bbak95mimr6f05mznmr2";
    };
  
    deps = [  ];
  };

  # Edit multiple regions in the same way simultaneously.
  iedit = buildEmacsPackage {
    name = "iedit-0.97";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/iedit-0.97.tar";
      sha256 = "02jyn1n31xprsskqv7q5kcgxcsrl3f0b5x0mij0nsmlcld377c9d";
    };
  
    deps = [  ];
  };

  # Ignore backups, build files, et al.
  ignoramus = buildEmacsPackage {
    name = "ignoramus-0.6.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ignoramus-0.6.4.el";
      sha256 = "1w3pn19kxzyrjfc10dg0mdsy3gxh9majxk1801drd9g6zf5yi3mz";
    };
  
    deps = [  ];
  };

  # An improved interface to `grep` and `find`
  igrep = buildEmacsPackage {
    name = "igrep-2.113";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/igrep-2.113.el";
      sha256 = "0xwqzfz882rv7rbiq9rmkmga21gfk26vz087xh2wcbq163191z9l";
    };
  
    deps = [  ];
  };

  # Image-dired extensions
  image-dired-plus = buildEmacsPackage {
    name = "image-dired-plus-0.6.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/image-dired+-0.6.0.el";
      sha256 = "12cjwqmqb0lld8v4ycksdzr7fx4mb5ia4lwgrirnf7a5bvd51d0m";
    };
  
    deps = [  ];
  };

  # imgur client for Emacs
  imgur = buildEmacsPackage {
    name = "imgur-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/imgur-0.1.el";
      sha256 = "03i10dbp1nhwxayi4digpb0k13ij9r78pkph3jb43mrwayx3828g";
    };
  
    deps = [ anything ];
  };

  # show vertical lines to guide indentation
  indent-guide = buildEmacsPackage {
    name = "indent-guide-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/indent-guide-1.0.1.el";
      sha256 = "0z77q63c7jnlzykgsiywc0wgpwmxcljyy3bdxdf0jm4qs8nf0lkx";
    };
  
    deps = [  ];
  };

  # minor-mode that adds some Grails project management to a grails project
  inf-groovy = buildEmacsPackage {
    name = "inf-groovy-2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/inf-groovy-2.0.el";
      sha256 = "0912w52q1m8f2c1w527n8mir0mq1rh8sfyk9f77blp4zc3f71gz4";
    };
  
    deps = [  ];
  };

  # Run a ruby process in a buffer
  inf-ruby = buildEmacsPackage {
    name = "inf-ruby-2.2.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/inf-ruby-2.2.5.el";
      sha256 = "172dnyk9fi8nj0v21f1xsrblzapg298rzhv3nsxysqw6n94zigzc";
    };
  
    deps = [  ];
  };

  # convert english words between singular and plural
  inflections = buildEmacsPackage {
    name = "inflections-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/inflections-1.1.el";
      sha256 = "0r5z7w70bi8fw130skyn02fmciaia31q2317c7n9dx2v1zyj5c4r";
    };
  
    deps = [  ];
  };

  # Major mode for Inform 6 interactive fiction code
  inform-mode = buildEmacsPackage {
    name = "inform-mode-1.6.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/inform-mode-1.6.1.el";
      sha256 = "0n7bccrv81prxcq8x8wx629sgpmk0p1kwp1j66c5m3rqdilwhwl6";
    };
  
    deps = [  ];
  };

  # Simple inline encryption via openssl
  inline-crypt = buildEmacsPackage {
    name = "inline-crypt-0.1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/inline-crypt-0.1.4.tar";
      sha256 = "16vwkwdi6yldyyn1f924zayn2hscm3hhqlzjvmikpn8cq2j9bw2h";
    };
  
    deps = [  ];
  };

  # Incremental occur
  ioccur = buildEmacsPackage {
    name = "ioccur-2.4";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/ioccur-2.4.el";
      sha256 = "1isid3kgsi5qkz27ipvmp9v5knx0qigmv7lz12mqdkwv8alns1p9";
    };
  
    deps = [  ];
  };

  # Adds support for IPython to python-mode.el
  ipython = buildEmacsPackage {
    name = "ipython-2927";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ipython-2927.el";
      sha256 = "1a4gwvd42fl1jrgndgmr9d5drww7jsda15i2z85h7c9ip6zxmd90";
    };
  
    deps = [  ];
  };

  # Interface for IETF RFC document.
  irfc = buildEmacsPackage {
    name = "irfc-0.5.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/irfc-0.5.6.el";
      sha256 = "05a7ahqfghq2pn5p767ccky93rl2ykhh3m8g31s8v0x816nszwq5";
    };
  
    deps = [  ];
  };

  # interactive server eval at mode, a comint for a daemonized emacs -*- lexical-binding: t -*-
  isea = buildEmacsPackage {
    name = "isea-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/isea-0.0.2.el";
      sha256 = "0g68idpjx5k7266qml5kahngpzr4rp43ba7plli3hrffc445g9mz";
    };
  
    deps = [ elpakit ];
  };

  # Extensions to `isearch.el'.
  isearch-plus = buildEmacsPackage {
    name = "isearch-plus-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/isearch+-21.0.el";
      sha256 = "05mwrrfklm2a0sppl0646rvnf91psrxa6gnivjz2djyb0lk0jgg2";
    };
  
    deps = [  ];
  };

  # Go to next CHAR which is similar to "f" in vim
  iy-go-to-char = buildEmacsPackage {
    name = "iy-go-to-char-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/iy-go-to-char-1.0.el";
      sha256 = "0z830ccb3pbhir97nim5jdhsfg7ab8y93q0wmgxwi0jlr4qkhirl";
    };
  
    deps = [  ];
  };

  # Major mode for editing J programs
  j-mode = buildEmacsPackage {
    name = "j-mode-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/j-mode-0.3.el";
      sha256 = "059g28gkr026xxnjy9470ja38kkp47x4y698m0vsipa2g2bp544c";
    };
  
    deps = [  ];
  };

  # A Jabber client for Emacs.
  jabber = buildEmacsPackage {
    name = "jabber-0.8.90";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jabber-0.8.90.tar";
      sha256 = "1rx2h4mgaqkg9ghmrzyaswvxg6ynvybr4fwknnkg95cna9yhmawz";
    };
  
    deps = [  ];
  };

  # Major mode for editing jade templates.
  jade-mode = buildEmacsPackage {
    name = "jade-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jade-mode-0.1.el";
      sha256 = "06b8pzc4vdzqyf86g954w50y0kpb9jmw6wyffyq7s6n1bh98lka2";
    };
  
    deps = [  ];
  };

  # Emacs Hit a Hint
  jaunte = buildEmacsPackage {
    name = "jaunte-0.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jaunte-0.0.0.el";
      sha256 = "0zv2dl7v7qbw1pd5psia66xx4fwkzdg2cshj4swd2ihm4pybqv05";
    };
  
    deps = [  ];
  };

  # Javadoc-Help.  Look up Java class on online javadocs in browser.
  javadoc-help = buildEmacsPackage {
    name = "javadoc-help-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/javadoc-help-1.0.el";
      sha256 = "0iiy8hsidbbmzrp5qhqga2ynp3h2zi35ca0b4p234krbir3maq0i";
    };
  
    deps = [  ];
  };

  # Javap major mode
  javap = buildEmacsPackage {
    name = "javap-8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/javap-8.el";
      sha256 = "1vp7b852hy437q8yfn17x860dn7sixzfbq6k5wkj7b6fhp6001wp";
    };
  
    deps = [  ];
  };

  # Javap major mode
  javap-mode = buildEmacsPackage {
    name = "javap-mode-9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/javap-mode-9.el";
      sha256 = "062barxdmsvlpxgp5gpwlfacl3cmbqx3ic8jj7iq7if76l9rp819";
    };
  
    deps = [  ];
  };

  # Minor mode for quick development of Java programs
  javarun = buildEmacsPackage {
    name = "javarun-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/javarun-0.1.1.el";
      sha256 = "02fw3crjw8sy8x3d1hif654i3xsm3j1wgaihdp9fwpmg6m95rwy7";
    };
  
    deps = [  ];
  };

  # Python auto-completion for Emacs
  jedi = buildEmacsPackage {
    name = "jedi-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jedi-0.1.2.tar";
      sha256 = "1rh3wzqf7szbx2d4pb2wgbndi46lgnsysp4akhb4s4zq1snap9m8";
    };
  
    deps = [ epc auto-complete ];
  };

  # Watch continuous integration build status -*- indent-tabs-mode: t; tab-width: 8 -*-
  jenkins-watch = buildEmacsPackage {
    name = "jenkins-watch-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jenkins-watch-1.2.el";
      sha256 = "1r1bvf25p5hgdgmzf5cgl1b0pvxd9hnp2s1fj8x4imk6h5fws3qi";
    };
  
    deps = [  ];
  };

  # Major mode for Jgraph files
  jgraph-mode = buildEmacsPackage {
    name = "jgraph-mode-1.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/jgraph-mode-1.0.el";
      sha256 = "1zhgdgymr6q3hv1l0l5asssdgyw7kmg6ncd6dwvz63837kzl7bcp";
    };
  
    deps = [  ];
  };

  # A major mode for jinja2
  jinja2-mode = buildEmacsPackage {
    name = "jinja2-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jinja2-mode-0.1.el";
      sha256 = "1dmwlpmqsmm338axh7mjgmlc5hfcq317g809k1yk0zqr5v123vvd";
    };
  
    deps = [  ];
  };

  # Connect to JIRA issue tracking software
  jira = buildEmacsPackage {
    name = "jira-0.3.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jira-0.3.3.el";
      sha256 = "1w2hwv37h0xddj3ki87rsj5fh90dkxmaxk9qbm66ij87xlh0xac6";
    };
  
    deps = [  ];
  };

  # Run javascript in an inferior process window.
  js-comint = buildEmacsPackage {
    name = "js-comint-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/js-comint-0.0.1.el";
      sha256 = "1pgx7hxkv25fhw49wbgybgzabgwqkw475vzdzi4785c7504lf7ip";
    };
  
    deps = [  ];
  };

  # Improved JavaScript editing mode
  js2-mode = buildEmacsPackage {
    name = "js2-mode-20130608";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/js2-mode-20130608.el";
      sha256 = "1s9q2bx870rbbk4jixji4pbchvpgf7k29z4vianxh3qr8zyp528c";
    };
  
    deps = [  ];
  };

  # JavaScript Object Notation parser / generator
  json = buildEmacsPackage {
    name = "json-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/json-1.2.el";
      sha256 = "1nsawlyv0q6v5z1f8fznfwb074lnbahx720di8441sq6xiynlbkq";
    };
  
    deps = [  ];
  };

  # Major mode for editing JSON files
  json-mode = buildEmacsPackage {
    name = "json-mode-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/json-mode-0.1.2.el";
      sha256 = "0mmvdrn8fz1rzip5g14266hl7vy50v6y6h0kkjd108cck14kdnwg";
    };
  
    deps = [  ];
  };

  # Run a javascript command interpreter in emacs on Windows.
  jsshell = buildEmacsPackage {
    name = "jsshell-2012.4.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jsshell-2012.4.7.el";
      sha256 = "1qxfl5hz0q1f1n0sbf2nh5zb5nygzfi1ad6pjhw74ncvpziymwqm";
    };
  
    deps = [  ];
  };

  # JSShell generated bundle
  jsshell-bundle = buildEmacsPackage {
    name = "jsshell-bundle-2012.4.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jsshell-bundle-2012.4.7.el";
      sha256 = "0di0vjwly72y2zsvrmq6bjwsj50a0cm0722kkz9540fd6sr112d8";
    };
  
    deps = [  ];
  };

  # enhanced tags functionality for Java development
  jtags = buildEmacsPackage {
    name = "jtags-0.97";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jtags-0.97.el";
      sha256 = "11n8d3xncdcl41p71qs464nsq77swd3g7k95s2iv92hck50pnd3n";
    };
  
    deps = [  ];
  };

  # jtags related functionality for Java development
  jtags-extras = buildEmacsPackage {
    name = "jtags-extras-0.3.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jtags-extras-0.3.0.el";
      sha256 = "0xadychsz85n1qxr9v8y5qqbg5wd0nfb6xapyfw2rrvx02a8larf";
    };
  
    deps = [  ];
  };

  # build functions which contextually jump between files
  jump = buildEmacsPackage {
    name = "jump-2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jump-2.2.el";
      sha256 = "1pn34jbs5nxw0vwajzm1z8j6llwykscyvnvwdijwma6jf7g449dp";
    };
  
    deps = [ findr inflections ];
  };

  # navigation by char
  jump-char = buildEmacsPackage {
    name = "jump-char-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/jump-char-0.1.el";
      sha256 = "0l8cq5fvmlpxfvm1a999flb9i92am0qg17sb9iwmmxiypphmd44g";
    };
  
    deps = [  ];
  };

  # jump to previous insertion points
  jumpc = buildEmacsPackage {
    name = "jumpc-2.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/jumpc-2.0.el";
      sha256 = "0r3r7wyp6qfd4av61q1h4j2fwhay1d7zlg57dpfq95xi25jq4d0y";
    };
  
    deps = [  ];
  };

  # Parse org-todo headlines to use org-tables as Kanban tables
  kanban = buildEmacsPackage {
    name = "kanban-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/kanban-0.1.2.el";
      sha256 = "10jgdda87yj4dm7k35ji8q9fz4srjf1qipgr7r0z5y3kf455gxqd";
    };
  
    deps = [  ];
  };

  # Key Choices -- Also Viper has different colors in different modes
  key-choices = buildEmacsPackage {
    name = "key-choices-0.201";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/key-choices-0.201.el";
      sha256 = "0zjvpmvj88d0iygpd2b2w556h42igw061iq2dy42vk79wmr74qy1";
    };
  
    deps = [ color-theme-vim-insert-mode color-theme-emacs-revert-theme ];
  };

  # map pairs of simultaneously pressed keys to commands
  key-chord = buildEmacsPackage {
    name = "key-chord-0.5.20080915";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/key-chord-0.5.20080915.el";
      sha256 = "1n036831a7fqjsj24pjjy6qjbr7x73cv7x3jrj9q0n4nn2j0awx5";
    };
  
    deps = [  ];
  };

  # map key sequence to commands
  key-combo = buildEmacsPackage {
    name = "key-combo-1.5.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/key-combo-1.5.1.el";
      sha256 = "05xi8lcdh7m3ffs4ry8haa7y7s7icg9sbh1qvsxj2nhg00civ1wn";
    };
  
    deps = [  ];
  };

  # track command frequencies
  keyfreq = buildEmacsPackage {
    name = "keyfreq-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/keyfreq-0.0.3.el";
      sha256 = "13asld32nzvgdjyh56nfwkw7c0zjia4cszdv4l0ph3gyp605p5f5";
    };
  
    deps = [ json ];
  };

  # Emacs key sequence quiz
  keywiz = buildEmacsPackage {
    name = "keywiz-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/keywiz-1.4.el";
      sha256 = "0mwcyc9jfjdlzjpd8dmy5wf7w3m8ws48nngr8ymbf5dmy04059xz";
    };
  
    deps = [  ];
  };

  # Add conditional branching to keyboard macros
  kmacro-decision = buildEmacsPackage {
    name = "kmacro-decision-0.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/kmacro-decision-0.9.el";
      sha256 = "0skq17fpdjpm9gyxdgcdgkwcy8za43a61mh5ksf0dvdrv9wq2cw2";
    };
  
    deps = [ el-x ];
  };

  # An emacs buffer list that tries to intelligently group together buffers.
  kpm-list = buildEmacsPackage {
    name = "kpm-list-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/kpm-list-1.0.el";
      sha256 = "07m2n4piq71sb1ha6y1iwm1ijhzaslkwxdfhh7p703g0747casll";
    };
  
    deps = [  ];
  };

  # key/value data structure functions
  kv = buildEmacsPackage {
    name = "kv-0.0.17";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/kv-0.0.17.el";
      sha256 = "0czprrrb2ppvph2d39msxi1gd5n4ldfamc635wdsn37dcgq1rd7c";
    };
  
    deps = [  ];
  };

  # communcate with the KWin window manager
  kwin = buildEmacsPackage {
    name = "kwin-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/kwin-0.1.el";
      sha256 = "118q5cb9a49rnm7hk4f71gwx9r26d67v5lpf1k5md2hligprsd25";
    };
  
    deps = [  ];
  };

  # Execute menu items as commands, with completion.
  lacarte = buildEmacsPackage {
    name = "lacarte-22.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lacarte-22.0.el";
      sha256 = "11bvqq51mvlfi4q96zy73lb951mny2h74imxlv85lvy5bwphddwj";
    };
  
    deps = [  ];
  };

  # Grammer check utility using LanguageTool
  langtool = buildEmacsPackage {
    name = "langtool-1.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/langtool-1.2.0.el";
      sha256 = "0xas12wy5q2fd9m9vhkpdilzrha95jj3p5sjwsb49qm0j6xddiy8";
    };
  
    deps = [  ];
  };

  # Late Night theme for Emacs 24
  late-night-theme = buildEmacsPackage {
    name = "late-night-theme-0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/late-night-theme-0.0.el";
      sha256 = "1pmdrzqlpba72xff0i8c6s011px8vfgkc61281v7m06x9l0aff6k";
    };
  
    deps = [  ];
  };

  # Clojure dependency resolver
  latest-clojars = buildEmacsPackage {
    name = "latest-clojars-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/latest-clojars-0.3.el";
      sha256 = "0iyaqv5jr2zkg7byrsdjjq9f53zy9hivpa8sc9lcc0spj1sgf40w";
    };
  
    deps = [  ];
  };

  # find out the longest common sequence
  lcs = buildEmacsPackage {
    name = "lcs-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lcs-1.1.el";
      sha256 = "158x8vjfdfxlwin0x5ab1p48mx8ajgx6y1ag02ac8w5znyk2izni";
    };
  
    deps = [  ];
  };

  # Add legalese to your program files
  legalese = buildEmacsPackage {
    name = "legalese-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/legalese-1.0.el";
      sha256 = "193lisc3g5nh1pzz3ssq2il0590i9z9wigvi2lmjrp17rfjxhj4a";
    };
  
    deps = [  ];
  };

  # Major mode for editing LESS CSS files (lesscss.org)
  less-css-mode = buildEmacsPackage {
    name = "less-css-mode-0.15";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/less-css-mode-0.15.el";
      sha256 = "0b2qy3anf1lh7db6p73ai40alqnzp4w2z35hll5jsfhc0lkq5fc8";
    };
  
    deps = [  ];
  };

  # Simplified implementation of recur -*- lexical-binding:t -*-
  let-recur = buildEmacsPackage {
    name = "let-recur-0.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/let-recur-0.0.5.el";
      sha256 = "0jjjy46jl3h4xwgdn39gjl0a5x6dnp59zgmjl98dqavnpdxinv8a";
    };
  
    deps = [  ];
  };

  # Check the erroneous assignments in let forms
  letcheck = buildEmacsPackage {
    name = "letcheck-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/letcheck-0.2.el";
      sha256 = "00d7l6z71a4fyw0wxhdywjwlghjnfx1wp37xqwmv4gfm2igaglrx";
    };
  
    deps = [  ];
  };

  # Edit distance between two strings.
  levenshtein = buildEmacsPackage {
    name = "levenshtein-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/levenshtein-1.0.el";
      sha256 = "0s1v3gqlfrqs1pq054mrp8qr42cdmis4bilkgw6m0k8hsqvxxann";
    };
  
    deps = [  ];
  };

  # Lexical analyser construction
  lex = buildEmacsPackage {
    name = "lex-1.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/lex-1.1.tar";
      sha256 = "1i6ri3k2b2nginhnmwy67mdpv5p75jkxjfwbf42wymza8fxzwbb7";
    };
  
    deps = [  ];
  };

  # Puts the value of lexical-binding in the mode line
  lexbind-mode = buildEmacsPackage {
    name = "lexbind-mode-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lexbind-mode-0.8.el";
      sha256 = "1dilpjjasdz97qwhgp6xybx87aprna6r3l4qgnqizyajpzjmxlmk";
    };
  
    deps = [  ];
  };

  # Commands to list Emacs Lisp library dependencies.
  lib-requires = buildEmacsPackage {
    name = "lib-requires-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lib-requires-21.0.el";
      sha256 = "1xymk0c7qr7c34mirkpzmqxnjl2141vsjxqiyxj6nxkk4ads5s9x";
    };
  
    deps = [  ];
  };

  # Alternate mode to display line numbers.
  lineno = buildEmacsPackage {
    name = "lineno-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lineno-0.1.el";
      sha256 = "1jvbh1dzkddhn8s3rhka64vvs0sl5491lzx1hqwvzk0fzxy9dyvl";
    };
  
    deps = [  ];
  };

  # Provides an interface for turning line-numbering off
  linum-off = buildEmacsPackage {
    name = "linum-off-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/linum-off-0.1.el";
      sha256 = "0mpfimb5vf1i3qssgg4p7cawk5ybaic1gmlks1chlqy3bz0a9fal";
    };
  
    deps = [  ];
  };

  # lisp editing tools
  lisp-editing = buildEmacsPackage {
    name = "lisp-editing-0.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lisp-editing-0.0.5.el";
      sha256 = "1h1dpfs20ach9y3vbfham189qhxj25fm4ibvy8b8asgak7s71i3l";
    };
  
    deps = [  ];
  };

  # Commands to *enhance* S-exp editing
  lisp-infection = buildEmacsPackage {
    name = "lisp-infection-0.0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lisp-infection-0.0.10.el";
      sha256 = "0hxpi5s1kxrphshyib8b6xpkg7zys69c37magfvylfy99q4k115r";
    };
  
    deps = [  ];
  };

  # Major mode for LispyScript code.
  lispyscript-mode = buildEmacsPackage {
    name = "lispyscript-mode-0.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lispyscript-mode-0.3.1.el";
      sha256 = "1djhs2zipvh00xj3vpah1brjv5csxnhaph29zikc0pmc5g97jk2y";
    };
  
    deps = [  ];
  };

  # List-manipulation utility functions
  list-utils = buildEmacsPackage {
    name = "list-utils-0.3.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/list-utils-0.3.0.el";
      sha256 = "0pjisslnmyclwdkw8q4669fmrimafi4l5s4siix9cl9myi5m4bcl";
    };
  
    deps = [  ];
  };

  # Major mode for LiveScript files in Emacs
  livescript-mode = buildEmacsPackage {
    name = "livescript-mode-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/livescript-mode-0.0.1.el";
      sha256 = "1v08mqhnjbnw79wlrdkg638jjrhm13kqnnzaj3cs1kzhdkrqdib0";
    };
  
    deps = [  ];
  };

  # Little Man Computer in Elisp
  lmc = buildEmacsPackage {
    name = "lmc-1.2";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/lmc-1.2.el";
      sha256 = "1jk6gscxi88r1w4swxkb6nwb0j4kwg0zv3j44zxkas37swjps6vb";
    };
  
    deps = [  ];
  };

  # Load all Emacs Lisp files in a given directory
  load-dir = buildEmacsPackage {
    name = "load-dir-0.0.3";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/load-dir-0.0.3.el";
      sha256 = "0w5rdc6gr7nm7r0d258mp5sc06n09mmz7kjg8bd3sqnki8iz7s32";
    };
  
    deps = [  ];
  };

  # Install emacs24 color themes by buffer.
  load-theme-buffer-local = buildEmacsPackage {
    name = "load-theme-buffer-local-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/load-theme-buffer-local-0.0.2.el";
      sha256 = "1jin9n5b88czhlgfl4j1ndgcbr7njh6whmd9i6w7rqpw0kn5wmmi";
    };
  
    deps = [  ];
  };

  # Perform an occur-like folding in current buffer
  loccur = buildEmacsPackage {
    name = "loccur-1.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/loccur-1.1.1.el";
      sha256 = "12n09zg9vlnfsj30fp41y2y5nhnj69b6gzzdxngba0h7az74k60z";
    };
  
    deps = [  ];
  };

  # logging library for Emacs
  logito = buildEmacsPackage {
    name = "logito-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/logito-0.1.el";
      sha256 = "06bm6c1w7qymbn5wvj40sgrmk828s324x254kq9cswdpb71zimw7";
    };
  
    deps = [ eieio ];
  };

  # Major mode for editing LOLCODE
  lolcode-mode = buildEmacsPackage {
    name = "lolcode-mode-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lolcode-mode-0.2.el";
      sha256 = "01j1yy0fw2x08lwdfzk7c4zf36kzzyyfd5pmcj174373nz3xzl2x";
    };
  
    deps = [  ];
  };

  # Extensions to look-mode for dired buffers
  look-dired = buildEmacsPackage {
    name = "look-dired-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/look-dired-0.1.el";
      sha256 = "05lqwkzkw5szgf2g0r06j8kk10qkg7qkjzinh9kfsd4zz011qs0f";
    };
  
    deps = [ look-mode ];
  };

  # quick file viewer for image and text file browsing
  look-mode = buildEmacsPackage {
    name = "look-mode-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/look-mode-1.0.el";
      sha256 = "0aqxc22yjsab1il7fg9lwba798bla16vx28rk37q0wid3zmj32wb";
    };
  
    deps = [  ];
  };

  # friendly imperative loop structures
  loop = buildEmacsPackage {
    name = "loop-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/loop-1.1.el";
      sha256 = "15sy2ys01khl10hia82y9yy1i3nc1yc8ddv536az7f4lfal37kks";
    };
  
    deps = [  ];
  };

  # Insert dummy pseudo Latin text.
  lorem-ipsum = buildEmacsPackage {
    name = "lorem-ipsum-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lorem-ipsum-0.1.el";
      sha256 = "00dz6bhgiwjsypj4yav3jvjdiy0z4c5krpzgcw144qqn18miqmfy";
    };
  
    deps = [  ];
  };

  # a major-mode for editing Lua scripts
  lua-mode = buildEmacsPackage {
    name = "lua-mode-20110428";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lua-mode-20110428.el";
      sha256 = "01xa1bl6w7xjdn7shc066njd6qgdv4y9jwpmyjnmky0zdq99xgb6";
    };
  
    deps = [  ];
  };

  # Linewise User Interface
  lui = buildEmacsPackage {
    name = "lui-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/lui-1.2.tar";
      sha256 = "1bmnigjhgsl3yxc7jmy0zrb38d4xmh666f2z3i689djd071kvfi3";
    };
  
    deps = [ tracking ];
  };

  # provide mac-style key bindings on Carbon Emacs
  mac-key-mode = buildEmacsPackage {
    name = "mac-key-mode-2010.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mac-key-mode-2010.1.3.el";
      sha256 = "0s92hp3n3bd7cqy60syfg08xg63ll5rbyvj18npslpl41zlgd8q3";
    };
  
    deps = [  ];
  };

  # in-buffer mathematical operations
  macro-math = buildEmacsPackage {
    name = "macro-math-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/macro-math-1.0.el";
      sha256 = "085xcb75n092lr0xcjbwb6gdaxissbmly3wcd4x5blfc7f4dwsd2";
    };
  
    deps = [  ];
  };

  # Utilities for writing macros.
  macro-utils = buildEmacsPackage {
    name = "macro-utils-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/macro-utils-1.0.el";
      sha256 = "1hd8m81fbsibx64apl5k4whavpgfm2m8v6lb2c6q3890ix5f5cp4";
    };
  
    deps = [  ];
  };

  # interactive macro stepper for Emacs Lisp
  macrostep = buildEmacsPackage {
    name = "macrostep-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/macrostep-0.6.el";
      sha256 = "06g78hxgya11l1hpn813jq4kskil4zmb4g6mk1ia3s9vxadhxvjs";
    };
  
    deps = [  ];
  };

  # Mode for automatically handle multiple tags files with Mactag rubygem
  mactag = buildEmacsPackage {
    name = "mactag-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mactag-0.0.1.el";
      sha256 = "0ninzlqcjfp5dh1f14h23shdj0gbyzc4gpmyds924g4yqqjskr4x";
    };
  
    deps = [  ];
  };

  # Control Git from Emacs.
  magit = buildEmacsPackage {
    name = "magit-1.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/magit-1.2.0.tar";
      sha256 = "1zfn5z7mpnrjh4ssg7nq9c7n355s09m2c229dmrxji4yr2zkgf06";
    };
  
    deps = [  ];
  };

  # GitHub pull requests extension for Magit
  magit-gh-pulls = buildEmacsPackage {
    name = "magit-gh-pulls-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/magit-gh-pulls-0.3.el";
      sha256 = "1mlrzfknr40lyyagrs87aqhf61lgnvbwcpk915b3yqjfv8nfzs0s";
    };
  
    deps = [ gh magit ];
  };

  # simple keybindings for Magit
  magit-simple-keys = buildEmacsPackage {
    name = "magit-simple-keys-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/magit-simple-keys-1.0.0.el";
      sha256 = "1c8k3m7clfff8aggp8h9z5lb3qiylrj3i6sbfj936a9aqkhy3m76";
    };
  
    deps = [ magit ];
  };

  # Magit extensions for using GitHub
  magithub = buildEmacsPackage {
    name = "magithub-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/magithub-0.2.el";
      sha256 = "0880nnsqhw8svkfj8mgfnibvvrf3jidib1ngcykahzlq1fnkac6a";
    };
  
    deps = [ magit json ];
  };

  # Simple maildir based MUA.
  maildir = buildEmacsPackage {
    name = "maildir-0.0.18";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/maildir-0.0.18.tar";
      sha256 = "0llmb9pgkwyhccv5zwddxlhxsvf7yx1ikaxfk18bmcr39r94wplk";
    };
  
    deps = [  ];
  };

  # modeline replacement forked from an early version of powerline.el
  main-line = buildEmacsPackage {
    name = "main-line-1.2.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/main-line-1.2.8.el";
      sha256 = "16jx95xsq2rl4f382d75zkpmym1zcx2bph2jz7brbn855s1jlhgs";
    };
  
    deps = [  ];
  };

  # Searches for Makefile and fetches targets
  makefile-runner = buildEmacsPackage {
    name = "makefile-runner-1.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/makefile-runner-1.1.2.el";
      sha256 = "1n4llpchf49d5dzxfpqnk11qmfwmgkyykcl11bddi7s2365bv2pc";
    };
  
    deps = [  ];
  };

  # Client for MarGo, providing Go utilities
  margo = buildEmacsPackage {
    name = "margo-2012.9.18";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/margo-2012.9.18.el";
      sha256 = "0a4bz3yd8pkpwvdl9xllxcl2ls8z11frmbbj50mvw9nxflpdz2b8";
    };
  
    deps = [ web json ];
  };

  # Mark additional regions in buffer matching current region.
  mark-more-like-this = buildEmacsPackage {
    name = "mark-more-like-this-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mark-more-like-this-1.0.el";
      sha256 = "1s6clcxq2k8mvxy0yaw3mqgl7wfgpy1h4g240pnz5fnx27p8ixjw";
    };
  
    deps = [  ];
  };

  # A library that sorta lets you mark several regions at once
  mark-multiple = buildEmacsPackage {
    name = "mark-multiple-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mark-multiple-1.0.el";
      sha256 = "0fxsjpf16fzgrjj5l9v3mmlnxbg50xqzb2hj3lqf481g5baw3jcb";
    };
  
    deps = [  ];
  };

  # Some simple tools to access the mark-ring in Emacs
  mark-tools = buildEmacsPackage {
    name = "mark-tools-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mark-tools-0.3.el";
      sha256 = "1y6n53c6xigkmfpvrwhgla1gvrzq1s49aw0rwkbdkd2cx9mdkpx4";
    };
  
    deps = [  ];
  };

  # Mark chars fitting certain characteristics
  markchars = buildEmacsPackage {
    name = "markchars-0.2.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/markchars-0.2.0.el";
      sha256 = "1wn9v9jzcyq5wxhw5839jsggfy97955ngspn2gn6jmvz6zdgy4hv";
    };
  
    deps = [  ];
  };

  # Emacs Major mode for Markdown-formatted text files
  markdown-mode = buildEmacsPackage {
    name = "markdown-mode-1.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/markdown-mode-1.9.el";
      sha256 = "0crzzi1vpdh3sdkd8bc6pdh500vx5wipqphgbq1y9v3r7bycay87";
    };
  
    deps = [  ];
  };

  # collection of faces for markup language modes
  markup-faces = buildEmacsPackage {
    name = "markup-faces-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/markup-faces-1.0.0.el";
      sha256 = "0x1xx9rskz02j7daxbg6br4m54qrsbnjbf6h1641khiiyrd17ssx";
    };
  
    deps = [  ];
  };

  # Elisp interface for the Emacs Lisp package server.
  marmalade = buildEmacsPackage {
    name = "marmalade-0.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/marmalade-0.0.4.el";
      sha256 = "18zlr8gpwdjr8fx941ar9ch920kc3rlkkhjb2ncacnxzrnjm1wdl";
    };
  
    deps = [ furl ];
  };

  # The Marmalade package store service.
  marmalade-service = buildEmacsPackage {
    name = "marmalade-service-2.0.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/marmalade-service-2.0.9.tar";
      sha256 = "1ba21vvd1fc51r3ls6f0zgr9x5hma9hdwq18xbkasnzalh29ssf7";
    };
  
    deps = [ dash s elnode ];
  };

  # A test tarball package.
  marmalade-test = buildEmacsPackage {
    name = "marmalade-test-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/marmalade-test-0.0.1.tar";
      sha256 = "00pa9kyybv4zshnp8b836vqg2nr2v8avhbf8zv7rglv65f5j43q6";
    };
  
    deps = [  ];
  };

  # maximize the emacs frame based on display size
  maxframe = buildEmacsPackage {
    name = "maxframe-0.5.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/maxframe-0.5.1.el";
      sha256 = "0byib2wbhadqz9sq102da5k0nyfj382d7s9byfx3rd61a8cb5787";
    };
  
    deps = [  ];
  };

  # mediawiki frontend
  mediawiki = buildEmacsPackage {
    name = "mediawiki-2.2.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mediawiki-2.2.3.el";
      sha256 = "0s29ir8ill602lc0ywwkn1b5syn2chh5zv93ylf7dvzmmhayl2z9";
    };
  
    deps = [  ];
  };

  # expand member functions for C++ classes
  member-function = buildEmacsPackage {
    name = "member-function-0.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/member-function-0.3.1.el";
      sha256 = "0p4zzv7wlrz1h9xmwk4fgjk27fbnzgqd1948c2cg7v9m25a4ri7w";
    };
  
    deps = [  ];
  };

  # Analyze the memory usage of Emacs in various ways
  memory-usage = buildEmacsPackage {
    name = "memory-usage-0.2";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/memory-usage-0.2.el";
      sha256 = "03qwb7sprdh1avxv3g7hhnhl41pwvnpxcpnqrikl7picy78h1gwj";
    };
  
    deps = [  ];
  };

  # advanced highlighting of matching parentheses
  mic-paren = buildEmacsPackage {
    name = "mic-paren-3.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mic-paren-3.8.el";
      sha256 = "0nmi89gahkxkhflc9hgmvmhffq4hzwfxi2yjwp0sf739yv06zfzd";
    };
  
    deps = [  ];
  };

  # Minor mode for running Midje tests in emacs, see: https://github.com/dnaumov/midje-mode
  midje-mode = buildEmacsPackage {
    name = "midje-mode-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/midje-mode-0.1.2.tar";
      sha256 = "0kq9pzfy8jg1nn3w4sn57kba1pbjg011q4b8kn0f7fzrnsi8i3gb";
    };
  
    deps = [ slime clojure-mode ];
  };

  # Very lean session saver
  minimal-session-saver = buildEmacsPackage {
    name = "minimal-session-saver-0.6.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/minimal-session-saver-0.6.0.el";
      sha256 = "0i1y134h8hqbca74j4h801b8ls96q8lg34wls8qhd1snxxb56f4z";
    };
  
    deps = [  ];
  };

  # Sidebar showing a "mini-map" of a buffer
  minimap = buildEmacsPackage {
    name = "minimap-1.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/minimap-1.0.el";
      sha256 = "1zlhny08bm2kv5qwvv5bh28mdjibz1djs5pqk8xv84jalzsig8n4";
    };
  
    deps = [  ];
  };

  # Multi-networks peer-to-peer client.
  mldonkey = buildEmacsPackage {
    name = "mldonkey-0.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mldonkey-0.0.4.tar";
      sha256 = "1wg9gl4i1ghn5jqzga9i0ks2lr3af9s4nvrcczwb26a04hpckz0n";
    };
  
    deps = [  ];
  };

  # An interactive, iterative 'git blame' mode for Emacs
  mo-git-blame = buildEmacsPackage {
    name = "mo-git-blame-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mo-git-blame-0.1.0.el";
      sha256 = "1qxfmj0hvdi4j3xdf9rkb0nlxn6f1as8fm0znabfl5qz5g7dqjss";
    };
  
    deps = [  ];
  };

  # mocking framework for emacs
  mocker = buildEmacsPackage {
    name = "mocker-0.2.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mocker-0.2.6.el";
      sha256 = "0rmfdl8rxxqyl44w97g163vs6lzzcq0k6gvnbq5995xglfcp10vv";
    };
  
    deps = [ eieio el-x ];
  };

  #  Smart command for compiling files
  mode-compile = buildEmacsPackage {
    name = "mode-compile-2.29";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mode-compile-2.29.el";
      sha256 = "1vdqd2325vhnrx873n1rxplq31h1ljkv2f8pjqv3fvs7p6lmf3ky";
    };
  
    deps = [  ];
  };

  # Show icons for modes
  mode-icons = buildEmacsPackage {
    name = "mode-icons-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mode-icons-0.1.0.tar";
      sha256 = "0gydkam4fvnngcnl3qk8jrrkd9hawmbf6490342ih33jjs2kq31p";
    };
  
    deps = [  ];
  };

  # Set up `mode-line-position'.
  modeline-posn = buildEmacsPackage {
    name = "modeline-posn-22.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/modeline-posn-22.0.el";
      sha256 = "01a6pyb97w0amd1f5kr36sl3ra9ai6wg76j60zbhxla5wd715d7c";
    };
  
    deps = [  ];
  };

  # a major mode to edit MoinMoin wiki pages
  moinmoin-mode = buildEmacsPackage {
    name = "moinmoin-mode-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/moinmoin-mode-1.0.el";
      sha256 = "1vipjxdlqrm328gdbsl6a05ms3d3z5hy5sv115zbqhr1k7fchsgn";
    };
  
    deps = [ screen-lines ];
  };

  # A MongoDB client.
  mongo = buildEmacsPackage {
    name = "mongo-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mongo-0.5.tar";
      sha256 = "0933kddyi9kxmbw95g1dh3pm6ma4d8m6f6xy5wz8lp9x5m4q9q6n";
    };
  
    deps = [  ];
  };

  # elnode adapter for mongo-el
  mongo-elnode = buildEmacsPackage {
    name = "mongo-elnode-0.5.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mongo-elnode-0.5.0.el";
      sha256 = "05276ahk48ahy419kwrwcb9q0qi1vw51bjl1m9lv2vmmvd30sr9b";
    };
  
    deps = [ mongo elnode ];
  };

  # REQUIRES EMACS 24: Monokai Color Theme for Emacs.
  monokai-theme = buildEmacsPackage {
    name = "monokai-theme-0.0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/monokai-theme-0.0.10.el";
      sha256 = "0kkwjcrw2zrygldaw37jzrgwc7rgsm8qrar6ajwipm99by38cg5z";
    };
  
    deps = [  ];
  };

  # Mote minor mode
  mote-mode = buildEmacsPackage {
    name = "mote-mode-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mote-mode-1.0.0.el";
      sha256 = "0pxwrdh0kk368k6jv20i2wc2i8jrl3ghianyam95w6xaq0hdhy4r";
    };
  
    deps = [ ruby-mode ];
  };

  # Extensions to `mouse.el'.
  mouse-plus = buildEmacsPackage {
    name = "mouse-plus-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mouse+-21.0.el";
      sha256 = "1xwi5w7d14k8mb772v2kqvci16hwiy4qwwnd0ksln8hlks7smcws";
    };
  
    deps = [  ];
  };

  # Move current line or region with M-up or M-down.
  move-text = buildEmacsPackage {
    name = "move-text-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/move-text-1.0.el";
      sha256 = "14ikrpy8r8gv69m5r1iq7pb5asz4xg3qw2cj83ry64b8sxq7m09j";
    };
  
    deps = [  ];
  };

  # makes it easier to use multiple shells within emacs
  multi-eshell = buildEmacsPackage {
    name = "multi-eshell-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/multi-eshell-0.0.1.el";
      sha256 = "0a4cnwn1q27hvmsxbqvnijgwawxhy4qch6p5b2dhbf4r1jac54l7";
    };
  
    deps = [  ];
  };

  # Easily work with multiple projects.
  multi-project = buildEmacsPackage {
    name = "multi-project-0.0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/multi-project-0.0.8.el";
      sha256 = "0lxyknz4wvz4dzd86yyagvm2nk6y2wq22fpn9145ly5ix1q3asr4";
    };
  
    deps = [  ];
  };

  # Managing multiple terminal buffers in Emacs.
  multi-term = buildEmacsPackage {
    name = "multi-term-0.8.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/multi-term-0.8.8.el";
      sha256 = "1zdv3gcshqg3i6zjj9nhzv4dvalb2gwfa3pxls3apypm47rwhkwv";
    };
  
    deps = [  ];
  };

  # multiple major mode support for web editing
  multi-web-mode = buildEmacsPackage {
    name = "multi-web-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/multi-web-mode-0.1.el";
      sha256 = "07ab60qawxwvzk5cmmx9bmc1lbhz11kl61dnmzgqxm0la3jz35nn";
    };
  
    deps = [  ];
  };

  # Multiple cursors for Emacs.
  multiple-cursors = buildEmacsPackage {
    name = "multiple-cursors-1.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/multiple-cursors-1.2.1.tar";
      sha256 = "1mwj0nzrj1v1n984yxyb29j3ln31scmrgw848sajqhxxxf5xi6rs";
    };
  
    deps = [  ];
  };

  # Authoring and publishing tool
  muse = buildEmacsPackage {
    name = "muse-3.20";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/muse-3.20.tar";
      sha256 = "0i5gfhgxdm1ripw7j3ixqlfkinx3fxjj2gk5md99h70iigrhcnm9";
    };
  
    deps = [  ];
  };

  # a mustache templating library in emacs lisp
  mustache = buildEmacsPackage {
    name = "mustache-0.20";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mustache-0.20.tar";
      sha256 = "1i3ks139li2wqvr7qg94l8f1zvvkpqnrplj6vpc27y54m04bn3ry";
    };
  
    deps = [ ht s dash ];
  };

  # A major mode for editing Mustache files.
  mustache-mode = buildEmacsPackage {
    name = "mustache-mode-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mustache-mode-1.2.el";
      sha256 = "08zypqfz0mapk40jm9fxvq294qin9zw4l8nvf0rl4897xfpzilfv";
    };
  
    deps = [  ];
  };

  # log keyboard commands to buffer
  mwe-log-commands = buildEmacsPackage {
    name = "mwe-log-commands-20041106";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/mwe-log-commands-20041106.el";
      sha256 = "1kwc6f28mm53jk4y2msrylgxkb8ahsxigp3sb2mc7psb7qk83r19";
    };
  
    deps = [  ];
  };

  # Package Initialization.
  my-packages = buildEmacsPackage {
    name = "my-packages-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/my-packages-0.1.0.el";
      sha256 = "1yacscnbfgl0mrcdma4v0jh4csq9f65i4q2dc3azisiwrpig44wa";
    };
  
    deps = [  ];
  };

  # mode for Notation 3
  n3-mode = buildEmacsPackage {
    name = "n3-mode-20071215";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/n3-mode-20071215.el";
      sha256 = "12m2qjcyhlap7kjbc1lcn98hibjamiqakjjvljwywz1wvq17v3xg";
    };
  
    deps = [  ];
  };

  # utility function set for namakemono
  namakemono = buildEmacsPackage {
    name = "namakemono-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/namakemono-0.0.1.el";
      sha256 = "1kxzg9sahqzna91hj4ds0g30a4wpdzk4a0wqiqf92clb30sj3vkk";
    };
  
    deps = [  ];
  };

  # Briefly highlight the current line
  nav-flash = buildEmacsPackage {
    name = "nav-flash-1.0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nav-flash-1.0.8.el";
      sha256 = "1xphm9h9qcqp0axgg9a83awbbfq4wlwl7pksi5nvfir1sz7fakbg";
    };
  
    deps = [  ];
  };

  # major mode for editing nemerle programs
  nemerle = buildEmacsPackage {
    name = "nemerle-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nemerle-0.2.el";
      sha256 = "0dlv2xq8pa6i7gbvzlnn3wykyfc40gf40akhazy314v0gbb6q07n";
    };
  
    deps = [  ];
  };

  # major mode for editing nginx config files
  nginx-mode = buildEmacsPackage {
    name = "nginx-mode-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nginx-mode-1.1.el";
      sha256 = "0n450zpihska9d6ll703ja3307wpnxi0azqw8p6p947rgd6pry2r";
    };
  
    deps = [  ];
  };

  # Minor mode to edit files via hex-dump format
  nhexl-mode = buildEmacsPackage {
    name = "nhexl-mode-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/nhexl-mode-0.1.el";
      sha256 = "1vpigrh2q96lc57vv0yw77ajz5sak3pna13rpr277n1bbxs2fg7k";
    };
  
    deps = [  ];
  };

  # A major mode for the Nimrod programming language
  nimrod-mode = buildEmacsPackage {
    name = "nimrod-mode-0.1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nimrod-mode-0.1.5.el";
      sha256 = "19w5dqb0zsz7c47cli11jnwvavks68qlnn88m9q3klk1vzrizsrp";
    };
  
    deps = [ auto-complete ];
  };

  # schemes 'named let' for emacs.
  nlet = buildEmacsPackage {
    name = "nlet-1.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nlet-1.10.el";
      sha256 = "00k58wk9nlhn2q2xxhgw8681xrll72dl3k6bdya7jirpf1qvf47a";
    };
  
    deps = [  ];
  };

  # Show line numbers in the margin
  nlinum = buildEmacsPackage {
    name = "nlinum-1.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/nlinum-1.1.el";
      sha256 = "113ia89b5zxmv7s6k6aqppy3vb4x7nvkagch5177zngld8ng6wyg";
    };
  
    deps = [  ];
  };

  # Learn the proper Emacs movement keys
  no-easy-keys = buildEmacsPackage {
    name = "no-easy-keys-1.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/no-easy-keys-1.0.2.el";
      sha256 = "1p5xy6rcyznhk17cngz3qwkfy5gyvkc65riw4ljn5bl87yi3my6r";
    };
  
    deps = [  ];
  };

  # Run Node.js REPL
  nodejs-repl = buildEmacsPackage {
    name = "nodejs-repl-0.0.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nodejs-repl-0.0.2.1.el";
      sha256 = "19rl2g9wad1lcj30mms68h72m4zl8bkc2dmiijr9lvl6xgasijgi";
    };
  
    deps = [  ];
  };

  # locally override functions
  noflet = buildEmacsPackage {
    name = "noflet-0.0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/noflet-0.0.7.el";
      sha256 = "13j6j875lxs6h4sg59gg76981fym6cpa2y6qim5g9y344hynnisc";
    };
  
    deps = [  ];
  };

  # Easy Python test running in Emacs
  nose = buildEmacsPackage {
    name = "nose-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nose-0.1.1.el";
      sha256 = "0bljkblp3ajxllly7mpxb8b25y7xrm7f606s1fbf8yq2kbyq2bd9";
    };
  
    deps = [  ];
  };

  # Organizing on-line note-taking
  notes-mode = buildEmacsPackage {
    name = "notes-mode-1.30";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/notes-mode-1.30.tar";
      sha256 = "1aqivlfa0nk0y27gdv68k5rg3m5wschh8cw196a13qb7kaghk9r6";
    };
  
    deps = [  ];
  };

  # notification front-end
  notify = buildEmacsPackage {
    name = "notify-2010.8.20";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/notify-2010.8.20.el";
      sha256 = "02wygw3glsn5k1sf6zmsdabfs1p789l78fsf8ml82lrz6mk1nhd7";
    };
  
    deps = [  ];
  };

  # Improves notmuch way of displaying labels through fonts, pictures, and hyperlinks.
  notmuch-labeler = buildEmacsPackage {
    name = "notmuch-labeler-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/notmuch-labeler-0.1.tar";
      sha256 = "0yv647y6i67nsw67cldp5nrpjdy4adh20qhiydxsnly2x72rh0rq";
    };
  
    deps = [  ];
  };

  # Client for Clojure nREPL
  nrepl = buildEmacsPackage {
    name = "nrepl-0.1.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nrepl-0.1.7.el";
      sha256 = "1xx8g4sd0gs4hzkwpfy17bba421b8zh9x9x3ij42llgk4z7xpphw";
    };
  
    deps = [ clojure-mode ];
  };

  # nrepl extensions for ritz
  nrepl-ritz = buildEmacsPackage {
    name = "nrepl-ritz-0.6.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nrepl-ritz-0.6.0.el";
      sha256 = "1m0hqwaqxdrgbp01z1fx1nci26jfd8mrinazvm0rbrr1cniwwvv3";
    };
  
    deps = [ nrepl ];
  };

  # NSIS-mode
  nsis-mode = buildEmacsPackage {
    name = "nsis-mode-0.44";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nsis-mode-0.44.el";
      sha256 = "0f3pxp7qdnvxb5iw9qz1dx2m02znf4k0i9y2m42kig634kbi8m0q";
    };
  
    deps = [  ];
  };

  # major mode for editing cmd scripts
  ntcmd = buildEmacsPackage {
    name = "ntcmd-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ntcmd-1.0.el";
      sha256 = "1k3h3p7syjrfmfxbzxwgccpgr0f7592f404y15ygrzfjhvx4lzmh";
    };
  
    deps = [  ];
  };

  # highlight groups of digits in long numbers
  num3-mode = buildEmacsPackage {
    name = "num3-mode-1.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/num3-mode-1.1.el";
      sha256 = "15jf1hf1izz0s82fplkp8lg9p9mwq82cvm01szmkxql6rhbn5gga";
    };
  
    deps = [  ];
  };

  # smooth-scrolling and minimap
  nurumacs = buildEmacsPackage {
    name = "nurumacs-3.4.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nurumacs-3.4.1.el";
      sha256 = "0j7lqk3ly1fn5vmdn5cl91llj5v4vm8bn264ss27h49v61x7chf5";
    };
  
    deps = [  ];
  };

  # Nyan Cat shows position in current buffer in mode-line.
  nyan-mode = buildEmacsPackage {
    name = "nyan-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nyan-mode-0.1.el";
      sha256 = "1vypm958p13gagbmqdjgdpscmn3s69pqn2xxasnk2bgsgxahxcm5";
    };
  
    deps = [  ];
  };

  # A low contrast color theme for Emacs.
  nzenburn-theme = buildEmacsPackage {
    name = "nzenburn-theme-20130513";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/nzenburn-theme-20130513.el";
      sha256 = "06kwq11g6lhbfng62plkscanln6y08saxfz7qlm89058la8cjc2s";
    };
  
    deps = [  ];
  };

  # An Emacs oauth client. See https://github.com/psanford/emacs-oauth/
  oauth = buildEmacsPackage {
    name = "oauth-1.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/oauth-1.0.3.tar";
      sha256 = "1f2kj61vxjkx9clhf5akc6di4a83hmrjiggydl7yj86hgfqb0nvm";
    };
  
    deps = [  ];
  };

  # OAuth 2.0 Authorization Protocol
  oauth2 = buildEmacsPackage {
    name = "oauth2-0.8";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/oauth2-0.8.el";
      sha256 = "1gljz2c4d5zxf1a95f6mfff4f3m3prlih89nfg3sqjg7lzqh3gdl";
    };
  
    deps = [  ];
  };

  # org-babel functions for template evaluation
  ob-sml = buildEmacsPackage {
    name = "ob-sml-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ob-sml-0.2.el";
      sha256 = "1fidgz179jfinszmpx5y27i1z69i6r5iwyjfs0zg59v958kbgg1v";
    };
  
    deps = [ sml-mode ];
  };

  # Extra functionality for occur
  occur-x = buildEmacsPackage {
    name = "occur-x-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/occur-x-0.1.1.el";
      sha256 = "1l3jgrwwzymwpckr4vkidq7vcmv8bpiym3z1hl7i7w19v2qv2nsh";
    };
  
    deps = [  ];
  };

  # Octopress interface for Emacs
  octomacs = buildEmacsPackage {
    name = "octomacs-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/octomacs-0.0.1.el";
      sha256 = "1fxz3bqq43rgb7yqvpgnk4g2pij0gcd6l300xhlsy11kahmiq7wr";
    };
  
    deps = [  ];
  };

  # edit pages on an Oddmuse wiki
  oddmuse = buildEmacsPackage {
    name = "oddmuse-20090222";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/oddmuse-20090222.el";
      sha256 = "0y9606cpi7bw4iqpma5mj8kxa3kl53xsccfx5jsqr06hcxihqavs";
    };
  
    deps = [  ];
  };

  # Run OfflineIMAP from Emacs
  offlineimap = buildEmacsPackage {
    name = "offlineimap-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/offlineimap-0.1.el";
      sha256 = "0aqwm43y8xr2j9236rhifzmaaq508cgz32j99cbqsz23qlbhl0y2";
    };
  
    deps = [  ];
  };

  # Support for OWL Manchester Notation
  omn-mode = buildEmacsPackage {
    name = "omn-mode-1.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/omn-mode-1.0.el";
      sha256 = "04kac2imxdf4qbd97sjsfaj3l6pfsa29mghpyv43rigxdwz2klb5";
    };
  
    deps = [  ];
  };

  # Open files with external programs
  openwith = buildEmacsPackage {
    name = "openwith-20120531";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/openwith-20120531.el";
      sha256 = "1ckhjkp5fnsdxwxax9krmlw0zqrsjdfmvp05m7j96sncnr2ybnxf";
    };
  
    deps = [  ];
  };

  # Outline-based notes management and organizer
  org = buildEmacsPackage {
    name = "org-20130617";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/org-20130617.tar";
      sha256 = "1izgcmskvgzv89wkm48r7rxhavmibsnh4yhv33asy9vp5xd7nkch";
    };
  
    deps = [  ];
  };

  # create and publish a blog with org-mode
  org-blog = buildEmacsPackage {
    name = "org-blog-1.18.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-blog-1.18.1.1.el";
      sha256 = "1h75h72h1andczsbahw5f0pdm6lzkym1iyj14avqz5b77ll6535k";
    };
  
    deps = [  ];
  };

  # Org-mode and Cua mode compatibility layer
  org-cua-dwim = buildEmacsPackage {
    name = "org-cua-dwim-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-cua-dwim-0.5.el";
      sha256 = "05qcmkm9crb0vy6fl97w8q3n9d7y3fnfswclx57k1vqlm3i5zjhd";
    };
  
    deps = [  ];
  };

  # Store your emacs config as an org file, and choose which bits to load.
  org-dotemacs = buildEmacsPackage {
    name = "org-dotemacs-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-dotemacs-0.2.el";
      sha256 = "03dixcwbc7ay5fyj1wci19s9r0znfhynxh778afbff75cvapvfad";
    };
  
    deps = [ org cl-lib ];
  };

  # Export Org-mode files as editable web pages
  org-ehtml = buildEmacsPackage {
    name = "org-ehtml-0.20120928";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-ehtml-0.20120928.tar";
      sha256 = "1x1d9xd73qmd3wlskrlpqhz0c8lq6jcpm2j8q5xznlzbnr6z9lxd";
    };
  
    deps = [ elnode org-plus-contrib ];
  };

  # use org for an email database -*- lexical-binding: t -*-
  org-email = buildEmacsPackage {
    name = "org-email-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-email-0.1.0.el";
      sha256 = "1p25014f2gssbc4gl19s5hhfncvw4g85q39nih9mph5bbfzy3isl";
    };
  
    deps = [  ];
  };

  # a simple org-mode based journaling mode
  org-journal = buildEmacsPackage {
    name = "org-journal-1.3.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-journal-1.3.4.el";
      sha256 = "1wfailzmncj0nd7mip54nmmfiq4bkyhma2yp4h64jzpak9xmdjvv";
    };
  
    deps = [  ];
  };

  # basic support for magit links
  org-magit = buildEmacsPackage {
    name = "org-magit-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-magit-0.2.0.el";
      sha256 = "1yxzjgzqaij38hwl4yfddp42k189yjadw8a6v5ipq56m0rb8p1mb";
    };
  
    deps = [ magit org ];
  };

  # org html export for text/html MIME emails
  org-mime = buildEmacsPackage {
    name = "org-mime-20120112";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-mime-20120112.el";
      sha256 = "084zqvizwyl8hviwvv3bi70mgpdj6hm8qr7j136ldliysi709qkv";
    };
  
    deps = [  ];
  };

  # Outlook org
  org-outlook = buildEmacsPackage {
    name = "org-outlook-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-outlook-0.3.el";
      sha256 = "16pc920f5177kbba1kfy56nblaccsr75ynjzjpj7jyc5nhg8my5q";
    };
  
    deps = [  ];
  };

  # simple presentation with an org file
  org-presie = buildEmacsPackage {
    name = "org-presie-0.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-presie-0.0.5.el";
      sha256 = "1zv37faw5nrifx5f6zqz5ycxmybh26ivfpcxw2f4hrh6adc8n4mz";
    };
  
    deps = [ framesize eimp org ];
  };

  # Integrates Readme.org and Commentary/Change-logs.
  org-readme = buildEmacsPackage {
    name = "org-readme-20130322.926";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-readme-20130322.926.el";
      sha256 = "1yfi23cl7knjwiis650nhy8q80ac2fa07kdaplfd9s3bzlwxdm3k";
    };
  
    deps = [ http-post-simple yaoddmuse header2 lib-requires ];
  };

  #  Org table comment modes.
  org-table-comment = buildEmacsPackage {
    name = "org-table-comment-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org-table-comment-0.2.el";
      sha256 = "0c57ygx06xa5xnr5swf1ln881kmgjs8km39xv0l8qccl60zw5cy4";
    };
  
    deps = [  ];
  };

  # Blog from Org mode to wordpress
  org2blog = buildEmacsPackage {
    name = "org2blog-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/org2blog-0.5.tar";
      sha256 = "0152phldh3mry6pcgxir8xxz9pazkzkrx5744rq3jmssabd0zvcc";
    };
  
    deps = [ org xml-rpc ];
  };

  # Web browsing helpers for OS X
  osx-browse = buildEmacsPackage {
    name = "osx-browse-0.8.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/osx-browse-0.8.6.el";
      sha256 = "1c1jm15jhnz4milgrml7s9j71vvrzjj0l5ysd49wr2dyn3hbivw7";
    };
  
    deps = [ browse-url-dwim ];
  };

  # Watch and respond to changes in geographical location on OS X
  osx-location = buildEmacsPackage {
    name = "osx-location-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/osx-location-0.2.tar";
      sha256 = "1c59ddq1qi4s1yyzcwnmqx02b2k1qkj8g6ny5gjlhg4fb0sbbavb";
    };
  
    deps = [  ];
  };

  # a one-time password creator
  otp = buildEmacsPackage {
    name = "otp-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/otp-1.0.el";
      sha256 = "1dfgqlqdf86vzkvpchv0x7cksr3laad9wrx3ac78xcwwp7hsql39";
    };
  
    deps = [  ];
  };

  # Major mode for source files of the Otter automated theorem prover
  otter-mode = buildEmacsPackage {
    name = "otter-mode-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/otter-mode-1.2.el";
      sha256 = "15awdwy1wp3m7rnhp5mpjllv687z9gzy91mb44q78p070406c3w7";
    };
  
    deps = [  ];
  };

  # Major mode for editing Oz programs
  oz = buildEmacsPackage {
    name = "oz-16513";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/oz-16513.tar";
      sha256 = "1zhbplpgfnfjkpxh6lg8xndgdyxn1nw95chmsa1bkqz9diwq9xwn";
    };
  
    deps = [  ];
  };

  # Perforce-Emacs Integration Library
  p4 = buildEmacsPackage {
    name = "p4-11.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/p4-11.0.el";
      sha256 = "0128b9ia49i5cw8nv8hl2iapdyig2s7m66hmk94h6xacs73w26wi";
    };
  
    deps = [  ];
  };

  # Predictive abbreviation expansion
  pabbrev = buildEmacsPackage {
    name = "pabbrev-3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pabbrev-3.1.el";
      sha256 = "0xal6cw9pgf968wly5v8mnz3aqrqf1sh6339n7ncbnfx7rsqr1dq";
    };
  
    deps = [  ];
  };

  # Simple package system for Emacs
  package = buildEmacsPackage {
    name = "package-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/package-1.0.el";
      sha256 = "0kc7gzm152nx3n0hhihgjkbv1rlfl6bj8mp21by07xjg699ijkxs";
    };
  
    deps = [ tabulated-list ];
  };

  # a package cache
  package-store = buildEmacsPackage {
    name = "package-store-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/package-store-0.3.el";
      sha256 = "1yqkmffrxqk8qpnlf4whnzhg92xk0i3ddiii7vkv6jq9z6lpghl9";
    };
  
    deps = [  ];
  };

  # Display ugly ^L page breaks as tidy horizontal lines
  page-break-lines = buildEmacsPackage {
    name = "page-break-lines-0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/page-break-lines-0.7.el";
      sha256 = "0ipjzkpcv8pm1w7nxayxrglivydws2nrs3d3flhnfwx20fxckcng";
    };
  
    deps = [  ];
  };

  # windows-scroll commands
  pager = buildEmacsPackage {
    name = "pager-2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pager-2.0.el";
      sha256 = "0wnwdwbmhcdlrxs79127295kk10g45d1q5nzkzfbvl7grm7wgg8x";
    };
  
    deps = [  ];
  };

  # minor mode for editing parentheses  -*- Mode: Emacs-Lisp -*-
  paredit = buildEmacsPackage {
    name = "paredit-22";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/paredit-22.el";
      sha256 = "19fqx7f2vg7g5wzdp70z613xlvm8nhy1h20d003awbv1pxa4lkvk";
    };
  
    deps = [  ];
  };

  # Enable some paredit features in non-lisp buffers
  paredit-everywhere = buildEmacsPackage {
    name = "paredit-everywhere-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/paredit-everywhere-0.2.el";
      sha256 = "0q71vdcq3vqka7zf8k9m5skjvms3dvnyvz06ppgbvcbh5pna7zaw";
    };
  
    deps = [ paredit ];
  };

  # Adds a menu to paredit.el as memory aid
  paredit-menu = buildEmacsPackage {
    name = "paredit-menu-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/paredit-menu-1.0.el";
      sha256 = "0dg5fnnqx8qvmh6cncn7gdrzyzqz0c64gry8dglw5q4kba0cqhql";
    };
  
    deps = [  ];
  };

  # Provide a face for parens in lisp modes.
  parenface = buildEmacsPackage {
    name = "parenface-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/parenface-1.1.el";
      sha256 = "1rbb10r7d3b5dpln6z21ma9f8mc4mazyi1x274jbkfffllxfbism";
    };
  
    deps = [  ];
  };

  # Provide a face for parens in lispy modes.
  parenface-plus = buildEmacsPackage {
    name = "parenface-plus-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/parenface-plus-1.1.tar";
      sha256 = "0l37gi1hzc0ksv259y45baxbhafb5ybp5yvf88qqiw4s7z5fvfy5";
    };
  
    deps = [  ];
  };

  # paste text to KDE's pastebin service
  paste-kde = buildEmacsPackage {
    name = "paste-kde-0.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/paste-kde-0.2.1.el";
      sha256 = "07glja73jsm3688bw30z7zk3llip4xqfwy31apkhzkls0w6mvjx0";
    };
  
    deps = [ web ];
  };

  # A simple interface to the www.pastebin.com webservice
  pastebin = buildEmacsPackage {
    name = "pastebin-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pastebin-0.1.el";
      sha256 = "165lq4ah2k940b8gbbk96parks5v9jr91lrx85my0yvn4mx7z5jy";
    };
  
    deps = [  ];
  };

  # Pastels on Dark theme for Emacs 24
  pastels-on-dark-theme = buildEmacsPackage {
    name = "pastels-on-dark-theme-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pastels-on-dark-theme-0.3.el";
      sha256 = "10kfrkxkib7srmcdjbsc0cigw8x8ms7y06b4zjyws6gz8skjii76";
    };
  
    deps = [  ];
  };

  # major mode for editing PC code,
  pc-mode = buildEmacsPackage {
    name = "pc-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pc-mode-0.1.el";
      sha256 = "1q7h62rh2cdfh2lph8gnxzmlgw8a1c4phn4a5pnjl6ivk8a475vg";
    };
  
    deps = [  ];
  };

  # persistent caching for Emacs
  pcache = buildEmacsPackage {
    name = "pcache-0.2.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pcache-0.2.3.el";
      sha256 = "01z2nmz05hq887gn2fjca3y45klfnxni8pmd2l5fqdrglbzhacpz";
    };
  
    deps = [ eieio ];
  };

  # Enhanced shell command completion    -*- lexical-binding: t -*-
  pcmpl-args = buildEmacsPackage {
    name = "pcmpl-args-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pcmpl-args-0.1.1.el";
      sha256 = "05cr8ir21ipyb05f6z24v3fxjbdc4qy0kzwd309gngfn8h70k5r8";
    };
  
    deps = [  ];
  };

  # parse, convert, and font-lock PCRE, Emacs and rx regexps
  pcre2el = buildEmacsPackage {
    name = "pcre2el-1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pcre2el-1.5.el";
      sha256 = "0ghcal4nyfj34wl2xsvn1d6blpgsy59n8j3xplwhllk4ig9ghicn";
    };
  
    deps = [ cl-lib ];
  };

  # Parser of csv -*- lexical-binding: t -*-
  pcsv = buildEmacsPackage {
    name = "pcsv-1.3.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pcsv-1.3.2.el";
      sha256 = "1ff5rlmazxdhfkh3w2azsgr68vd74rc9swxivpqvzl2smvj20rp1";
    };
  
    deps = [  ];
  };

  # Perl Development Environment
  pde = buildEmacsPackage {
    name = "pde-0.2.16";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pde-0.2.16.tar";
      sha256 = "0cmbakny08cwwyg0lfmc51wjhy3cmihy1l1r97cr7phqsm8wijaf";
    };
  
    deps = [  ];
  };

  # PeepOpen plugin for emacs.
  peep-open = buildEmacsPackage {
    name = "peep-open-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/peep-open-0.0.2.el";
      sha256 = "1wrpkmhbm0xhpd3gm9qil6ih6ngxq4zv4szm5fifw7lxpkv0qv61";
    };
  
    deps = [  ];
  };

  # Graphical file chooser for Emacs on Mac OS X.
  peepopen = buildEmacsPackage {
    name = "peepopen-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/peepopen-0.1.0.el";
      sha256 = "0vgrzznkq8bs7q7q7pyy31cx6nv2qbq7crq853xq6v5qx6ikhycq";
    };
  
    deps = [  ];
  };

  # run the python pep8 checker putting hits in a grep buffer
  pep8 = buildEmacsPackage {
    name = "pep8-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pep8-1.2.el";
      sha256 = "14435ikx3pivanr6f513gy0fjxv1aiy2zgj4v77z4dbk00sn6l1v";
    };
  
    deps = [  ];
  };

  # Declare lexicaly scoped vars as my().
  perl-myvar = buildEmacsPackage {
    name = "perl-myvar-1.25";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/perl-myvar-1.25.el";
      sha256 = "133q88zg88w0x5fx51zdj10mrljzwswfniyd8qs5gqgiai8pd6cw";
    };
  
    deps = [  ];
  };

  # basic support for perlbrew environments
  perlbrew = buildEmacsPackage {
    name = "perlbrew-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/perlbrew-0.1.el";
      sha256 = "0lg3h7cwqdk35cdh2hcs15mjc6fx3kxg0sagmvsqc6qk7pmdsqgv";
    };
  
    deps = [  ];
  };

  # minor mode for Perl::Critic integration
  perlcritic = buildEmacsPackage {
    name = "perlcritic-1.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/perlcritic-1.10.el";
      sha256 = "1ls21wccaxc3kznczaikjb075awk3vkaraaagnlqws5kmx0279v2";
    };
  
    deps = [  ];
  };

  # Persistent storage, returning nil on failure
  persistent-soft = buildEmacsPackage {
    name = "persistent-soft-0.8.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/persistent-soft-0.8.6.el";
      sha256 = "03gxz7ankcivrhzy6ywwnvpa4nnpqv73pni8prphj2k19ad94q2f";
    };
  
    deps = [ pcache list-utils ];
  };

  # switch between named "perspectives" of the editor
  perspective = buildEmacsPackage {
    name = "perspective-1.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/perspective-1.9.el";
      sha256 = "0lk3bjz10s8w7p7sgf2b2x4j0prrkjp34zzdh9h1560v23jp0b5i";
    };
  
    deps = [  ];
  };

  # Emacs Lisp interface to the PostgreSQL RDBMS
  pg = buildEmacsPackage {
    name = "pg-0.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pg-0.12.el";
      sha256 = "1dx60g9d1jcqbf4a5pkm7z4pcjb34rz0qdxkrghaq05n84p89m7n";
    };
  
    deps = [  ];
  };

  # Control phantomjs from Emacs			
  phantomjs = buildEmacsPackage {
    name = "phantomjs-0.0.11";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/phantomjs-0.0.11.tar";
      sha256 = "0jhi4pv1fvn3s2ypvl3n1m4ikl7axbic2wfkb4m9n72wg6sd9rsc";
    };
  
    deps = [  ];
  };

  # Extra features for `php-mode'
  php-extras = buildEmacsPackage {
    name = "php-extras-0.4.4.20130612";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/php-extras-0.4.4.20130612.tar";
      sha256 = "0jhnnssvlx8cqx9fbhikz6jr6b399g2z7ixxzgxa3lj31bnbzwif";
    };
  
    deps = [ php-mode ];
  };

  # major mode for editing PHP code
  php-mode = buildEmacsPackage {
    name = "php-mode-1.5.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/php-mode-1.5.0.el";
      sha256 = "0853wzrnssckr5g7fhz9vzrrdyk2dm5p2ivbybgczl26541hfblm";
    };
  
    deps = [  ];
  };

  # get stuff from pinboard -*- lexical-binding: t -*-
  pinboard = buildEmacsPackage {
    name = "pinboard-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pinboard-0.0.1.el";
      sha256 = "1nyyyhnqlipq69hxs33pmpcsgijl6r04m3d1yr3jak2zhrfripz6";
    };
  
    deps = [  ];
  };

  # Interact with Pivotal Tracker through its API
  pivotal-tracker = buildEmacsPackage {
    name = "pivotal-tracker-1.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pivotal-tracker-1.2.0.el";
      sha256 = "075wsf5ak3n3hj9pcqv8vgldidl4wn7axk43w84vq97bpyn43lk7";
    };
  
    deps = [  ];
  };

  # Major mode for plantuml
  plantuml-mode = buildEmacsPackage {
    name = "plantuml-mode-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/plantuml-mode-0.2.el";
      sha256 = "0crvy92n0cx67d9mv5a1wyx8xnc4by4z8l5z3r263yclx9ndaj8v";
    };
  
    deps = [  ];
  };

  #  Screen for Emacsen(this is not original. original is http://www.morishima.net/~naoto/elscreen-en/?lang=en)
  po-elscreen = buildEmacsPackage {
    name = "po-elscreen-1.4.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/po-elscreen-1.4.6.el";
      sha256 = "1p7k7lx44m7gpmppjdn87y7fss6p9czpdcaq67iz7dl4kmqvssxa";
    };
  
    deps = [  ];
  };

  #  Screen for Emacsen(this is not original)
  po.elscreen = buildEmacsPackage {
    name = "po.elscreen-1.4.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/po.elscreen-1.4.6.el";
      sha256 = "13ql8apprffacivzlww1rq0gbxjcnz01s8r58csgdrrvszxa0mk3";
    };
  
    deps = [  ];
  };

  # Sass major mode
  po.foo = buildEmacsPackage {
    name = "po.foo-3.0.20";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/po.foo-3.0.20.el";
      sha256 = "10341wmkbgzk2c0rmyy7brs01sqxv8prvxkxx5053ml3fxfym1cp";
    };
  
    deps = [ haml-mode ];
  };

  # Major mode for editing .pod-files.
  pod-mode = buildEmacsPackage {
    name = "pod-mode-20121117.2120";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pod-mode-20121117.2120.tar";
      sha256 = "010klgbpwy42sa5r9dmh3yh40fp46nfd5hswqpk2yvm3l8wa2jgm";
    };
  
    deps = [  ];
  };

  # Restore window points when returning to buffers
  pointback = buildEmacsPackage {
    name = "pointback-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pointback-0.2.el";
      sha256 = "0bfnn7zw746clz0130sj35qw88k837538i79rclxp0vmczwqpj24";
    };
  
    deps = [  ];
  };

  # Minor mode for working with Django Projects
  pony-mode = buildEmacsPackage {
    name = "pony-mode-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pony-mode-0.2.tar";
      sha256 = "0r8l5lxhyj7sbl01ncc1ahgdw6szpvnldm3m9hc3gv85crjaixpj";
    };
  
    deps = [  ];
  };

  # Visual Popup User Interface
  popup = buildEmacsPackage {
    name = "popup-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/popup-0.5.el";
      sha256 = "10pn9nn9iagcwnzixvq0bsw3i1plfi29yn496m3ykdzfwfh1z71i";
    };
  
    deps = [  ];
  };

  # Popup Window Manager.
  popwin = buildEmacsPackage {
    name = "popwin-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/popwin-0.4.el";
      sha256 = "1fkhlmsaf7ixw65gnc7q00cj7c25ifxjznj7ffbsq37d0mbk3c4h";
    };
  
    deps = [  ];
  };

  # Show tooltip at point -*- coding: utf-8 -*-
  pos-tip = buildEmacsPackage {
    name = "pos-tip-0.4.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pos-tip-0.4.5.el";
      sha256 = "055gixdp20gahdv2l6cr2q754akrx1fg3fagfw5w32akcm1drskp";
    };
  
    deps = [  ];
  };

  # Major mode for editing POV-Ray scene files.
  pov-mode = buildEmacsPackage {
    name = "pov-mode-3.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pov-mode-3.3.tar";
      sha256 = "07fp08c3jb85hz8rq7gc5bb6wm1i3q7zpggcl5hyzz6xi593pfw8";
    };
  
    deps = [  ];
  };

  # run powershell as an inferior shell in emacs
  powershell = buildEmacsPackage {
    name = "powershell-0.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/powershell-0.2.1.el";
      sha256 = "189ksi48dam2xvd1nj2a6p18pcaly72wp6phr5r3ypcp6dhvd717";
    };
  
    deps = [  ];
  };

  # Display Control-l characters in a pretty way
  pp-c-l = buildEmacsPackage {
    name = "pp-c-l-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pp-c-l-1.0.el";
      sha256 = "0vpqiai6qmkh666avy4l777ynf6r56gw8ak7nhm9nw87qfirl4x0";
    };
  
    deps = [  ];
  };

  # Predictive Mode (Contains Dependencies)
  predictive = buildEmacsPackage {
    name = "predictive-0.19.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/predictive-0.19.5.tar";
      sha256 = "0hfcg3y7hfi7qq0mjsk27z9vlzyz76syd6yq8mflvsc87js46znh";
    };
  
    deps = [  ];
  };

  # Show the word `lambda' as the Greek letter.
  pretty-lambdada = buildEmacsPackage {
    name = "pretty-lambdada-22.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pretty-lambdada-22.0.el";
      sha256 = "1b72axiw196dydxdgs4p1z9yaj5abhpd8yyb4zp2gqry2mbnvx61";
    };
  
    deps = [  ];
  };

  # Redisplay parts of the buffer as pretty symbols.
  pretty-mode-plus = buildEmacsPackage {
    name = "pretty-mode-plus-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pretty-mode-plus-1.1.tar";
      sha256 = "0xg3hji862v8s21371hkcc4f7b09x93xqshqvh0x5iinlikm51ml";
    };
  
    deps = [  ];
  };

  # network process tools
  proc-net = buildEmacsPackage {
    name = "proc-net-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/proc-net-0.0.1.el";
      sha256 = "1f0xx8hb9sl0s0rwab4kwc90nzi87nblf6mxd8qkkd938v4s1ayh";
    };
  
    deps = [  ];
  };

  # Keep track of the current project
  project = buildEmacsPackage {
    name = "project-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/project-1.0.el";
      sha256 = "0smabwgv68ib76206pgqv02kk0k1wdjphrl3rh4q18a38wd7sdf1";
    };
  
    deps = [  ];
  };

  # Define code projects. Full-text search, etc.
  project-mode = buildEmacsPackage {
    name = "project-mode-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/project-mode-1.0.el";
      sha256 = "0an8s4lq4zlzw5jnqb7w6skc1g3rjr18ivaq15dhc49gjp503rzm";
    };
  
    deps = [ levenshtein ];
  };

  # Manage and navigate projects in Emacs easily
  projectile = buildEmacsPackage {
    name = "projectile-0.9.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/projectile-0.9.1.el";
      sha256 = "1k325ij9l4ydl1iqrnda66fphhk6fi3v3m2gyrx1ggq3nb7inq4l";
    };
  
    deps = [ s dash ];
  };

  # major mode for editing and running Prolog (and Mercury) code
  prolog = buildEmacsPackage {
    name = "prolog-1.22";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/prolog-1.22.el";
      sha256 = "1pv64lp4jvnl55mysxgqbsk3mzfpp0v1sk9w85ilsibg73g2j2zr";
    };
  
    deps = [  ];
  };

  # major mode for editing protocol buffers.
  protobuf-mode = buildEmacsPackage {
    name = "protobuf-mode-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/protobuf-mode-0.3.el";
      sha256 = "0d6wyfcqz4226sc1a6hmm36ybildnavynvlljklxvbihcrzfd27b";
    };
  
    deps = [  ];
  };

  # Lennart Staflin's Psgml package, with Elisp syntax fixed for Emacsen >=24.
  psgml = buildEmacsPackage {
    name = "psgml-1.4.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/psgml-1.4.0.tar";
      sha256 = "0dslg0xrbanar0cnkn70rv3y3m7j2g4h2mqwq424q1kmdlbrf7ba";
    };
  
    deps = [  ];
  };

  # Subversion interface for emacs
  psvn = buildEmacsPackage {
    name = "psvn-1.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/psvn-1.1.1.el";
      sha256 = "0ns98cd2g5whscdyswvhcck8xnvwg4158yda8i9z4x59ax6mkfph";
    };
  
    deps = [  ];
  };

  # A simple mode for editing puppet manifests
  puppet-mode = buildEmacsPackage {
    name = "puppet-mode-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/puppet-mode-0.2.el";
      sha256 = "1v2x32bclnfpws7mchzi9v3kscy1af7j4i7clgmsypmhb77243p4";
    };
  
    deps = [  ];
  };

  # an overtly purple color theme for Emacs24.
  purple-haze-theme = buildEmacsPackage {
    name = "purple-haze-theme-0.0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/purple-haze-theme-0.0.7.el";
      sha256 = "1i7ivz6bj510r5kb5g0szpi0nhpd3ijk7fd2sxq428qpnqaq6yr9";
    };
  
    deps = [  ];
  };

  # Complete symbols at point using Pymacs.
  pycomplete = buildEmacsPackage {
    name = "pycomplete-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pycomplete-1.0.el";
      sha256 = "0f49kryxa0j9hyyvyxidsb1d506jhs8gch10j3km683bgz64c9dz";
    };
  
    deps = [  ];
  };

  # Python Development Environment
  pyde = buildEmacsPackage {
    name = "pyde-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pyde-0.6.el";
      sha256 = "09m5bkmrk29r225c2ykfkd63ff716fhjjwb094hr24p2jy55cgql";
    };
  
    deps = [ pymacs auto-complete yasnippet fuzzy pyvirtualenv ];
  };

  # run the python pyflakes checker putting hits in a grep buffer
  pyflakes = buildEmacsPackage {
    name = "pyflakes-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pyflakes-1.0.el";
      sha256 = "1xdj4w501kcvzrkkz5fv9dmp4s991h0c3f6n44dbz7zrxlb7d4ic";
    };
  
    deps = [  ];
  };

  # run the python pylint checker putting hits in a grep buffer
  pylint = buildEmacsPackage {
    name = "pylint-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pylint-1.0.el";
      sha256 = "0jyql9hc6cib4n4sslvxnsyfwh03gdb22lwash2c3q3n410kf1a8";
    };
  
    deps = [  ];
  };

  # Interface between Emacs Lisp and Python
  pymacs = buildEmacsPackage {
    name = "pymacs-0.25";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pymacs-0.25.el";
      sha256 = "0vwp72a99907xp4hlb52n5xqdmf0dxhsrjvwmsdz01amia4bvyhc";
    };
  
    deps = [  ];
  };

  # Complete python code using heuristic static analysis
  pysmell = buildEmacsPackage {
    name = "pysmell-0.7.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pysmell-0.7.2.el";
      sha256 = "157byaazjrayskl6k7dl6gab4mzzd6mzdjqaf5m871x5rgz89h5l";
    };
  
    deps = [  ];
  };

  # Easy Python test running in Emacs
  pytest = buildEmacsPackage {
    name = "pytest-0.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pytest-0.2.1.el";
      sha256 = "1r43ac32p9nx5w14l4clbvjjczicam47ky5n5pi7p30bz88f9nrp";
    };
  
    deps = [  ];
  };

  # Python's flying circus support for Emacs
  python = buildEmacsPackage {
    name = "python-20120402";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/python-20120402.el";
      sha256 = "16lkgl0fq5g89hzmjbsy51drs96hdpqxp93i0zv2z3gs2zx4mvir";
    };
  
    deps = [  ];
  };

  # A Jazzy package for managing Django projects
  python-django = buildEmacsPackage {
    name = "python-django-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/python-django-0.1.el";
      sha256 = "055ssgmgc4bddwbkvh75idd4lm62jlh67fgykb852vsz8a3x92lf";
    };
  
    deps = [  ];
  };

  # Python major mode
  python-mode = buildEmacsPackage {
    name = "python-mode-6.0.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/python-mode-6.0.10.tar";
      sha256 = "178r4gxsss479wwq9pm85811d9klacdc8zxp8ayhnfm7lgjny1kr";
    };
  
    deps = [  ];
  };

  # minor mode for running `pep8'
  python-pep8 = buildEmacsPackage {
    name = "python-pep8-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/python-pep8-1.1.el";
      sha256 = "1zzacm36igmiqy76v1sb2g4ms5lsgh9s34kz7r3bf6w765saal82";
    };
  
    deps = [  ];
  };

  # minor mode for running `pylint'
  python-pylint = buildEmacsPackage {
    name = "python-pylint-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/python-pylint-1.1.el";
      sha256 = "0x3hj32ibskgzp1nppm9cy8zgm9nb281g41sh8cycxysicnss2xa";
    };
  
    deps = [  ];
  };

  # Python Pyvirtualenv support
  pyvirtualenv = buildEmacsPackage {
    name = "pyvirtualenv-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/pyvirtualenv-1.1.el";
      sha256 = "0778mdn4j094g2wc92r9qz1p2hd6rnrsn3mjk0aj8k75gfrg4z71";
    };
  
    deps = [  ];
  };

  # Based on solarized color theme for Emacs.
  qsimpleq-theme = buildEmacsPackage {
    name = "qsimpleq-theme-0.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/qsimpleq-theme-0.1.3.el";
      sha256 = "1mszap3zsrbw4pwrwqzf0d7g9y4n9kswrmbqwxcsnml1n7rqg7ys";
    };
  
    deps = [  ];
  };

  # enhanced support for editing and running Scheme code
  quack = buildEmacsPackage {
    name = "quack-0.42";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/quack-0.42.el";
      sha256 = "006dkn2rz5lp0i19ybpfgi779wsv2bvlchmxz12jxjzy7gxy98nx";
    };
  
    deps = [  ];
  };

  # Minor mode for quarter-plane style editing
  quarter-plane = buildEmacsPackage {
    name = "quarter-plane-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/quarter-plane-0.1.el";
      sha256 = "0hj3asdzf05h8j1fsxx9y71arnprg2xwk2dcb81zj04hzggzpwmm";
    };
  
    deps = [  ];
  };

  # Queue data structure
  queue = buildEmacsPackage {
    name = "queue-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/queue-0.1.el";
      sha256 = "1qdbyjzyf2zv311ak4g67c6xax8ngr27miidgdr1zwzyxxb6jqik";
    };
  
    deps = [  ];
  };

  # Run commands quickly
  quickrun = buildEmacsPackage {
    name = "quickrun-1.8.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/quickrun-1.8.4.el";
      sha256 = "1zifzss1axq8dsw6bjiaabn6a9krd1w93s8ff62y1h821rqj7ari";
    };
  
    deps = [  ];
  };

  # Provides automatically created yasnippets for R function argument lists.
  r-autoyas = buildEmacsPackage {
    name = "r-autoyas-0.28";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/r-autoyas-0.28.el";
      sha256 = "1fmyz37gfymwhkxzsmp8x680wyc9l98brhm8b1wsw9crps71k5zs";
    };
  
    deps = [  ];
  };

  # Browse documentation from the R5RS Revised5 Report
  r5rs = buildEmacsPackage {
    name = "r5rs-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/r5rs-1.0.el";
      sha256 = "171gqjpb4hgdzx146c57g1c3qy77lm5g8q7sdx40riqnw1pmdcc7";
    };
  
    deps = [  ];
  };

  # Highlight nested parens, brackets, braces a different color at each depth.
  rainbow-delimiters = buildEmacsPackage {
    name = "rainbow-delimiters-1.3.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rainbow-delimiters-1.3.4.el";
      sha256 = "0y4912f1hagnphilp7drprm4yq6v3cr3vj1i1dqnfgv6rzv56f3g";
    };
  
    deps = [  ];
  };

  # Colorize color names in buffers
  rainbow-mode = buildEmacsPackage {
    name = "rainbow-mode-0.8";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/rainbow-mode-0.8.el";
      sha256 = "0hnqchhzd8ds97nyfa1cqglmi8qg705i7hfw9zhxxmrhyinsaxbf";
    };
  
    deps = [  ];
  };

  # Emacs integration for rbenv
  rbenv = buildEmacsPackage {
    name = "rbenv-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rbenv-0.0.2.el";
      sha256 = "10f80vhil3rwbyzp4hpjnadw6bczssb7d0rnyc2pyh09ma67vfk3";
    };
  
    deps = [  ];
  };

  # color nicks
  rcirc-color = buildEmacsPackage {
    name = "rcirc-color-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rcirc-color-0.2.el";
      sha256 = "1ia6ky16nny704nvms7yq5sz74v0324xr26wpkhpl20h1sf5ywh1";
    };
  
    deps = [  ];
  };

  # libnotify popups
  rcirc-notify = buildEmacsPackage {
    name = "rcirc-notify-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rcirc-notify-0.6.el";
      sha256 = "0v44n3mh31b7x3344xkcpw64ln25yryv43vvnj9gi58lvzib33mk";
    };
  
    deps = [  ];
  };

  # robots based on rcirc irc -*- lexical-binding: t -*-
  rcirc-robots = buildEmacsPackage {
    name = "rcirc-robots-0.0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rcirc-robots-0.0.7.el";
      sha256 = "11pqrypia2ygsl47flsr34l008sgscid3mry03cigav3vsqdwf3c";
    };
  
    deps = [ kv anaphora ];
  };

  # do irc over ssh sessions -*- lexical-binding: t -*-
  rcirc-ssh = buildEmacsPackage {
    name = "rcirc-ssh-0.0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rcirc-ssh-0.0.7.el";
      sha256 = "1qacvnkipmlhdkd2285akm5m9smcbr94a74spgw3nbwqbcydkcpm";
    };
  
    deps = [ kv ];
  };

  # Unambiguous non-cycling completion for rcirc
  rcirc-ucomplete = buildEmacsPackage {
    name = "rcirc-ucomplete-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rcirc-ucomplete-1.0.1.el";
      sha256 = "1561hvxnl8zs1dmprpbn83k7nbjgwnq8c3j7fm4vzz4kslnmfy09";
    };
  
    deps = [  ];
  };

  # enable real auto save
  real-auto-save = buildEmacsPackage {
    name = "real-auto-save-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/real-auto-save-0.3.el";
      sha256 = "1ni85jyl3g6qqz0qab4ss7rkr6r4mp6jxzvqkij89iw3xigzdi3i";
    };
  
    deps = [  ];
  };

  # Mark a rectangle of text with highlighting.
  rect-mark = buildEmacsPackage {
    name = "rect-mark-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rect-mark-1.4.el";
      sha256 = "16gzx55y38h45gn7nwqd0ia2kpv3qgzvwjhzq4kc3k77d6pd2s2q";
    };
  
    deps = [  ];
  };

  # narrow-to-region that operates recursively
  recursive-narrow = buildEmacsPackage {
    name = "recursive-narrow-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/recursive-narrow-1.0.el";
      sha256 = "1j6xfshv2770sv1mmig3268xx0hqjw25vjilpm9njikb5vijqc8d";
    };
  
    deps = [  ];
  };

  # Redo/undo system for Emacs
  redo-plus = buildEmacsPackage {
    name = "redo-plus-1.15";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/redo+-1.15.el";
      sha256 = "0sv36mlnhb300hfvwv0v4dgapinwklnszbg71s76p318ql7v9mf2";
    };
  
    deps = [  ];
  };

  # A library for pasting to https://refheap.com
  refheap = buildEmacsPackage {
    name = "refheap-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/refheap-0.0.3.el";
      sha256 = "1lgb24g4zavdshjnc6v2zx1rfcr1zmrrqp16nzhzkdvf3gdsxzp9";
    };
  
    deps = [  ];
  };

  # A regular expression evaluation tool for programmers
  regex-tool = buildEmacsPackage {
    name = "regex-tool-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/regex-tool-1.2.el";
      sha256 = "0sm53b6a5sm9806m0jnqc9d1bbi6qm0h0vaw8bd10s12ghsp0gd1";
    };
  
    deps = [  ];
  };

  # Enable custom bindings when mark is active.
  region-bindings-mode = buildEmacsPackage {
    name = "region-bindings-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/region-bindings-mode-0.1.el";
      sha256 = "1yf9hrfvjnx1754f67cj0i57k93sir62rhjjrkcsib53y7ag80i2";
    };
  
    deps = [  ];
  };

  # Add/delete a region into/from a region list, such as ‘((4 . 7) (11 . 15) (17 . 17) (20 . 25)).
  region-list-edit = buildEmacsPackage {
    name = "region-list-edit-20100530.808";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/region-list-edit-20100530.808.el";
      sha256 = "1hcsr4s6pym4mz0p40vah3gjjf7xv56dppp9dw47w780n21dnghs";
    };
  
    deps = [  ];
  };

  # Interactively list/edit registers
  register-list = buildEmacsPackage {
    name = "register-list-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/register-list-0.1.el";
      sha256 = "1azgfm4yvhp2bqqplmfbz1fij8gda527lks82bslnpnabd8m6sjh";
    };
  
    deps = [  ];
  };

  # deduce the repository root directory for a given file
  repository-root = buildEmacsPackage {
    name = "repository-root-1.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/repository-root-1.0.3.el";
      sha256 = "1mys4rk7kr0cyngmzn2aqd7idmfl1dj0gkl9yrqwn7wm401lxl7y";
    };
  
    deps = [  ];
  };

  # Compatible layer for URL request in Emacs
  request = buildEmacsPackage {
    name = "request-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/request-0.2.0.el";
      sha256 = "04r4dmi5hg1svnm1bkql1ahy61d92axp6bvmf0ryras32y3jhzb9";
    };
  
    deps = [  ];
  };

  # Wrap request.el by deferred
  request-deferred = buildEmacsPackage {
    name = "request-deferred-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/request-deferred-0.2.0.el";
      sha256 = "0cmf68lyddraxgmn87r7hb17pz99yhjqmy64iq2yla79r9jncqqw";
    };
  
    deps = [ deferred request ];
  };

  # Improved AMD module management
  requirejs-mode = buildEmacsPackage {
    name = "requirejs-mode-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/requirejs-mode-1.1.el";
      sha256 = "0ncbyly8mkxm04lra9k6kfwdcibihy7fqp4m00jw3q71libd99s1";
    };
  
    deps = [  ];
  };

  # indicate relative locations in the fringe
  rfringe = buildEmacsPackage {
    name = "rfringe-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rfringe-1.0.1.el";
      sha256 = "1h2wj93fsf5n5plysqamidvr2jdv4q8f6xn33b9jnmlzn0grs2ys";
    };
  
    deps = [  ];
  };

  # Rinari Is Not A Rails IDE
  rinari = buildEmacsPackage {
    name = "rinari-2.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rinari-2.10.el";
      sha256 = "0z3n0c260yk5paskiyy8fhck3bxhjpq48mszn3psd45dyiv25411";
    };
  
    deps = [ ruby-mode inf-ruby ruby-compilation jump ];
  };

  # Code navigation, documentation lookup and completion for Ruby
  robe = buildEmacsPackage {
    name = "robe-0.7.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/robe-0.7.4.tar";
      sha256 = "1nccrjganbgs618amf6v0n8fbq2dq6fykvw11p1ksf71mm7659ba";
    };
  
    deps = [ inf-ruby ];
  };

  # Roy major mode
  roy-mode = buildEmacsPackage {
    name = "roy-mode-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/roy-mode-0.1.0.el";
      sha256 = "1gg69bv46w3mc2g7kwg1lybhp63vskrchy9ambpv02in4wbl94af";
    };
  
    deps = [  ];
  };

  # Enhance ruby-mode for RSpec
  rspec-mode = buildEmacsPackage {
    name = "rspec-mode-1.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rspec-mode-1.7.el";
      sha256 = "1jn1nvf0mf1kwh1pbxrhl8miyysf6lqj6jsdqsx8d3gwv97kg19r";
    };
  
    deps = [ ruby-mode ];
  };

  # An Emacs interface for RuboCop
  rubocop = buildEmacsPackage {
    name = "rubocop-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rubocop-0.1.el";
      sha256 = "0ljkqj90asy35n698kjk3m9dh7m1wxps4xjw1n6pnycxzvannbn1";
    };
  
    deps = [ dash ];
  };

  # highlight matching block
  ruby-block = buildEmacsPackage {
    name = "ruby-block-0.0.11";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ruby-block-0.0.11.el";
      sha256 = "1ynvm0cq13jb2b52qa2i4vv20qh0r33as51d4l2257qzvwpsr8b4";
    };
  
    deps = [  ];
  };

  # run a ruby process in a compilation buffer
  ruby-compilation = buildEmacsPackage {
    name = "ruby-compilation-0.17";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ruby-compilation-0.17.el";
      sha256 = "03dk67ka73rq999fi6nhl8fwqsbnljc168jqxjsccdv19ppap8xv";
    };
  
    deps = [ inf-ruby ];
  };

  # Automatic insertion of end blocks for Ruby
  ruby-end = buildEmacsPackage {
    name = "ruby-end-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ruby-end-0.2.0.el";
      sha256 = "16wn564iz88m86ni0l4bvy2sjwc8xhfcjndkmdmh9q1ylncc52pg";
    };
  
    deps = [  ];
  };

  # Toggle ruby hash syntax between classic and 1.9 styles
  ruby-hash-syntax = buildEmacsPackage {
    name = "ruby-hash-syntax-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ruby-hash-syntax-0.1.el";
      sha256 = "1fhfwla7y4w064zh7cmap1s7bhc94nigq4r3d3wn003vqhv8y62m";
    };
  
    deps = [  ];
  };

  # ruby-mode package
  ruby-mode = buildEmacsPackage {
    name = "ruby-mode-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ruby-mode-1.1.tar";
      sha256 = "0vfbydfd439jl4byzwirfa6ad54i9rq2lzqs2amcl0i6ikjc26pd";
    };
  
    deps = [  ];
  };

  # Minor mode for Behaviour and Test Driven
  ruby-test-mode = buildEmacsPackage {
    name = "ruby-test-mode-1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ruby-test-mode-1.5.el";
      sha256 = "0pcm8dg4nhl1frgp0rcsg8zgzcfaf8nlyyzfadvlsbjl38f1kcci";
    };
  
    deps = [ ruby-mode ];
  };

  # Collection of handy functions for ruby-mode
  ruby-tools = buildEmacsPackage {
    name = "ruby-tools-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ruby-tools-0.1.0.el";
      sha256 = "0h9y1g4igvzn9q9bgjjf8sb4chrm5hjsf5zv8zsc9hzn6pvy2n7p";
    };
  
    deps = [  ];
  };

  # Ruby-like String Interpolation for format
  rubyinterpol = buildEmacsPackage {
    name = "rubyinterpol-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rubyinterpol-0.1.el";
      sha256 = "1gc096xh2z3xlf0jd0nv7q0kanx1mg6hvp9w7a24yc33jj8spki0";
    };
  
    deps = [  ];
  };

  # A collaborative editing framework for Emacs
  rudel = buildEmacsPackage {
    name = "rudel-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rudel-0.3.tar";
      sha256 = "1fw1fh2mqxml317712p28xj171cpbmpv5c46hjdfn09fypshn93n";
    };
  
    deps = [ eieio ];
  };

  # A major emacs mode for editing Rust source code
  rust-mode = buildEmacsPackage {
    name = "rust-mode-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rust-mode-0.1.0.el";
      sha256 = "0hig35kw5wplqdlliv5w0yy3md40lji4gwdai0irrc8g2dyrhr0x";
    };
  
    deps = [ cm-mode ];
  };

  # Emacs integration for rvm
  rvm = buildEmacsPackage {
    name = "rvm-1.3.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rvm-1.3.0.el";
      sha256 = "1mzsdsnmxmvli67f9fywv51lvz1hgm6vxiyrmpgld56fbglzlvfb";
    };
  
    deps = [  ];
  };

  # special functions for Hunspell in ispell.el
  rw-hunspell = buildEmacsPackage {
    name = "rw-hunspell-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rw-hunspell-0.2.el";
      sha256 = "0siz76syxbmw264xpx1wgyx54y32x4qsp0lr8g92qcnd2qkv5qrj";
    };
  
    deps = [  ];
  };

  # additional functions for ispell.el
  rw-ispell = buildEmacsPackage {
    name = "rw-ispell-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rw-ispell-0.1.el";
      sha256 = "1420yw8xj15c38jacwsy7ih998pp25sp0fq41l4fgymld543gmag";
    };
  
    deps = [  ];
  };

  # Language & Country Codes
  rw-language-and-country-codes = buildEmacsPackage {
    name = "rw-language-and-country-codes-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/rw-language-and-country-codes-0.1.el";
      sha256 = "1hcq0vjrn062yfwrvdp69wcj0b87f4w0rg15hf605ywihxym7jc6";
    };
  
    deps = [  ];
  };

  # The long lost Emacs string manipulation library.
  s = buildEmacsPackage {
    name = "s-1.6.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/s-1.6.1.el";
      sha256 = "0h6ysq2hrrf6y908px2nh7qbwybc8sg9ss8fhllxp1vanlfl2jkw";
    };
  
    deps = [  ];
  };

  # s operations for buffers
  s-buffer = buildEmacsPackage {
    name = "s-buffer-0.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/s-buffer-0.0.4.el";
      sha256 = "1lhrgsw5fjs18qcibix4fwgc5sha9f62a83h3ivcw443g0pvlnm5";
    };
  
    deps = [ s noflet ];
  };

  # A better backspace
  sackspace = buildEmacsPackage {
    name = "sackspace-0.8.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sackspace-0.8.1.el";
      sha256 = "1inh02lddjzyr9933n0y5m1gb122vik05dhl2j3f2gznnl3ispz0";
    };
  
    deps = [  ];
  };

  # Major mode for editing Sass files
  sass-mode = buildEmacsPackage {
    name = "sass-mode-3.0.14";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sass-mode-3.0.14.el";
      sha256 = "03s84z7jmzr9ilfhq2skqi9i7gsvq1n6yqr95izsj9ab73n7fmih";
    };
  
    deps = [ haml-mode ];
  };

  # Track (erc/org/dbus/...) events and react to them.
  sauron = buildEmacsPackage {
    name = "sauron-0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sauron-0.8.tar";
      sha256 = "08m83nz885cibkf71xx2y1xczihs3p1kxbad24f79lrvqg27d77a";
    };
  
    deps = [  ];
  };

  # save and restore installed packages
  save-packages = buildEmacsPackage {
    name = "save-packages-0.20121012";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/save-packages-0.20121012.el";
      sha256 = "0ldsk9sgmnq2ppgrv3hqw733sha5wa7kgq6kdp4h00x72ilrmg0c";
    };
  
    deps = [  ];
  };

  # save opened files across sessions
  save-visited-files = buildEmacsPackage {
    name = "save-visited-files-1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/save-visited-files-1.3.el";
      sha256 = "10kx85crpw87zfpjvrqzahds3p0dxgikvllygl5szsyr70v51144";
    };
  
    deps = [  ];
  };

  # Sawfish mode.
  sawfish = buildEmacsPackage {
    name = "sawfish-1.32";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sawfish-1.32.el";
      sha256 = "02b0ldn9hcqmqh28w0d3y2pszx9nign5a2j0mpgdadfjr6s1ydnf";
    };
  
    deps = [  ];
  };

  # SCAD mode derived mode
  scad-mode = buildEmacsPackage {
    name = "scad-mode-90.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/scad-mode-90.0.el";
      sha256 = "05ixngxgv1x4a9lvdcy4xiw2rsmvrzm1l76qx46kf199bqwpps53";
    };
  
    deps = [  ];
  };

  # Scala major mode
  scala-mode = buildEmacsPackage {
    name = "scala-mode-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/scala-mode-0.0.2.tar";
      sha256 = "14k0r218axzsbry7481g8dqpj3f1pn4kw874gpi8ns5br9b0f9ig";
    };
  
    deps = [  ];
  };

  # Smart tab completion for Emacs
  scheme-complete = buildEmacsPackage {
    name = "scheme-complete-0.8.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/scheme-complete-0.8.2.el";
      sha256 = "0lxahfn2jfrcg483dhakwpk9dyng2zaknad8q7zzx4k11x0znw6m";
    };
  
    deps = [  ];
  };

  # Paste to the web via scp.
  scpaste = buildEmacsPackage {
    name = "scpaste-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/scpaste-0.6.el";
      sha256 = "1cjcgbdm95wmnhx14rizkz2qs2x4bs2vlmcya6v96k2n6a7mm778";
    };
  
    deps = [ htmlize ];
  };

  # Mode-specific scratch buffers
  scratch = buildEmacsPackage {
    name = "scratch-20110708";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/scratch-20110708.el";
      sha256 = "0bqmc3dx40nxyhlakizhd0w0px1b068769rv8rsy4hcmgn6ji47a";
    };
  
    deps = [  ];
  };

  # a minor mode for screen-line-based point motion
  screen-lines = buildEmacsPackage {
    name = "screen-lines-0.55";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/screen-lines-0.55.el";
      sha256 = "0ilm3x2chns7m9qlcid9hddnm4jgmqp2hj2xwbpl1mql6p0gqbzi";
    };
  
    deps = [  ];
  };

  # This mode ofers vim-like scrolloff function
  scrolloff = buildEmacsPackage {
    name = "scrolloff-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/scrolloff-1.0.el";
      sha256 = "0ap96fqah7a347k9af80v3gqmm2a24gbi34nb53iavi7p10pxndh";
    };
  
    deps = [  ];
  };

  # Major mode for editing SCSS files
  scss-mode = buildEmacsPackage {
    name = "scss-mode-0.5.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/scss-mode-0.5.0.el";
      sha256 = "0d1skwz0drq6xgjwxh8s9xyf023k8v3s5f0qm0hp1a2sm6rv1793";
    };
  
    deps = [  ];
  };

  # Sea Before Storm color theme for Emacs 24
  sea-before-storm-theme = buildEmacsPackage {
    name = "sea-before-storm-theme-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sea-before-storm-theme-0.3.el";
      sha256 = "19kil669j1qc7kbv7vvnim0dnb1q0p77fwwrhchj0c13fnk1fj70";
    };
  
    deps = [  ];
  };

  # Edit in seclusion. A Dark Room mode.
  seclusion-mode = buildEmacsPackage {
    name = "seclusion-mode-1.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/seclusion-mode-1.1.1.el";
      sha256 = "1zhb825najfh97wzi3fpny0g3lp57nx4whcx2zq4pzw4zdnmaicf";
    };
  
    deps = [  ];
  };

  # highlight the current sentence
  sentence-highlight = buildEmacsPackage {
    name = "sentence-highlight-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sentence-highlight-0.1.el";
      sha256 = "11fyj61l926xpishdx2pp36dwpij9ijgwkyhhszrg31vh256p8m0";
    };
  
    deps = [  ];
  };

  # makes sequences of numbers -*- lexical-binding: t -*-
  sequence = buildEmacsPackage {
    name = "sequence-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sequence-0.0.1.el";
      sha256 = "1nrd4xz9hic18w8ajwxvlzavsdrwwk5a8z7ga3qv3r0m993ry7g9";
    };
  
    deps = [  ];
  };

  # use variables, registers and buffer places across sessions
  session = buildEmacsPackage {
    name = "session-2.2.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/session-2.2.1.el";
      sha256 = "01a7dzzlpzzr795hgic1rlg4ghc8pap4j8zxrcgzwkvvgjhqb7qk";
    };
  
    deps = [  ];
  };

  # Support for the Gnome Session Manager
  session-manager = buildEmacsPackage {
    name = "session-manager-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/session-manager-0.5.el";
      sha256 = "0qg3nvw0p01rrx8jw72pp97xcnclp9qii5xlhgqc4dj1pa3sfphm";
    };
  
    deps = [  ];
  };

  # pattern matching for elisp
  shadchen = buildEmacsPackage {
    name = "shadchen-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/shadchen-1.0.el";
      sha256 = "1bh0jngaaapck0pymh0gchinj743z1ng25vc0hcdwij4p211kknw";
    };
  
    deps = [  ];
  };

  # Open a shell relative to the working directory
  shell-here = buildEmacsPackage {
    name = "shell-here-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/shell-here-1.1.el";
      sha256 = "1wzz6s47y7dcvmrd5kqhnbmb9fpjy03lzkr65dq673g8lrpnzql2";
    };
  
    deps = [  ];
  };

  # Easily switch between shell buffers, like with alt+tab.
  shell-switcher = buildEmacsPackage {
    name = "shell-switcher-0.1.5.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/shell-switcher-0.1.5.1.tar";
      sha256 = "0ng2yh0v0slyxl4z9qc4my9xkgjzwxy15vw3kd80dbxsfjd2wnj9";
    };
  
    deps = [  ];
  };

  # Utilities for working with Shen code.
  shen-mode = buildEmacsPackage {
    name = "shen-mode-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/shen-mode-0.1.tar";
      sha256 = "1dr24kkah4hr6vrfxwhl9vzjnwn4n773bw23c3j9bkmlgnbvn0kz";
    };
  
    deps = [  ];
  };

  # irc bouncer
  shoes-off = buildEmacsPackage {
    name = "shoes-off-0.1.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/shoes-off-0.1.8.el";
      sha256 = "16h44bmpyhzf6q92g2x49v2jjl9l44djmia7fsvxrg3zamzwhyx3";
    };
  
    deps = [ kv anaphora ];
  };

  # component-wise string shortener
  shorten = buildEmacsPackage {
    name = "shorten-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/shorten-0.2.el";
      sha256 = "0j3qzmy4vclhvb6j75j4as3slww19m012bc4j70f5kwswngps6y1";
    };
  
    deps = [  ];
  };

  # Show the css of the html attribute the cursor is on
  show-css = buildEmacsPackage {
    name = "show-css-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/show-css-1.1.el";
      sha256 = "0vrsq2ijnmgz5zzn84z5j21zbdbm7wnnqn6cf0aja67jhqv0swcw";
    };
  
    deps = [  ];
  };

  # Navigate and visualize the mark-ring
  show-marks = buildEmacsPackage {
    name = "show-marks-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/show-marks-0.3.el";
      sha256 = "1jqy1mm6c2crv80h3b28dlss504wqa49almnfyza47xly80z6lcv";
    };
  
    deps = [ fm ];
  };

  # Simple project definition, chiefly for project file finding and grepping.
  simp = buildEmacsPackage {
    name = "simp-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/simp-0.2.0.tar";
      sha256 = "1k3pypsl9b52z0svnaxh8fmyzgwsffjgq14lbmcnn7w7pvwszbyh";
    };
  
    deps = [  ];
  };

  # Extensions to simple-call-tree
  simple-call-tree-plus = buildEmacsPackage {
    name = "simple-call-tree-plus-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/simple-call-tree+-1.0.0.el";
      sha256 = "00p8lir3kn1ipk3g6mgnq0qzz0rq7552jcq5xkvpbsa43i6syz29";
    };
  
    deps = [  ];
  };

  # Simplified Mode Line for Emacs 24
  simple-mode-line = buildEmacsPackage {
    name = "simple-mode-line-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/simple-mode-line-0.3.el";
      sha256 = "0gymkz4qj4llxx9wsph28x0x63331zs8v3sc9yp2mf23r37pmvd3";
    };
  
    deps = [  ];
  };

  # Simplified access to the system clipboard
  simpleclip = buildEmacsPackage {
    name = "simpleclip-0.2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/simpleclip-0.2.2.el";
      sha256 = "07bvaapxg1kc6s40p3adj46xkk3m7qwyhmx9171lmwrgihb83hwg";
    };
  
    deps = [  ];
  };

  # A simple subset of zencoding-mode for Emacs.
  simplezen = buildEmacsPackage {
    name = "simplezen-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/simplezen-0.1.1.el";
      sha256 = "1gd9r51bpyvpmc18na6ghd4rx6bxcvw7bb0g6ci7znjmybr48v29";
    };
  
    deps = [  ];
  };

  # Major mode for SiSU markup text
  sisu-mode = buildEmacsPackage {
    name = "sisu-mode-3.0.3";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/sisu-mode-3.0.3.el";
      sha256 = "0ay9hfix3x53f39my02071dzxrw69d4zx5zirxwmmmyxmkaays3r";
    };
  
    deps = [  ];
  };

  # a blog engine with elnode -*- lexical-binding: t -*-
  skinny = buildEmacsPackage {
    name = "skinny-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/skinny-0.0.3.el";
      sha256 = "0rpsalccd4gangpw9hf75nrxgz05nkl87xb6iqdv5pblphm8sbm2";
    };
  
    deps = [ elnode creole ];
  };

  # Rip Clojure namespaces apart and rebuild them.
  slamhound = buildEmacsPackage {
    name = "slamhound-2.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slamhound-2.0.0.el";
      sha256 = "0mskza5m74n6ii3wq3g0ign72ajnsyl54avcci7w3nfk5vjglg2q";
    };
  
    deps = [  ];
  };

  # Major mode for editing Slim files
  slim-mode = buildEmacsPackage {
    name = "slim-mode-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slim-mode-1.1.el";
      sha256 = "134yyap66camcwwb8fazvg10khvfymbghnr9lpnniqbqdx9814ww";
    };
  
    deps = [  ];
  };

  # Superior Lisp Interaction Mode for Emacs
  slime = buildEmacsPackage {
    name = "slime-20100404.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slime-20100404.1.el";
      sha256 = "0x3bcy0a452qi0xcffkln53kqvb410spr1si7c61sjvsnxz54c73";
    };
  
    deps = [  ];
  };

  # slime extensions for swank-clj
  slime-clj = buildEmacsPackage {
    name = "slime-clj-0.1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slime-clj-0.1.5.el";
      sha256 = "0dkk2xmnks8y3vkf91jmbrlnb7415mbk4nnscvwsmvh3m321md2m";
    };
  
    deps = [  ];
  };

  # Fuzzy symbol completion for Slime
  slime-fuzzy = buildEmacsPackage {
    name = "slime-fuzzy-20100404";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slime-fuzzy-20100404.el";
      sha256 = "0mlda0rp24p7b123q88ndkz09ing940lq6yi0vbi643rpxfx5x9z";
    };
  
    deps = [ slime ];
  };

  # Slime extension for swank-js.
  slime-js = buildEmacsPackage {
    name = "slime-js-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slime-js-0.0.1.el";
      sha256 = "1z7il36m3p3z1nx5610ph2zra0kw7kbxx299w8sfw18n64b1q6la";
    };
  
    deps = [ slime-repl slime ];
  };

  # Read-Eval-Print Loop written in Emacs Lisp
  slime-repl = buildEmacsPackage {
    name = "slime-repl-20100404";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slime-repl-20100404.el";
      sha256 = "1j3s2abpjw80hp51cxhs5g6d8rq7syaqi2cpn2kv9lhkrb5iwbkx";
    };
  
    deps = [ slime ];
  };

  # slime extensions for ritz
  slime-ritz = buildEmacsPackage {
    name = "slime-ritz-0.6.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slime-ritz-0.6.0.el";
      sha256 = "0kf8113m7rvhpa4q9iil66y2pmayymg2kvxd82b784rjmk6dvpps";
    };
  
    deps = [  ];
  };

  # package for slough - this is for a secret TW thing
  slough = buildEmacsPackage {
    name = "slough-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/slough-0.1.el";
      sha256 = "1vj632pip29xbqrmwqr0mq83d8k404rpm1hh27w30k1w3byqh4bc";
    };
  
    deps = [ nrepl smartparens ];
  };

  # Semantic navigatioin
  smart-forward = buildEmacsPackage {
    name = "smart-forward-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smart-forward-1.0.0.el";
      sha256 = "15sz6p26qjlh60wlvd2bqp6sxfq7cw7y1hsa7qr5d519m64h6pz6";
    };
  
    deps = [ expand-region ];
  };

  # A color coded smart mode-line.
  smart-mode-line = buildEmacsPackage {
    name = "smart-mode-line-1.7.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smart-mode-line-1.7.1.el";
      sha256 = "0i7yafcmjqj7hr6ass07h7fmpl0xjfi5qqlzhdj9ymfmq6rsi4xz";
    };
  
    deps = [  ];
  };

  # Insert operators with surrounding spaces smartly
  smart-operator = buildEmacsPackage {
    name = "smart-operator-4.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/smart-operator-4.0.el";
      sha256 = "193hcs9gqmkspvf52q4z9x571cf8cirdkj0g2si6pwy84dmdrh6a";
    };
  
    deps = [  ];
  };

  # Intelligent tab completion and indentation.
  smart-tab = buildEmacsPackage {
    name = "smart-tab-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smart-tab-0.3.el";
      sha256 = "02n35v6z3jily4j0110xj2pk7nmjfcr3p9ccyzzl88dmgk1qvcp3";
    };
  
    deps = [  ];
  };

  # vim-like window controlling plugin
  smart-window = buildEmacsPackage {
    name = "smart-window-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smart-window-0.6.el";
      sha256 = "0sb6a3lgfkkqn6affvrpznll5df86x2i89zy0xrva1375zjxwjy0";
    };
  
    deps = [  ];
  };

  # a smarter wrapper for `compile'
  smarter-compile = buildEmacsPackage {
    name = "smarter-compile-2012.4.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smarter-compile-2012.4.9.el";
      sha256 = "1wak4sbgbq5la956c5z5a9n2l4i2k7y6dzcm0p28misnv6f968pp";
    };
  
    deps = [  ];
  };

  # Automatic insertion, wrapping and paredit-like navigation with user defined pairs.
  smartparens = buildEmacsPackage {
    name = "smartparens-1.4.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smartparens-1.4.4.tar";
      sha256 = "0d2qij50a7pdpz5mcl51bg92hwkkszr7a12ws1b4355nw2dq103s";
    };
  
    deps = [ dash ];
  };

  # Support sequential operation which omitted prefix keys.
  smartrep = buildEmacsPackage {
    name = "smartrep-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smartrep-0.0.3.el";
      sha256 = "0f1cg407sd7263ck41w0hc80jvb2rjvskpgj8cgscmy0nwg2dv78";
    };
  
    deps = [  ];
  };

  # M-x interface with Ido-style fuzzy matching.
  smex = buildEmacsPackage {
    name = "smex-2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smex-2.0.el";
      sha256 = "0kzcayrr5ms360n5why8lys23d67vp0rqkdk5ms9pgp75321sxda";
    };
  
    deps = [  ];
  };

  # Major mode for editing (Standard) ML
  sml-mode = buildEmacsPackage {
    name = "sml-mode-6.4";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/sml-mode-6.4.el";
      sha256 = "1yhwk1lq3zhh5bjx8ky7zvm3h9a6l1yzy5wsa7s86dn5a8ksqkl6";
    };
  
    deps = [  ];
  };

  # Show position in a scrollbar like way in mode-line
  sml-modeline = buildEmacsPackage {
    name = "sml-modeline-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sml-modeline-0.5.el";
      sha256 = "188djcjc90yrl36bj8fzpdjlkpn8a1yb1jb259mkgx8pcn928nfr";
    };
  
    deps = [  ];
  };

  # Minor mode for smooth scrolling and in-place scrolling.
  smooth-scroll = buildEmacsPackage {
    name = "smooth-scroll-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smooth-scroll-1.2.el";
      sha256 = "0mzm8bkspzdj54vh13fr7ky3i3j68kkbvc24v3kc4n2aqb3da1n0";
    };
  
    deps = [  ];
  };

  # Make emacs scroll smoothly
  smooth-scrolling = buildEmacsPackage {
    name = "smooth-scrolling-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/smooth-scrolling-1.0.1.el";
      sha256 = "01nx9mgb9im7y5v771qk86nn36ynclq636zfdr9qdpqgy0qhgd1d";
    };
  
    deps = [  ];
  };

  # Play the Sokoban game in emacs
  sokoban = buildEmacsPackage {
    name = "sokoban-1.23";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sokoban-1.23.el";
      sha256 = "0f72bfqwjwfhg1d4ri8cigm2hacmmdb7r4ll2fyspx450596y1ds";
    };
  
    deps = [  ];
  };

  # The Solarized color theme, ported to Emacs.
  solarized-theme = buildEmacsPackage {
    name = "solarized-theme-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/solarized-theme-1.0.0.tar";
      sha256 = "1ssqpfvm9c6qikhczphcafq7qqlml9dwh7pmbcbdc2daiqy6ksp3";
    };
  
    deps = [  ];
  };

  # a dark colorful theme for Emacs24.
  soothe-theme = buildEmacsPackage {
    name = "soothe-theme-0.3.16";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/soothe-theme-0.3.16.el";
      sha256 = "07q60qlmqpzdp5q9152g6rss01wyfzz9nqmqlyb2hwxjvr084sd5";
    };
  
    deps = [  ];
  };

  # Edit and interactively evaluate SPARQL queries.
  sparql-mode = buildEmacsPackage {
    name = "sparql-mode-0.6.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sparql-mode-0.6.1.el";
      sha256 = "085dhk00kp4ng561qhq6m5g0q85h83jw472fn3qgl64ic3nc64kw";
    };
  
    deps = [  ];
  };

  # minor mode for spell checking
  speck = buildEmacsPackage {
    name = "speck-2010.5.25";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/speck-2010.5.25.el";
      sha256 = "19i7bk19vvqkfsn7h8scng2wpmvll5vavh701d2azazfhkwxdv8g";
    };
  
    deps = [  ];
  };

  # Control the spotify application from emacs
  spotify = buildEmacsPackage {
    name = "spotify-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/spotify-0.2.el";
      sha256 = "1hhypwi8a2s1p97k3bk9vgj52ng03xsx7zi4agll7clvhklxk7sd";
    };
  
    deps = [  ];
  };

  # Major mode for dealing with sprint.ly
  sprintly-mode = buildEmacsPackage {
    name = "sprintly-mode-0.0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sprintly-mode-0.0.4.el";
      sha256 = "19h6vx7gmv49z5sxp79q2w65lvsc40l1kk09l1w8r1x9zpcc0231";
    };
  
    deps = [ furl ];
  };

  # indentation of SQL statements
  sql-indent = buildEmacsPackage {
    name = "sql-indent-1.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sql-indent-1.10.el";
      sha256 = "061hfybg3ybm7svsg21bdlgz9r9j90rfqj804b42hwjyqbf731n9";
    };
  
    deps = [  ];
  };

  # Same frame speedbar
  sr-speedbar = buildEmacsPackage {
    name = "sr-speedbar-0.1.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sr-speedbar-0.1.8.el";
      sha256 = "0fy5rv416glkfdydir39fqspvbwmi0gcxdfiap67l16437ccl3ca";
    };
  
    deps = [  ];
  };

  # Support for remote logins using ssh.
  ssh = buildEmacsPackage {
    name = "ssh-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ssh-1.2.el";
      sha256 = "1i9ccgk7k13rbz8rvwj1spz9qhpycmcnrj4p7h8xajx54rqjhgn7";
    };
  
    deps = [  ];
  };

  # Mode for fontification of ~/.ssh/config
  ssh-config-mode = buildEmacsPackage {
    name = "ssh-config-mode-1.13";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ssh-config-mode-1.13.el";
      sha256 = "172k36nwk5w0c0zj2g6xwgfw8h4vzg6czainndw5m52i28yx8dqs";
    };
  
    deps = [  ];
  };

  # Saner defaults and goodies.
  starter-kit = buildEmacsPackage {
    name = "starter-kit-2.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/starter-kit-2.0.3.tar";
      sha256 = "0dhnc57519n02zg91675d8pdfcah09cv90lbf4np7bzwzr8gb6ll";
    };
  
    deps = [ paredit idle-highlight-mode find-file-in-project smex ido-ubiquitous magit ];
  };

  # Saner defaults and goodies: bindings
  starter-kit-bindings = buildEmacsPackage {
    name = "starter-kit-bindings-2.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/starter-kit-bindings-2.0.2.el";
      sha256 = "16asvmv4886pb6489ij9z5sfivi6q1906bp6fyl7k8zhink9v35i";
    };
  
    deps = [ starter-kit ];
  };

  # Saner defaults and goodies: eshell tweaks
  starter-kit-eshell = buildEmacsPackage {
    name = "starter-kit-eshell-2.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/starter-kit-eshell-2.0.3.el";
      sha256 = "09cbyc7il2h6a9kwjbny5k36awcm7pzjjm2flhxvl1limyvzi8rm";
    };
  
    deps = [  ];
  };

  # Saner defaults and goodies for Javascript
  starter-kit-js = buildEmacsPackage {
    name = "starter-kit-js-2.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/starter-kit-js-2.0.1.el";
      sha256 = "0i82s0pdjp47s5a26yvyl88pjwmm39v71rxc6bgzwkyqvg9nx3qz";
    };
  
    deps = [ starter-kit ];
  };

  # Saner defaults and goodies for lisp languages
  starter-kit-lisp = buildEmacsPackage {
    name = "starter-kit-lisp-2.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/starter-kit-lisp-2.0.3.el";
      sha256 = "0gws8b5yla1s6k5p9m8ms8y12r14z1gnvdzwgss0c6nb2q8iijhg";
    };
  
    deps = [ starter-kit elisp-slime-nav ];
  };

  # Saner defaults and goodies for Ruby
  starter-kit-ruby = buildEmacsPackage {
    name = "starter-kit-ruby-2.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/starter-kit-ruby-2.0.3.el";
      sha256 = "0xn5k81chm61jjzvdj5irf4yypkaws08yijs90pxws7n3kz5zvij";
    };
  
    deps = [ inf-ruby starter-kit ];
  };

  # Avoid escape nightmares by editing string in separate buffer
  string-edit = buildEmacsPackage {
    name = "string-edit-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/string-edit-0.1.0.el";
      sha256 = "1a4ffcy9lg88qk2irfrzxmrjgcx3rpvwmvgln293gdmx03fpsavr";
    };
  
    deps = [ dash ];
  };

  # String-manipulation utilities
  string-utils = buildEmacsPackage {
    name = "string-utils-0.2.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/string-utils-0.2.8.el";
      sha256 = "17pbbgajcai62y6w61faz6vaygh60y8spk0k6f8k2g2vlzync2l2";
    };
  
    deps = [ list-utils ];
  };

  # Use a different background for even and odd lines
  stripe-buffer = buildEmacsPackage {
    name = "stripe-buffer-0.2.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/stripe-buffer-0.2.2.el";
      sha256 = "1br66sd6hbxysqha22bwby4jz4v6gs6ky3ygi0bj3f9vlm83hvg3";
    };
  
    deps = [ cl-lib ];
  };

  # Major mode for editing stylus templates.
  stylus-mode = buildEmacsPackage {
    name = "stylus-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/stylus-mode-0.1.el";
      sha256 = "0gx5ilx22xp6lkgx0yridyc5xxd02z693birrxk7b7psqwxpyq6a";
    };
  
    deps = [  ];
  };

  # Nice looking emacs 24 theme
  subatomic-enhanced-theme = buildEmacsPackage {
    name = "subatomic-enhanced-theme-20130226.2229";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/subatomic-enhanced-theme-20130226.2229.el";
      sha256 = "0wi4dzbchysf151wd8qab42yirm3r4ybz9878cqw91h509hnfj75";
    };
  
    deps = [  ];
  };

  # REQUIRES EMACS 24 - Sublime Text 2 Emulation for Emacs
  sublime = buildEmacsPackage {
    name = "sublime-0.0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sublime-0.0.7.tar";
      sha256 = "089sfcrv2fxygm3sj2qzv1pf7m83sckn18llxn3ad0mlgbqj1ccs";
    };
  
    deps = [ coffee-mode find-file-in-project haml-mode ido-ubiquitous less-css-mode magit markdown-mode monokai-theme paredit sass-mode smex yaml-mode yasnippet ];
  };

  # Functions for working with comints
  subshell-proc = buildEmacsPackage {
    name = "subshell-proc-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/subshell-proc-0.2.el";
      sha256 = "1j9w4bil93bb3rjj8s90zsaw64mf61l1f30jipd7yfcyfw4mr45s";
    };
  
    deps = [  ];
  };

  # Totsuzen-no-Shi
  sudden-death = buildEmacsPackage {
    name = "sudden-death-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sudden-death-0.2.el";
      sha256 = "1nqfdfj004yl92ivbf9mcyvqccn4prlqhcg31w5spr9zpj16cv02";
    };
  
    deps = [  ];
  };

  # Provides Sumatra Forward search
  sumatra-forward = buildEmacsPackage {
    name = "sumatra-forward-2008.10.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sumatra-forward-2008.10.8.el";
      sha256 = "1hxlb5q7vyshl5c59lfsw0nvq0x1yiaq8xzd2hhnlag4yxijvs0p";
    };
  
    deps = [  ];
  };

  # Finnish national and Christian holidays for calendar
  suomalainen-kalenteri = buildEmacsPackage {
    name = "suomalainen-kalenteri-2013.4.18";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/suomalainen-kalenteri-2013.4.18.tar";
      sha256 = "14d2xifhpngj7k7y5vl13xq6jrjc1lm320c6galiafrs031zc86k";
    };
  
    deps = [  ];
  };

  # SuperGenPass for Emacs
  supergenpass = buildEmacsPackage {
    name = "supergenpass-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/supergenpass-0.1.el";
      sha256 = "0qvhryj93jrzdlqkx55i17sj9yl66fqr1msvbcp1ncdcrc777ifa";
    };
  
    deps = [  ];
  };

  # emulate surround.vim from Vim
  surround = buildEmacsPackage {
    name = "surround-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/surround-0.1.el";
      sha256 = "0iwnkhyiw2pqggi5j975lsxy52kica5n6k43dgh82y95lv9yr644";
    };
  
    deps = [  ];
  };

  # Analog clock using Scalable Vector Graphics
  svg-clock = buildEmacsPackage {
    name = "svg-clock-0.4";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/svg-clock-0.4.el";
      sha256 = "1b25b68idiw30xcbqpnk2az6n8mc19hw8pjh4ga684wiz50340xq";
    };
  
    deps = [  ];
  };

  # swank-cdt helper functions
  swank-cdt = buildEmacsPackage {
    name = "swank-cdt-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/swank-cdt-1.0.1.el";
      sha256 = "01s47jzx7mqyqxzsn57hn6msc66vhrkz1i9vcysbh3aw6g1dpy5g";
    };
  
    deps = [  ];
  };

  # simple swarm chat
  swarmhacker = buildEmacsPackage {
    name = "swarmhacker-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/swarmhacker-0.0.1.el";
      sha256 = "17wgz932yb84mby62c5ks896h87k7sn03qyicizrh1gz85mmy7q3";
    };
  
    deps = [  ];
  };

  # A *visual* way to choose a window to switch to
  switch-window = buildEmacsPackage {
    name = "switch-window-0.9";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/switch-window-0.9.el";
      sha256 = "0j8n2ic98mysh3avcr4bb6hnckb7j6ggi0w3s620rwwxrjrjrcqr";
    };
  
    deps = [  ];
  };

  # SWS mode
  sws-mode = buildEmacsPackage {
    name = "sws-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/sws-mode-0.1.el";
      sha256 = "1hfjcgkzznkwf6vir34lrnq0fx37dipw9i54k4djcddxcl07p3ll";
    };
  
    deps = [  ];
  };

  # List symbols of object files
  symbols-mode = buildEmacsPackage {
    name = "symbols-mode-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/symbols-mode-0.3.el";
      sha256 = "1xpcsdkjjrz82hk8yx5k97lwaxfrk6z120jji533y08sd3s09iwk";
    };
  
    deps = [  ];
  };

  # Look up synonyms for a word or phrase in a thesaurus.
  synonyms = buildEmacsPackage {
    name = "synonyms-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/synonyms-1.0.el";
      sha256 = "1zfygb585vzrqk8bcdzdr4d839yj5qqyry0f3rs2r3m996yv019g";
    };
  
    deps = [  ];
  };

  # Effect-free forms such as if/then/else
  syntactic-sugar = buildEmacsPackage {
    name = "syntactic-sugar-0.9.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/syntactic-sugar-0.9.2.el";
      sha256 = "0r5mpq9agpbmy8ic0jp7xbmc1bzlkyiy0nwgikncmsb93am3656j";
    };
  
    deps = [  ];
  };

  # A mode for SystemTap
  systemtap-mode = buildEmacsPackage {
    name = "systemtap-mode-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/systemtap-mode-0.2.el";
      sha256 = "1spng8kfawzbjvmlvrlsi3xfx4nyknn3ipfbk3qlj3qqwkh77lbf";
    };
  
    deps = [  ];
  };

  # Tagged non-deterministic finite-state automata
  tNFA = buildEmacsPackage {
    name = "tNFA-0.1.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/tNFA-0.1.1.el";
      sha256 = "01n4p8lg8f2k55l2z77razb2sl202qisjqm5lff96a2kxnxinsds";
    };
  
    deps = [ queue ];
  };

  # Display a tab bar in the header line  -*-no-byte-compile: t; -*-
  tabbar = buildEmacsPackage {
    name = "tabbar-2.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tabbar-2.0.1.el";
      sha256 = "09dzk2xx45jzvk1bkvcwbijv1yhypch85h9ndvsx1jinghd0ln1w";
    };
  
    deps = [  ];
  };

  # Pretty tabbar, autohide, use both tabbar/ruler
  tabbar-ruler = buildEmacsPackage {
    name = "tabbar-ruler-0.36";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tabbar-ruler-0.36.el";
      sha256 = "1mxygx246r14v3v95iy09j7w9vypiv3a3ifhh22g8m2n8k1s9r2l";
    };
  
    deps = [ tabbar ];
  };

  # Use second tab key pressed for what you want
  tabkey2 = buildEmacsPackage {
    name = "tabkey2-1.40";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tabkey2-1.40.el";
      sha256 = "0bbr09hhaj8vznwmg4ap7d7in3gf527hghgrilxcjgaqw3ydbn62";
    };
  
    deps = [  ];
  };

  # Distraction free writing mode
  tabula-rasa-mode = buildEmacsPackage {
    name = "tabula-rasa-mode-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tabula-rasa-mode-0.1.0.el";
      sha256 = "1aqmwwn2ssjpvlfv3sff0ldx0xb3rnlqmwr6wxaky4bn2x615bj9";
    };
  
    deps = [  ];
  };

  # generic major mode for tabulated lists.
  tabulated-list = buildEmacsPackage {
    name = "tabulated-list-0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tabulated-list-0.el";
      sha256 = "1yh322wsskz95lybrq21gc4qryqb98dcxgdq1slm9w4dm4d978g8";
    };
  
    deps = [  ];
  };

  # Some paredit-like features for html-mode
  tagedit = buildEmacsPackage {
    name = "tagedit-1.4.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tagedit-1.4.0.el";
      sha256 = "1586fij14rkyr2mqh9yiazsrgz1a8756n0kasrnabfifmd7bhrvj";
    };
  
    deps = [ s dash ];
  };

  # Tango 2 color theme for GNU Emacs 24
  tango-2-theme = buildEmacsPackage {
    name = "tango-2-theme-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tango-2-theme-1.0.0.el";
      sha256 = "1vxbvi05w4amax3a6jjqfm5g82lv9xnkhjbzv3scpyixwap7fgdd";
    };
  
    deps = [  ];
  };

  # unit test front-end
  test-case-mode = buildEmacsPackage {
    name = "test-case-mode-0.1.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/test-case-mode-0.1.8.el";
      sha256 = "0567lkyb6ss1dkdf3mgj4d2h13mcv6yx1lb2dnnc9hgsz48zkmf9";
    };
  
    deps = [  ];
  };

  # Smart umlaut conversion for TeX.
  tex-smart-umlauts = buildEmacsPackage {
    name = "tex-smart-umlauts-1.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tex-smart-umlauts-1.1.0.el";
      sha256 = "0lngq7vqrpqrzyfbk04hi496zps8gikx7zw8dlxijkb29jnjwl28";
    };
  
    deps = [  ];
  };

  # tracking, setting, guessing language of text
  text-language = buildEmacsPackage {
    name = "text-language-0.20121008";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/text-language-0.20121008.el";
      sha256 = "0r6scnza8z9822lss06nhq9yb3sf38vrcm0rkqbr7x7wv5vsjim2";
    };
  
    deps = [  ];
  };

  # TextMate minor mode for Emacs
  textmate = buildEmacsPackage {
    name = "textmate-5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/textmate-5.el";
      sha256 = "1ll80y1j33n5ymp83vbzgcq4rvr0jlzqcdrjw4wym8zzq0llfgg8";
    };
  
    deps = [  ];
  };

  # Import Textmate macros into yasnippet syntax
  textmate-to-yas = buildEmacsPackage {
    name = "textmate-to-yas-0.21";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/textmate-to-yas-0.21.el";
      sha256 = "0241ydn4scals8wy566bhx3fxn4yvh3z0vp3g0vwmwxznhxmcz5q";
    };
  
    deps = [  ];
  };

  # MS Team Foundation Server commands for Emacs.
  tfs = buildEmacsPackage {
    name = "tfs-0.2.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tfs-0.2.7.el";
      sha256 = "1yi1sz02i126hylwmz5i778maf65j12vnvql0lx6mxwmwzmd26c8";
    };
  
    deps = [  ];
  };

  # Sunrise/Sunset Theme Changer for Emacs
  theme-changer = buildEmacsPackage {
    name = "theme-changer-2.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/theme-changer-2.0.0.el";
      sha256 = "0n93ms885c44jjyg26gm0b5if6955474wv7rymf5cnsrbffvhp4s";
    };
  
    deps = [  ];
  };

  # Take your themes for a ride!
  theme-park-mode = buildEmacsPackage {
    name = "theme-park-mode-0.1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/theme-park-mode-0.1.2.el";
      sha256 = "1mg3a4dn8ynxycd0jvv5kj7kkhj61xlcc2malm0hg6hd4g4sy71g";
    };
  
    deps = [  ];
  };

  # replace a word with a synonym looked up in a web service.
  thesaurus = buildEmacsPackage {
    name = "thesaurus-2012.4.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/thesaurus-2012.4.7.el";
      sha256 = "1v5jlvhpjycz33vkz5xnc6b4riamw3s5kqjmxlzf48ipz27sry2s";
    };
  
    deps = [  ];
  };

  # java thread dump viewer
  thread-dump = buildEmacsPackage {
    name = "thread-dump-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/thread-dump-1.0.el";
      sha256 = "1hz0flyg9d3ckxbjpbd56ag405rf2ajwa3k9cnx96hyhq9jy90nk";
    };
  
    deps = [  ];
  };

  # Plain text reader of HTML documents
  thumb-through = buildEmacsPackage {
    name = "thumb-through-0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/thumb-through-0.3.el";
      sha256 = "0vx8nm8xpxrb3inbky1gvcb0avw0ckwfpdm8i214vpih66mvawbv";
    };
  
    deps = [  ];
  };

  # Interface to the HTML Tidy program
  tidy = buildEmacsPackage {
    name = "tidy-2.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tidy-2.12.el";
      sha256 = "1kqhfq8r0ak0rqhm06f5059c9jrf069j0n9zppzcmz1scixljnn6";
    };
  
    deps = [  ];
  };

  # Mayor mode for editing tintin++ scripts
  tintin-mode = buildEmacsPackage {
    name = "tintin-mode-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tintin-mode-1.0.0.el";
      sha256 = "0vhnc7snzpvyw2crm97yzwsswl8ay4drz4hgylm46b9w7lsflgdm";
    };
  
    deps = [  ];
  };

  # A major mode for editing todo.txt files
  todotxt = buildEmacsPackage {
    name = "todotxt-0.2.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/todotxt-0.2.3.el";
      sha256 = "00ir4r3v07qp1ask6hg4llf7kk8dmyfg17hyknyk4clarmasa7x2";
    };
  
    deps = [  ];
  };

  # Mojor mode for editing TOML files
  toml-mode = buildEmacsPackage {
    name = "toml-mode-0.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/toml-mode-0.1.3.el";
      sha256 = "0rk1wijk16f7aa46q8m7723x1v37ki740r4wy8imidih1w56kmxq";
    };
  
    deps = [  ];
  };

  # REQUIRES EMACS 24
  toxi-theme = buildEmacsPackage {
    name = "toxi-theme-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/toxi-theme-0.1.0.el";
      sha256 = "16iks5vs65khkqa27f9iwh395ndgqf0v7jrj48gl7xn6jkyb01nf";
    };
  
    deps = [  ];
  };

  # Keep track of recently closed files
  track-closed-files = buildEmacsPackage {
    name = "track-closed-files-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/track-closed-files-0.1.el";
      sha256 = "0hfw3i9ik7pdm7wc4k4hp9nnc1ndbs3mzb7w5zhw8qq70xkzv2p1";
    };
  
    deps = [  ];
  };

  # Buffer modification tracking
  tracking = buildEmacsPackage {
    name = "tracking-1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tracking-1.3.el";
      sha256 = "00sj6r4xl586lcbxpkkz6q973xj499zkrc4mlzxd4l0gmvxmyhar";
    };
  
    deps = [ shorten ];
  };

  # Trie data structure
  trie = buildEmacsPackage {
    name = "trie-0.2.6";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/trie-0.2.6.el";
      sha256 = "1q3i1dhq55c3b1hqpvmh924vzvhrgyp76hr1ci7bhjqvjmjx24ii";
    };
  
    deps = [ tNFA heap ];
  };

  # A theme loosely based on Tron: Legacy colors
  tron-theme = buildEmacsPackage {
    name = "tron-theme-12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tron-theme-12.el";
      sha256 = "1df1vslxyrpwksy82c8iwr5y5pp87kgqv7g7v32634ysscy20l5z";
    };
  
    deps = [  ];
  };

  # Test the content of a value
  truthy = buildEmacsPackage {
    name = "truthy-0.2.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/truthy-0.2.6.el";
      sha256 = "14m7sgm7vnpdvq0b041z84r3ygjnyvsmpk20y3zb9bl2dh4a4w1l";
    };
  
    deps = [ list-utils ];
  };

  # Emacs major mode for editing Template Toolkit files.
  tt-mode = buildEmacsPackage {
    name = "tt-mode-20121117.2045";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tt-mode-20121117.2045.tar";
      sha256 = "1ckimnrnyji31cp8djqmb8xq7p0nx8r3hgqab8hmdvjsdihrz9qz";
    };
  
    deps = [  ];
  };

  # mode for Turtle(RDF)
  ttl-mode = buildEmacsPackage {
    name = "ttl-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ttl-mode-0.1.el";
      sha256 = "0vzzphkirhb7zvv1mg0vks8q77b6xpkqqxzqjflg5q0d5xhky539";
    };
  
    deps = [  ];
  };

  # Tiny Tiny RSS elisp bindings
  ttrss = buildEmacsPackage {
    name = "ttrss-1.7.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ttrss-1.7.5.el";
      sha256 = "0n2pg3giakalkc6d75rarfvyblpykn2an6mkn69fvgx3i157v67j";
    };
  
    deps = [  ];
  };

  # OCaml mode for Emacs.
  tuareg = buildEmacsPackage {
    name = "tuareg-2.0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tuareg-2.0.5.tar";
      sha256 = "0mhxqmmilhlxbjzn5san0fcbl6xv1az80zl795p291j8nknvh2sb";
    };
  
    deps = [ caml ];
  };

  # an Tumblr mode for Emacs
  tumble = buildEmacsPackage {
    name = "tumble-1.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tumble-1.5.el";
      sha256 = "0v3jcp4wk3dycpdz51aj4saz89fqcjpcjb59q8mc652gj3pzbakd";
    };
  
    deps = [  ];
  };

  # An Emacs tumblr client.
  tumblesocks = buildEmacsPackage {
    name = "tumblesocks-0.0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tumblesocks-0.0.6.tar";
      sha256 = "0dkbxbxl6z84y5wbhjm8khjfffrz6b886nx1phw09lfldi2y413a";
    };
  
    deps = [ htmlize oauth markdown-mode ];
  };

  # Major mode for editing files for Tup
  tup-mode = buildEmacsPackage {
    name = "tup-mode-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tup-mode-1.2.el";
      sha256 = "0jxm35la40d080yi9mph4c3cp18xzgvw3q3gmgpqiqssf1dm5lzh";
    };
  
    deps = [  ];
  };

  # Twilight theme for GNU Emacs 24 (deftheme)
  twilight-theme = buildEmacsPackage {
    name = "twilight-theme-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/twilight-theme-1.0.0.el";
      sha256 = "1wk2lvdzjn4l5kmaprg21qm4mbhkqb6zn3iy95qgxr0yp9i70c57";
    };
  
    deps = [  ];
  };

  # Major mode for Twitter
  twittering-mode = buildEmacsPackage {
    name = "twittering-mode-2.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/twittering-mode-2.0.0.el";
      sha256 = "02b66i53b24i8gfpk6c5k6ifw41gifbzsj3932g3day108mdq151";
    };
  
    deps = [  ];
  };

  # A game for fast typers, inspired by The Typing Of The Dead.
  typing = buildEmacsPackage {
    name = "typing-1.1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/typing-1.1.4.el";
      sha256 = "1yr0kc9jg96g82bdlnsdlsg4ymf6q3nklchgbg7asmdbhnwhzng4";
    };
  
    deps = [  ];
  };

  # Typing practice
  typing-practice = buildEmacsPackage {
    name = "typing-practice-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/typing-practice-0.1.el";
      sha256 = "0kff8g8ds7hy6hxygn3vnjhg88l08894h57lxpms2sjzg118wp8g";
    };
  
    deps = [  ];
  };

  # Minor mode for typographic editing
  typo = buildEmacsPackage {
    name = "typo-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/typo-1.1.el";
      sha256 = "0s9k8cb3vgbd7670kzkr0bn30skk2sdl3rdz2wsshfvrgmdn6214";
    };
  
    deps = [  ];
  };

  # Automatic typographical punctuation marks
  typopunct = buildEmacsPackage {
    name = "typopunct-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/typopunct-1.0.el";
      sha256 = "0gr67g1isyw4cp0j0srir26chgaqn5w1v2pry3ig06x5h2z0f74x";
    };
  
    deps = [  ];
  };

  # Major mode for UCI configuration files
  uci-mode = buildEmacsPackage {
    name = "uci-mode-1.0.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/uci-mode-1.0.0.el";
      sha256 = "1c2hn56nrfcwiwv4v9km9gadx3praz204vr9njswwqr69kq07wp5";
    };
  
    deps = [  ];
  };

  # Utilities for Unicode characters
  ucs-utils = buildEmacsPackage {
    name = "ucs-utils-0.7.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ucs-utils-0.7.2.el";
      sha256 = "06prg7i2h9pw3vvbnmga8qy875rbjy77ycim86yfsj8m1h34d6hg";
    };
  
    deps = [ persistent-soft pcache ];
  };

  # Ujelly theme for GNU Emacs 24 (deftheme)
  ujelly-theme = buildEmacsPackage {
    name = "ujelly-theme-1.0.20";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ujelly-theme-1.0.20.el";
      sha256 = "0yz7v1gjkz4j5fbk29fqv6mx1wcaw2dscd8yr3abi88a3jk4qpv6";
    };
  
    deps = [  ];
  };

  # find convenient unbound keystrokes
  unbound = buildEmacsPackage {
    name = "unbound-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/unbound-0.1.el";
      sha256 = "0x0dhlqjw8bkz364rmmk9ls9and3gam6n4fn84yj8ql4i4y6afan";
    };
  
    deps = [  ];
  };

  # Treat undo history as a tree
  undo-tree = buildEmacsPackage {
    name = "undo-tree-0.6.3";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/undo-tree-0.6.3.el";
      sha256 = "0wddqdxym5kzrrkvbrg851ibp5bx183ll9vvxn1i0zbbihji7pai";
    };
  
    deps = [  ];
  };

  # The inverse of fill-paragraph and fill-region
  unfill = buildEmacsPackage {
    name = "unfill-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/unfill-0.1.el";
      sha256 = "1yq44462pm7abrm8hs6ybpwmlh1xx0qa71zmvav97xz7jj036xc5";
    };
  
    deps = [  ];
  };

  # Unicode confusables table
  uni-confusables = buildEmacsPackage {
    name = "uni-confusables-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/uni-confusables-0.1.tar";
      sha256 = "0s3scvzhd4bggk0qafcspf97cmcvdw3w8bbf5ark4p22knvg80zp";
    };
  
    deps = [  ];
  };

  # Surround a string with box-drawing characters
  unicode-enbox = buildEmacsPackage {
    name = "unicode-enbox-0.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/unicode-enbox-0.1.3.el";
      sha256 = "1lkvqx1l65xybv3lgyhcvf55wjd5680fyqxshwxswp9wx9bv63qk";
    };
  
    deps = [ string-utils ucs-utils persistent-soft pcache ];
  };

  # Configure Unicode fonts
  unicode-fonts = buildEmacsPackage {
    name = "unicode-fonts-0.3.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/unicode-fonts-0.3.4.el";
      sha256 = "17wahph0y621qs859x8k9j9ni2lx2j6q0lzhk8jb05ki4716vhnm";
    };
  
    deps = [ font-utils ucs-utils persistent-soft pcache ];
  };

  # Progress-reporter with fancy characters
  unicode-progress-reporter = buildEmacsPackage {
    name = "unicode-progress-reporter-0.5.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/unicode-progress-reporter-0.5.3.el";
      sha256 = "036ks5j25i5d7xp1phh3nvrwacxxzknhixg3jwrsw68fryvng949";
    };
  
    deps = [  ucs-utils persistent-soft pcache ];
  };

  # teach whitespace-mode about fancy characters
  unicode-whitespace = buildEmacsPackage {
    name = "unicode-whitespace-0.2.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/unicode-whitespace-0.2.3.el";
      sha256 = "0ki1k86ypwxfsgidp87ymnxg07mfvmvdv80jbz7mj1pr0jslg0z5";
    };
  
    deps = [ ucs-utils persistent-soft pcache ];
  };

  # UUID's for EmacsLisp
  uuid = buildEmacsPackage {
    name = "uuid-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/uuid-0.0.3.el";
      sha256 = "0k2d5rjvvzji121cb88vqq76qzgzdd4yhv7c9y6cigdws24m5525";
    };
  
    deps = [  ];
  };

  # Vala mode derived mode
  vala-mode = buildEmacsPackage {
    name = "vala-mode-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vala-mode-0.1.el";
      sha256 = "162psmlidvf3nlk7i6im4gx3ra8vwnnxcvpa2rl81bv9yvz67272";
    };
  
    deps = [  ];
  };

  # a VC backend for darcs
  vc-darcs = buildEmacsPackage {
    name = "vc-darcs-1.12";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vc-darcs-1.12.el";
      sha256 = "1nwi17x6a7wag77m9r7cy5n6h9bbc1fczlxlq9ljnmh94slhpz6f";
    };
  
    deps = [  ];
  };

  # vcard parsing and display routines
  vcard = buildEmacsPackage {
    name = "vcard-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vcard-0.1.el";
      sha256 = "1igm8al1p4f82dq3fbr42ny6f970yv5ma2ma6qf46p8mnk1br475";
    };
  
    deps = [  ];
  };

  # Vector-manipulation utility functions
  vector-utils = buildEmacsPackage {
    name = "vector-utils-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vector-utils-0.1.0.el";
      sha256 = "0rfm4sxd0m5r3z44kswkjq6y6m4kyjynisamhgh5gqqbkdj6h3ag";
    };
  
    deps = [  ];
  };

  # Vertica SQL mode extension
  vertica = buildEmacsPackage {
    name = "vertica-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vertica-0.1.0.el";
      sha256 = "1clm122gjbwn75fgmqd44fcr6q5mcazr70znfsffjzmbjzb1kjx0";
    };
  
    deps = [ sql ];
  };

  # VimGolf interface for the One True Editor
  vimgolf = buildEmacsPackage {
    name = "vimgolf-0.9.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vimgolf-0.9.2.el";
      sha256 = "1nwjhw8m7jh265bb9xvmpdn0pjkk5ppw4pkc6ci59zf231qbrapf";
    };
  
    deps = [  ];
  };

  # Major mode for vimrc files
  vimrc-mode = buildEmacsPackage {
    name = "vimrc-mode-0.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vimrc-mode-0.3.1.el";
      sha256 = "1fs8r3nhq3vhd3xfkc3h2bmh6i50jdzvnxq5d92iaiwcpr83qxld";
    };
  
    deps = [  ];
  };

  # Virtualenv for Python  -*- coding: utf-8 -*-
  virtualenv = buildEmacsPackage {
    name = "virtualenv-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/virtualenv-1.2.el";
      sha256 = "0ahz99q1qhzvxk44pj2i5rbd16bxqad0s1wffn942x65ajp57lcx";
    };
  
    deps = [  ];
  };

  # color code strings in current buffer, this elisp show you one as real color.
  visible-color-code = buildEmacsPackage {
    name = "visible-color-code-0.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/visible-color-code-0.0.1.el";
      sha256 = "1gdp7l4x38gb4354bj1f3xl9qd21xkljh2571gljx566ynk2alca";
    };
  
    deps = [  ];
  };

  # View Large Files
  vlf = buildEmacsPackage {
    name = "vlf-0.2";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/vlf-0.2.el";
      sha256 = "0drfsqbs74amzfyv4ygbfmf9s0dsmbhjhbmjmlc665l0a7dm1zhl";
    };
  
    deps = [  ];
  };

  # show vertical line (column highlighting) mode.
  vline = buildEmacsPackage {
    name = "vline-1.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/vline-1.10.el";
      sha256 = "0znyhrbrsdvcil5g8v1fsk2v5rlgnlirrn2pj1pw4f18yzy8grfl";
    };
  
    deps = [  ];
  };

  # Minor mode for visual feedback on some operations.
  volatile-highlights = buildEmacsPackage {
    name = "volatile-highlights-1.10";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/volatile-highlights-1.10.el";
      sha256 = "1hdn6l36c1mg352d798y2982m37k4xg0q1ifdfzz6r9jn2r7n404";
    };
  
    deps = [  ];
  };

  # Run Windows application associated with a file.
  w32-browser = buildEmacsPackage {
    name = "w32-browser-21.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/w32-browser-21.0.el";
      sha256 = "1204rqrxlykpi6y6gyvdwf5ycv419i03716hys6r1jac9qi6kz4l";
    };
  
    deps = [  ];
  };

  # read the registry from elisp
  w32-registry = buildEmacsPackage {
    name = "w32-registry-2012.4.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/w32-registry-2012.4.6.el";
      sha256 = "167j975a4smhppgvniqa54s9d3hgfv2rg2xj504zj2b574g2fcph";
    };
  
    deps = [  ];
  };

  # The WACky WorkSPACE manager for emACS
  wacspace = buildEmacsPackage {
    name = "wacspace-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wacspace-0.4.el";
      sha256 = "19bp167x7cwpfyq089h7srb46sd55lxc0arjg782a8i4l74f2vyk";
    };
  
    deps = [ dash cl-lib ];
  };

  # run a shell command when saving a buffer
  watch-buffer = buildEmacsPackage {
    name = "watch-buffer-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/watch-buffer-1.0.1.el";
      sha256 = "1j5wsbhqp2k3nq9nwv58p5zbgvbhswxsls18c0jlqfhyliv3pmr7";
    };
  
    deps = [  ];
  };

  # Running word count with goals (minor mode)
  wc-mode = buildEmacsPackage {
    name = "wc-mode-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wc-mode-1.1.el";
      sha256 = "0h7lipcnx3xnwpq4885cy7l288gncz22j1xd19qkabdgay8abk6j";
    };
  
    deps = [  ];
  };

  # General interface for text checkers
  wcheck-mode = buildEmacsPackage {
    name = "wcheck-mode-2013.6.13";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wcheck-mode-2013.6.13.tar";
      sha256 = "1q13gxc6c10vgl30021w97na1lg5b6d2spx89m58dnmdxx8mbrzd";
    };
  
    deps = [  ];
  };

  # Get weather reports via worldweatheronline.com
  weather = buildEmacsPackage {
    name = "weather-2012.3.27.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/weather-2012.3.27.2.el";
      sha256 = "035w2pmnq4z9l4n0mmnys5qx8c9yai6yv2mj3wxdsqgspzxibyff";
    };
  
    deps = [  ];
  };

  # Weather data from met.no in Emacs
  weather-metno = buildEmacsPackage {
    name = "weather-metno-20121023";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/weather-metno-20121023.tar";
      sha256 = "1fi3w1np5rss7pqbdn7bvgr1f96384i2pcv6gaqn2dx5wqcx0wsm";
    };
  
    deps = [  ];
  };

  # useful HTTP client -*- lexical-binding: t -*-
  web = buildEmacsPackage {
    name = "web-0.3.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/web-0.3.7.el";
      sha256 = "04q8gz2l2f1ydy5swinr2g5a39fs14ffbmkk9aazrvckzbbp5s84";
    };
  
    deps = [  ];
  };

  # Emacs WebSocket client and server
  websocket = buildEmacsPackage {
    name = "websocket-1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/websocket-1.0.el";
      sha256 = "1apjiaxf9007aarbcdz31b4vwl21rsacqc462cr4q6f09849b090";
    };
  
    deps = [  ];
  };

  # Chat via WeeChat's relay protocol in Emacs
  weechat = buildEmacsPackage {
    name = "weechat-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/weechat-0.2.tar";
      sha256 = "1lg31mx6yqrkn2qinp2n36bs6bkb9jq49fvpj7d8zapvw6ar99i8";
    };
  
    deps = [ s cl-lib  tracking ];
  };

  # Emacs-wget is an interface program of GNU wget on Emacs.
  wget = buildEmacsPackage {
    name = "wget-1.94";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wget-1.94.tar";
      sha256 = "1hq318bpxkklr5s1vyly4f7rmfgv9yq6kvsgy1nwyws0pw7r8bar";
    };
  
    deps = [  ];
  };

  # Writable grep buffer and apply the changes to files
  wgrep = buildEmacsPackage {
    name = "wgrep-2.1.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wgrep-2.1.3.el";
      sha256 = "10pk7r6bjifz4gjf2zm16i46451rg9c3sf4bdi4c75jxq42qrlmh";
    };
  
    deps = [  ];
  };

  # Writable ack-and-a-half buffer and apply the changes to files
  wgrep-ack = buildEmacsPackage {
    name = "wgrep-ack-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wgrep-ack-0.1.1.el";
      sha256 = "1h5w52hhd6z91lg25zvwry23nn7knc8jxiv267l9a3nmgw8gdajq";
    };
  
    deps = [ wgrep ];
  };

  # Writable helm-grep-mode buffer and apply the changes to files
  wgrep-helm = buildEmacsPackage {
    name = "wgrep-helm-0.1.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wgrep-helm-0.1.0.el";
      sha256 = "1kxv99cvdlxvyyc287f6cvb9rwx2qwbbbxd8rb6gkhjgq9jdqrav";
    };
  
    deps = [ wgrep ];
  };

  # operate on current line if region undefined
  whole-line-or-region = buildEmacsPackage {
    name = "whole-line-or-region-1.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/whole-line-or-region-1.3.1.el";
      sha256 = "0354p1ckxgdapiwn9bd5pp5bzwrlqba8zca1k5vnsb94ayhk6q2f";
    };
  
    deps = [  ];
  };

  # Simple file navigation using [[WikiStrings]]
  wiki-nav = buildEmacsPackage {
    name = "wiki-nav-0.6.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wiki-nav-0.6.4.el";
      sha256 = "18mgz6l3p1naijixpjfzxzhch23fxnxb9xfwf5ixzw5x0rm4yqkl";
    };
  
    deps = [ button-lock nav-flash ];
  };

  # use elisp doc strings to make other documentation
  wikidoc = buildEmacsPackage {
    name = "wikidoc-0.8.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wikidoc-0.8.1.el";
      sha256 = "1fbkcq6wlz086ngkraq3ak17kr9wd4y3nbqf9m1vhz30d0wvn239";
    };
  
    deps = [  ];
  };

  # fast, dynamic bindings for window-switching/resizing
  win-switch = buildEmacsPackage {
    name = "win-switch-1.0.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/win-switch-1.0.8.el";
      sha256 = "1jn9pd46fhlicnrw85wg2qiyp9iybf50x45q9xdwvad3p3x1ngxn";
    };
  
    deps = [  ];
  };

  # Find the last visible point in a window
  window-end-visible = buildEmacsPackage {
    name = "window-end-visible-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/window-end-visible-0.0.3.el";
      sha256 = "08w9kc9293j3r0splk7683cv1s9fd1afxfadhgv70fsczmcv6p73";
    };
  
    deps = [  ];
  };

  # Jump to a window by number
  window-number = buildEmacsPackage {
    name = "window-number-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/window-number-1.0.1.el";
      sha256 = "18xibzn6cg1m2ii21a31xxwvh8h2051vvnrnvmqf643scc65mq86";
    };
  
    deps = [  ];
  };

  # Resize windows interactively
  windresize = buildEmacsPackage {
    name = "windresize-0.1";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/windresize-0.1.el";
      sha256 = "0b5bfs686nkp7s05zgfqvr1mpagmkd74j1grq8kp2w9arj0qfi3x";
    };
  
    deps = [  ];
  };

  # Simple, intuitive window resizing
  windsize = buildEmacsPackage {
    name = "windsize-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/windsize-0.1.el";
      sha256 = "1gbws13cc78hz34gbh8x0q2lpn3h1n61xnkysq06cxrcwaym68sv";
    };
  
    deps = [  ];
  };

  # Remember buffer positions per-window, not per buffer
  winpoint = buildEmacsPackage {
    name = "winpoint-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/winpoint-1.4.el";
      sha256 = "018ja6kp5lghq1qflw7d70nqn56hy3k4rb155nmy4v2qfwrcjhij";
    };
  
    deps = [  ];
  };

  # Poor-man's namespaces for elisp
  with-namespace = buildEmacsPackage {
    name = "with-namespace-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/with-namespace-1.1.el";
      sha256 = "0h510c64fw22c5bannspk98l43m6g5kb0y3qxmb8mh4s3h7f9lz6";
    };
  
    deps = [  ];
  };

  # workgroups for windows (for Emacs)
  workgroups = buildEmacsPackage {
    name = "workgroups-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/workgroups-0.2.0.el";
      sha256 = "1ayc5ysl9v52hshvqwpsqm1g1r9z23vyizbqm76qpb38czjlb6gd";
    };
  
    deps = [  ];
  };

  # Workspaces for Emacsen 
  workspaces = buildEmacsPackage {
    name = "workspaces-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/workspaces-0.1.el";
      sha256 = "19gw1xc66hp5aqk934rkxs43w04h6js9iaj411870138n00z0mbs";
    };
  
    deps = [  ];
  };

  # show whole days of world-time diffs
  world-time-mode = buildEmacsPackage {
    name = "world-time-mode-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/world-time-mode-0.0.2.el";
      sha256 = "1dz7fyf4kdjgcswxq6bwnqw04240jdr5p6hmyhm2zf6wma53kaj5";
    };
  
    deps = [  ];
  };

  # Wrap text with punctation or tag
  wrap-region = buildEmacsPackage {
    name = "wrap-region-0.7.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wrap-region-0.7.1.el";
      sha256 = "0yyvgshpnpzqw95cg5c1laa9fx860bm88lkqgl9ikaczvf80b9ay";
    };
  
    deps = [  ];
  };

  # Polish up poor writing on the fly
  writegood-mode = buildEmacsPackage {
    name = "writegood-mode-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/writegood-mode-1.2.el";
      sha256 = "0vw2f90wffklygkhihvangr7i96m8mbjs96xikll1ffmv1xi8qx7";
    };
  
    deps = [  ];
  };

  # Tools and minor mode to trim whitespace on text lines
  ws-trim = buildEmacsPackage {
    name = "ws-trim-1.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/ws-trim-1.4.el";
      sha256 = "0zskvyx1cq51syplajk7mvwkg2b76zsxdzm75m5js15px3wairh2";
    };
  
    deps = [  ];
  };

  # Look up wxWidgets API by using local html manual.
  wxwidgets-help = buildEmacsPackage {
    name = "wxwidgets-help-0.0.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/wxwidgets-help-0.0.3.tar";
      sha256 = "06bd9k2cn7shdwg228qqf1604nanp116h1wai3k4agmwmm695pl0";
    };
  
    deps = [  ];
  };

  # Emacs Interface to XClip
  xclip = buildEmacsPackage {
    name = "xclip-1.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/xclip-1.0.el";
      sha256 = "0isgcmm9iwi734v869nnv0l9ysn1l81yn9jbbknf2jabjn3y5ww2";
    };
  
    deps = [  ];
  };

  # Insert pre-defined license text
  xlicense = buildEmacsPackage {
    name = "xlicense-1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/xlicense-1.1.tar";
      sha256 = "1hqi3b90nx22w0p73c0gl26f4x1fh9hsa30h92fsvlmfmzw9hpr0";
    };
  
    deps = [  ];
  };

  # A DSL for generating XML.
  xml-gen = buildEmacsPackage {
    name = "xml-gen-0.4";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/xml-gen-0.4.el";
      sha256 = "07c7jcdq9a6ciak1ycxygf48f984vd0xdb8lxwdv783g1pwb8i0l";
    };
  
    deps = [  ];
  };

  # An elisp implementation of clientside XML-RPC
  xml-rpc = buildEmacsPackage {
    name = "xml-rpc-1.6.8";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/xml-rpc-1.6.8.el";
      sha256 = "0lyl82gmhijaary67qwx975818c3l1qc139l8ln21r8nfzh79g0i";
    };
  
    deps = [  ];
  };

  # Yet Another Emacs integration for gist.github.com
  yagist = buildEmacsPackage {
    name = "yagist-0.8.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/yagist-0.8.3.el";
      sha256 = "1axy07lrmldprbbvmw734ihvhb9dj3m80w68dkmh0gl6jmlhxsd2";
    };
  
    deps = [ json ];
  };

  # Major mode for editing YAML files
  yaml-mode = buildEmacsPackage {
    name = "yaml-mode-0.0.7";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/yaml-mode-0.0.7.el";
      sha256 = "0wkmqkf1rmizgg4vf1b6rbjhxs1p0613c20rmj5zqdpykd374knq";
    };
  
    deps = [  ];
  };

  # Yet another oddmuse for Emacs
  yaoddmuse = buildEmacsPackage {
    name = "yaoddmuse-0.1.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/yaoddmuse-0.1.1.el";
      sha256 = "0xnzkvlsw9bm70lkimz0dhx0055s7bsggjnfkrwmb631cbv3wc4z";
    };
  
    deps = [  ];
  };

  # Yet Another RI interface for Emacs
  yari = buildEmacsPackage {
    name = "yari-0.6";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/yari-0.6.el";
      sha256 = "18s677k2dd5m8nba10vnr9ppvd9lr9vhspklds53fd9l94zdm4cw";
    };
  
    deps = [  ];
  };

  # Loads Yasnippets on demand (makes start up faster)
  yas-jit = buildEmacsPackage {
    name = "yas-jit-0.8.3";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/yas-jit-0.8.3.el";
      sha256 = "17y0zpci2yjvj7qzbrln11y5bs4gybkxf89xs5aihgi9jhy8dj6q";
    };
  
    deps = [  ];
  };

  # Yet Another Scroll Bar Mode
  yascroll = buildEmacsPackage {
    name = "yascroll-0.2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/yascroll-0.2.0.el";
      sha256 = "0ma31xjydb21f3m949l8my70lwjhiwsjgpc7g2m8hzm99cinlicv";
    };
  
    deps = [  ];
  };

  # A template system for Emacs
  yasnippet = buildEmacsPackage {
    name = "yasnippet-0.8.0";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/yasnippet-0.8.0.tar";
      sha256 = "1syb9sc6xbw4vjhaix8b41lbm5zq6myrljl4r72yi6ndj5z9bmpr";
    };
  
    deps = [  ];
  };

  # Yet another snippet extension (Auto compiled bundle)
  yasnippet-bundle = buildEmacsPackage {
    name = "yasnippet-bundle-0.6.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/yasnippet-bundle-0.6.1.el";
      sha256 = "1rp0pfbf870jd2san1j3fkzri65sbgkjqkj7lfi654ji5xf647qk";
    };
  
    deps = [  ];
  };

  # integrates Emacs with Zeitgeist.
  zeitgeist = buildEmacsPackage {
    name = "zeitgeist-0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/zeitgeist-0.1.el";
      sha256 = "1y9zripg0i10my3dvvap019yhz8bskh8yjf365q525gq0chv3d08";
    };
  
    deps = [  ];
  };

  # zen and art color theme for GNU Emacs 24
  zen-and-art-theme = buildEmacsPackage {
    name = "zen-and-art-theme-1.0.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/zen-and-art-theme-1.0.1.el";
      sha256 = "18hj9y07zvnq1zqmihjcizn6gk7m6nir1dk04wwl3brkb5i674vg";
    };
  
    deps = [  ];
  };

  # remove/restore Emacs distractions quickly
  zen-mode = buildEmacsPackage {
    name = "zen-mode-20120627";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/zen-mode-20120627.tar";
      sha256 = "0c9001m77dhc3inpn83c9vg4x8km9wj1c92csg5ib2lv3nlg1wrk";
    };
  
    deps = [  ];
  };

  # A low contrast color theme for Emacs.
  zenburn-theme = buildEmacsPackage {
    name = "zenburn-theme-2.0";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/zenburn-theme-2.0.el";
      sha256 = "1mj9c88wlhm6h9spyrkb5pab9r16hbzdgw33dsj0wq8kv5q8z547";
    };
  
    deps = [  ];
  };

  # Unfold CSS-selector-like expressions to markup
  zencoding-mode = buildEmacsPackage {
    name = "zencoding-mode-0.5.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/zencoding-mode-0.5.1.el";
      sha256 = "18451wggly25j64b3m5m1may91sa4b7mp95xp6ayfffn8hdiiwg1";
    };
  
    deps = [  ];
  };

  # Highlight variable and function call and others in c/emacs, make life easy.
  zjl-hl = buildEmacsPackage {
    name = "zjl-hl-20121028.1901";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/zjl-hl-20121028.1901.el";
      sha256 = "0d2x1pmyl5ccwss14bb29m8857n0q5sw1yag5bzyfwm7r8b9bzpg";
    };
  
    deps = [ highlight region-list-edit ];
  };

  # ZNC + ERC 
  znc = buildEmacsPackage {
    name = "znc-0.0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/znc-0.0.2.el";
      sha256 = "119fkl9xm9fm2h89qrbaxic2qrai39c1l13vps098cfhg1nn3rp6";
    };
  
    deps = [   ];
  };
}
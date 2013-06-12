{ pkgs, emacs, callPackage }:
let
  stdenv = pkgs.stdenv;
  fetchurl = pkgs.fetchurl;
in
rec {
  buildEmacsPackage = import ../applications/editors/emacs-modes/package-el {
    inherit stdenv;
    inherit emacs;
    inherit (pkgs) runCommand;
    inherit (pkgs) gnutar;
  };

  # inherit (pkgs) callPackage;
  inherit (pkgs.lib) lowPrio hiPrio;

  elisp-slime-nav = buildEmacsPackage {
    name = "elisp-slime-nav-0.5";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/elisp-slime-nav-0.5.el";
      sha256 = "1lflivm8kjr1kn8h2azbb1f53ca8az2gf9ffrqzc0ys1hdz585f6";
    };

    deps = [cl-lib];
  };

  cl-lib = buildEmacsPackage {
    name = "cl-lib-0.3";
    src = fetchurl {
      url = "http://elpa.gnu.org/packages/cl-lib-0.3.el";
      sha256 = "1k7wkm7xf918ivgvf0mk8m18y66z07xjg8lhrh43v3byibhc75kd";
    };
  };

  s = buildEmacsPackage {
    name = "s-1.3.1";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/s-1.3.1.el";
      sha256 = "0n0xvdaldx1w2b2xs9ap1l0aslaj74bypphjfpc31hdfwpz8kjbi";
    };
  };

  tracking = buildEmacsPackage {
    name = "tracking-1.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/tracking-1.2.el";
      sha256 = "11kba4g6fx0wq7viang1aqk1v5h0abaj30qpl5gbackwwb3rd5pw";
    };
  };

  weechat-el = buildEmacsPackage {
    name = "weechat-0.2";
    src = fetchurl {
      url = "http://marmalade-repo.org/packages/weechat-0.2.tar";
      sha256 = "09sgihahc427w72wpmdac3zl024cpgv24r8mhkj8fsv3k1b0b51j";
    };

    deps = [ cl-lib s tracking ];
  };

  # Legacy emacs packages from all-packages.nix (not yet built via package.el)

  autoComplete = callPackage ../applications/editors/emacs-modes/auto-complete { };
  bbdb = callPackage ../applications/editors/emacs-modes/bbdb { };
  cedet = callPackage ../applications/editors/emacs-modes/cedet { };
  calfw = callPackage ../applications/editors/emacs-modes/calfw { };
  coffee = callPackage ../applications/editors/emacs-modes/coffee { };
  colorTheme = callPackage ../applications/editors/emacs-modes/color-theme { };
  cua = callPackage ../applications/editors/emacs-modes/cua { };
  # ecb = callPackage ../applications/editors/emacs-modes/ecb { };
  jabber = callPackage ../applications/editors/emacs-modes/jabber { };
  emacsClangCompleteAsync = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };
  emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };
  emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { };
  emms = callPackage ../applications/editors/emacs-modes/emms { };
  flymakeCursor = callPackage ../applications/editors/emacs-modes/flymake-cursor { };
  gh = callPackage ../applications/editors/emacs-modes/gh { };
  graphvizDot = callPackage ../applications/editors/emacs-modes/graphviz-dot { };
  gist = callPackage ../applications/editors/emacs-modes/gist { };
  jade = callPackage ../applications/editors/emacs-modes/jade { };
  jdee = callPackage ../applications/editors/emacs-modes/jdee {
    # Requires Emacs 23, for `avl-tree'.
  };
  js2 = callPackage ../applications/editors/emacs-modes/js2 { };
  stratego = callPackage ../applications/editors/emacs-modes/stratego { };
  haskellMode = callPackage ../applications/editors/emacs-modes/haskell { };
  ocamlMode = callPackage ../applications/editors/emacs-modes/ocaml { };
  tuaregMode = callPackage ../applications/editors/emacs-modes/tuareg { };
  hol_light_mode = callPackage ../applications/editors/emacs-modes/hol_light { };
  htmlize = callPackage ../applications/editors/emacs-modes/htmlize { };
  logito = callPackage ../applications/editors/emacs-modes/logito { };
  loremIpsum = callPackage ../applications/editors/emacs-modes/lorem-ipsum { };
  magit = callPackage ../applications/editors/emacs-modes/magit { };
  maudeMode = callPackage ../applications/editors/emacs-modes/maude { };
  notmuch = callPackage ../applications/networking/mailreaders/notmuch { };
  # This is usually a newer version of Org-Mode than that found in GNU Emacs, so
  # we want it to have higher precedence.
  org = hiPrio (callPackage ../applications/editors/emacs-modes/org { });
  org2blog = callPackage ../applications/editors/emacs-modes/org2blog { };
  pcache = callPackage ../applications/editors/emacs-modes/pcache { };
  phpMode = callPackage ../applications/editors/emacs-modes/php { };
  prologMode = callPackage ../applications/editors/emacs-modes/prolog { };
  proofgeneral = callPackage ../applications/editors/emacs-modes/proofgeneral {
    texLive = pkgs.texLiveAggregationFun {
      paths = [ pkgs.texLive pkgs.texLiveCMSuper ];
    };
  };
  quack = callPackage ../applications/editors/emacs-modes/quack { };
  rectMark = callPackage ../applications/editors/emacs-modes/rect-mark { };
  remember = callPackage ../applications/editors/emacs-modes/remember { };
  rudel = callPackage ../applications/editors/emacs-modes/rudel { };
  scalaMode = callPackage ../applications/editors/emacs-modes/scala-mode { };
  sunriseCommander = callPackage ../applications/editors/emacs-modes/sunrise-commander { };
  xmlRpc = callPackage ../applications/editors/emacs-modes/xml-rpc { };
} 

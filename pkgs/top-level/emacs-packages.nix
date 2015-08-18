# package.el-based emacs packages

## FOR USERS
#
# Recommended way: simply use `emacsWithPackages` from
# `all-packages.nix` with the packages you want.
#
# Possible way: use `emacs` from `all-packages.nix`, install
# everything to a system or user profile and then add this at the
# start your `init.el`:
/*
  (require 'package)

  ;; optional. makes unpure packages archives unavailable
  (setq package-archives nil)

  ;; optional. use this if you install emacs packages to the system profile
  (add-to-list 'package-directory-list "/run/current-system/sw/share/emacs/site-lisp/elpa")

  ;; optional. use this if you install emacs packages to user profiles (with nix-env)
  (add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")

  (package-initialize)
*/

## FOR CONTRIBUTORS
#
# When adding a new package here please note that
# * lib.licenses are `with`ed on top of the file here
# * both trivialBuild and melpaBuild will automatically derive a
#   `meta` with `platforms` and `homepage` set to something you are
#   unlikely to want to override for most packages

{ overrides

, lib, stdenv, fetchurl, fetchgit, fetchFromGitHub

, emacs
, trivialBuild
, melpaBuild

, external
}@args:

with lib.licenses;

let self = _self // overrides;
    callPackage = lib.callPackageWith (self // removeAttrs args ["overrides" "external"]);
    _self = with self; {

  inherit emacs;

  ## START HERE

  ac-haskell-process = melpaBuild rec {
    pname   = "ac-haskell-process";
    version = "0.5";
    src = fetchFromGitHub {
      owner  = "purcell";
      repo   = pname;
      rev    = version;
      sha256 = "0dlrhc1dmzgrjvcnlqvm6clyv0r6zray6qqliqngy14880grghbm";
    };
    packageRequires = [ auto-complete haskell-mode ];
    meta = {
      description = "Haskell code completion for auto-complete Emacs framework";
      license = gpl3Plus;
    };
  };

  ace-jump-mode = melpaBuild rec {
    pname   = "ace-jump-mode";
    version = "20140616";
    src = fetchFromGitHub {
      owner  = "winterTTr";
      repo   = pname;
      rev    = "8351e2df4fbbeb2a4003f2fb39f46d33803f3dac";
      sha256 = "17axrgd99glnl6ma4ls3k01ysdqmiqr581wnrbsn3s4gp53mm2x6";
    };
    meta = {
      description = "Advanced cursor movements mode for Emacs";
      license = gpl3Plus;
    };
  };

  ag = melpaBuild rec {
    pname   = "ag";
    version = "0.44";
    src = fetchFromGitHub {
      owner  = "Wilfred";
      repo   = "${pname}.el";
      rev    = version;
      sha256 = "19y5w9m2flp4as54q8yfngrkri3kd7fdha9pf2xjgx6ryflqx61k";
    };
    packageRequires = [ dash s ];
    meta = {
      description = "Search using ag from inside Emacs";
      license = gpl3Plus;
    };
  };

  agda2-mode = with external; trivialBuild {
    pname = "agda-mode";
    version = Agda.version;

    phases = [ "buildPhase" "installPhase" ];

    # already byte-compiled by Agda builder
    buildPhase = ''
      agda=`${Agda}/bin/agda-mode locate`
      cp `dirname $agda`/*.el* .
    '';

    meta = {
      description = "Agda2-mode for Emacs extracted from Agda package";
      longDescription = ''
        Wrapper packages that liberates init.el from `agda-mode locate` magic.
        Simply add this to user profile or systemPackages and do `(require 'agda2)` in init.el.
      '';
      homepage = Agda.meta.homepage;
      license = Agda.meta.license;
    };
  };

  alert = melpaBuild rec {
    pname = "alert";
    version = "1.2";
    src = fetchFromGitHub {
      owner = "jwiegley";
      repo  = pname;
      rev   = "v${version}";
      sha256 = "1vpc3q40m6dcrslki4bg725j4kv6c6xfxwjjl1ilg7la49fwwf26";
    };
    packageRequires = [ gntp log4e ];
    meta = {
      description = "A Growl-like alerts notifier for Emacs";
      license = gpl2Plus;
    };
  };

  anzu = melpaBuild rec {
    pname = "anzu";
    version = "0.52";
    src = fetchFromGitHub {
      owner = "syohex";
      repo  = "emacs-anzu";
      rev = "f41db6225d8fb983324765aa42c94d3ee379a49f";
      sha256 = "1mn20swasrl8kr557r1850vr1q0gcnwlxxafnc6lq5g01kjfcdxd";
    };
    meta = {
      description = "Show number of matches in Emacs mode-line while searching";
      longDescription = ''
        anzu.el is an Emacs port of anzu.vim. anzu.el provides a minor
        mode which displays current match and total matches information
        in the mode-line in various search mode.
      '';
      license = gpl3Plus;
    };
  };

  apel = melpaBuild rec {
    pname = "apel";
    version = "10.8";
    src = fetchFromGitHub {
      owner  = "wanderlust";
      repo   = pname;
      rev    = "8402e59eadb580f59969114557b331b4d9364f95";
      sha256 = "0sdxnf4b8rqs1cbjxh23wvxmj7ll3zddv8yfdgif6zmgyy8xhc9m";
    };
    files = [
      "alist.el" "apel-ver.el" "broken.el" "calist.el"
      "emu.el" "filename.el" "install.el" "inv-23.el" "invisible.el"
      "mcharset.el" "mcs-20.el" "mcs-e20.el" "mule-caesar.el"
      "path-util.el" "pccl-20.el" "pccl.el" "pces-20.el" "pces-e20.el"
      "pces.el" "pcustom.el" "poe.el" "poem-e20.el" "poem-e20_3.el"
      "poem.el" "product.el" "pym.el" "richtext.el" "static.el"
    ];
    meta = {
      description = "A Portable Emacs Library";
      license = gpl3Plus; # probably
    };
  };

  async = melpaBuild rec {
    pname   = "async";
    version = "1.2";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = "emacs-async";
      rev    = "v${version}";
      sha256 = "1j6mbvvbnm2m1gpsy9ipxiv76b684nn57yssbqdyiwyy499cma6q";
    };
    meta = {
      description = "Asynchronous processing in Emacs";
      license = gpl3Plus;
    };
  };

  auctex = melpaBuild rec {
    pname   = "auctex";
    version = "11.87.7";
    src = fetchurl {
      url    = "http://elpa.gnu.org/packages/${pname}-${version}.tar";
      sha256 = "07bhw8zc3d1f2basjy80njmxpsp4f70kg3ynkch9ghlai3mm2b7n";
    };
    buildPhase = ''
      cp $src ${pname}-${version}.tar
    '';
    meta = {
      description = "Extensible package for writing and formatting TeX files in GNU Emacs and XEmacs";
      homepage = https://www.gnu.org/software/auctex/;
      license = gpl3Plus;
    };
  };

  auto-complete = melpaBuild rec {
    pname = "auto-complete";
    version = "1.4.0";
    src = fetchFromGitHub {
      owner = pname;
      repo  = pname;
      rev   = "v${version}";
      sha256 = "050lb8qjq7ra35mqp6j6qkwbvq5zj3yhz73aym5kf1vjd42rmjcw";
    };
    packageRequires = [ popup ];
    meta = {
      description = "Auto-complete extension for Emacs";
      homepage = http://cx4a.org/software/auto-complete/;
      license = gpl3Plus;
    };
  };

  autotetris = melpaBuild {
    pname = "autotetris-mode";
    version = "20141114.846";
    src = fetchFromGitHub {
      owner = "skeeto";
      repo = "autotetris-mode";
      rev = "7d348d33829bc89ddbd2b4d5cfe5073c3b0cbaaa";
      sha256 = "14pjsb026mgjf6l3dggy255knr7c1vfmgb6kgafmkzvr96aglcdc";
    };
    files = [ "autotetris-mode.el" ];
    meta =  { license = unlicense; };
  };

  bind-key = melpaBuild {
    pname   = "bind-key";
    version = "20150317";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = "use-package";
      rev    = "b836266ddfbc835efdb327ecb389ff9e081d7c55";
      sha256 = "187wnqqm5g43cg8b6a9rbd9ncqad5fhjb96wjszbinjh1mjxyh7i";
    };
    files = [ "bind-key.el" ];
    meta = {
      description = "A simple way to manage personal keybindings";
      license = gpl3Plus;
    };
  };

  browse-kill-ring = melpaBuild rec {
    pname   = "browse-kill-ring";
    version = "20140104";
    src = fetchFromGitHub {
      owner  = pname;
      repo   = pname;
      rev    = "f81ca5f14479fa9e938f89bf8f6baa3c4bdfb755";
      sha256 = "149g4qs5dqy6yzdj5smb39id5f72bz64qfv5bjf3ssvhwl2rfba8";
    };
    meta = {
      description = "Interactively insert items from Emacs kill-ring";
      license = gpl2Plus;
    };
  };

  button-lock = melpaBuild rec {
    pname   = "button-lock";
    version = "1.0.2";
    src = fetchFromGitHub {
      owner  = "rolandwalker";
      repo   = pname;
      rev    = "v${version}";
      sha256 = "1kqcc1d56jz107bswlzvdng6ny6qwp93yck2i2j921msn62qvbb2";
    };
    meta = {
      description = "Mouseable text in Emacs";
      license  = bsd2;
    };
  };

  caml = melpaBuild rec {
    pname   = "caml";
    version = "4.2.1"; # TODO: emacs doesn't seem to like 02 as a version component..
    src = fetchFromGitHub {
      owner  = "ocaml";
      repo   = "ocaml";
      rev    = "4.02.1";
      sha256 = "05lms9qhcnwgi7k034kiiic58c9da22r32mpak0ahmvp5fylvjpb";
    };
    fileSpecs = [ "emacs/*.el" ];
    configurePhase = "true";
    meta = {
      description = "OCaml code editing commands for Emacs";
      license = gpl2Plus;
    };
  };

  change-inner = melpaBuild rec {
    pname   = "change-inner";
    version = "20130208";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${pname}.el";
      rev    = "6374b745ee1fd0302ad8596cdb7aca1bef33a730";
      sha256 = "1fv8630bqbmfr56zai08f1q4dywksmghhm70084bz4vbs6rzdsbq";
    };
    packageRequires = [ expand-region ];
    meta = {
      description = "Change contents based on semantic units in Emacs";
      license = gpl3Plus;
    };
  };

  circe = melpaBuild rec {
    pname   = "circe";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    packageRequires = [ lcs lui ];
    fileSpecs = [ "lisp/circe*.el" ];
    meta = {
      description = "IRC client for Emacs";
      license = gpl3Plus;
    };
  };

  company = melpaBuild rec {
    pname   = "company";
    version = "0.8.12";
    src = fetchFromGitHub {
      owner  = "company-mode";
      repo   = "company-mode";
      rev    = version;
      sha256 = "08rrjfp2amgya1hswjz3vd5ja6lg2nfmm7454p0h1naz00hlmmw0";
    };
    meta = {
      description = "Modular text completion framework for Emacs";
      license = gpl3Plus;
    };
  };

  company-ghc = melpaBuild rec {
    pname   = "company-ghc";
    version = "0.1.10";
    src = fetchFromGitHub {
      owner  = "iquiw";
      repo   = "company-ghc";
      rev    = "v${version}";
      sha256 = "0lzwmjf91fxhkknk4z9m2v6whk1fzpa7n1rspp61lwmyh5gakj3x";
    };
    packageRequires = [ company ghc-mod ];
    meta = {
      description = "company-mode completion backend for haskell-mode via ghc-mod";
      license = gpl3Plus;
    };
  };

  dash = melpaBuild rec {
    pname   = "dash";
    version = "2.11.0";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${pname}.el";
      rev    = version;
      sha256 = "02gfrcda7gj3j5yx71dz40xylrafl4pcaj7bgfajqi9by0w2nrnx";
    };
    meta = {
      description = "A modern list library for Emacs";
      license = gpl3Plus;
    };
  };

  deferred = melpaBuild rec {
    version = "0.3.2";
    pname = "deferred";

    src = fetchFromGitHub {
      owner = "kiwanami";
      repo = "emacs-${pname}";
      rev = "896d4b53210289afe489e1ee7db4e12cb9248109";
      sha256 = "0ysahdyvlg240dynwn23kk2d9kb432zh2skr1gydm3rxwn6f18r0";
    };

    meta = {
      description = "Simple asynchronous functions for emacs-lisp";
      longDescription = ''
        deferred.el provides facilities to manage asynchronous tasks.
        The API and implementations were translated from JSDeferred (by cho45)
         and Mochikit.Async (by Bob Ippolito) in JavaScript.
      '';
      license = gpl3Plus;
    };
  };

  diminish = melpaBuild rec {
    pname   = "diminish";
    version = "0.44";
    src = fetchFromGitHub {
      owner  = "emacsmirror";
      repo   = pname;
      rev    = version;
      sha256 = "0hshw7z5f8pqxvgxw74kbj6nvprsgfvy45fl854xarnkvqcara09";
    };
    meta = {
      description = "Diminishes the amount of space taken on the mode-line by Emacs minor modes";
      homepage = http://www.eskimo.com/~seldon/;
      license = gpl3Plus;
    };
  };

  epl = melpaBuild rec {
    pname   = "epl";
    version = "20140823";
    src = fetchFromGitHub {
      owner  = "cask";
      repo   = pname;
      rev    = "63c78c08e345455f3d4daa844fdc551a2c18024e";
      sha256 = "04a2aq8dj2cmy77vw142wcmnjvqdbdsp6z0psrzz2qw0b0am03li";
    };
    meta = { license = gpl3Plus; };
  };

  evil-god-state = melpaBuild rec {
    pname   = "evil-god-state";
    version = "20140830";
    src = fetchFromGitHub {
      owner  = "gridaphobe";
      repo   = pname;
      rev    = "234a9b6f500ece89c3dfb5c1df5baef6963e4566";
      sha256 = "16v6dpw1hibrkf9hga88gv5axvp1pajd67brnh5h4wpdy9qvwgyy";
    };
    packageRequires = [ evil god-mode ];
    meta = { license = gpl3Plus; };
  };

  evil-indent-textobject = melpaBuild rec {
    pname   = "evil-indent-textobject";
    version = "0.2";
    src = fetchFromGitHub {
      owner  = "cofi";
      repo   = pname;
      rev    = "70a1154a531b7cfdbb9a31d6922482791e20a3a7";
      sha256 = "0nghisnc49ivh56mddfdlcbqv3y2vqzjvkpgwv3zp80ga6ghvdmz";
    };
    packageRequires = [ evil ];
    meta = {
      description = "Textobject for evil based on indentation";
      license = gpl2Plus;
    };
  };

  evil-leader = melpaBuild rec {
    pname   = "evil-leader";
    version = "0.4.3";
    src = fetchFromGitHub {
      owner  = "cofi";
      repo   = pname;
      rev    = version;
      sha256 = "1k2zinchs0jjllp8zkpggckyy63dkyi5yig3p46vh4w45jdzysk5";
    };
    packageRequires = [ evil ];
    meta = {
      description = "<leader> key for evil";
      license = gpl3Plus;
    };
  };

  evil-surround = melpaBuild rec {
    pname   = "evil-surround";
    version = "20140616";
    src = fetchFromGitHub {
      owner  = "timcharper";
      repo   = pname;
      rev    = "71f380b6b6ed38f739c0a4740b3d6de0c52f915a";
      sha256 = "0wrmlmgr4mwxlmmh8blplddri2lpk4g8k3l1vpb5c6a975420qvn";
    };
    packageRequires = [ evil ];
    meta = {
      description = "surround.vim emulation for Emacs evil mode";
      license = gpl3Plus;
    };
  };

  evil = melpaBuild {
    pname   = "evil";
    version = "20141020";
    src = fetchgit {
      url = "https://github.com/emacsmirror/evil.git";
      rev = "999ec15587f85100311c031aa8efb5d50c35afe4";
      sha256 = "5f67643d19a31172e68f2f195959d33bcd26c2786eb71e67eb27eb52f5bf387a";
    };
    packageRequires = [ goto-chg undo-tree ];
    meta = {
      description = "Extensible vi layer for Emacs";
      license = gpl3Plus;
    };
  };

  exec-path-from-shell = melpaBuild rec {
    pname   = "exec-path-from-shell";
    version = "20141022";
    src = fetchFromGitHub {
      owner  = "purcell";
      repo   = pname;
      rev    = "e4af0e9b44738e7474c89ed895200b42e6541515";
      sha256 = "0lxikiqf1jik88lf889q4f4f8kdgg3npciz298x605nhbfd5snbd";
    };
    meta = { license = gpl3Plus; };
  };

  expand-region = melpaBuild rec {
    pname   = "expand-region";
    version = "20141012";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${pname}.el";
      rev    = "fa413e07c97997d950c92d6012f5442b5c3cee78";
      sha256 = "04k0518wfy72wpzsswmncnhd372fxa0r8nbfhmbyfmns8n7sr045";
    };
    meta = {
      description = "Increases the selected region by semantic units in Emacs";
      license = gpl3Plus;
    };
  };

  flim = melpaBuild rec {
    pname = "flim";
    version = "1.14.9"; # 20141216
    src = fetchFromGitHub {
      owner  = "wanderlust";
      repo   = pname;
      rev    = "488a4d70fb4ae57bdd30dc75c2d75579894e28a2";
      sha256 = "178fhpbyffksr4v3m8jmx4rx2vqyz23qhbyvic5afabxi6lahjfs";
    };
    packageRequires = [ apel ];
    meta = {
      description = "Email message encoding library for Emacs";
      license = gpl3Plus; # probably
    };
  };

  flycheck = melpaBuild rec {
    pname   = "flycheck";
    version = "0.23";
    src = fetchFromGitHub {
      owner  = pname;
      repo   = pname;
      rev    = version;
      sha256 = "1ydk1wa7h7z9qw7prfvszxrmy2dyzsdij3xdy10rq197xnrw94wz";
    };
    packageRequires = [ dash let-alist pkg-info ];
    meta = { license = gpl3Plus; };
  };

  flycheck-haskell = melpaBuild rec {
    pname   = "flycheck-haskell";
    version = "0.7.2";
    src = fetchFromGitHub {
      owner  = "flycheck";
      repo   = pname;
      rev    = version;
      sha256 = "0143lcn6g46g7skm4r6lqq09s8mr3268rikbzlh65qg80rpg9frj";
    };
    packageRequires = [ dash flycheck haskell-mode let-alist pkg-info ];
    meta = { license = gpl3Plus; };
  };

  flycheck-pos-tip = melpaBuild rec {
    pname   = "flycheck-pos-tip";
    version = "20140813";
    src = fetchFromGitHub {
      owner  = "flycheck";
      repo   = pname;
      rev    = "5b3a203bbdb03e4f48d1654efecd71f44376e199";
      sha256 = "0b4x24aq0jh4j4bjv0fqyaz6hzh3gqf57k9763jj9rl32cc3dpnp";
    };
    packageRequires = [ flycheck popup ];
    meta = { license = gpl3Plus; };
  };

  ghc-mod = melpaBuild rec {
    pname = "ghc";
    version = external.ghc-mod.version;
    src = external.ghc-mod.src;
    packageRequires = [ haskell-mode ];
    propagatedUserEnvPkgs = [ external.ghc-mod ];
    fileSpecs = [ "elisp/*.el" ];
    meta = { license = bsd3; };
  };

  git-auto-commit-mode = melpaBuild rec {
    pname = "git-auto-commit-mode";
    version = "4.4.0";
    src = fetchFromGitHub {
      owner  = "ryuslash";
      repo   = pname;
      rev    = version;
      sha256 = "0psmr7749nzxln4b500sl3vrf24x3qijp12ir0i5z4x25k72hrlh";
    };
    meta = {
      description = "Automatically commit to git after each save";
      license = gpl3Plus;
    };
  };

  git-commit-mode = melpaBuild rec {
    pname = "git-commit-mode";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "12a1xs3w2dp1a55qhc01dwjkavklgfqnn3yw85dhi4jdz8r8j7m0";
    };
    files = [ "git-commit-mode.el" ];
    meta = { license = gpl3Plus; };
  };

  git-rebase-mode = melpaBuild rec {
    pname = "git-rebase-mode";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "12a1xs3w2dp1a55qhc01dwjkavklgfqnn3yw85dhi4jdz8r8j7m0";
    };
    files = [ "git-rebase-mode.el" ];
    meta = { license = gpl3Plus; };
  };

  git-timemachine = melpaBuild rec {
    pname = "git-timemachine";
    version = "2.3";
    src = fetchFromGitHub {
      owner  = "pidu";
      repo   = pname;
      rev    = version;
      sha256 = "1lm6rgbzbxnwfn48xr6bg05lb716grfr4nqm8lvjm64nabh5y9bh";
    };
    meta = {
      description = "Step through historic revisions of git controlled files";
      license = gpl3Plus;
    };
  };

  gitattributes-mode = melpaBuild rec {
    pname = "gitattributes-mode";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "12a1xs3w2dp1a55qhc01dwjkavklgfqnn3yw85dhi4jdz8r8j7m0";
    };
    files = [ "gitattributes-mode.el" ];
    meta = { license = gpl3Plus; };
  };

  gitconfig-mode = melpaBuild rec {
    pname = "gitconfig-mode";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "12a1xs3w2dp1a55qhc01dwjkavklgfqnn3yw85dhi4jdz8r8j7m0";
    };
    files = [ "gitconfig-mode.el" ];
    meta = { license = gpl3Plus; };
  };

  gitignore-mode = melpaBuild rec {
    pname = "gitignore-mode";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "12a1xs3w2dp1a55qhc01dwjkavklgfqnn3yw85dhi4jdz8r8j7m0";
    };
    files = [ "gitignore-mode.el" ];
    meta = { license = gpl3Plus; };
  };

  gntp = melpaBuild rec {
    pname = "gntp";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "tekai";
      repo  = "${pname}.el";
      rev   = "v${version}";
      sha256 = "1nvyjjjydrimpxy4cpg90si7sr8lmldbhlcm2mx8npklp9pn5y3a";
    };
    meta = { license = gpl2Plus; };
  };

  gnus = melpaBuild rec {
    pname   = "gnus";
    version = "20140501";
    src = fetchgit {
      url = "http://git.gnus.org/gnus.git";
      rev = "4228cffcb7afb77cf39678e4a8988a57753502a5";
      sha256 = "0qd0wpxkz47irxghmdpa524c9626164p8vgqs26wlpbdwyvm64a0";
    };
    fileSpecs = [ "lisp/*.el" "texi/*.texi" ];
    preBuild = ''
      (cd lisp && make gnus-load.el)
    '';
    meta = { license = gpl3Plus; };
  };

  god-mode = melpaBuild rec {
    pname   = "god-mode";
    version = "20140811";
    src = fetchFromGitHub {
      owner  = "chrisdone";
      repo   = pname;
      rev    = "6b7ae259a58ca1d7776aa4eca9f1092e4c0033e6";
      sha256 = "1amr98nq82g2d3f3f5wlqm9g38j64avygnsi9rrlbfqz4f71vq7x";
    };
    meta = { license = gpl3Plus; };
  };

  goto-chg = melpaBuild rec {
    pname   = "goto-chg";
    version = "1.6";
    src = fetchgit {
      url = "https://gitorious.org/evil/evil.git";
      rev = "999ec15587f85100311c031aa8efb5d50c35afe4";
      sha256 = "5f67643d19a31172e68f2f195959d33bcd26c2786eb71e67eb27eb52f5bf387a";
    };
    files = [ "lib/goto-chg.el" ];
    meta = { license = gpl3Plus; };
  };

  haskell-mode = melpaBuild rec {
    pname   = "haskell-mode";
    version = "13.14";
    src = fetchFromGitHub {
      owner  = "haskell";
      repo   = pname;
      rev    = "v${version}";
      sha256 = "1mxr2cflgafcr8wkvgbq8l3wmc9qhhb7bn9zl1bkf10zspw9m58z";
    };
    meta = { license = gpl3Plus; };
  };

  helm-swoop = melpaBuild rec {
    pname   = "helm-swoop";
    version = "20141224";
    src = fetchFromGitHub {
      owner  = "ShingoFukuyama";
      repo   = pname;
      rev    = "06a251f7d7fce2a5719e0862e5855972cd8ab1ae";
      sha256 = "0nq33ldhbvfbm6jnsxqdf3vwaqrsr2gprkzll081gcyl2s1x0l2m";
    };
    packageRequires = [ helm ];
    meta = { license = gpl3Plus; };
  };

  helm = melpaBuild rec {
    pname   = "helm";
    version = "20150105";
    src = fetchFromGitHub {
      owner  = "emacs-helm";
      repo   = pname;
      rev    = "e5608ad86e7ca72446a4b1aa0faf604200ffe895";
      sha256 = "0n2kr6pyzcsi8pq6faxz2y8kicz1gmvj98fzzlq3a107dqqp25ay";
    };
    packageRequires = [ async ];
    meta = { license = gpl3Plus; };
  };

  hi2 = melpaBuild rec {
    pname   = "hi2";
    version = "1.0";
    src = fetchFromGitHub {
      owner  = "nilcons";
      repo   = pname;
      rev    = version;
      sha256 = "1s08sgbh5v59lqskd0s1dscs6dy7z5mkqqkabs3gd35agbfvbmlf";
    };
    meta = { license = gpl3Plus; };
  };

  ibuffer-vc = melpaBuild rec {
    pname   = "ibuffer-vc";
    version = "0.10";
    src = fetchFromGitHub {
      owner  = "purcell";
      repo   = pname;
      rev    = version;
      sha256 = "0bqdi5w120256g74k0j4jj81x804x1gcg4dxa74w3mb6fl5xlvs8";
    };
    meta = { license = gpl3Plus; };
  };

  ido-ubiquitous = melpaBuild rec {
    pname   = "ido-ubiquitous";
    version = "2.17";
    src = fetchFromGitHub {
      owner  = "DarwinAwardWinner";
      repo   = pname;
      rev    = "323e4cddc05d5a4546c1b64132b2b1e9f8896452";
      sha256 = "0wdjz3cqzrxhrk68g5gyvc9j2rb6f4yw00xbjgw9ldwlhmkwy5ja";
    };
    meta = {
      description = "Does what you expected ido-everywhere to do in Emacs";
      license = gpl3Plus;
    };
  };

  idris-mode = melpaBuild rec {
    pname   = "idris-mode";
    version = "0.9.18";
    src = fetchFromGitHub {
      owner  = "idris-hackers";
      repo   = "idris-mode";
      rev    = version;
      sha256 = "11dw2ydlqhqx569wrp56w11rhgvm6mb6mzq2cwsv2vfyjvvawyxg";
    };
    meta = { license = gpl3Plus; };
  };

  lcs = melpaBuild rec {
    pname   = "lcs";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    fileSpecs = [ "lisp/lcs*.el" ];
    meta = { license = gpl3Plus; };
  };

  let-alist = melpaBuild rec {
    pname   = "let-alist";
    version = "1.0.4";
    src = fetchurl {
      url    = "http://elpa.gnu.org/packages/${pname}-${version}.el";
      sha256 = "07312bvvyz86lf64vdkxg2l1wgfjl25ljdjwlf1bdzj01c4hm88x";
    };
    unpackPhase = "true";
    buildPhase = ''
      cp $src ${pname}-${version}.el
    '';
    meta = { license = gpl3Plus; };
  };

  log4e = melpaBuild rec {
    pname = "log4e";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "aki2o";
      repo  = pname;
      rev   = "v${version}";
      sha256 = "1l28n7a0v2zkknc70i1wn6qb5i21dkhfizzk8wcj28v44cgzk022";
    };
    meta = { license = gpl2Plus; };
  };

  lui = melpaBuild rec {
    pname   = "lui";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    packageRequires = [ tracking ];
    fileSpecs = [ "lisp/lui*.el" ];
    meta = { license = gpl3Plus; };
  };

  magit = melpaBuild rec {
    pname   = "magit";
    version = "2.1.0";
    src = fetchFromGitHub {
      owner  = pname;
      repo   = pname;
      rev    = version;
      sha256 = "0pyqa79km1y58phsf4sq2a25rx9lw0di1hb6a5y17xisa8li7sfl";
    };
    packageRequires = [ dash git-commit magit-popup with-editor ];
    fileSpecs = [ "lisp/magit-utils.el"
                  "lisp/magit-section.el"
                  "lisp/magit-git.el"
                  "lisp/magit-mode.el"
                  "lisp/magit-process.el"
                  "lisp/magit-core.el"
                  "lisp/magit-diff.el"
                  "lisp/magit-wip.el"
                  "lisp/magit-apply.el"
                  "lisp/magit-log.el"
                  "lisp/magit.el"
                  "lisp/magit-sequence.el"
                  "lisp/magit-commit.el"
                  "lisp/magit-remote.el"
                  "lisp/magit-bisect.el"
                  "lisp/magit-stash.el"
                  "lisp/magit-blame.el"
                  "lisp/magit-ediff.el"
                  "lisp/magit-extras.el"
                  "lisp/git-rebase.el"
                  "Documentation/magit.texi"
                  "Documentation/AUTHORS.md"
                  "COPYING"
                ];
    meta = { license = gpl3Plus; };
  };
  git-commit = melpaBuild rec {
    pname = "git-commit";
    version = magit.version;
    src = magit.src;
    packageRequires = [ dash with-editor ];
    fileSpecs = [ "lisp/git-commit.el" ];
    meta = { license = gpl3Plus; };
  };
  magit-popup = melpaBuild rec {
    pname = "magit-popup";
    version = magit.version;
    src = magit.src;
    packageRequires = [ dash with-editor ];
    fileSpecs = [ "Documentation/magit-popup.texi" "lisp/magit-popup.el" ];
    meta = { license = gpl3Plus; };
  };
  with-editor = melpaBuild rec {
    pname = "with-editor";
    version = magit.version;
    src = magit.src;
    packageRequires = [ dash ];
    fileSpecs = [ "Documentation/with-editor.texi" "lisp/with-editor.el" ];
    meta = { license = gpl3Plus; };
  };

  markdown-mode = melpaBuild rec {
    pname   = "markdown-mode";
    version = "2.0";
    src = fetchFromGitHub {
      owner  = "defunkt";
      repo   = pname;
      rev    = "v${version}";
      sha256 = "1l2w0j9xl8pipz61426s79jq2yns42vjvysc6yjc29kbsnhalj29";
    };
    meta = { license = gpl3Plus; };
  };

  moe-theme = melpaBuild rec {
    pname   = "moe-theme";
    version = "1.0";
    src = fetchFromGitHub {
      owner  = "kuanyui";
      repo   = "${pname}.el";
      rev    = "39384a7a9e6886f3a3d79efac4009fcd800a4a14";
      sha256 = "0i7m15x9sij5wh0gwbijsis8a4jm8izywj7xprk21644ndskvfiz";
    };
    meta = { license = gpl3Plus; };
  };

  monokai-theme = melpaBuild rec {
    pname   = "monokai-theme";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner  = "oneKelvinSmith";
      repo   = "monokai-emacs";
      rev    = "v${version}";
      sha256 = "02w7k4s4698p4adjy4a36na28sb1s2zw4xsjs7p2hv9iiw9kmyvz";
    };
    meta = { license = gpl3Plus; };
  };

  multiple-cursors = melpaBuild rec {
    pname = "multiple-cursors";
    version = "20150627";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "multiple-cursors.el";
      rev    = "9b53e892e6167f930763a3c5aedf8773110a8ae9";
      sha256 = "0wcrdb137a9aq6dynlqbvypb6m2dj48m899xwy7ilnf2arrmipid";
    };
  };

  nyan-mode = callPackage ../applications/editors/emacs-modes/nyan-mode {
    inherit lib;
  };

  org-plus-contrib = melpaBuild rec {
    pname   = "org-plus-contrib";
    version = "20150406";
    src = fetchurl {
      url    = "http://orgmode.org/elpa/${pname}-${version}.tar";
      sha256 = "1ny2myg4rm75ab2gl5rqrwy7h53q0vv18df8gk3zv13kljj76c6i";
    };
    buildPhase = ''
      cp $src ${pname}-${version}.tar
    '';
    meta = { license = gpl3Plus; };
  };

  org-trello = melpaBuild rec {
    pname = "org-trello";
    version = "0.6.9.3";
    src = fetchFromGitHub {
      owner = "org-trello";
      repo = pname;
      rev = "f1e1401a373dd492eee49fb131b1cd66b3a9ac37";
      sha256 = "003gdh8rgdl3k8h20wgbciqyacyqr64w1wfdqvwm9qdz414q5yj3";
    };
    packageRequires = [ request-deferred deferred dash s ];
    files = [ "org-trello-*.el" ];
    meta = {
      description = "Org minor mode - 2-way sync org & trello";
      longDescription = ''
        Org-trello is an emacs minor mode that extends org-mode with
        Trello abilities.
      '';
      homepage = https://org-trello.github.io/;
      license = gpl3Plus;
    };
  };

  perspective = melpaBuild rec {
    pname   = "perspective";
    version = "1.12";
    src = fetchFromGitHub {
      owner  = "nex3";
      repo   = "${pname}-el";
      rev    = version;
      sha256 = "12c2rrhysrcl2arc6hpzv6lxbb1r3bzlvdp23hnp9sci6yc10k3q";
    };
    meta = { license = gpl3Plus; };
  };

  pkg-info = melpaBuild rec {
    pname   = "pkg-info";
    version = "20140610";
    src = fetchFromGitHub {
      owner  = "lunaryorn";
      repo   = "${pname}.el";
      rev    = "475cdeb0b8d44f9854e506c429eeb445787014ec";
      sha256 = "0x4nz54f2shgcw3gx66d265vxwdpdirn64gzii8dpxhsi7v86n0p";
    };
    packageRequires = [ epl ];
    meta = { license = gpl3Plus; };
  };

  popup = melpaBuild rec {
    pname   = "popup";
    version = "0.5.2";
    src = fetchFromGitHub {
      owner  = "auto-complete";
      repo   = "${pname}-el";
      rev    = "v${version}";
      sha256 = "0aazkczrzpp75793bpi0pz0cs7vinhdrpxfdlzi0cr39njird2yj";
    };
    meta = { license = gpl3Plus; };
  };

  projectile = melpaBuild rec {
    pname   = "projectile";
    version = "0.12.0";
    src = fetchFromGitHub {
      owner  = "bbatsov";
      repo   = pname;
      rev    = "v${version}";
      sha256 = "1bl5wpkyv9xlf5v5hzkj8si1z4hjn3yywrjs1mx0g4irmq3mk29m";
    };
    fileSpecs = [ "projectile.el" ];
    packageRequires = [ dash helm pkg-info ];
    meta = { license = gpl3Plus; };
  };
  helm-projectile = melpaBuild rec {
    pname   = "helm-projectile";
    version = projectile.version;
    src     = projectile.src;
    fileSpecs = [ "helm-projectile.el" ];
    packageRequires = [ helm projectile ];
    meta = { license = gpl3Plus; };
  };
  persp-projectile = melpaBuild rec {
    pname   = "persp-projectile";
    version = projectile.version;
    src     = projectile.src;
    fileSpecs = [ "persp-projectile.el" ];
    packageRequires = [ perspective projectile ];
    meta = { license = gpl3Plus; };
  };

  rainbow-delimiters = melpaBuild rec {
    pname = "rainbow-delimiters";
    version = "2.1.1";
    src = fetchFromGitHub {
      owner = "Fanael";
      repo = pname;
      rev = version;
      sha256 = "0gxc8j5a14bc9mp43cbcz41ipc0z1yvmypg52dnl8hadirry20gd";
    };
    meta = {
      description = "Highlight delimiters with colors according to their depth";
      license = gpl3Plus;
    };
  };

  request = melpaBuild rec {
    pname = "request";
    version = "0.2.0";

    src = fetchFromGitHub {
      owner = "tkf";
      repo = "emacs-${pname}";
      rev = "adf7de452f9914406bfb693541f1d280093c4efd";
      sha256 = "0dja4g43zfjbxqvz2cgivgq5sfm6fz1563qgrp4yxknl7bdggb92";
    };

    files = [ "request.el" ];

    meta = {
      description = "Easy HTTP request for Emacs Lisp";
      longDescription = ''
        Request.el is a HTTP request library with multiple backends. It supports
        url.el which is shipped with Emacs and curl command line program. User
        can use curl when s/he has it, as curl is more reliable than url.el.
        Library author can use request.el to avoid imposing external dependencies
        such as curl to users while giving richer experience for users who have curl.
      '';
      license = gpl3Plus;
    };
  };

  request-deferred = melpaBuild rec {
    pname = "request-deferred";
    version = request.version;
    src = request.src;
    packageRequires = [ request deferred ];
    files = [ "request-deferred.el" ];
    meta = request.meta
        // { description = "${request.meta.description} (deferred)"; };
  };

  rich-minority = melpaBuild rec {
    pname   = "rich-minority";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner  = "Bruce-Connor";
      repo   = pname;
      rev    = version;
      sha256 = "0kvhy4mgs9llihwsb1a9n5a85xzjiyiyawxnz0axy2bvwcxnp20k";
    };
    packageRequires = [ dash ];
    meta = {
      description = "Hiding and/or highlighting the list of minor modes in the Emacs mode-line.";
      license = gpl3Plus;
    };
  };

  s = melpaBuild rec {
    pname   = "s";
    version = "20140910";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${pname}.el";
      rev    = "1f85b5112f3f68169ddaa2911fcfa030f979eb4d";
      sha256 = "9d871ea84f98c51099528a03eddf47218cf70f1431d4c35c19c977d9e73d421f";
    };
    meta = { license = gpl3Plus; };
  };

  semi = melpaBuild rec {
    pname = "semi";
    version = "1.14.7"; # 20150203
    src = fetchFromGitHub {
      owner  = "wanderlust";
      repo   = pname;
      rev    = "9976269556c5bcc021e4edf1b0e1accd39929528";
      sha256 = "1g1xg57pz4msd3f998af5gq28qhmvi410faygzspra6y6ygaka68";
    };
    packageRequires = [ apel flim ];
    meta = {
      description = "MIME library for Emacs";
      license = gpl3Plus; # probably
    };
  };

  shorten = melpaBuild rec {
    pname   = "shorten";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    fileSpecs = [ "lisp/shorten*.el" ];
    meta = { license = gpl3Plus; };
  };

  smart-mode-line = melpaBuild rec {
    pname   = "smart-mode-line";
    version = "2.6";
    src = fetchFromGitHub {
      owner  = "Bruce-Connor";
      repo   = pname;
      rev    = version;
      sha256 = "17nav2jbvbd13xzgp29x396mc617n2dh6whjk4wnyvsyv7r0s9f6";
    };
    packageRequires = [ dash rich-minority ];
    meta = { license = gpl3Plus; };
  };

  smartparens = melpaBuild rec {
    pname   = "smartparens";
    version = "1.6.2";
    src = fetchFromGitHub {
      owner  = "Fuco1";
      repo   = pname;
      rev    = version;
      sha256 = "16pzd740vd1r3qfmxia2ibiarinm6xpja0mjv3nni5dis5s4r9gc";
    };
    packageRequires = [ dash ];
    meta = { license = gpl3Plus; };
  };

  smex = melpaBuild rec {
    pname = "smex";
    version = "20141210";
    src = fetchFromGitHub {
      owner  = "nonsequitur";
      repo   = pname;
      rev    = "aff8d4485139ac28f1c7e62912c0d0d480995831";
      sha256 = "0017f1ji7rxad2n49dhn5g0pmw6lmw80cqk6dynszizj46xpbqfp";
    };
    meta = {
      description = "M-x enhancement for Emacs build on top of Ido";
      license = emacs.meta.license; # should be "same as Emacs"
    };
  };

  structured-haskell-mode = melpaBuild rec {
    pname = "shm";
    version = external.structured-haskell-mode.version;
    src = external.structured-haskell-mode.src;
    packageRequires = [ haskell-mode ];
    fileSpecs = [ "elisp/*.el" ];

    meta = {
      description = "Structured editing Emacs mode for Haskell";
      license = bsd3;
      platforms = external.structured-haskell-mode.meta.platforms;
    };
  };

  swiper = melpaBuild rec {
    pname   = "swiper";
    version = "0.5.0";
    src = fetchFromGitHub {
      owner  = "abo-abo";
      repo   = pname;
      rev    = version;
      sha256 = "1a28vignwpcn62xk46w5p5wjfrbcmvs0gz1jgn4ba7ibmn4cmnnm";
    };
    fileSpecs = [ "swiper.el" "ivy.el" "colir.el" "counsel.el" ];
    meta = { license = gpl3Plus; };
  };

  switch-window = melpaBuild rec {
    pname   = "switch-window";
    version = "20140919";
    src = fetchFromGitHub {
      owner  = "dimitri";
      repo   = pname;
      rev    = "3ffbe68e584f811e891f96afa1de15e0d9c1ebb5";
      sha256 = "09221128a0f55a575ed9addb3a435cfe01ab6bdd0cca5d589ccd37de61ceccbd";
    };
    meta = { license = gpl3Plus; };
  };

  tracking = melpaBuild rec {
    pname   = "tracking";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    packageRequires = [ shorten ];
    fileSpecs = [ "lisp/tracking*.el" ];
    meta = { license = gpl3Plus; };
  };

  tuareg = melpaBuild rec {
    pname = "tuareg";
    version = "2.0.9";
    src = fetchFromGitHub {
      owner  = "ocaml";
      repo   = pname;
      rev    = version;
      sha256 = "1j2smhqrwy0zydhbyjkpnwzq05fgfa85kc0d9kzwq0mppdndspp4";
    };
    packageRequires = [ caml ];
    meta = { license = gpl3Plus; };
  };

  undo-tree = melpaBuild rec {
    pname   = "undo-tree";
    version = "0.6.4";
    src = fetchgit {
      url    = "http://www.dr-qubit.org/git/${pname}.git";
      rev    = "a3e81b682053a81e082139300ef0a913a7a610a2";
      sha256 = "1qla7njkb7gx5aj87i8x6ni8jfk1k78ivwfiiws3gpbnyiydpx8y";
    };
    meta = { license = gpl3Plus; };
  };

  use-package = melpaBuild rec {
    pname   = "use-package";
    version = "20150317";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = pname;
      rev    = "b836266ddfbc835efdb327ecb389ff9e081d7c55";
      sha256 = "187wnqqm5g43cg8b6a9rbd9ncqad5fhjb96wjszbinjh1mjxyh7i";
    };
    packageRequires = [ bind-key diminish ];
    files = [ "use-package.el" ];
    meta = { license = gpl3Plus; };
  };

  volatile-highlights = melpaBuild rec {
    pname   = "volatile-highlights";
    version = "1.11";
    src = fetchFromGitHub {
      owner  = "k-talo";
      repo   = "${pname}.el";
      rev    = "fb2abc2d4d4051a9a6b7c8de2fe7564161f01f24";
      sha256 = "1v0chqj5jir4685jd8ahw86g9zdmi6xd05wmzhyw20rbk924fcqf";
    };
    meta = { license = gpl3Plus; };
  };

  wanderlust = melpaBuild rec {
    pname = "wanderlust";
    version = "2.15.9"; # 20150301
    src = fetchFromGitHub {
      owner  = pname;
      repo   = pname;
      rev    = "13fb4f6519490d4ac7138f3bcf76707654348071";
      sha256 = "1l48xfcwkm205prspa1rns6lqfizik5gpdwmlfgyb5mabm9x53zn";
    };
    packageRequires = [ apel flim semi ];
    fileSpecs = [
      "doc/wl.texi" "doc/wl-ja.texi"
      "elmo/*.el" "wl/*.el"
      "etc/icons"
    ];
    meta = {
      description = "E-Mail client for Emacs";
      license = gpl3Plus; # probably
    };
  };

  web-mode = melpaBuild rec {
    pname   = "web-mode";
    version = "11.1.12";
    src = fetchFromGitHub {
      owner  = "fxbois";
      repo   = pname;
      rev    = "67259f16bfaec5c006a53533b8feeba7771e1365";
      sha256 = "16zcnwm7wnbl1xbsx7rr5rr697ax141akfx2lknwirx18vqmkijj";
    };

    meta = {
      description = "Web template editing mode for emacs";
      license = gpl2;
    };
  };

  weechat = melpaBuild rec {
    pname   = "weechat.el";
    version = "0.2.2";
    src = fetchFromGitHub {
      owner  = "the-kenny";
      repo   = pname;
      rev    = version;
      sha256 = "0f90m2s40jish4wjwfpmbgw024r7n2l5b9q9wr6rd3vdcwks3mcl";
    };
    postPatch = lib.optionalString (!stdenv.isLinux) ''
      rm weechat-sauron.el weechat-secrets.el
    '';
    packageRequires = [ s ];
    meta = { license = gpl3Plus; };
  };

  wgrep = melpaBuild rec {
    pname   = "wgrep";
    version = "20141017";
    src = fetchFromGitHub {
      owner  = "mhayashi1120";
      repo   = "Emacs-wgrep";
      rev    = "7ef26c51feaef8a5ec0929737130ab8ba326983c";
      sha256 = "075z0glain0dp56d0cp468y5y88wn82ab26aapsrdzq8hmlshwn4";
    };
    meta = { license = gpl3Plus; };
  };

  zenburn-theme = melpaBuild rec {
    pname   = "zenburn-theme";
    version = "2.2";
    src = fetchFromGitHub {
      owner  = "bbatsov";
      repo   = "zenburn-emacs";
      rev    = "v${version}";
      sha256 = "1zspqpwgyv3969irg8p7zj3g4hww4bmnlvx33bvjyvvv5c4mg5wv";
    };
    meta = { license = gpl3Plus; };
  };


}; in self

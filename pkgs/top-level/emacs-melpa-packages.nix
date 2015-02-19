{ pkgs, stdenv, fetchurl, fetchFromGitHub, fetchgit
, emacs, texinfo

# non-emacs packages
, external
}:

# package.el-based emacs packages

## init.el
# (require 'package)
# (setq package-archives nil
#       package-user-dir "~/.nix-profile/share/emacs/site-lisp/elpa")
# (package-initialize)

with stdenv.lib.licences;

let
  melpaBuild = import ../build-support/melpa {
    inherit stdenv fetchurl emacs texinfo;
  };
in

rec {
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
      platforms = stdenv.lib.platforms.all;
    };
  };

  bind-key = melpaBuild {
    pname   = "bind-key";
    version = "20141013";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = "use-package";
      rev    = "d43af5e0769a92f77e01dea229e376d9006722ef";
      sha256 = "1m4v5h52brg2g9rpbqfq9m3m8fv520vg5mjwppnbw6099d17msqd";
    };
    files = [ "bind-key.el" ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  company = melpaBuild rec {
    pname   = "company";
    version = "0.8.6";
    src = fetchFromGitHub {
      owner  = "company-mode";
      repo   = "company-mode";
      rev    = version;
      sha256 = "1xwxyqg5dan8m1qkdxyzm066ryf24h07karpdlm3s09izfdny33f";
    };
    meta = { licence = gpl3Plus; };
  };

  dash = melpaBuild rec {
    pname   = "dash";
    version = "2.9.0";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${pname}.el";
      rev    = version;
      sha256 = "1lg31s8y6ljsz6ps765ia5px39wim626xy8fbc4jpk8fym1jh7ay";
    };
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  evil = melpaBuild {
    pname   = "evil";
    version = "20141020";
    src = fetchgit {
      url = "git://gitorious.org/evil/evil";
      rev = "999ec15587f85100311c031aa8efb5d50c35afe4";
      sha256 = "0yiqpzsm5sr7xdkixdvfg312dk9vsdcmj69gizk744d334yn8rsz";
    };
    packageRequires = [ goto-chg undo-tree ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  flycheck = melpaBuild rec {
    pname   = "flycheck";
    version = "0.20";
    src = fetchFromGitHub {
      owner  = pname;
      repo   = pname;
      rev    = version;
      sha256 = "0cq7y7ssm6phvx5pfv2yqq4j0yqmm0lhjav7v4a8ql7094cd790a";
    };
    packageRequires = [ dash pkg-info ];
    meta = { licence = gpl3Plus; };
  };

  ghc-mod = melpaBuild rec {
    pname = "ghc";
    version = external.ghc-mod.version;
    src = external.ghc-mod.src;
    fileSpecs = [ "elisp/*.el" ];
    meta = { licence = bsd3; };
  };

  git-commit-mode = melpaBuild rec {
    pname = "git-commit-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "git-commit-mode.el" ];
    meta = { licence = gpl3Plus; };
  };

  git-rebase-mode = melpaBuild rec {
    pname = "git-rebase-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "git-rebase-mode.el" ];
    meta = { licence = gpl3Plus; };
  };

  gitattributes-mode = melpaBuild rec {
    pname = "gitattributes-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "gitattributes-mode.el" ];
    meta = { licence = gpl3Plus; };
  };

  gitconfig-mode = melpaBuild rec {
    pname = "gitconfig-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "gitconfig-mode.el" ];
    meta = { licence = gpl3Plus; };
  };

  gitignore-mode = melpaBuild rec {
    pname = "gitignore-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "gitignore-mode.el" ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  goto-chg = melpaBuild rec {
    pname   = "goto-chg";
    version = "1.6";
    src = fetchgit {
      url = "git://gitorious.org/evil/evil";
      rev = "999ec15587f85100311c031aa8efb5d50c35afe4";
      sha256 = "0yiqpzsm5sr7xdkixdvfg312dk9vsdcmj69gizk744d334yn8rsz";
    };
    files = [ "lib/goto-chg.el" ];
    meta = { licence = gpl3Plus; };
  };

  haskell-mode = melpaBuild rec {
    pname   = "haskell-mode";
    version = "20150101";
    src = fetchFromGitHub {
      owner  = "haskell";
      repo   = pname;
      rev    = "0db5efaaeb3b22e5a3fdafa600729e14c1716ee2";
      sha256 = "0d63cgzj579cr8zbrnl0inyy35b26sxinqxr7bgrjsngpmhm52an";
    };
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  idris-mode = melpaBuild rec {
    pname   = "idris-mode";
    version = "0.9.15";
    src = fetchFromGitHub {
      owner  = "idris-hackers";
      repo   = "idris-mode";
      rev    = version;
      sha256 = "00pkgk1zxan89i8alsa2dpa9ls7imqk5zb1kbjwzrlbr0gk4smdb";
    };
    packageRequires = [ flycheck ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  magit = melpaBuild rec {
    pname   = "magit";
    version = "20141025";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "magit";
      rev    = "50c08522c8a3c67e0f3b821fe4df61e8bd456ff9";
      sha256 = "0mzyx72pidzvla1x2qszn3c60n2j0n8i5k875c4difvd1n4p0vsk";
    };
    packageRequires = [ git-commit-mode git-rebase-mode ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  org-plus-contrib = melpaBuild rec {
    pname   = "org-plus-contrib";
    version = "20141020";
    src = fetchurl {
      url    = "http://orgmode.org/elpa/${pname}-${version}.tar";
      sha256 = "02njxmdbmias2f5psvwqc115dyakcwm2g381gfdv8qz4sqav0r77";
    };
    buildPhase = ''
      cp $src ${pname}-${version}.tar
    '';
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  popup = melpaBuild rec {
    pname   = "popup";
    version = "0.5.0";
    src = fetchFromGitHub {
      owner  = "auto-complete";
      repo   = "${pname}-el";
      rev    = "v${version}";
      sha256 = "0836ayyz1syvd9ry97ya06l8mpr88c6xbgb4d98szj6iwbypcj7b";
    };
    meta = { licence = gpl3Plus; };
  };

  projectile = melpaBuild rec {
    pname   = "projectile";
    version = "20141020";
    src = fetchFromGitHub {
      owner  = "bbatsov";
      repo   = pname;
      rev    = "13580d83374e0c17c55b3a680b816dfae407657e";
      sha256 = "10c28h2g53sg68lwamhak0shdhh26h5xaipipz3n4281sr1fwg58";
    };
    packageRequires = [ dash helm s pkg-info epl ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  structured-haskell-mode = melpaBuild rec {
    pname = "shm";
    version = external.structured-haskell-mode.version;
    src = external.structured-haskell-mode.src;
    packageRequires = [ haskell-mode ];
    fileSpecs = [ "elisp/*.el" ];

    meta = {
      homepage = "https://github.com/chrisdone/structured-haskell-mode";
      description = "Structured editing Emacs mode for Haskell";
      license = bsd3;
      platforms = external.structured-haskell-mode.meta.platforms;
    };
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
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  undo-tree = melpaBuild rec {
    pname   = "undo-tree";
    version = "0.6.4";
    src = fetchgit {
      url    = "http://www.dr-qubit.org/git/${pname}.git";
      rev    = "a3e81b682053a81e082139300ef0a913a7a610a2";
      sha256 = "1qla7njkb7gx5aj87i8x6ni8jfk1k78ivwfiiws3gpbnyiydpx8y";
    };
    meta = { licence = gpl3Plus; };
  };

  use-package = melpaBuild rec {
    pname   = "use-package";
    version = "20141013";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = pname;
      rev    = "d43af5e0769a92f77e01dea229e376d9006722ef";
      sha256 = "1m4v5h52brg2g9rpbqfq9m3m8fv520vg5mjwppnbw6099d17msqd";
    };
    packageRequires = [ bind-key diminish ];
    files = [ "use-package.el" ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };

  weechat = melpaBuild rec {
    pname   = "weechat.el";
    version = "20141016";
    src = fetchFromGitHub {
      owner  = "the-kenny";
      repo   = pname;
      rev    = "4cb2ced1eda5167ce774e04657d2cd077b63c706";
      sha256 = "003sihp7irm0qqba778dx0gf8xhkxd1xk7ig5kgkryvl2jyirk28";
    };
    postPatch = stdenv.lib.optionalString (!stdenv.isLinux) ''
      rm weechat-sauron.el weechat-secrets.el
    '';
    packageRequires = [ s ];
    meta = { licence = gpl3Plus; };
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
    meta = { licence = gpl3Plus; };
  };
}

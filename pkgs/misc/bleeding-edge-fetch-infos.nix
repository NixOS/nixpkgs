{ # Warning, this file is updated automatically by nix-repository-manager
  # which will add or replace exsiting attribute sets only
  # new items will be added before the last line, 4 lines will be removed when
  # replacing always, matched by "name ="

  cabal = args: with args; fetchurl { # Thu Aug 21 09:07:56 UTC 2008
    url = http://mawercer.de/~nix/repos/cabal.tar.gz;
    sha256 = "2c370636ef30593325b1c01eed37eb0e993923acb6387724d97a5eed51b00887";
  };
  getOptions = args: with args; fetchurl { # Thu Jul  9 23:31:53 CEST 2009
    url = "http://mawercer.de/~nix/repos/getOptions-nrmtag1.tar.gz";
    sha256 = "5ec39b43a58a507ed3652bc53d57d9b785a6fbb72a8824b951590e076c704589";
  };
  ghc_lambdavm = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/ghc_lambdavm.tar.gz;
    sha256 = "3d10e839b8226987383e870258ff38b56442ff254688f7c50983850676f992cb";
  };
  git = args: with args; fetchurl { # Tue Jan 20 22:28:04 UTC 2009
    url = "http://mawercer.de/~nix/repos/git-a227bce65f3fcdfbf28f109809b7e2e518b906f8.tar.gz";
    sha256 = "7420a385718c7edec956fb0cba1a8a11d4b45edc833d7c06bf7c4764188ce180";
  };
  happs_data = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_data.tar.gz;
    sha256 = "084c5a3ddb8393fd41679ad7e87e6057b3434556b3508e062175edbcd8fb1cac";
  };
  happs_hsp = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_hsp.tar.gz;
    sha256 = "cc4df8509468ec83e3f448bb1e1fe5cb7e1f2408851861df31f139778e3c8cc8";
  };
  happs_hsp_template = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_hsp_template.tar.gz;
    sha256 = "b41336352ab878c1342c872e82354de1853366ddaf3abeb213ccad073052c9ac";
  };
  happs_ixset = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_ixset.tar.gz;
    sha256 = "c3972895d312256f0b126cead4a425bbf8d310af4ef3040708e64a614488b263";
  };
  happs_plugins = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_plugins.tar.gz;
    sha256 = "0ecb644e0ab07b719c54ffb67185302575feafd9dd747ac16ffc7428521be8e9";
  };
  happs_server = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_server.tar.gz;
    sha256 = "5170e7a1f725809615a90cabac11fbdb3d23b57d6684db3786b24b2de87d6fb5";
  };
  happs_state = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_state.tar.gz;
    sha256 = "29f3e5a857a9eda66cf55257cbd2daf00a9fa5921cadeb90db5b2d8e2aa1ecfd";
  };
  happs_util = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/happs_util.tar.gz;
    sha256 = "799de3edbac7f408ab5f4129702a75926903f9ebc43bf4ae11b5af214d051e43";
  };
  haskellnet = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/haskellnet.tar.gz;
    sha256 = "fde6f79b09d6cfbc6021aed9fa54ed186715a6eaacd4634f07554d4d3777f70d";
  };
  haskell__exts = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/haskell__exts.tar.gz;
    sha256 = "6cb2214ee3a62083325c907e47979b5fdf6809ce0ef2cd400fba0219b3f42090";
  };
  hjavascript = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hjavascript.tar.gz;
    sha256 = "fcf76a344eda3afca9b87f8e8ae1d343953b1bdda5da062f887a47f7d5a3c0da";
  };
  hjquery = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hjquery.tar.gz;
    sha256 = "32691467d83acd73f733c695266fbeeb4978ee43f4380d3b3554350bfb7cbb0e";
  };
  hjscript = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hjscript.tar.gz;
    sha256 = "fba290645b5ada63030143137d653d34ca5874660e8ab31072a76a57933dfce2";
  };
  hsc2hs = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hsc2hs.tar.gz;
    sha256 = "3179eba85e56f30250793dbb612ffb8ad869e37297a185c2e0fb29134afb73af";
  };
  hsjava = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hsjava.tar.gz;
    sha256 = "952839e53f63fc43c7c8a760bab97d150c504e148ebdd407be5e642661ed048f";
  };
  hspCgi = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hspCgi.tar.gz;
    sha256 = "87bd8cb7e3ccad0147c36ce7af0f3089684b739f4149376821e258445b83f7b6";
  };
  hsp = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hsp.tar.gz;
    sha256 = "bfaf83e5eff20226f9602c7889462f86d176b673b1cf677c280aeabb6dd560a3";
  };
  hsp_xml = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hsp_xml.tar.gz;
    sha256 = "203efdd5ec3784be0b1580569e56f278e102c2275350934a3b2ee4850b7ee34f";
  };
  hsql = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hsql.tar.gz;
    sha256 = "9856e6811a4fc78bf55a1c4bb08091075a343995696b7026a0ef0dae91abc99a";
  };
  hsutils = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hsutils.tar.gz;
    sha256 = "6d1cc9881fb2684016e52d3ab8e6666c5396da168eb298c3a549294668f6aa52";
  };
  http = args: with args; fetchurl { # Thu Aug 21 09:04:57 UTC 2008
    url = http://mawercer.de/~nix/repos/http.tar.gz;
    sha256 = "3166d17951bd5a052c059e161cd3f44afdb2b6a329c49b645f9cfdccda416d37";
  };
  hypertable = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/hypertable.tar.gz;
    sha256 = "d8a385def778d817415a6dd9d7ce10a60525c3c4a4d4dd8ec3bd8cfd359d2ab4";
  };
  libnih = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/libnih.tar.gz;
    sha256 = "443c7af0363d1fb3b040d1903ff28cbd520c9f32634bff639263b8315b293acc";
  };
  mkcabal = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/mkcabal.tar.gz;
    sha256 = "9f231756c36b46d29516ed327a320837194799a76de4833dc6a5c88e5ccd1658";
  };
  nix_repository_manager = args: with args; fetchurl { # Sun Sep  6 16:46:13 CEST 2009
    url = "http://mawercer.de/~nix/repos/nix_repository_manager-nrmtag6.tar.gz";
    sha256 = "6c5daa1b320ada16ce7e8c2279ab3a27726e23fa3c1115f8c0bbd64ff806c7b7";
  };
  plugins = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/plugins.tar.gz;
    sha256 = "33206e33258b64fbb077291cd1f5f20629c6129c5541c177e51074a3082f59fa";
  };
  syb_with_class = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/syb_with_class.tar.gz;
    sha256 = "f67c979bb980e69856f26f89b9bdcb5cf962e4db0b1fb859f53928c2d6b45f5b";
  };
  synergy = args: with args; fetchurl { # Mon Mar 30 10:08:36 CEST 2009
    url = "http://mawercer.de/~nix/repos/synergy-F_10-08-35.tar.gz";
    sha256 = "764b88b69f342017094380f62099f4a0dfdcddb6a289abb6b646f7ac2f37d675";
  };
  takusen = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/takusen.tar.gz;
    sha256 = "35f3dbededae1a8d3bf648b229cbaf983907ff762b80674a65505f13c44147df";
  };
  upstart = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/upstart.tar.gz;
    sha256 = "3243857ce4e0cd0d6fe28dbdcaa294b5590befed79b54a306b40cb5c65b381db";
  };
  haxml = args: with args; fetchurl { # Wed Aug 20 23:33:52 UTC 2008
    url = http://mawercer.de/~nix/repos/haxml.tar.gz;
    sha256 = "71ab127d11c06781fa62e76eda12fe979227c89e767961740222ab2f3a912cbe";
  };
  haskell_src_exts = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/haskell_src_exts.tar.gz;
    sha256 = "6cb2214ee3a62083325c907e47979b5fdf6809ce0ef2cd400fba0219b3f42090";
  };
  storableVector = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/storableVector.tar.gz;
    sha256 = "ce7ac7973e12ff92ceb371b95fc74430c7870f0fc27ae02fad4792b1643653b6";
  };
  kdesupport_akode = args: with args; fetchurl { # Wed Aug 13 15:09:07 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_akode.tar.gz;
    sha256 = "9fb2a363c3331fe67cc3bddcc430df30f8f1b9869ec7673fb97ecb18313ef710";
  };
  kdesupport_eigen = args: with args; fetchurl { # Wed Aug 13 15:28:37 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_eigen.tar.gz;
    sha256 = "25854580e5fcb222e6463cf02802e5160ca0e037d9f86bee4b5edf22d8161607";
  };
  kdesupport_gmm = args: with args; fetchurl { # Wed Aug 13 15:09:46 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_gmm.tar.gz;
    sha256 = "70faafe70e0eac747f6ffa47cebd537c6bda7509739d634a0c49cb85bc797668";
  };
  kdesupport_qca = args: with args; fetchurl { # Wed Aug 13 15:10:38 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_qca.tar.gz;
    sha256 = "ca0d8c0ffdec7b81a3d3574e8d16fd423f8a42a9793ecd8d2997671a48c8d62b";
  };
  kdesupport_qimageblitz = args: with args; fetchurl { # Wed Aug 13 14:55:54 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_qimageblitz.tar.gz;
    sha256 = "25e31db3fdd73f97dda82a071031b766ecbacf583924ed1d8af7418bf408204d";
  };
  kdesupport_soprano = args: with args; fetchurl { # Wed Aug 13 14:59:54 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_soprano.tar.gz;
    sha256 = "4a3a6ff41d29b7efb1fe9b80db232579f76cc683b18a95f45d6f2bda9bb25800";
  };
  kdesupport_strigi = args: with args; fetchurl { # Wed Aug 13 15:00:49 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_strigi.tar.gz;
    sha256 = "77ff3345a49ffdcc57f3fca48c20b751967a18db9d0ee3922dca7c20ff2f400f";
  };
  kdesupport_taglib = args: with args; fetchurl { # Wed Aug 13 15:01:45 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_taglib.tar.gz;
    sha256 = "ae6c92e2ed40bec330f764d7549e7d200477ba1e3126dba41539225b3a9ad13a";
  };
  kdesupport_akonadi = args: with args; fetchurl { # Wed Aug 13 15:11:30 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_akonadi.tar.gz;
    sha256 = "a845ed8e82e9545de9ac2a086e510d0ad81efccd068a677a928c25f5f6481ece";
  };
  kdesupport_automoc = args: with args; fetchurl { # Wed Aug 13 15:28:25 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_automoc.tar.gz;
    sha256 = "b40161ec6dd1ef040a488a6926bd75d54b0230025b03df9fde8fd2207882aae7";
  };
  kdesupport_cpptoxml = args: with args; fetchurl { # Wed Aug 13 15:11:49 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_cpptoxml.tar.gz;
    sha256 = "8c4909dc0f57a337d07d3d3d365baeecd021f41705a2998ba6d3ff8d992b6a09";
  };
  kdesupport_decibel = args: with args; fetchurl { # Wed Aug 13 15:12:09 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_decibel.tar.gz;
    sha256 = "76f98fb2f020ec5ba2f8017c54e0db392a8f660e1d9ddb20f6125f5feab1caff";
  };
  kdesupport_emerge = args: with args; fetchurl { # Wed Aug 13 15:12:30 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_emerge.tar.gz;
    sha256 = "acfce47b2cbb3b7af864ec8dd7df664d2cb8b4cbf6484e91adc912562422bfa6";
  };
  kdesupport_phonon = args: with args; fetchurl { # Wed Aug 13 15:13:48 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_phonon.tar.gz;
    sha256 = "36e8fc19ab376991cd820143994900c976b5a3d4905923eee56d8b153083bdd2";
  };
  kdesupport_tapioca_qt = args: with args; fetchurl { # Wed Aug 13 15:13:50 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_tapioca_qt.tar.gz;
    sha256 = "9d313cdd685c6532b6052adc63a51a89a10aae5c5648d71e93e3d4eed8af8c0f";
  };
  kdesupport_telepathy_qt = args: with args; fetchurl { # Wed Aug 13 15:13:52 UTC 2008
    url = http://mawercer.de/~nix/repos/kdesupport_telepathy_qt.tar.gz;
    sha256 = "022599182ff629662bbd01acdea6ead9aec64b3e73e8da3eb58ef857803035f2";
  };
  cinelerra = args: with args; fetchurl { # Tue Oct 14 12:36:49 UTC 2008
    url = "http://mawercer.de/~nix/repos/cinelerra-9f9adf2ad5472886d5bc43a05c6aa8077cabd967.tar.gz";
    sha256 = "1e84ff59dcd7a3c80343eb9be302f822e510c95398fd1a6c8f2e4b163fd51e45";
  };
  hg2git = args: with args; fetchurl { # Tue Jan 20 22:49:27 UTC 2009
    url = "http://mawercer.de/~nix/repos/hg2git-0fabb998a19c850cb8fcfcf72414b18070d94378.tar.gz";
    sha256 = "ce7cd089681e6eee24f5bc9ab3b73f1e49d368b83a32d00695eadca00533ac5d";
  };
 octave = args: with args; fetchurl { # Mon Dec  1 23:23:49 UTC 2008
   url = "http://mawercer.de/~nix/repos/octave-03b414516dd8.tar.gz";
   sha256 = "28ca0be1407954e746909241bda95c5bf0a04f611e73100c1e3967ddc249c519";
 };
  zsh = args: with args; fetchurl { # Sun Dec 21 12:50:24 UTC 2008
    url = "http://mawercer.de/~nix/repos/zsh-2008-12-21_12-50-23.tar.gz";
    sha256 = "9af16f89205759d7ade51268dbdfa02cec3db10b35dc7a56ffe8e1fde2074ae7";
  };
  topGit = args: with args; fetchurl { # Sat Sep 26 02:02:43 CEST 2009
    url = "http://mawercer.de/~nix/repos/topGit-f59e4f9e87e5f485fdaee0af002edd2105fa298a.tar.gz";
    sha256 = "04e3c5e60570f414c1d2ee9ed64b80362b1958ebbac7d5c235cce17e9a339c94";
  };
  qgit = args: with args; fetchurl { # Tue Jan 20 21:35:00 UTC 2009
    url = "http://mawercer.de/~nix/repos/qgit-b5dd5fd691e9423124cf356abe26e641bc33d159.tar.gz";
    sha256 = "e04de308feb40716a6b02d1f69dc834f4fa859865b64e8f91beb6018fa953f96";
  };
  autofs = args: with args; fetchurl { # Thu Apr 30 04:42:28 CEST 2009
    url = "http://mawercer.de/~nix/repos/autofs-9a77464b8a661d33a6205756955e0047727d5c1f.tar.gz";
    sha256 = "0260817c5deb87210a4cea340d0ef0f35577ef14f37bd7da05a2f08be385ac2f";
  };
  ctags = args: with args; fetchurl { # Thu May  7 20:12:55 CEST 2009
    url = "http://mawercer.de/~nix/repos/ctags-703.tar.gz";
    sha256 = "3f897b303f446aa8b52832d2aef280d359979bb2cd8768a2e70b6475adc64d61";
  };
  sqlalchemy05 = args: with args; fetchurl { # Fri Jun 26 00:00:40 CEST 2009
    url = "http://mawercer.de/~nix/repos/sqlalchemy05-6076.tar.gz";
    sha256 = "7baad2cda5a61bcbc4093a6026727d69bc7bd7c0399e25e479eaa2e2000f69b1";
  };
  sqlalchemyMigrate = args: with args; fetchurl { # Fri Jun 26 00:22:43 CEST 2009
    url = "http://mawercer.de/~nix/repos/sqlalchemyMigrate-569.tar.gz";
    sha256 = "7775d9bf7e25a8270ac112d9b1d916a36691a73beb9a87a6473d005d3ee0f0bf";
  };
  ghc_syb = args: with args; fetchurl { # Thu Jul  9 23:41:34 CEST 2009
    url = "http://mawercer.de/~nix/repos/ghc_syb-876b121e73f1b5ca4b17b0c6908b27ba7efb0374.tar.gz";
    sha256 = "325a19962e90dc5fb07845d2ac4df6e332061cda4b8950b95bcb782706ed3e31";
  };
  pywebcvs = args: with args; fetchurl { # Wed Aug 12 15:00:25 CEST 2009
    url = "http://mawercer.de/~nix/repos/pywebcvs-1493.tar.gz";
    sha256 = "4183b18f48738cf607ef29baae75f7edec46504d1fb31bdedfbc897dcadbe599";
  };
  MPlayer = args: with args; fetchurl { # Sun Sep  6 16:46:45 CEST 2009
    url = "http://mawercer.de/~nix/repos/MPlayer-29652.tar.gz";
    sha256 = "c202a43041d753b78777c3bb22a60068626b8a8aaf59f1d2cd054844a7c8546b";
  };
  netsurf = args: with args; fetchurl { # Tue Oct 27 17:37:11 CET 2009
    url = "http://mawercer.de/~nix/repos/netsurf-9654.tar.gz";
    sha256 = "cf0cf1d6283e331174b5377cf0e458756987b99a8264807c567cc06ece501880";
  };
  libCSS = args: with args; fetchurl { # Tue Oct 27 17:35:11 CET 2009
    url = "http://mawercer.de/~nix/repos/libCSS-9654.tar.gz";
    sha256 = "a9ee85fcbba00543a634037f793f16ba1b8f02535fbfa6c2dfed074309ccc7a6";
  };
  libwapcaplet = args: with args; fetchurl { # Tue Oct 27 17:37:04 CET 2009
    url = "http://mawercer.de/~nix/repos/libwapcaplet-9654.tar.gz";
    sha256 = "471c13e0e5ac58c27e17261116401c3aba7760d3012ac878fe90a1c6cb5b3383";
  };
  libsvgtiny = args: with args; fetchurl { # Tue Oct 27 17:36:54 CET 2009
    url = "http://mawercer.de/~nix/repos/libsvgtiny-9654.tar.gz";
    sha256 = "250a1e1f7d53b3d211910edadf478147ae52c4c136a7763fb8df54cd7a296c2b";
  };
  libdom = args: with args; fetchurl { # Tue Oct 27 17:35:49 CET 2009
    url = "http://mawercer.de/~nix/repos/libdom-9654.tar.gz";
    sha256 = "31a002dcb68550d061c343eda146dd8578fc33121ee6f3a3c0920faaa28ee26e";
  };
  netsurf_haru = args: with args; fetchurl { # Tue Oct 27 17:38:50 CET 2009
    url = "http://mawercer.de/~nix/repos/netsurf_haru-9654.tar.gz";
    sha256 = "ca8fcdcbcb1e4007742d2214adf2eaa49829e988b6d9f0fe74108ca18e487d3b";
  };
  git_fast_export = args: with args; fetchurl { # Mon Oct 26 07:16:34 CET 2009
    url = "http://mawercer.de/~nix/repos/git_fast_export-1464dabbff7fe42b9069e98869db40276d295ad6.tar.gz";
    sha256 = "4d99bf7eefe86dd3305fc5ce27581830fc7dfe10f66ff5c5da054f737704b0bd";
  };
  haxe = args: with args; fetchurl { # Fri Nov 27 00:39:37 CET 2009
    url = "http://mawercer.de/~nix/repos/haxe-F_00-39-37.tar.gz";
    sha256 = "7c5f275568b1a5ce7b672bfad232696004e5b6607f3767bbfe8c32880d6583b1";
  };
  haxe_extc = args: with args; fetchurl { # Fri Nov 27 00:39:38 CET 2009
    url = "http://mawercer.de/~nix/repos/haxe_extc-F_00-39-38.tar.gz";
    sha256 = "78800c67ecc328fd5358ebdbf561189f40125238f3f35045eb8b5416e77fc115";
  };
  haxe_extlib_dev = args: with args; fetchurl { # Fri Nov 27 00:39:39 CET 2009
    url = "http://mawercer.de/~nix/repos/haxe_extlib_dev-F_00-39-39.tar.gz";
    sha256 = "383044c91d39585e960c416b9c2eeaaa3f89613171662cb78dcb75fe6fe918b7";
  };
  haxe_neko_include = args: with args; fetchurl { # Fri Nov 27 00:39:40 CET 2009
    url = "http://mawercer.de/~nix/repos/haxe_neko_include-F_00-39-40.tar.gz";
    sha256 = "efbb4ce93d01a649b2d32e46c4a0e1fb016d104a136cd428b8cc1704b4ab3dc7";
  };
  haxe_swflib = args: with args; fetchurl { # Fri Nov 27 00:39:45 CET 2009
    url = "http://mawercer.de/~nix/repos/haxe_swflib-F_00-39-45.tar.gz";
    sha256 = "05ae9c8006b2ffac91794c13db7189b5f21687a4afe0d1358fd3681be18705ba";
  };
  haxe_xml_light = args: with args; fetchurl { # Fri Nov 27 00:39:46 CET 2009
    url = "http://mawercer.de/~nix/repos/haxe_xml_light-F_00-39-46.tar.gz";
    sha256 = "b23004c09d5e76b76de5a1938333c1aaccf059ebe62ad25728a267df79069a43";
  };
}

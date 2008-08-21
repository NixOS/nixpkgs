{ # Warning, this file is updated automatically by nix-repository-manager
  # which will add or replace exsiting attribute sets only
  # new items will be added before the last line, 4 lines will be removed when
  # replacing always, matched by "name ="

  cabal = args: with args; fetchurl { # Thu Aug 21 09:07:56 UTC 2008
    url = http://mawercer.de/~nix/repos/cabal.tar.gz;
    sha256 = "2c370636ef30593325b1c01eed37eb0e993923acb6387724d97a5eed51b00887";
  };
  getOptions = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/getOptions.tar.gz;
    sha256 = "6475f2e5762cee2b8544d051c2b831ed5bd22a5711eca86fd6e0f0e95ac8b8b0";
  };
  ghc_lambdavm = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/ghc_lambdavm.tar.gz;
    sha256 = "3d10e839b8226987383e870258ff38b56442ff254688f7c50983850676f992cb";
  };
  git = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/git.tar.gz;
    sha256 = "1f0df3da8d6c9425ab80bd9c623570b7a35e5a622fbf56b903e1bf82a01d4e5f";
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
  nix_repository_manager = args: with args; fetchurl { # Tue Aug 19 13:26:08 UTC 2008
    url = http://mawercer.de/~nix/repos/nix_repository_manager.tar.gz;
    sha256 = "8eb43825b7336af95544626c558920a809d043d7417da294d36166df526e57ca";
  };
  plugins = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/plugins.tar.gz;
    sha256 = "33206e33258b64fbb077291cd1f5f20629c6129c5541c177e51074a3082f59fa";
  };
  syb_with_class = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/syb_with_class.tar.gz;
    sha256 = "f67c979bb980e69856f26f89b9bdcb5cf962e4db0b1fb859f53928c2d6b45f5b";
  };
  synergy = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/synergy.tar.gz;
    sha256 = "c86dde2f10e7071d823cff542ea6c98a7e29a45e4909034edbd7605caa775a47";
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
}

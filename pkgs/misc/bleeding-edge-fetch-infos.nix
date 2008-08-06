{ cabal = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/cabal.tar.gz;
    sha256 = "33bdbe8f0c213dcc28da88a2775f81f72e89209806e26b412699220c3db206ec";
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
  http = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/http.tar.gz;
    sha256 = "3e463fa090c6a7ddb06e88b592b1788a216db7eaf9384850b6d462217ba5be62";
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
  nix_repository_manager = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/nix_repository_manager.tar.gz;
    sha256 = "449065f8411c5628b9fe88445601558dfd9a5f87b1703df9465838ef0afb9d34";
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
  haxml = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/haxml.tar.gz;
    sha256 = "916bc2c4f3d24c0d99ac771f503a6c5eb96d98b656274ab358c7383c606d27f0";
  };
  haskell_src_exts = args: with args; fetchurl {
    url = http://mawercer.de/~nix/repos/haskell_src_exts.tar.gz;
    sha256 = "6cb2214ee3a62083325c907e47979b5fdf6809ce0ef2cd400fba0219b3f42090";
  };
}

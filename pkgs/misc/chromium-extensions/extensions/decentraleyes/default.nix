{ stdenv, pkgs, buildChromiumExtension }:
with stdenv.lib;
buildChromiumExtension rec {
  pname = "decentraleyes";
  version = "2.0.14";

  src = pkgs.fetchgit {
    url = "https://git.synz.io/Synzvato/decentraleyes.git";
    rev = "v${version}";
    sha256 = "01bmhhj3yhfy8jad0qrdkjdqipr2vsxzwnx73w6p9kv9vrg8m2pi";
  };

  meta = {
    description = "Protects you against tracking through \"free\", centralized, content delivery";
    homepage = "https://decentraleyes.org/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ryneeverett ];
  };
}

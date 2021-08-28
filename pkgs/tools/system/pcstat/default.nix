{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage {
  pname = "pcstat-unstable";
  version = "2017-05-28";

  goPackagePath = "github.com/tobert/pcstat";

  src = fetchFromGitHub {
    rev    = "91a7346e5b462a61e876c0574cb1ba331a6a5ac5";
    owner  = "tobert";
    repo   = "pcstat";
    sha256 = "88853e42d16c05e580af4fb8aa815a84ea0fc43e3a25e19c85e649a5f5a2874c";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Page Cache stat: get page cache stats for files on Linux";
    homepage = "https://github.com/tobert/pcstat";
    license = licenses.asl20;
    maintainers = with maintainers; [ aminechikhaoui ];
  };
}

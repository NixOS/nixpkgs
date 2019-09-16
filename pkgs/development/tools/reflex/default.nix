{ lib, fetchFromGitHub, buildGoPackage }:


buildGoPackage rec {
  pname = "reflex";
  version = "0.2.0";

  goPackagePath = "github.com/cespare/reflex";

  src = fetchFromGitHub {
    owner = "cespare";
    repo = "reflex";
    rev = "v${version}";
    sha256 = "0ccwjmf8rjh03hpbmfiy70ai9dhgvb5vp7albffq0cmv2sl69dqr";
  };

  meta = with lib; {
    description = "A small tool to watch a directory and rerun a command when certain files change";
    homepage = https://github.com/cespare/reflex;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nicknovitski ];
  };
}

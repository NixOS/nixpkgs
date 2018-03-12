{ lib, bundlerEnv, ruby, stdenv, fetchFromGitHub, nodejs, pkgs }:


let
  env = bundlerEnv {
    name = "staytus";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in

stdenv.mkDerivation rec {
  name = "staytus-2017-11-08";

  src = fetchFromGitHub {
    owner = "adamcooke";
    repo = "staytus";
    rev = "8a601d2f1778d8fb878701ca88e7b28b1ec3c9c6";
    sha256 = "0fbrm5f3li65bpgki54nb4w1hg1mhy2w918pqv904dimgkikxv7l";
  };

  buildInputs = [ env.wrappedRuby env nodejs ];

  meta = with lib; {
    description = "A monitoring framework that aims to be simple, malleable, and scalable";
    homepage    = http://staytus.co/;
    license     = licenses.mit;
    maintainers = with maintainers; [ ravloony ];
    platforms   = platforms.unix;
  };

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/staytus
  '';

  passthru = {
    inherit env ruby;
  };
}

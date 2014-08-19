{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.2.28";
  name = "nsq-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    apps=(nsq_pubsub nsq_stat nsq_tail nsq_to_file nsq_to_http nsq_to_nsq nsqd nsqlookupd)

    mkdir build

    go build -v -o build/nsqadmin github.com/bitly/nsq/nsqadmin
    for app in "''${apps[@]}"; do
      go build -v -o build/$app github.com/bitly/nsq/apps/$app
    done
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv build/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A realtime distributed messaging platform";
    homepage = http://nsq.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}

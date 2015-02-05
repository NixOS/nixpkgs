{ lib, goPackages, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "0.2.28";
  name = "nsq-${version}";
  goPackagePath = "github.com/bitly/nsq";
  src = fetchFromGitHub {
    owner = "bitly";
    repo = "nsq";
    rev = "v${version}";
    sha256 = "0drmf1j5w3q4l6f7xjy3y7d7cl50gcx0qwci6mahxsyaaclx60yx";
  };

  subPackages = [ "nsqadmin" ] ++
                map (x: "apps/"+x) [ "nsq_pubsub" "nsq_stat" "nsq_tail"
                                     "nsq_to_file" "nsq_to_http" "nsq_to_nsq"
                                     "nsqd" "nsqlookupd" ];

  buildInputs = [ go-nsq go-options toml perks go-hostpool ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "A realtime distributed messaging platform";
    homepage = http://nsq.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}

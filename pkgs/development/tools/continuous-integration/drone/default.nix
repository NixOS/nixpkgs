{ stdenv, fetchFromGitHub, buildGoPackage, go-bindata, go-bindata-assetfs }:

buildGoPackage rec {
  name = "drone.io-${version}";
  version = "0.5-20161104-${stdenv.lib.strings.substring 0 7 revision}";
  revision = "232df356afeeb4aec5e2959fa54b084dcadb267f";
  goPackagePath = "github.com/drone/drone";

  # These dependencies pulled (in `drone` buildprocess) via Makefile,
  # so I extracted them here, all revisions pinned by same date, as ${version}
  extraSrcs = [ 
    {
      goPackagePath = "github.com/drone/drone-ui";
      src = fetchFromGitHub {
        owner = "drone";
        repo = "drone-ui";
        rev = "e66df33b4620917a2e7b59760887cc3eed543664";
        sha256 = "0d50xdzkh9akpf5c0sqgcgy11v2vz858l36jp5snr94zkrdkv0n1";
      };
    }
    {
      goPackagePath = "github.com/drone/mq";
      src = fetchFromGitHub {
        owner = "drone";
        repo = "mq";
        rev = "0f296601feeed952dabd038793864acdbefe6dbe";
        sha256 = "1k7439c90l4w29g7wyixfmpbkap7bn8yh8zynbjyjf9qjzwsnw97";
      };
    }
    {
      goPackagePath = "github.com/tidwall/redlog";
      src = fetchFromGitHub {
        owner = "tidwall";
        repo = "redlog";
        rev = "54086c8553cd23aba652513a87d2b085ea961541";
        sha256 = "12a7mk6r8figjinzkbisxcaly6sasggy62m8zs4cf35lpq2lhffq";
      };
    }
    {
      goPackagePath = "golang.org/x/crypto";
      src = fetchFromGitHub {
        owner = "golang";
        repo = "crypto";
        rev = "9477e0b78b9ac3d0b03822fd95422e2fe07627cd";
        sha256 = "1qcqai6nf1q50z9ga7r4ljnrh1qz49kwlcqpri4bknx732lqq0v5";
      };
    }
  ];
  nativeBuildInputs = [ go-bindata go-bindata-assetfs ];

  preBuild = ''
    go generate github.com/drone/drone/server/template
    go generate github.com/drone/drone/store/datastore/ddl
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = revision;
    sha256 = "0xrijcrlv3ag9n2kywkrhdkxyhxc8fs6zqn0hyav6a6jpqnsahg3";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ avnik ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}

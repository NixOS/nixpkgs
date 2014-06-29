{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "code.google.com/p/snappy-go";
      src = fetchhg {
        url = "http://code.google.com/p/snappy-go";
        rev = "14";
        sha256 = "0ywa52kcii8g2a9lbqcx8ghdf6y56lqq96sl5nl9p6h74rdvmjr7";
      };
    }
    {
      root = "github.com/BurntSushi/toml";
      src = fetchFromGitHub {
        owner = "BurntSushi";
        repo = "toml";
        rev = "f87ce853111478914f0bcffa34d43a93643e6eda";
        sha256 = "0g8203y9ycf34j2q3ymxb8nh4habgwdrjn9vdgrginllx73yq565";
      };
    }
    {
      root = "github.com/bitly/go-hostpool";
      src = fetchFromGitHub {
        owner = "bitly";
        repo = "go-hostpool";
        rev = "fed86fae5cacdc77e7399937e2f8836563620a2e";
        sha256 = "0nbssfp5ksj4hhc0d8lfq54afd9nqv6qzk3vi6rinxr3fgplrj44";
      };
    }
    {
      root = "github.com/bitly/go-nsq";
      src = fetchFromGitHub {
        owner = "bitly";
        repo = "go-nsq";
        rev = "c79a282f05364e340eadc2ce2f862a3d44eea9c0";
        sha256 = "19jlwj5419p5xwjzfnzlddjnbh5g7ifnqhd00i5p0b6ww1gk011p";
      };
    }
    {
      root = "github.com/bitly/go-simplejson";
      src = fetchFromGitHub {
        owner = "bitly";
        repo = "go-simplejson";
        rev = "1cfceb0e12f47ec02665ef480212d7b531d6f4c5";
        sha256 = "1d8x0himl58qn87lv418djy6mbs66p9ai3zpqq13nhkfl67fj3bi";
      };
    }
    {
      root = "github.com/bitly/nsq";
      src = fetchFromGitHub {
        owner = "bitly";
        repo = "nsq";
        rev = "048691a8242c9ec224fc46bf7d05f321026b69f8";
        sha256 = "0drmf1j5w3q4l6f7xjy3y7d7cl50gcx0qwci6mahxsyaaclx60yx";
      };
    }
    {
      root = "github.com/bmizerany/assert";
      src = fetchFromGitHub {
        owner = "bmizerany";
        repo = "assert";
        rev = "e17e99893cb6509f428e1728281c2ad60a6b31e3";
        sha256 = "1lfrvqqmb09y6pcr76yjv4r84cshkd4s7fpmiy7268kfi2cvqnpc";
      };
    }
    {
      root = "github.com/bmizerany/perks";
      src = fetchFromGitHub {
        owner = "bmizerany";
        repo = "perks";
        rev = "aac9e2eab5a334037057336897fd10b0289a5ae8";
        sha256 = "1d027jgc327qz5xmal0hrpqvsj45i9yqmm9pxk3xp3hancvz3l3k";
      };
    }
    {
      root = "github.com/kr/pretty";
      src = fetchFromGitHub {
        owner = "kr";
        repo = "pretty";
        rev = "bc9499caa0f45ee5edb2f0209fbd61fbf3d9018f";
        sha256 = "1m61y592qsnwsqn76v54mm6h2pcvh4wlzbzscc1ag645x0j33vvl";
      };
    }
    {
      root = "github.com/kr/pty";
      src = fetchFromGitHub {
        owner = "kr";
        repo = "pty";
        rev = "67e2db24c831afa6c64fc17b4a143390674365ef";
        sha256 = "1l3z3wbb112ar9br44m8g838z0pq2gfxcp5s3ka0xvm1hjvanw2d";
      };
    }
    {
      root = "github.com/kr/text";
      src = fetchFromGitHub {
        owner = "kr";
        repo = "text";
        rev = "6807e777504f54ad073ecef66747de158294b639";
        sha256 = "1wkszsg08zar3wgspl9sc8bdsngiwdqmg3ws4y0bh02sjx5a4698";
      };
    }
    {
      root = "github.com/mreiferson/go-options";
      src = fetchFromGitHub {
        owner = "mreiferson";
        repo = "go-options";
        rev = "896a539cd709f4f39d787562d1583c016ce7517e";
        sha256 = "0hg0n5grcjcj5719rqchz0plp39wfk3znqxw8y354k4jwsqwmn17";
      };
    }
    {
      root = "github.com/mreiferson/go-snappystream";
      src = fetchFromGitHub {
        owner = "mreiferson";
        repo = "go-snappystream";
        rev = "97c96e6648e99c2ce4fe7d169aa3f7368204e04d";
        sha256 = "08ylvx9r6b1fi76v6cqjvny4yqsvcqjfsg93jdrgs7hi4mxvxynn";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}

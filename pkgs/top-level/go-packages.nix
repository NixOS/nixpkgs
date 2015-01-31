/* This file defines the composition for Go packages. */

{ overrides, stdenv, go, buildGoPackage
,fetchgit, fetchhg, fetchurl, fetchFromGitHub }:

let self = _self // overrides; _self = with self; {

  inherit go buildGoPackage;

  ## OFFICIAL GO PACKAGES

  image = buildGoPackage rec {
    rev = "490b1ad139b3";
    name = "go.image-${rev}";
    goPackagePath = "code.google.com/p/go.image";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "02m6ifwby2fi88njarbbb6dimwg0pd2b6llkgyadh4b9wzp2vy4r";
    };
  };

  net = buildGoPackage rec {
    rev = "3338d5f109e9";
    name = "go.net-${rev}";
    goPackagePath = "code.google.com/p/go.net";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "0yz807y3ac07x3nf0qlaw1w1i6asynrpyssjl8jyv3pplww0qj7i";
    };
    propagatedBuildInputs = [ text ];
  };

  text = buildGoPackage rec {
    rev = "024681b033be";
    name = "go.text-${rev}";
    goPackagePath = "code.google.com/p/go.text";
    src = fetchhg {
      inherit rev;
      url = "https://${goPackagePath}";
      sha256 = "19px5pw5mvwjb7ymivfkkkr6cyl2npv834jxlr6y0x5ca1djhsci";
    };
    doCheck = false;
  };

  ## THIRD PARTY

  cobra = buildGoPackage rec {
    date = "20140617";
    rev = "10a8494a87448bf5003222d9974f166437e7f042";
    name = "cobra-${date}-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/spf13/cobra";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "1ydcccx0zdswca4v9hfmrn8ck42h485hy3wrd9k7y6mra3r6c08j";
    };
    propagatedBuildInputs = [ pflag ];
  };

  goconvey = buildGoPackage rec {
    version = "1.5.0";
    name = "goconvey-${version}";
    goPackagePath = "github.com/smartystreets/goconvey";
    src = fetchurl {
      name = "${name}.tar.gz";
      url = "https://github.com/smartystreets/goconvey/archive/${version}.tar.gz";
      sha256 = "0g3965cb8kg4kf9b0klx4pj9ycd7qwbw1jqjspy6i5d4ccd6mby4";
    };
    buildInputs = [ oglematchers ];
    doCheck = false; # please check again
  };

  go-bencode = buildGoPackage rec {
    version = "1.1.1";
    name = "go-bencode-${version}";
    goPackagePath = "github.com/ehmry/go-bencode";

    src = fetchurl {
      url = "https://${goPackagePath}/archive/v${version}.tar.gz";
      sha256 = "0y2kz2sg1f7mh6vn70kga5d0qhp04n01pf1w7k6s8j2nm62h24j6";
    };
  };

  oglematchers = buildGoPackage rec {
    rev = "4fc24f97b5b74022c2a3f4ca7eed57ca29083d3e";
    name = "oglematchers-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jacobsa/oglematchers";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "4075ede31601adf8c4e92739693aebffa3718c641dfca75b09cf6b4bd6c26cc0";
    };
    #goTestInputs = [ ogletest ];
    doCheck = false; # infinite recursion
  };

  oglemock = buildGoPackage rec {
    rev = "d054ecee522bdce4481690cdeb09d1b4c44da4e1";
    name = "oglemock-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jacobsa/oglemock";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "685e7fc4308d118ae25467ba84c64754692a7772c77c197f38d8c1b63ea81da2";
    };
    buildInputs = [ oglematchers ];
    #goTestInputs = [ ogletest ];
    doCheck = false; # infinite recursion
  };

  ogletest = buildGoPackage rec {
    rev = "7de485607c3f215cf92c1f793b5d5a7de46ec3c7";
    name = "ogletest-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/jacobsa/ogletest";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "0cfc43646d59dcea5772320f968aef2f565fb5c46068d8def412b8f635365361";
    };
    buildInputs = [ oglemock oglematchers ];
    doCheck = false; # check this again
  };

  pflag = buildGoPackage rec {
    date = "20131112";
    rev = "94e98a55fb412fcbcfc302555cb990f5e1590627";
    name = "pflag-${date}-${stdenv.lib.strings.substring 0 7 rev}";
    goPackagePath = "github.com/spf13/pflag";
    src = fetchgit {
      inherit rev;
      url = "https://${goPackagePath}.git";
      sha256 = "0z8nzdhj8nrim8fz11magdl0wxnisix9p2kcvn5kkb3bg8wmxhbg";
    };
    doCheck = false; # bad import path in tests
  };

}; in self

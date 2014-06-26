{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "code.google.com/p/gogoprotobuf";
      src = fetchgit {
        url = "https://code.google.com/p/gogoprotobuf";
        rev = "7fd1620f09261338b6b1ca1289ace83aee0ec946";
        sha256 = "0f13y29zpxkv7b7kwnszygvg04fd5m9r8vpkl1wa3gxnc6az54i9";
      };
    }
    {
      root = "github.com/coreos/etcd";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "etcd";
        rev = "1359d29fa451b059bb76b51260610d92853e7316";
        sha256 = "0iz3vmf3nfp1i5r8al207wm0jvj68i47a814w90b1jl8g4f2amp7";
      };
    }
    {
      root = "github.com/coreos/fleet";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "fleet";
        rev = "da0a02ed3b07d83b0b542dcdee56e08d2457ab9c";
        sha256 = "0b8aq4ppyv1fjvf3f2qjq80mvjvf9r104bf4048wgsrs0pccs6s8";
      };
    }
    {
      root = "github.com/coreos/raft";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "raft";
        rev = "67dca7288f1665b59860421673d46314f4348e45";
        sha256 = "1l27kjkwcxgx89d2m537plagbp1wh6qlzxirza6lliblrgxry6mw";
      };
    }
    {
      root = "github.com/stathat/go";
      src = fetchFromGitHub {
        owner = "stathat";
        repo = "go";
        rev = "01d012b9ee2ecc107cb28b6dd32d9019ed5c1d77";
        sha256 = "0mrn70wjfcs4rfkmga3hbfqmbjk33skcsc8pyqxp02bzpwdpc4bi";
      };
    }
    {
      root = "github.com/stretchr/objx";
      src = fetchFromGitHub {
        owner = "stretchr";
        repo = "objx";
        rev = "cbeaeb16a013161a98496fad62933b1d21786672";
        sha256 = "1xn7iibjik77h6h0jilfvcjkkzaqz45baf44p3rb2i03hbmkqkp1";
      };
    }
    {
      root = "github.com/stretchr/testify";
      src = fetchFromGitHub {
        owner = "stretchr";
        repo = "testify";
        rev = "3e03dde72495487a4deb74152ac205d0619fbc8d";
        sha256 = "1xd9sbi6y68cfwkxgybcz0dbfx4r6jmxq51wjj6six3wm9p7m8ls";
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


{ stdenv, lib, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/coreos/etcd";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "etcd";
        rev = "9970141f76241c909977af7bafe7b6f2c4923de8";
        sha256 = "1bva46gfy4rkfw8k8pb3lsfzfg16csds01f0nvfrkh99pr7sp0sy";
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

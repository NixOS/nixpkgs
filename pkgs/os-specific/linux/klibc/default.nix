{stdenv, fetchurl, perl, bison, mktemp, kernel
  , version ? "1.5"
  , sha256 ?  "1izhf8kscjymsvsvhcqw9awnmp94vwv70zdj09srg9bkpjj0n017"
  , subdir ? ""
  , addPreBuild ? ""
}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "klibc-${version}";
  #builder = ./builder.sh;
  makeFlags = ["V=1" "prefix=$out" "SHLIBDIR=$out/lib"];
  preBuild = ''
    makeFlags=$(eval "echo $makeFlags")

    mkdir -p linux/include
    cp -prd $kernel/lib/modules/*/build/include/* linux/include/
    chmod -R u+w linux/include/
  '' + addPreBuild;
  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/${subdir}klibc-${version}.tar.bz2";
    inherit sha256;
#    url = mirror://kernel/linux/libs/klibc/Testing/klibc-1.5.14.tar.bz2;
#    sha256 = "1cmrqpgamnv2ns7dlxjm61zc88dxm4ff0aya413ij1lmhp2h2sfc";
  };
  inherit kernel;
  buildInputs = [perl bison mktemp];
  #patches = [./install.patch];
}

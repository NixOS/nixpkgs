{stdenv, fetchurl, perl, bison, mktemp, kernelHeaders}:

assert stdenv.isLinux;

let version = "1.5.15"; in

stdenv.mkDerivation {
  name = "klibc-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/Testing/klibc-${version}.tar.bz2";
    sha256 = "1x401wmjca6zkyikf9xz45b3wb1hnj0m2s9in1sg6xdhi3pk8lwb";
  };
  
  makeFlags = ["V=1" "prefix=$out" "SHLIBDIR=$out/lib"];
  
  preBuild = ''
    sed -i /CONFIG_AEABI/d defconfig
    echo "CONFIG_AEABI=y" >> defconfig
    makeFlags=$(eval "echo $makeFlags")

    mkdir linux
    cp -prsd ${kernelHeaders}/include linux/
    chmod -R u+w linux/include/
  ''; # */
  
  # Install static binaries as well.
  postInstall = ''
    dir=$out/lib/klibc/bin.static
    mkdir $dir
    cp $(find $(find . -name static) -type f ! -name "*.g" -a ! -name ".*") $dir/
    cp usr/dash/sh $dir/
  '';
  
  buildInputs = [perl bison mktemp];
}

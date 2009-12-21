{stdenv, fetchurl, perl, bison, mktemp, linuxHeaders}:

assert stdenv.isLinux;

let version = "1.5"; in

stdenv.mkDerivation {
  name = "klibc-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/klibc/klibc-${version}.tar.bz2";
    sha256 = "1izhf8kscjymsvsvhcqw9awnmp94vwv70zdj09srg9bkpjj0n017";
  };
  
  makeFlags = ["V=1" "prefix=$out" "SHLIBDIR=$out/lib"];
  
  preBuild = ''
    makeFlags=$(eval "echo $makeFlags")

    mkdir linux
    cp -prsd ${linuxHeaders}/include linux/
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

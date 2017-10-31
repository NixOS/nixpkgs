{ stdenv, fetchurl }:

let
  arch =
    if stdenv.system == "x86_64-linux" then "amd64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "Unsupported architecture";

in stdenv.mkDerivation rec {
  name = "ut2004-demo-${version}";
  version = "3334";

  src = fetchurl {
    url = "http://treefort.icculus.org/ut2004/UT2004-LNX-Demo${version}.run.gz";
    sha256 = "0d5f84qz8l1rg16yzx2k4ikr46n9iwj68na1bqi87wrww7ck6jh7";
  };

  buildCommand = ''
    cat $src | gunzip > setup.run
    chmod +x setup.run
    ./setup.run --noexec --target .
    mkdir $out
    tar -xaf ut2004demo.tar.bz2 -C $out
    tar -xaf linux-${arch}.tar.bz2 -C $out

    rm $out/System/libSDL-1.2.so.0
    rm $out/System/openal.so
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "A first-person shooter video game developed by Epic Games and Digital Extreme -- demo version";
    homepage = http://www.unrealtournament2004.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

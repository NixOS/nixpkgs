{ stdenv, fetchurl, fetchzip, scons, zlib }:

stdenv.mkDerivation rec {
  pname = "nsis";
  version = "3.05";

  src =
    fetchurl {
      url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}-src.tar.bz2";
      sha256 = "1sbwx5vzpddharkb7nj4q5z3i5fbg4lan63ng738cw4hmc4v7qdn";
    };
  srcWinDistributable =
    fetchzip {
      url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}.zip";
      sha256 = "0i3pzdilyy5g0r2c92pd2jl92ji9f75vv98mndzq8vw03a34yh3q";
    };

  postUnpack = ''
    mkdir -p $out/share/nsis
    cp -avr ${srcWinDistributable}/{Contrib,Include,Plugins,Stubs} \
      $out/share/nsis
    chmod -R u+w $out/share/nsis
  '';

  nativeBuildInputs = [ scons ];
  buildInputs = [ zlib ];

  sconsFlags = [
    "SKIPSTUBS=all"
    "SKIPPLUGINS=all"
    "SKIPUTILS=all"
    "SKIPMISC=all"
    "APPEND_CPPPATH=${zlib.dev}/include"
    "APPEND_LIBPATH=${zlib}/lib"
    "NSIS_CONFIG_CONST_DATA=no"
  ];

  preBuild = ''
    sconsFlagsArray+=("PATH=$PATH")
  '';

  prefixKey = "PREFIX=";
  installTargets = [ "install-compiler" ];

  meta = with stdenv.lib; {
    description = "NSIS is a free scriptable win32 installer/uninstaller system that doesn't suck and isn't huge";
    homepage = https://nsis.sourceforge.io/;
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pombeirp ];
  };
}

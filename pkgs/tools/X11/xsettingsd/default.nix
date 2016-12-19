{ stdenv, fetchFromGitHub, scons, libX11, pkgconfig }:

stdenv.mkDerivation rec {
  name = "xsettingsd-${version}";
  version = "git-2015-06-14";

  src = fetchFromGitHub {
    owner = "derat";
    repo = "xsettingsd";
    rev = "b4999f5e9e99224caf97d09f25ee731774ecd7be";
    sha256 = "18cp6a66ji483lrvf0vq855idwmcxd0s67ijpydgjlsr70c65j7s";
  };

  patches = [
    ./SConstruct.patch
  ];

  buildInputs = [ libX11 scons pkgconfig ];
  buildPhase = ''
    mkdir -p "$out"
    scons \
      -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES \
      "prefix=$out"
  '';
  
  installPhase = ''
    mkdir -p "$out"/bin
    install xsettingsd "$out"/bin
    install dump_xsettings "$out"/bin
  '';

  meta = with stdenv.lib; {
    description = "Provides settings to X11 applications via the XSETTINGS specification";
    homepage = https://github.com/derat/xsettingsd;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, scons, libX11, pkgconfig }:

stdenv.mkDerivation rec {
  name = "xsettingsd-${version}";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "derat";
    repo = "xsettingsd";
    rev = "2a516a91d8352b3b93a7a1ef5606dbd21fa06b7c";
    sha256 = "0f9lc5w18x6xs9kf72jpixprp3xb7wqag23cy8zrm33n2bza9dj0";
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
    platforms = platforms.linux;
  };
}

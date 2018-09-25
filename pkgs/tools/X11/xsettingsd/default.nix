{ stdenv, fetchFromGitHub, scons, pkgconfig, libX11 }:

stdenv.mkDerivation rec {
  name = "xsettingsd-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "derat";
    repo = "xsettingsd";
    rev = "v${version}";
    sha256 = "05m4jlw0mgwp24cvyklncpziq1prr2lg0cq9c055sh4n9d93d07v";
  };

  patches = [
    ./SConstruct.patch
  ];

  nativeBuildInputs = [ scons pkgconfig ];

  buildInputs = [ libX11 ];

  buildPhase = ''
    scons -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES
  '';
  
  installPhase = ''
    install -D -t "$out"/bin xsettingsd dump_xsettings
    install -D -t "$out"/usr/share/man/man1 xsettingsd.1 dump_xsettings.1
  '';

  meta = with stdenv.lib; {
    description = "Provides settings to X11 applications via the XSETTINGS specification";
    homepage = https://github.com/derat/xsettingsd;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}

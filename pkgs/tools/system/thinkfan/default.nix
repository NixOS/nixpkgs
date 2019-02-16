{ stdenv, fetchFromGitHub, cmakeCurses, libyamlcpp, pkgconfig
, smartSupport ? false, libatasmart }:

stdenv.mkDerivation rec {
  pname = "thinkfan";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "vmatare";
    repo = "thinkfan";
    rev = "${version}";
    sha256 = "1983p8aryfgpyhflh5r5xz27y136a4vvm7plgrg44q4aicqbcp8j";
  };

  configureFlags = [
    "-DCMAKE_INSTALL_DOCDIR==share/doc/${pname}"
    "-DUSE_NVML=OFF"
    "-DUSE_ATASMART=ON"
    "-DUSE_YAML=ON"
  ];

  nativeBuildInputs = [ cmakeCurses pkgconfig ];

  buildInputs = [libyamlcpp] ++ stdenv.lib.optional smartSupport libatasmart;

  cmakeFlags = stdenv.lib.optional smartSupport "-DUSE_ATASMART=ON";

  installPhase = ''
    install -Dm755 {.,$out/bin}/thinkfan

    cd "$NIX_BUILD_TOP"; cd "$sourceRoot" # attempt to be a bit robust
    install -Dm644 {.,$out/share/doc/thinkfan}/README
    cp -R examples $out/share/doc/thinkfan
    install -Dm644 {src,$out/share/man/man1}/thinkfan.1
  '';

  meta = {
    license = stdenv.lib.licenses.gpl3;
    homepage = https://github.com/vmatare/thinkfan;
    maintainers = with stdenv.lib.maintainers; [ domenkozar ];
    platforms = stdenv.lib.platforms.linux;
  };
}

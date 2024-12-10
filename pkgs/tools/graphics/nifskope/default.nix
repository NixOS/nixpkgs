{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  qttools,
  substituteAll,
  libGLU,
  wrapQtAppsHook,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "nifskope";
  version = "2.0.dev7";

  src = fetchFromGitHub {
    owner = "niftools";
    repo = "nifskope";
    rev = "47b788d26ae0fa12e60e8e7a4f0fa945a510c7b2"; # `v${version}` doesn't work with submodules
    sha256 = "1wqpn53rkq28ws3apqghkzyrib4wis91x171ns64g8kp4q6mfczi";
    fetchSubmodules = true;
  };

  patches = [
    ./external-lib-paths.patch
    (substituteAll {
      src = ./qttools-bins.patch;
      qttools = "${qttools.dev}/bin";
    })
    (fetchpatch {
      name = "qt512-build-fix.patch";
      url = "https://github.com/niftools/nifskope/commit/30954e7f01f3d779a2a1fd37d363e8a6ad560bd3.patch";
      sha256 = "0d6xjj2mjjhdd7w1aig5f75jksjni16jyj0lxsz51pys6xqb6fpj";
    })
  ] ++ (lib.optional stdenv.isAarch64 ./no-sse-on-arm.patch);

  buildInputs = [
    qtbase
    qttools
    libGLU.dev
  ];
  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  preConfigure = ''
    shopt -s globstar
    for i in **/*.cpp; do
      substituteInPlace $i --replace /usr/share/nifskope $out/share/nifskope
    done
  '';

  # Inspired by install/linux-install/nifskope.spec.in.
  installPhase = ''
    runHook preInstall

    d=$out/share/nifskope
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $d/{shaders,lang}
    cp release/NifSkope $out/bin/
    cp ./res/nifskope.png $out/share/pixmaps/
    cp release/{nif.xml,kfm.xml,style.qss} $d/
    cp res/shaders/*.frag res/shaders/*.prog res/shaders/*.vert $d/shaders/
    cp ./res/lang/*.ts ./res/lang/*.tm $d/lang/
    cp ./install/linux-install/nifskope.desktop $out/share/applications

    substituteInPlace $out/share/applications/nifskope.desktop \
      --replace 'Exec=nifskope' "Exec=$out/bin/NifSkope" \
      --replace 'Icon=nifskope' "Icon=$out/share/pixmaps/nifskope.png"

    find $out/share -type f -exec chmod -x {} \;

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://niftools.sourceforge.net/wiki/NifSkope";
    description = "A tool for analyzing and editing NetImmerse/Gamebryo '*.nif' files";
    maintainers = with maintainers; [ eelco ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "NifSkope";
  };
}

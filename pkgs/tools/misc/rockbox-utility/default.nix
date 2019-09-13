{ stdenv, fetchurl, pkgconfig, libusb1
, qtbase, qttools, makeWrapper, qmake
, withEspeak ? false, espeak ? null }:

let inherit (stdenv.lib) getDev; in

stdenv.mkDerivation  rec {
  pname = "rockbox-utility";
  version = "1.4.0";

  src = fetchurl {
    url = "https://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    sha256 = "0k3ycga3b0jnj13whwiip2l0gx32l50pnbh7kfima87nq65aaa5w";
  };

  buildInputs = [ libusb1 qtbase qttools ]
    ++ stdenv.lib.optional withEspeak espeak;
  nativeBuildInputs = [ makeWrapper pkgconfig qmake ];

  postPatch = ''
    sed -i rbutil/rbutilqt/rbutilqt.pro \
        -e '/^lrelease.commands =/ s|$$\[QT_INSTALL_BINS\]/lrelease -silent|${getDev qttools}/bin/lrelease|'
  '';

  preConfigure = ''
    cd rbutil/rbutilqt
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 RockboxUtility $out/bin/rockboxutility
    ln -s $out/bin/rockboxutility $out/bin/RockboxUtility
    wrapProgram $out/bin/rockboxutility \
    ${stdenv.lib.optionalString withEspeak ''
      --prefix PATH : ${espeak}/bin
    ''}

    runHook postInstall
  '';

  # `make build/rcc/qrc_rbutilqt-lang.cpp` fails with
  #      RCC: Error in 'rbutilqt-lang.qrc': Cannot find file 'lang/rbutil_cs.qm'
  # Do not add `lrelease rbutilqt.pro` into preConfigure, otherwise `make lrelease`
  # may clobber the files read by the parallel `make build/rcc/qrc_rbutilqt-lang.cpp`.
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Open source firmware for mp3 players";
    homepage = https://www.rockbox.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu ];
  };
}

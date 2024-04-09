{ stdenv
, fetchurl
, lib
, autoPatchelfHook
, wrapQtAppsHook
, gmpxx
, gnustep
, libbsd
, libffi_3_3
, ncurses6
}:

stdenv.mkDerivation rec {
  pname = "hopper";
  version = "5.5.3";
  rev = "v4";

  src = fetchurl {
    url = "https://d2ap6ypl1xbe4k.cloudfront.net/Hopper-${rev}-${version}-Linux-demo.pkg.tar.xz";
    hash = "sha256-xq9ZVg1leHm/tq6LYyQLa8p5dDwBd64Jt92uMoE0z58=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
  ];

  buildInputs = [
    gnustep.libobjc
    libbsd
    libffi_3_3
    ncurses6
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share

    cp $sourceRoot/opt/hopper-${rev}/bin/Hopper $out/bin/hopper
    cp \
      --archive \
      $sourceRoot/opt/hopper-${rev}/lib/libBlocksRuntime.so* \
      $sourceRoot/opt/hopper-${rev}/lib/libdispatch.so* \
      $sourceRoot/opt/hopper-${rev}/lib/libgnustep-base.so* \
      $sourceRoot/opt/hopper-${rev}/lib/libHopperCore.so* \
      $sourceRoot/opt/hopper-${rev}/lib/libkqueue.so* \
      $sourceRoot/opt/hopper-${rev}/lib/libobjcxx.so* \
      $sourceRoot/opt/hopper-${rev}/lib/libpthread_workqueue.so* \
      $out/lib

    cp -r $sourceRoot/usr/share $out

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace "$out/share/applications/hopper-${rev}.desktop" \
      --replace "Exec=/opt/hopper-${rev}/bin/Hopper" "Exec=$out/bin/hopper"
  '';

  meta = with lib; {
    homepage = "https://www.hopperapp.com/index.html";
    description = "A macOS and Linux Disassembler";
    license = licenses.unfree;
    maintainers = with maintainers; [
      Enteee
    ];
    platforms = platforms.linux;
  };
}

{ stdenv
, fetchurl
, lib
, autoPatchelfHook
, wrapQtAppsHook
, libbsd
, python27
, gmpxx
, ncurses5
, gnustep
, libffi
}:
stdenv.mkDerivation rec {
  pname = "hopper";
  version = "4.5.21";
  rev = "v${lib.versions.major version}";

  src = fetchurl {
    url = "https://d2ap6ypl1xbe4k.cloudfront.net/Hopper-${rev}-${version}-Linux.pkg.tar.xz";
    sha256 = "0s733n3hmzpsnrvfryq7kzsvwshd1y9fzm16a64gnii8cmfalrqc";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    wrapQtAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libbsd
    python27
    gmpxx
    ncurses5
    gnustep.libobjc
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

    # we already ship libffi.so.7
    ln -s ${lib.getLib libffi}/lib/libffi.so $out/lib/libffi.so.6

    cp -r $sourceRoot/usr/share $out

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace "$out/share/applications/hopper-${rev}.desktop" \
      --replace "Exec=/opt/hopper-${rev}/bin/Hopper" "Exec=$out/bin/hopper"
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.hopperapp.com/index.html";
    description = "A macOS and Linux Disassembler";
    license = licenses.unfree;
    maintainers = with maintainers; [
      luis
      Enteee
    ];
    platforms = platforms.linux;
  };
}

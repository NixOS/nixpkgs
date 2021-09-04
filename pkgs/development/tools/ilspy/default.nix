{
  stdenv
, lib
, makeWrapper
, autoPatchelfHook
, coreutils
, libX11
, libkrb5
, curl
, lttng-ust
, gtk3
, openssl
, icu
, unzip
, fetchurl
, makeDesktopItem
}:
let
  libs = [
    libX11
    stdenv.cc.cc.lib
    libkrb5
    curl
    lttng-ust
    gtk3
    openssl.out
    icu
  ];
  icon = fetchurl {
    url = https://github.com/icsharpcode/ILSpy/raw/3f4602be91444727150d108f58be8cf39e0e3ab6/ILSpy/Images/ILSpy.ico;
    sha256 = "0xy64dsq0svqhb35ypy3b2nfsw6y8m3l8rg27drlbmbjz9y55rlc";
  };
  desktopItem = makeDesktopItem {
    type = "Application";
    name = "ILSpy";
    desktopName = "ILSpy";
    exec = "ILSpy";
    comment = ".NET assembly browser and decompiler";
    categories = "Development";
    icon = "ILSpy";
  };
in
stdenv.mkDerivation rec {
  pname = "ilspy";
  version = "unstable-${releaseVersion}";
  releaseVersion = "7.0-rc2";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  # Crashes at startup when stripping:
  # "Failed to create CoreCLR, HRESULT: 0x80004005"
  dontStrip = true;

  # autoPatchelfHook could not satisfy dependency liblttng-ust.so.0 wanted by /nix/store/g78530fqy6mibaqlcbjgx022kwak86x6-ilspy-unstable-7.0-rc2/bin/libcoreclrtraceptprovider.so
  # everything seems to work fine without it
  autoPatchelfIgnoreMissingDeps = true;

  sourceRoot = ".";

  buildInputs = [
    makeWrapper
    unzip
  ] ++ libs;

  src = fetchurl {
    url = "https://github.com/icsharpcode/AvaloniaILSpy/releases/download/v${releaseVersion}/linux-x64.zip";
    sha256 = "19c92pg2aji584filb0hykih82s4i8fqds51avnrlgvr0fydjnkm";
  };

  installPhase = ''
    ${unzip}/bin/unzip ILSpy-linux-x64-Release.zip # a zip within a zip, I think they made a mistake packaging this
    ${coreutils}/bin/mkdir -p \
      $out/bin \
      $out/share/applications \
      $out/share/pixmaps
    ${coreutils}/bin/ln -s ${icon} $out/share/pixmaps/ILSpy.ico
    ${coreutils}/bin/mv artifacts/linux-x64/* $out/bin
    ${coreutils}/bin/chmod a+x $out/bin/ILSpy

    wrapProgram $out/bin/ILSpy \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"

    ${coreutils}/bin/ln -s ${desktopItem}/share/applications/ILSpy.desktop $out/share/applications/ILSpy.desktop

  '';

  meta = with lib; {
    description = ".NET assembly browser and decompiler";
    homepage = "https://github.com/icsharpcode/AvaloniaILSpy";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ mausch ];
  };
}

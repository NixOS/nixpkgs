{
  stdenv
, lib
, makeWrapper
, autoPatchelfHook
, coreutils
, libX11
, kerberos
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
    kerberos
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
  releaseVersion = "5.0-rc2";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  # Crashes at startup when stripping:
  # "Failed to create CoreCLR, HRESULT: 0x80004005"
  dontStrip = true;

  sourceRoot = ".";

  buildInputs = [
    makeWrapper
    unzip
  ] ++ libs;

  src = fetchurl {
    url = "https://github.com/icsharpcode/AvaloniaILSpy/releases/download/v${releaseVersion}/ILSpy-linux-x64-Release.zip";
    sha256 = "1p1fkdkpbcqj2q4n7y241lzx98w33vmh4n2gahw7lbrrg1p7rxxa";
  };

  installPhase = ''
    ${coreutils}/bin/chmod a+x ILSpy
    ${coreutils}/bin/mkdir -p \
      $out/bin \
      $out/share/applications \
      $out/share/pixmaps
    ${coreutils}/bin/ln -s ${icon} $out/share/pixmaps/ILSpy.ico
    ${coreutils}/bin/mv * $out/bin

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

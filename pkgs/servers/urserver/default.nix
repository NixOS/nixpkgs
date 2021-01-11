{ lib, stdenv
, fetchurl
, autoPatchelfHook
, bluez
, libX11
, libXtst
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "urserver";
  version = "3.6.0.745";

  src = fetchurl {
    url = "https://www.unifiedremote.com/static/builds/server/linux-x64/745/urserver-${version}.tar.gz";
    sha256 = "1ib9317bg9n4knwnlbrn1wfkyrjalj8js3a6h7zlcl8h8xc0szc8";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    bluez
    libX11
    libXtst
    makeWrapper
  ];

  installPhase = ''
    install -m755 -D urserver $out/bin/urserver
    wrapProgram $out/bin/urserver --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath buildInputs}"
    cp -r remotes $out/bin/remotes
    cp -r manager $out/bin/manager
  '';

  meta = with lib; {
    homepage = "https://www.unifiedremote.com/";
    description = "The one-and-only remote for your computer";
    license = licenses.unfree;
    maintainers = with maintainers; [ sfrijters ];
    platforms = [ "x86_64-linux" ];
  };
}

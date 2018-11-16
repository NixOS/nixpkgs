{ stdenv, fetchurl, fetchFromGitHub, makeWrapper
, meson
, ninja
, pkgconfig

, platformTools
, ffmpeg
, SDL2
}:

let
  version = "1.3";
  prebuilt_server = fetchurl {
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}.jar";
    sha256 = "1ha04wfmghblwr9ajfl96cswacfgrk0b7klq2ixfvw1kgwhmm6hg";
  };
in
stdenv.mkDerivation rec {
  name = "scrcpy-${version}";
  inherit version;
  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "scrcpy";
    rev = "v${version}";
    sha256 = "02szi8w3w0lacyz42hlayxififi863qpm63yg9qir3jcl2vs7vdk";
  };

  nativeBuildInputs = [ makeWrapper meson ninja pkgconfig ];

  buildInputs = [ ffmpeg SDL2 ];

  # Manually install the server jar to prevent Meson from "fixing" it
  preConfigure = ''
    echo -n > server/meson.build
  '';

  postInstall = ''
    mkdir -p "$out/share/scrcpy"
    ln -s "${prebuilt_server}" "$out/share/scrcpy/scrcpy-server.jar"

    # runtime dep on `adb` to push the server
    wrapProgram "$out/bin/scrcpy" --prefix PATH : "${platformTools}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Display and control Android devices over USB or TCP/IP";
    homepage = https://github.com/Genymobile/scrcpy;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ deltaevo lukeadams ];
  };
}

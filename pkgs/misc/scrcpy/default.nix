{ stdenv, fetchurl, fetchFromGitHub, makeWrapper
, meson
, ninja
, pkgconfig

, platformTools
, ffmpeg
, SDL2
}:

let
  version = "1.2";
  prebuilt_server = fetchurl {
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}.jar";
    sha256 = "0q0zyqw7y33r9ybjp8ay6yac7ifca1lq14pjvw6x78zxs976affb";
  };
in
stdenv.mkDerivation rec {
  name = "scrcpy-${version}";
  inherit version;
  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "scrcpy";
    rev = "v${version}";
    sha256 = "01zw6h6mz2cwqfh9lwypm8pbfx9m9df91l1fq1i0f1d8v49x8wqc";
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

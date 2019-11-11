{ stdenv, fetchFromGitHub
, Carbon
, Cocoa
, CoreServices
, IOKit
, ScriptingBridge
}:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "2.1.2";
  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "yabai";
    rev = "v${version}";
    sha256 = "0bfag249kk5k25imwxassz0wp6682gjzkhr38dibbrrqvdwig3pg";
  };

  buildInputs = [ Carbon Cocoa CoreServices IOKit ScriptingBridge ];

  installPhase = ''
    install -d $out/bin
    cp bin/yabai $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A tiling window manager for macOS based on binary space partitioning";
    homepage = https://github.com/koekeishiya/yabai;
    platforms = platforms.darwin;
    license = licenses.mit;
  };
}

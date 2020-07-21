{ stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, xxd }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "11rsi6z2z7ynfqs1xq3bvf187k5xnwm0d45a8ai9hrqdsf3f1j19";
  };

  buildInputs = [ Carbon Cocoa ScriptingBridge xxd ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/yabai $out/bin/yabai
    cp ./doc/yabai.1 $out/share/man/man1/yabai.1
  '';

  meta = with stdenv.lib; {
    description = ''
      A tiling window manager for macOS based on binary space partitioning
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ cmacrae shardy ];
    license = licenses.mit;
  };
}

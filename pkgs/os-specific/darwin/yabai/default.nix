{ stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, xxd }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rxl0in3rhmrgg3v3l91amr497x37i2w1jqm52k0jb9my1sk67rs";
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

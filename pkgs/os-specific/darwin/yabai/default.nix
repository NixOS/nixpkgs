{ lib, stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, xxd }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pvyjdxgy7yxxz4x87f8an0dlxvxbnmv5kya8hkzw2na453ihvab";
  };

  buildInputs = [ Carbon Cocoa ScriptingBridge xxd ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/yabai $out/bin/yabai
    cp ./doc/yabai.1 $out/share/man/man1/yabai.1
  '';

  meta = with lib; {
    description = ''
      A tiling window manager for macOS based on binary space partitioning
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ cmacrae shardy ];
    license = licenses.mit;
  };
}

{ lib, stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, SkyLight, xxd }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "3.3.10";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gd88s3a05qvvyjhk5wpw1crb7p1gik1gdxn7pv2vq1x7zyvzvph";
  };

  buildInputs = [ Carbon Cocoa ScriptingBridge SkyLight xxd ];

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

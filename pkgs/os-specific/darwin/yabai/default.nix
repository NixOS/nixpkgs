{ lib, stdenv, fetchFromGitHub, darwin, xxd }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "3.3.10";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8O6//T894C32Pba3F2Z84Z6VWeCXlwml3xsXoIZGqL0=";
  };

  nativeBuildInputs = [ xxd ];

  buildInputs = with darwin.apple_sdk.frameworks; [
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
  ];

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

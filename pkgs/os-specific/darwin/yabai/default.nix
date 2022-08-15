{ lib, stdenv, fetchFromGitHub, darwin, xxd }:
let
  replace = {
    "aarch64-darwin" = "--replace '-arch x86_64' ''";
    "x86_64-darwin" = "--replace '-arch arm64e' '' --replace '-arch arm64' ''";
  }.${stdenv.system};
in stdenv.mkDerivation rec {
  pname = "yabai";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "10n67xwhifl0gij1hdqr00ncmkq2j7pa9m10p6ishqfmxy1wqp0z";
  };

  prePatch = ''
    substituteInPlace Makefile \
        --replace 'xcrun clang' clang \
        ${replace}
  '';

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

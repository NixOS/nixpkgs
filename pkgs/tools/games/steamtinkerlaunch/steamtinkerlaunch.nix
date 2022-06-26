{ stdenv, pkgs, xdotool, makeWrapper, xorg, unixtools, yad }:
with pkgs;

stdenv.mkDerivation {
  name = "steamtinkerlaunch";
  src = fetchFromGitHub {
    owner = "frostworx";
    repo = "steamtinkerlaunch";
    rev = "39bacab0c2bf1a9338e7385b4035753c0a197907";
    sha256 = "Fa7DXEIi9MIwj+48eGPE/sKfgy6aOZiWyJ0KrbHuhyQ=";
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    PREFIX="$out" make install
    wrapProgram $out/bin/steamtinkerlaunch \
      --prefix PATH : ${lib.makeBinPath [xdotool xorg.xwininfo unixtools.xxd yad]}
  '';

  meta = {
    description = "Wrapper tool for use with the Steam client which allows customizing and start tools and options for games quickly on the fly";
    homepage = "https://github.com/frostworx/steamtinkerlaunch";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Soupstraw ];
  };
}

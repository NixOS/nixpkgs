{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  name = "vitetris-${version}";
  version = "0.57.2";

  src = fetchFromGitHub {
    owner = "vicgeralds";
    repo = "vitetris";
    rev = "v${version}";
    sha256 = "0px0h4zrpzr6xd1vz7w9gr6rh0z74y66jfzschkcvj84plld10k6";
  };

  hardeningDisable = [ "format" ];

  makeFlags = "INSTALL=install";

  meta = {
    description = "Terminal-based Tetris clone by Victor Nilsson";
    homepage = http://www.victornils.net/tetris/;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ siers ];

    longDescription = ''
      vitetris is a terminal-based Tetris clone by Victor Nilsson. Gameplay is much
      like the early Tetris games by Nintendo.

      Features include: configurable keys, highscore table, two-player mode with
      garbage, network play, joystick (gamepad) support on Linux or with Allegro.
    '';
  };
}

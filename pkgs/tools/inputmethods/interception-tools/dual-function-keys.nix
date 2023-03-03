{ stdenv, lib, fetchFromGitLab, pkg-config, yaml-cpp, libevdev }:

stdenv.mkDerivation rec {
  pname = "dual-function-keys";
  version = "1.4.0";

  src = fetchFromGitLab {
    group = "interception";
    owner = "linux/plugins";
    repo = pname;
    rev = version;
    sha256 = "sha256-xlplbkeptXMBlRnSsc5NgGJfT8aoZxTRgTwTOd7aiWg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libevdev yaml-cpp ];

  prePatch = ''
    substituteInPlace config.mk --replace \
      '/usr/include/libevdev-1.0' \
      "$(pkg-config --cflags libevdev | cut -c 3-)"
  '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    homepage = "https://gitlab.com/interception/linux/plugins/dual-function-keys";
    description = "Tap for one key, hold for another.";
    license = licenses.mit;
    maintainers = with maintainers; [ svend ];
    platforms = platforms.linux;
  };
}

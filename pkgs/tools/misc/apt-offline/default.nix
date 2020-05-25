{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.8.1";
  pname = "apt-offline";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0k79d1d8jiwg1s684r05njmk1dz8gsb8a9bl4agz7m31snc11j84";
  };

  doCheck = false;

  # Requires python-qt4 (feel free to get it working).
  preFixup = ''rm "$out/bin/apt-offline-gui"'';

  meta = with stdenv.lib; {
    description = "Offline APT package manager";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

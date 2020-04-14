{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.8.2";
  pname = "apt-offline";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y9l4jwjk8qsh8x0kk0nqgk6mfsj7zp1gvapnm2bypywkwljbisz";
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

{ stdenv, fetchurl, bash, buildPythonApplication }:

buildPythonApplication rec {
  version = "1.3";
  name = "apt-offline-${version}";

  src = fetchurl {
    #url = "https://alioth.debian.org/frs/download.php/file/3855/${name}.tar.gz";
    # The above URL has two problems: it requires one to be logged in, and it
    # uses a CA that curl doesn't know about.  Instead, we use this mirror:
    url = "http://www.falsifian.org/a/cFi5/${name}.tar.gz";
    sha256 = "1sp7ai2abzhbg9y84700qziybphvpzl2nk3mz1d1asivzyjvxlxy";
  };

  buildInputs = [ ];

  doCheck = false;

  # Requires python-qt4 (feel free to get it working).
  preFixup = ''rm "$out/bin/apt-offline-gui"'';

  meta = with stdenv.lib; {
    description = "offline APT package manager";
    license = licenses.gpl3;
    maintainers = [ maintainers.falsifian ];
    platforms = platforms.linux;
  };
}

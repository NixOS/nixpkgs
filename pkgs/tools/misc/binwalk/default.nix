{ stdenv, fetchFromGitHub, python, wrapPython, curses, zlib, xz, ncompress, gzip, bzip2, gnutar, p7zip, cabextract
, pyqtgraph ? null
, visualizationSupport ? false }:

assert visualizationSupport -> pyqtgraph != null;

stdenv.mkDerivation rec {
  version = "2.0.1";
  name = "binwalk-${version}";

  src = fetchFromGitHub {
    owner = "devttys0";
    repo = "binwalk";
    rev = "v${version}";
    sha256 = "1r5389lk3gk8y4ksrfljyb97l6pwnwvv8g1slbgr20avkzgw8zmn";
  };

  pythonPath = with stdenv.lib; [ curses ]
               ++ optional visualizationSupport [ pyqtgraph ];

  propagatedBuildInputs = with stdenv.lib; [ python wrapPython curses zlib xz ncompress gzip bzip2 gnutar p7zip cabextract ]
                          ++ optional visualizationSupport [ pyqtgraph ];

  postInstall = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    homepage = "http://binwalk.org";
    description = "A tool for searching a given binary image for embedded files";
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}

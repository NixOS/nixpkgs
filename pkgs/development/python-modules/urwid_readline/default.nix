{ stdenv, buildPythonPackage, fetchPypi, pythonPackages, pytest }:

buildPythonPackage rec {
  pname = "urwid_readline";
  version = "0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i7rwxhs686lgzgbwfvl2niw5yhzwjncx8ql7n0sdpk7n6sxq9xq";
  };

  checkInputs = [ pytest ];

  buildInputs = with pythonPackages; [ urwid ];

  meta = with stdenv.lib; {
    description = "A textbox edit widget for urwid that supports readline shortcuts";
    homepage = https://github.com/rr-/urwid_readline;
    repositories.git = git://github.com/rr-/urwid_readline.git;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}

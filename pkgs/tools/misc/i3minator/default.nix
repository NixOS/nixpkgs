{ stdenv, fetchFromGitHub, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  pname = "i3minator";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "carlesso";
    repo = "i3minator";
    rev = version;
    sha256 = "07dic5d2m0zw0psginpl43xn0mpxw7wilj49d02knz69f7c416lm";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ pythonPackages.pyyaml pythonPackages.i3-py ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "i3 project manager similar to tmuxinator";
    longDescription = ''
      A simple "workspace manager" for i3. It allows to quickly
      manage workspaces defining windows and their layout. The
      project is inspired by tmuxinator and uses i3-py.
    '';
    homepage = "https://github.com/carlesso/i3minator";
    license = stdenv.lib.licenses.wtfpl;
    maintainers = with maintainers; [ domenkozar ];
    platforms = stdenv.lib.platforms.linux;
  };

}

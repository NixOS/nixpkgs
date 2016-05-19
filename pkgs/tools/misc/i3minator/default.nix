{ stdenv, fetchurl, buildPythonApplication, pythonPackages, python }:

buildPythonApplication rec {
  name = "i3minator-${version}";
  version = "0.0.4";

  src = fetchurl {
    url = "https://github.com/carlesso/i3minator/archive/${version}.tar.gz";
    sha256 = "11dn062788kwfs8k2ry4v8zr2gn40r6lsw770s9g2gvhl5n469dw";
  };

  propagatedBuildInputs = [ pythonPackages.pyyaml pythonPackages.i3-py ];

  meta = with stdenv.lib; {
    description = "i3 project manager similar to tmuxinator";
    longDescription = ''
      A simple "workspace manager" for i3. It allows to quickly
      manage workspaces defining windows and their layout. The
      project is inspired by tmuxinator and uses i3-py.
    '';
    homepage = https://github.com/carlesso/i3minator;
    license = stdenv.lib.licenses.wtfpl;
    maintainers = with maintainers; [ domenkozar ];
    platforms = stdenv.lib.platforms.linux;
  };

}

{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ydiff";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5430577ecd30974d766ee9b8333e06dc76a947b4aae36d39612a0787865a121";
  };

  # test suite requires a multitude of other version control tooling
  # currently only a single file, an import/usage should suffice
  checkPhase = ''
    $out/bin/ydiff --help
  '';

  meta = with stdenv.lib; {
    description = "View colored, incremental diff in workspace or from stdin with side by side and auto pager support (Was \"cdiff\")";
    longDescription = ''
      Term based tool to view colored, incremental diff in a Git/Mercurial/Svn
      workspace or from stdin, with side by side (similar to diff -y) and auto
      pager support
    '';
    homepage = "https://github.com/ymattw/ydiff";
    license = licenses.bsd3;
    maintainers = [ maintainers.limeytexan ];
  };
}

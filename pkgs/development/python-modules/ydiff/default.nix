{ lib, buildPythonPackage, fetchPypi, docutils, pygments
, gitMinimal, mercurial, subversion, patchutils, less
}:

buildPythonPackage rec {
  pname = "ydiff";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5430577ecd30974d766ee9b8333e06dc76a947b4aae36d39612a0787865a121";
  };

  patchPhase = ''
    substituteInPlace ydiff.py \
      --replace "['git'" "['${gitMinimal}/bin/git'" \
      --replace "['hg'" "['${mercurial}/bin/hg'" \
      --replace "['svn'" "['${subversion}/bin/svn'" \
      --replace "['filterdiff'" "['${patchutils}/bin/filterdiff'" \
      --replace "['less'" "['${less}/bin/less'" # doesn't support PAGER from env
    substituteInPlace tests/test_ydiff.py \
      --replace /bin/rm rm \
      --replace /bin/sh sh
    patchShebangs setup.py
    patchShebangs tests/*.sh
  '';

  nativeCheckInputs = [ docutils pygments ];

  checkPhase = ''
    runHook preCheck
    make doc-check reg # We don't want the linter or coverage check.
    runHook postCheck
  '';

  meta = with lib; {
    description = "View colored, incremental diff in workspace or from stdin with side by side and auto pager support (Was \"cdiff\")";
    longDescription = ''
      Term based tool to view colored, incremental diff in a version
      controlled workspace (supports Git, Mercurial, Perforce and Svn
      so far) or from stdin, with side by side (similar to diff -y)
      and auto pager support.
    '';
    homepage = "https://github.com/ymattw/ydiff";
    license = licenses.bsd3;
    maintainers = (with maintainers; [ leenaars ]) ++ teams.deshaw.members;
  };
}

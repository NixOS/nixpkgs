{ stdenv, fetchFromGitHub, python, autoreconfHook, pkgconfig, makeWrapper
, flex
, gettext, libedit, glib, imagemagick, libxml2, boost, gnuplot, graphviz
, tesseract, gts, libXtst
}:
stdenv.mkDerivation rec {
  version = "0.42";
  pname = "fMBT";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "fMBT";
    rev = "v${version}";
    sha256 = "1jb9nb2mipc5cg99a80dny4m06vz2zral0q30fv75rz2cb6ja4zp";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig flex makeWrapper
    python.pkgs.wrapPython ];

  buildInputs = [ python gettext libedit glib imagemagick libxml2 boost
    gnuplot graphviz tesseract gts 
    ];

  propagatedBuildInputs = with python.pkgs; [
    pyside pydbus pexpect pysideShiboken
  ];

  preBuild = ''
    export PYTHONPATH="$PYTHONPATH:$out/lib/python${python.pythonVersion}/site-packages"
    export PATH="$PATH:$out/bin"
    export LD_LIBRARY_PATH="${stdenv.lib.makeLibraryPath [libXtst]}"
  '';

  postInstall = ''
    echo -e '#! ${stdenv.shell}\npython "$@"' > "$out/bin/fmbt-python"
    chmod a+x "$out/bin/fmbt-python"
    patchShebangs "$out/bin"
    for i in "$out"/bin/*; do
      wrapProgram "$i" --suffix "PATH" ":" "$PATH" \
        --suffix "PYTHONPATH" ":" "$PYTHONPATH" \
        --suffix "LD_LIBRARY_PATH" ":" "$LD_LIBRARY_PATH"
    done
  '';

  meta = with stdenv.lib; {
    description = "Free Model-Based Testing tool";
    homepage = "https://github.com/intel/fMBT";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
  };
}


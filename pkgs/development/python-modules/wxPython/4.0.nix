{ lib, stdenv, buildPythonPackage, fetchPypi, python, pkgconfig
, six, sip, waf, doxygen
, wxGTK, wxmac, darwin
}:

buildPythonPackage rec {
  pname = "wxPython";
  version = "4.0.1";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0467fmh5p73y1gys22npqqlygpz3yivxrbar6889p2rnfldarwpq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    if stdenv.isDarwin
    then [ wxmac darwin.apple_sdk.frameworks.Cocoa ]
    else [ wxGTK wxGTK.gtk ];
  propagatedBuildInputs = [ six ];

  NIX_LDFLAGS = lib.optionals (!stdenv.isDarwin) ([ "-lX11" ] ++ (if wxGTK.withGtk2 then [ "-lgdk-x11-2.0" ] else [ "-lgtk-3" "-lgdk-3" ]));

  SIP = "${sip}/bin/sip";
  DOXYGEN = "${doxygen}/bin/doxygen";

  buildFlags = [ "--release" "--use_syswx" "--no_magic" ] ++ lib.optional (!stdenv.isDarwin) (if wxGTK.withGtk2 then "--gtk2" else "--gtk3");

  buildPhase = ''
    ${python.interpreter} build.py build $buildFlags --jobs=$NIX_BUILD_CORES
    ${python.interpreter} setup.py bdist_wheel --skip-build
  '';

  passthru = {
    wxGTK = if stdenv.isDarwin then wxmac else wxGTK;
  };

  meta = with stdenv.lib; {
    description = "A wxWidgets GUI toolkit for Python";
    homepage = https://www.wxpython.org/;
    license = wxGTK.meta.license;
    platforms = platforms.unix;
    broken = !wxGTK.unicode || !wxGTK.withWebKit;
  };
}

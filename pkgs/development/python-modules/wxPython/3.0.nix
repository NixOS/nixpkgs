{ stdenv, fetchurl
, lib
, pythonPackages
, openglSupport ? true
, wxWidgets
, pkgconfig
, setfile ? null , AGL ? null
}:

assert wxWidgets.unicode;

with pythonPackages;

stdenv.mkDerivation rec {
  name = "wxPython-${version}";
  version = "3.0.2.0";

  disabled = isPy3k || isPyPy;
  doCheck = false;

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "0qfzx3sqx4mwxv99sfybhsij4b5pc03ricl73h4vhkzazgjjjhfm";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ pkgconfig wxWidgets ]
    ++ lib.optional openglSupport pyopengl
    ++ lib.optionals stdenv.isDarwin [ AGL ];

  configureFlags = [
    "--disable-precomp-headers"
    "--with-macosx-version-min=10.7"
  ];

  patchPhase = ''
    substituteInPlace configure --replace "-framework System" -lSystem
    substituteInPlace configure --replace /Developer/Tools/SetFile ${setfile}/bin/SetFile
  '';

  passthru = { inherit wxWidgets openglSupport; };
}

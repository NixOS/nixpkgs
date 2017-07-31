{ stdenv, fetchFromGitHub, intltool, file, pythonPackages, cairo }:

pythonPackages.buildPythonApplication rec {
  name = "oblogout-unstable-${version}";
  version = "2009-11-18";

  src = fetchFromGitHub {
    owner = "nikdoof";
    repo = "oblogout";
    rev = "ee023158c03dee720a1af9b1307b14ed5a95f5a0";
    sha256 = "0nj87q94idb5ki4wnb2xipfgc6k6clr3rmm4xxh46b58z4zhhbmj";
  };

  nativeBuildInputs = [ intltool file pythonPackages.distutils_extra ];

  buildInputs = [ cairo ];

  propagatedBuildInputs = [ pythonPackages.pygtk pythonPackages.pillow pythonPackages.dbus-python ];

  patches = [ ./oblogout-0.3-fixes.patch ];

  postPatch = ''
    substituteInPlace data/oblogout --replace sys.prefix \"$out/${pythonPackages.python.sitePackages}\"
    substituteInPlace oblogout/__init__.py --replace sys.prefix \"$out\"
    mkdir -p $out/share/doc
    cp -a README $out/share/doc
  '';

  meta = {
    description = "Openbox logout script";
    homepage = https://launchpad.net/oblogout;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}

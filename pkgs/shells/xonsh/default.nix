{stdenv, fetchurl, python3Packages}:

python3Packages.buildPythonPackage rec {
  name = "xonsh-${version}";
  version = "0.1.3";

  # The logo xonsh prints during build contains unicode characters, and this
  # fails because locales have not been set up in the build environment.
  # We can fix this on Linux by setting:
  #    export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
  # but this would not be a cross platform solution, so it's simpler to just
  # patch the setup.py script to not print the logo during build.
  prePatch = ''
    substituteInPlace setup.py --replace "print(logo)" ""
  '';

  propagatedBuildInputs = [ python3Packages.ply ];

  src = fetchurl {
    url = "https://github.com/scopatz/xonsh/archive/${version}.zip";
    sha256 = "0p2d7p892w77ii8yy51vpw7jlz2y53k8g61m7l8bar3hr3qrl306";
  };

  meta = with stdenv.lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = "http://xonsh.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}

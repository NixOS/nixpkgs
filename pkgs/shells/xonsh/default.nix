{stdenv, fetchurl, python3Packages}:

python3Packages.buildPythonApplication rec {
  name = "xonsh-${version}";
  version = "0.2.7";

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
    url = "mirror://pypi/x/xonsh/${name}.tar.gz";
    sha256= "10pglgmzj6l0l8mb3r2rxnbigqigcqn9njcgdcrg7s1b409cq4md";
  };

  meta = with stdenv.lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = "http://xonsh.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}

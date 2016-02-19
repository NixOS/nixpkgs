{stdenv, fetchFromGitHub, python3Packages}:

python3Packages.buildPythonApplication rec {
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

  src = fetchFromGitHub {
    owner = "scopatz";
    repo = "xonsh";
    rev = version;
    sha256 = "04qnjqpz5y38g22irpph13j2a4hy7mk9pqvqz1mfimaf8zgmyh1n";
  };

  meta = with stdenv.lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = "http://xonsh.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}

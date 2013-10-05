{ stdenv, fetchgit, python, phantomjs }:

stdenv.mkDerivation rec {
  name = "casperjs-1.0.0-RC5";

  src = fetchgit {
    url = "git://github.com/n1k0/casperjs.git";
    rev = "refs/tags/1.0.0-RC5";
    sha256 = "e7fd6b94b4b304416159196208dea7f6e8841a667df102eb378a698a92f0f2c7";
  };

  patchPhase = ''
    substituteInPlace bin/casperjs --replace "/usr/bin/env python" "${python}/bin/python" \
                                   --replace "'phantomjs'" "'${phantomjs}/bin/phantomjs'"
  '';

  installPhase = ''
    mkdir -p $out/share/casperjs $out/bin
    cp -a . $out/share/casperjs/.
    ln -s $out/share/casperjs/bin/casperjs $out/bin
  '';

  meta = {
    description = "Navigation scripting & testing utility for PhantomJS";
    longDescription = ''
      CasperJS is a navigation scripting & testing utility for PhantomJS.
      It eases the process of defining a full navigation scenario and provides useful high-level
      functions, methods & syntaxic sugar for doing common tasks such as:
      - defining & ordering navigation steps
      - filling forms
      - clicking links
      - capturing screenshots of a page (or an area)
      - making assertions on remote DOM
      - logging & events
      - downloading base64 encoded resources, even binary ones
      - catching errors and react accordingly
      - writing functional test suites, exporting results as JUnit XML (xUnit)
    '';

    homepage = http://casperjs.org;
    license = stdenv.lib.licenses.mit;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}

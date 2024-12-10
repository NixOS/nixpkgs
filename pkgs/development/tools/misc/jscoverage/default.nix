{
  autoconf,
  fetchurl,
  makedepend,
  perl,
  python3,
  lib,
  stdenv,
  zip,
}:

stdenv.mkDerivation rec {
  pname = "jscoverage";
  version = "0.5.1";

  src = fetchurl {
    url = "https://siliconforks.com/${pname}/download/${pname}-${version}.tar.bz2";
    sha256 = "c45f051cec18c10352f15f9844f47e37e8d121d5fd16680e2dd0f3b4420eb7f4";
  };

  patches = [
    ./jsfalse_to_null.patch
  ];

  nativeBuildInputs = [
    perl
    python3
    zip
  ];

  strictDeps = true;

  # It works without MOZ_FIX_LINK_PATHS, circumventing an impurity
  # issue.  Maybe we could kick js/ (spidermonkey) completely and
  # instead use our spidermonkey via nix.
  preConfigure = ''
    sed -i 's/^MOZ_FIX_LINK_PATHS=.*$/MOZ_FIX_LINK_PATHS=""/' ./js/configure
  '';

  meta = {
    description = "Code coverage for JavaScript";

    longDescription = ''
      JSCoverage is a tool that measures code coverage for JavaScript
      programs.

      Code coverage statistics show which lines of a program have been
      executed (and which have been missed). This information is useful
      for constructing comprehensive test suites (hence, it is often
      called test coverage).

      JSCoverage works by instrumenting the JavaScript code used in web
      pages. Code coverage statistics are collected while the
      instrumented JavaScript code is executed in a web browser.

      JSCoverage supports the complete language syntax described in the
      ECMAScript Language Specification (ECMA-262, 3rd
      edition). JSCoverage works with any modern standards-compliant web
      browser - including Internet Explorer (IE 6, 7, and 8), Firefox,
      Opera, Safari, and Google Chrome - on Microsoft Windows and
      GNU/Linux.
    '';

    homepage = "http://siliconforks.com/jscoverage/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}

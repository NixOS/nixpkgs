{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
    name = "wcwidth-${version}";
    version = "0.1.7";

    src = fetchurl {
      url = "mirror://pypi/w/wcwidth/${name}.tar.gz";
      sha256 = "0pn6dflzm609m4r3i8ik5ni9ijjbb5fa3vg1n7hn6vkd49r77wrx";
    };

    # Checks fail due to missing tox.ini file:
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Measures number of Terminal column cells of wide-character codes";
      longDescription = ''
        This API is mainly for Terminal Emulator implementors -- any Python
        program that attempts to determine the printable width of a string on
        a Terminal. It is implemented in python (no C library calls) and has
        no 3rd-party dependencies.
      '';
      homepage = https://github.com/jquast/wcwidth;
      license = licenses.mit;
    };
  }

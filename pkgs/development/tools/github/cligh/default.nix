{ stdenv, fetchurl, pythonPackages }:

with pythonPackages;
buildPythonApplication rec {
  name = "cligh-${version}";
  version = "0.3";
 
  src = fetchurl {
    url = "https://github.com/CMB/cligh/archive/v${version}.tar.gz";
    sha256 = "0779v3g9q656crs7hiakhmkr8207qiqyn67brl67iz1cbccnhwid";
  };

  propagatedBuildInputs = [ pyxdg PyGithub ];

  meta = {
    homepage = "http://the-brannons.com/software/cligh.html";
    description = "A simple command-line interface to the facilities of Github";
    longDescription = ''
        Cligh is a simple command-line interface to the facilities of GitHub.
        It is written by Christopher Brannon chris@the-brannons.com. The
        current version is 0.3, released July 23, 2016. This program is still
        in the early stage of development. It is by no means feature-complete.
        A friend and I consider it useful, but others may not. 
    '';
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ jhhuh ];
  };
}

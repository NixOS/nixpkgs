{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "cligh-${version}";
  version = "0.3";

  doCheck = false; # no tests

  src = fetchFromGitHub {
    owner = "CMB";
    repo = "cligh";
    rev = "v${version}";
    sha256 = "0d1fd78rzl2n75xpmy1gnxh1shvcs4qm0j4qqszqvfriwkg2flxn";
  };

  propagatedBuildInputs = with pythonPackages; [ pyxdg PyGithub ];

  meta = with stdenv.lib; {
    homepage = "http://the-brannons.com/software/cligh.html";
    description = "A simple command-line interface to the facilities of Github";
    longDescription = ''
        Cligh is a simple command-line interface to the facilities of GitHub.
        It is written by Christopher Brannon chris@the-brannons.com. The
        current version is 0.3, released July 23, 2016. This program is still
        in the early stage of development. It is by no means feature-complete.
        A friend and I consider it useful, but others may not.
    '';
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = [ maintainers.jhhuh ];
  };
}

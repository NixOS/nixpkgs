{ stdenv, fetchgit, pkgs }:

stdenv.mkDerivation rec {
  pname = "pyenv";
  version = "1.2.20";

  src = fetchgit {
    url = "https://github.com/pyenv/pyenv.git";
    rev = "c52d26d8dbc7a0f9c7d4d4f8886fe5d1f7dbd563";
    sha256 = "1jpi761cnkaxvrk4ym2mb47sdvfbkpa81skhx94ivi13slbm0dzq";
  };

  buildInputs = [ pkgs.bash ];

  buildPhase = "true";
  installPhase = ''
    cp -r ${src} $out
  '';

  meta = with stdenv.lib; {
    description = "Simple Python version management";
    longDescription = ''
      pyenv lets you easily switch between multiple versions of Python.
    '';
    homepage = "https://github.com/pyenv/pyenv";
    changelog = "https://github.com/pyenv/pyenv/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.stephenwithph ];
    platforms = platforms.all;
  };
}

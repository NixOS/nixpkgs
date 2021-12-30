{ lib, stdenv, fetchFromGitHub, perlPackages, pythonPackages, shocco, testVersion }:

stdenv.mkDerivation rec {
  pname = "shocco";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "rtomayko";
    repo = "shocco";
    rev = version;
    sha256 = "1nkwcw9fqf4vyrwidqi6by7nrmainkjqkirkz3yxmzk6kzwr38mi";
  };

  prePatch = ''
    # Don't change $PATH
    substituteInPlace configure --replace PATH= NIRVANA=
  '';

  buildInputs = [ perlPackages.TextMarkdown pythonPackages.pygments ];

  passthru.tests.version = testVersion { package = shocco; };

  meta = with lib; {
    description = "A quick-and-dirty, literate-programming-style documentation generator for / in POSIX shell";
    homepage = "https://rtomayko.github.io/shocco/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ dotlambda ];
  };
}

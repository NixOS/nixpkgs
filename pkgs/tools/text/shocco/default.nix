{ stdenv, fetchFromGitHub, perlPackages, pythonPackages }:

stdenv.mkDerivation rec {
  name = "shocco-${version}";
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

  meta = with stdenv.lib; {
    description = "A quick-and-dirty, literate-programming-style documentation generator for / in POSIX shell";
    homepage = https://rtomayko.github.io/shocco/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ dotlambda ];
  };
}

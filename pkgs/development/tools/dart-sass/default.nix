{ stdenv, fetchFromGitHub, buildDartPackage }:

buildDartPackage rec {
  pname = "dart-sass";
  version = "1.26.10";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    sha256 = "0qnqjd1ny8cm0jzd9fjacf12628ilc7py9p0fziww0d6n70cgrr0";
  };

  pubspecLock = ./pubspec.lock;
  pubSha256 = "00n9vawlzb57m1m00f6hn0xd0mka80bbygid77rj2k1cd5glwvzp";

  executables = {
    dart-sass = "sass";
    sass = "sass";
  };

  meta = with stdenv.lib; {
    description = "The reference implementation of Sass, written in Dart.";
    homepage = "https://sass-lang.com/dart-sass";
    maintainers = [ maintainers.tadfisher ];
    license = licenses.mit;
  };
}

{ stdenv, lib, bundlerEnv }:

let version = "4.4.2";
in bundlerEnv {
  name = "gist-${version}";
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;
  meta = with lib; {
    homepage = "http://defunkt.io/gist/";
    description = "upload code to https://gist.github.com (or github enterprise)";
    platforms = platforms.all;
    license = licenses.mit;
  };
}

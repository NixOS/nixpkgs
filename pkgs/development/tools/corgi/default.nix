{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "corgi-${rev}";
  rev = "v0.2.3";

  goPackagePath = "github.com/DrakeW/corgi";

  src = fetchFromGitHub {
    owner = "DrakeW";
    repo = "corgi";
    inherit rev;
    sha256 = "0ahwpyd6dac04qw2ak51xfbwkr42sab1gkhh52i7hlcy12jpwl8q";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "CLI workflow manager";
    longDescription = ''
      Corgi is a command-line tool that helps with your repetitive command usages by organizing them into reusable snippet.
    '';
    homepage = https://github.com/DrakeW/corgi;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ kalbasit ];
  };
}

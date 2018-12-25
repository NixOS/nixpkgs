{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "corgi-${rev}";
  rev = "v0.2.4";

  goPackagePath = "github.com/DrakeW/corgi";

  src = fetchFromGitHub {
    inherit rev;

    owner = "DrakeW";
    repo = "corgi";
    sha256 = "0h9rjv1j129n1ichwpiiyspgim1273asi3s6hgizvbc75gbbb8fn";
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

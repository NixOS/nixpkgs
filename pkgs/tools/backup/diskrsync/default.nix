{ buildGoPackage, fetchFromGitHub, stdenv, openssh, makeWrapper }:

buildGoPackage rec {
  pname = "diskrsync";
  version = "unstable-2019-01-02";

  src = fetchFromGitHub {
    owner = "dop251";
    repo = pname;
    rev = "e8598ef71038527a8a77d1a6cf2a73cfd96d9139";
    sha256 = "1dqpmc4hp81knhdk3mrmwdr66xiibsvj5lagbm5ciajg9by45mcs";
  };

  goPackagePath = "github.com/dop251/diskrsync";
  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram "$bin/bin/diskrsync" --argv0 diskrsync --prefix PATH : ${openssh}/bin
  '';

  meta = with stdenv.lib; {
    description = "Rsync for block devices and disk images";
    homepage = https://github.com/dop251/diskrsync;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };

}

{ buildGoPackage, fetchFromGitHub, stdenv, openssh, makeWrapper }:

buildGoPackage rec {

  name = "${pname}-${version}";
  pname = "diskrsync";
  version = "unstable-2018-02-03";

  src = fetchFromGitHub {
    owner = "dop251";
    repo = pname;
    rev = "2f36bd6e5084ce16c12a2ee216ebb2939a7d5730";
    sha256 = "1rpfk7ds4lpff30aq4d8rw7g9j4bl2hd1bvcwd1pfxalp222zkxn";
  };

  goPackagePath = "github.com/dop251/diskrsync";
  goDeps = ./deps.nix;

  buildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram "$bin/bin/diskrsync" --prefix PATH : ${openssh}/bin
  '';

  meta = with stdenv.lib; {
    description = "Rsync for block devices and disk images";
    homepage = https://github.com/dop251/diskrsync;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };

}

{ lib, stdenv, fetchFromGitHub, makeWrapper
, trash-cli, coreutils, which, getopt }:

stdenv.mkDerivation rec {
  pname = "rmtrash";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "PhrozenByte";
    repo = pname;
    rev = "v${version}";
    sha256 = "04a9c65wnkq1fj8qhdsdbps88xjbp7rn6p27y25v47kaysvrw01j";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    for f in rm{,dir}trash; do
      install -D ./$f $out/bin/$f
      wrapProgram $out/bin/$f \
        --prefix PATH : ${lib.makeBinPath [ trash-cli coreutils which getopt ]}
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/PhrozenByte/rmtrash";
    description = "trash-put made compatible with GNUs rm and rmdir";
    longDescription = ''
      Put files (and directories) in trash using the `trash-put` command in a
      way that is, otherwise as `trash-put` itself, compatible to GNUs `rm`
      and `rmdir`.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peelz ];
  };
}

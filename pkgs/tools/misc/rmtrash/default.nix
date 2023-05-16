{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper
, trash-cli, coreutils, which, getopt }:

stdenvNoCC.mkDerivation rec {
  pname = "rmtrash";
<<<<<<< HEAD
  version = "1.15";
=======
  version = "1.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "PhrozenByte";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-vCtIM6jAYfrAOopiTcb4M5GNtucVnK0XEEKbMq1Cbc4=";
=======
    sha256 = "0wfb2ykzlsxyqn9krfsis9jxhaxy3pxl71a4f15an1ngfndai694";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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
    platforms = platforms.all;
  };
}

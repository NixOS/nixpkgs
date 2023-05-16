{lib, stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation {
  pname = "easysnap";
<<<<<<< HEAD
  version = "unstable-2022-06-03";
=======
  version = "unstable-2020-04-04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
<<<<<<< HEAD
    rev = "5f961442315a6f7eb8ca5b705bd52fe1e6d7dc42";
    sha256 = "sha256-jiKdpwuw0Oil0sxUr/3KJ6Nbfxh8DvBei0yy0nRM+Vs=";
=======
    rev = "26f89c0c3cda01e2595ee19ae5fb8518da25b4ef";
    sha256 = "1k49k1m7y8s099wyiiz8411i77j1156ncirynmjfyvdhmhcyp5rw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    mkdir -p $out/bin
<<<<<<< HEAD
    cp easysnap* $out/bin/
=======
    cp -n easysnap* $out/bin/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    for i in $out/bin/*; do
      substituteInPlace $i \
        --replace zfs ${zfs}/bin/zfs
    done
  '';

  meta = with lib; {
    homepage    = "https://github.com/sjau/easysnap";
    description = "Customizable ZFS Snapshotting tool with zfs send/recv pulling";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ sjau ];
  };

}

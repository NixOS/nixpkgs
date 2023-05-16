{ lib, buildNpmPackage, src, version }:

buildNpmPackage {
  inherit src version;
  pname = "photoprism-frontend";

  postPatch = ''
    cd frontend
  '';

<<<<<<< HEAD
  npmDepsHash = "sha256-tFO6gdERlljGJfMHvv6gMahZ6FgrXQOC/RQOsg1WAVk=";
=======
  npmDepsHash = "sha256-NAtZ85WjiQn9w0B9Y78XL+tSsshHlaXS8+WtojFJmGg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ../assets $out/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ benesim ];
  };
}

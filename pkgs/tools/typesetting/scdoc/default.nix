<<<<<<< HEAD
{ lib
, stdenv
, fetchFromSourcehut
, buildPackages
}:

stdenv.mkDerivation (finalAttrs: {
=======
{ lib, stdenv, fetchFromSourcehut, buildPackages }:

stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "scdoc";
  version = "1.11.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
<<<<<<< HEAD
    repo = "scdoc";
    rev = finalAttrs.version;
    hash = "sha256-2NVC+1in1Yt6/XGcHXP+V4AAz8xW/hSq9ctF/Frdgh0=";
  };

  outputs = [ "out" "man" "dev" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" ""
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "HOST_SCDOC=${lib.getExe buildPackages.scdoc}"
=======
    repo = pname;
    rev = version;
    sha256 = "07c2vmdgqifbynm19zjnrk7h102pzrriv73izmx8pmd7b3xl5mfq";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" "" \
      --replace "/usr/local" "$out"
  '';

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "HOST_SCDOC=${buildPackages.scdoc}/bin/scdoc"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "A simple man page generator written in C99 for POSIX systems";
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ primeos AndersonTorres ];
    platforms = lib.platforms.unix;
    mainProgram = "scdoc";
  };
})
=======
  meta = with lib; {
    description = "A simple man page generator";
    longDescription = ''
      scdoc is a simple man page generator written for POSIX systems written in
      C99.
    '';
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

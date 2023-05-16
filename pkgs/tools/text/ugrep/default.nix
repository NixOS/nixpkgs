{ lib
, stdenv
, fetchFromGitHub
, boost
, bzip2
, lz4
, pcre2
, xz
, zlib
<<<<<<< HEAD
, zstd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ugrep";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "ugrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7cE8kbj8ChvHOPb1F7Fj9talg82nXpXRPt4oBSGSWZw=";
=======
}:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NDH2OEweIU0/JHfkq0md6cll2uwCTLkVmJcmF337DUw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    boost
    bzip2
    lz4
    pcre2
    xz
    zlib
<<<<<<< HEAD
    zstd
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Ultra fast grep with interactive query UI";
    homepage = "https://github.com/Genivia/ugrep";
<<<<<<< HEAD
    changelog = "https://github.com/Genivia/ugrep/releases/tag/v${finalAttrs.version}";
=======
    changelog = "https://github.com/Genivia/ugrep/releases/tag/v${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ numkem ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  zig_0_11,
}:

stdenv.mkDerivation rec {
  pname = "poop";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "poop";
    rev = version;
    hash = "sha256-ekZpulQ1NpEOCG9KU2I4O0NL8mD+CC7bKF0tZbl7vHo=";
  };

  # fix compilation with zig 0.11
  patches = [
    # https://github.com/andrewrk/poop/pull/41
    (fetchpatch {
      name = "update-to-zig-0-11-0.patch";
      url = "https://github.com/andrewrk/poop/commit/15c794d9dea91570485104cda26346f2ae5c9365.patch";
      hash = "sha256-iv3IuYIDPzs98wiTXcO0igngaRRdQnASvzA4bYET54c=";
    })
    # https://github.com/andrewrk/poop/pull/36
    (fetchpatch {
      name = "update-zig-to-latest-0-11-0-dev-3883-7166407d8.patch";
      url = "https://github.com/andrewrk/poop/commit/b1ca37c0cf637e9bbbf24cd243bafaedf02fa8c7.patch";
      hash = "sha256-/j2zqi0Q2Pl7ZL+4GflwD/MnqcKScT/1SdYJAQ3o4bU=";
    })
  ];

  nativeBuildInputs = [
    zig_0_11.hook
  ];

  meta = with lib; {
    description = "Compare the performance of multiple commands with a colorful terminal user interface";
    homepage = "https://github.com/andrewrk/poop";
    changelog = "https://github.com/andrewrk/poop/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
    mainProgram = "poop";
  };
}

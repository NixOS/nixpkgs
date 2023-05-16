{ lib, stdenv
, cairo
, fetchFromGitHub
<<<<<<< HEAD
=======
, gettext
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, glib
, gobject-introspection
, gtksourceview3
, json-glib
, libelf
, makeWrapper
, pango
, pkg-config
, polkit
, python3
, scons
, sphinx
, util-linux
, wrapGAppsHook
, withGui ? false }:

assert withGui -> !stdenv.isDarwin;

stdenv.mkDerivation rec {
  pname = "rmlint";
<<<<<<< HEAD
  version = "2.10.2";
=======
  version = "2.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-pOo1YfeqHUU6xyBRFbcj2lX1MHJ+a5Hi31BMC1nYZGo=";
=======
    sha256 = "15xfkcw1bkfyf3z8kl23k3rlv702m0h7ghqxvhniynvlwbgh6j2x";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # pass through NIX_* environment variables to scons.
    ./scons-nix-env.patch
  ];

  nativeBuildInputs = [
    pkg-config
    sphinx
    scons
  ] ++ lib.optionals withGui [
    makeWrapper
    wrapGAppsHook
<<<<<<< HEAD
    gobject-introspection
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    glib
    json-glib
    libelf
    util-linux
  ] ++ lib.optionals withGui [
    cairo
<<<<<<< HEAD
=======
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gtksourceview3
    pango
    polkit
    python3
    python3.pkgs.pygobject3
  ];

  prePatch = ''
    # remove sources of nondeterminism
    substituteInPlace lib/cmdline.c \
      --replace "__DATE__" "\"Jan  1 1970\"" \
      --replace "__TIME__" "\"00:00:00\""
    substituteInPlace docs/SConscript \
      --replace "gzip -c " "gzip -cn "
  '';

  # Otherwise tries to access /usr.
  prefixKey = "--prefix=";

  sconsFlags = lib.optionals (!withGui) [ "--without-gui" ];

  # in GUI mode, this shells out to itself, and tries to import python modules
  postInstall = lib.optionalString withGui ''
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
    gappsWrapperArgs+=(--prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${python3.pkgs.pygobject3}):$(toPythonPath ${python3.pkgs.pycairo})")
  '';

  meta = with lib; {
    description = "Extremely fast tool to remove duplicates and other lint from your filesystem";
    homepage = "https://rmlint.readthedocs.org";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ aaschmid koral ];
  };
}

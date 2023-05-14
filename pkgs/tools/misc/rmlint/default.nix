{ lib, stdenv
, cairo
, fetchFromGitHub
, gettext
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
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${version}";
    sha256 = "15xfkcw1bkfyf3z8kl23k3rlv702m0h7ghqxvhniynvlwbgh6j2x";
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
  ];

  buildInputs = [
    glib
    json-glib
    libelf
    util-linux
  ] ++ lib.optionals withGui [
    cairo
    gobject-introspection
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

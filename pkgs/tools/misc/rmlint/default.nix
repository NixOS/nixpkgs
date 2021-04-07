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

with lib;
stdenv.mkDerivation rec {
  pname = "rmlint";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${version}";
    sha256 = "15xfkcw1bkfyf3z8kl23k3rlv702m0h7ghqxvhniynvlwbgh6j2x";
  };

  CFLAGS="-I${lib.getDev util-linux}/include";

  nativeBuildInputs = [
    pkg-config
    sphinx
    gettext
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

  # this doesn't seem to support configureFlags, and appends $out afterwards,
  # so add the --without-gui in front of it
  prefixKey = lib.optionalString (!withGui) " --without-gui " + "--prefix=";

  # in GUI mode, this shells out to itself, and tries to import python modules
  postInstall = lib.optionalString withGui ''
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
    gappsWrapperArgs+=(--prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${python3.pkgs.pygobject3}):$(toPythonPath ${python3.pkgs.pycairo})")
  '';

  meta = {
    description = "Extremely fast tool to remove duplicates and other lint from your filesystem";
    homepage = "https://rmlint.readthedocs.org";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.koral ];
  };
}

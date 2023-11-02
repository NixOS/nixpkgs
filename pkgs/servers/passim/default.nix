{ lib, stdenv, fetchFromGitHub, cmake, meson, ninja, pkg-config, glib
, gobject-introspection, python3, systemd }:

stdenv.mkDerivation (finalAttrs: {
  pname = "passim";
  version = "unstable-2023-07-31";
  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "passim";
    rev = "ea75eee265cf6694c98e75b7e2ae2e3cd8f413ae";
    hash = "sha256-pHH/nVFTQiK14loLcoCmh8iOkFh4KU5i+9ZEutoCpCA=";
  };
  nativeBuildInputs = [ meson ninja pkg-config python3 ];
  buildInputs = [ glib gobject-introspection systemd ];
  mesonFlags = [ "-Dsystemd_root_prefix=$out" ];
  meta = finalAttrs.src.meta // {
    description = "A local caching server";
    homepage = "https://github.com/hughsie/passim";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})

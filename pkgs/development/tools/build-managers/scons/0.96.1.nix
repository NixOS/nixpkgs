{stdenv, fetchurl, python, version ? "0.96.1"}:

assert version == "0.96.1";

import ./default.nix
{
  inherit stdenv fetchurl python version;
  versionHash = "0z8cimrb10pj10zx9hv8xdqa1dpwjj61yhf3l26ifw323in1isk7";
}

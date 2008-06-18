{stdenv, fetchurl, python, version ? "0.98.5"}:

assert version == "0.98.5";

import ./default.nix
{
  inherit stdenv fetchurl python version;
  versionHash = "0xya9pkrwkdg1z2671slhl5nr5jf0pq46cr9ak7dxc8b0wazsh6j";
}

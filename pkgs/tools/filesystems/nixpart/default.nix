{ stdenv, fetchFromGitHub, python3Packages, nix }:

python3Packages.buildPythonApplication rec {
  name = "nixpart-${version}";
  version = "unstable-1.0.0";

  src = fetchFromGitHub {
    owner = "aszlig";
    repo = "nixpart";
    rev = "e22e1b5ccecf491949addffe9c0555ee55e76008";
    sha256 = "1j1m7d180jmxngc95z5fghxzbhxw5ysvalnxpa94cmj0s4mp5ljx";
  };

  checkInputs = [ nix ];
  propagatedBuildInputs = [ python3Packages.blivet ];
  makeWrapperArgs = [ "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\"" ];

  meta = {
    description = "NixOS storage manager/partitioner";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
    platforms = stdenv.lib.platforms.linux;
  };
}

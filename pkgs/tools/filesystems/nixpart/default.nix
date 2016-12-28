{ stdenv, fetchFromGitHub, python3Packages, nix }:

python3Packages.buildPythonApplication rec {
  name = "nixpart-${version}";
  version = "unstable-1.0.0";

  src = fetchFromGitHub {
    owner = "aszlig";
    repo = "nixpart";
    rev = "fb8163fc8831a8f931d03771ed2173aa66288312";
    sha256 = "1z50afx6fqni3brinazabw0aa8i49hdg0a7p6calc8yaq1ccq9dm";
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

{ stdenv, fetchFromGitHub, python3Packages, nix }:

python3Packages.buildPythonApplication rec {
  name = "nixpart-${version}";
  version = "unstable-1.0.0";

  src = fetchFromGitHub {
    owner = "aszlig";
    repo = "nixpart";
    rev = "1c52c26bcd9b8f939b0be04face8f704cda80067";
    sha256 = "1zzgffsrap767rjs9m37havgmclibvh1z67cljkiz4cqk12ivciq";
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

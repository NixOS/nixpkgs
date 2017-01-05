{ stdenv, fetchFromGitHub, python3Packages, nix }:

python3Packages.buildPythonApplication rec {
  name = "nixpart-${version}";
  version = "unstable-1.0.0";

  src = fetchFromGitHub {
    owner = "aszlig";
    repo = "nixpart";
    rev = "b213f29886bf28757f0c7afb6baf23ecf4993cf0";
    sha256 = "1jkd8n64b06nm9zbqc7dakb300mwrcmddxxlkm36n2kv15gsyh1p";
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

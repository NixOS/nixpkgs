{ stdenv, fetchFromGitHub, python3Packages, nix }:

python3Packages.buildPythonApplication rec {
  name = "nixpart-${version}";
  version = "unstable-1.0.0";

  src = fetchFromGitHub {
    owner = "aszlig";
    repo = "nixpart";
    rev = "478adc5823c3424b900dafcb5359d9925fe36e41";
    sha256 = "0g07zjhzpqa7wjy9k0jpn87dzp5kp0xhdgj7r8hhf9b0mzl9jm1y";
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

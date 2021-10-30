{ lib, stdenv, buildPythonPackage, fetchFromGitHub, libiconv, rustPlatform, setuptools-rust }:

buildPythonPackage rec {
  pname = "skytemple-rust";
  version = "unstable-2021-05-30"; # Contains build bug fixes, but is otherwise identical to 0.0.1.post0

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = "cff8b2930af6d25d41331fab8c04f56a4fd75e95";
    sha256 = "18y6wwvzyw062zlv3gcirr1hgld9d97ffyrvy0jvw8nr3b9h9x0i";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1ypcsf9gbq1bz29kfn7g4kg8741mxg1lfcbb14a0vfhjq4d6pnx9";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [ cargoSetupHook rust.cargo rust.rustc ]);

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    description = "Binary Rust extensions for SkyTemple";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix ];
  };
}

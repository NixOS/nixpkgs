{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, libiconv
, Foundation
, rustPlatform
, setuptools-rust }:

buildPythonPackage rec {
  pname = "skytemple-rust";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "sha256-rC7KA79va8gZpMKJQ7s3xYdbopNqmWdRYDCbaWaxsR0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-lXPCxRbaqUC5EfyeBPtJDuGADYOA+DWMaOZRwXppP8E=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];
  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [ cargoSetupHook rust.cargo rust.rustc ]);

  GETTEXT_SYSTEM = true;

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    description = "Binary Rust extensions for SkyTemple";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}

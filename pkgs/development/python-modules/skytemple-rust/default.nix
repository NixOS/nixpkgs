{ lib
, stdenv
, buildPythonPackage
, cargo
, fetchFromGitHub
, libiconv
, Foundation
, rustPlatform
, rustc
, setuptools-rust
, range-typed-integers
}:

buildPythonPackage rec {
  pname = "skytemple-rust";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-Txx8kQNb3ODbaJXfuHERzPx4zGUqYXzy+jbLNaMyf+w=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-KQA8dfHnuysx9EUySJXZ/52Hfq6AbALwkBp3B1WJJuc=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];
  nativeBuildInputs = [ setuptools-rust rustPlatform.cargoSetupHook cargo rustc ];
  propagatedBuildInputs = [ range-typed-integers ];

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

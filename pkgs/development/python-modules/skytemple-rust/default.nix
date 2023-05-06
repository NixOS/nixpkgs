{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, libiconv
, Foundation
, rustPlatform
, setuptools-rust
, range-typed-integers
}:

buildPythonPackage rec {
  pname = "skytemple-rust";
  version = "1.4.0.post0";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-aw57B15sDbMcdNPD8MW+O7AdqSSqjlOcuXNSm10GdPM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-SvHrMr5k4afVdU5nvg+bcoHVmzHYyoOYqv7nOSVxRCE=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];
  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [ cargoSetupHook rust.cargo rust.rustc ]);
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

{ lib
, stdenv
, buildPythonPackage
, cargo
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # Necessary for python3Packages.skytemple-files tests to pass.
    # https://github.com/SkyTemple/skytemple-files/issues/449
    (fetchpatch {
      url = "https://github.com/SkyTemple/skytemple-rust/commit/eeeac215c58eda2375dc499aaa1950df0e859802.patch";
      hash = "sha256-9oUrwI+ZMI0Pg8F/nzLkf0YNkO9WSMkUAqDk4GuGfQo=";
      includes = [ "src/st_kao.rs" ];
    })
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];
  nativeBuildInputs = [ setuptools-rust rustPlatform.cargoSetupHook cargo rustc ];
  propagatedBuildInputs = [ range-typed-integers ];

  GETTEXT_SYSTEM = true;

  doCheck = false; # tests for this package are in skytemple-files package
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    description = "Binary Rust extensions for SkyTemple";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}

{ lib, stdenv, buildPythonPackage, fetchFromGitHub, libiconv, rustPlatform, setuptools-rust }:

buildPythonPackage rec {
  pname = "skytemple-rust";
  version = "unstable-2021-08-11";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = "e306e5edc096cb3fef25585d9ca5a2817543f1cd";
    sha256 = "0ja231gsy9i1z6jsaywawz93rnyjhldngi5i787nhnf88zrwx9ml";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0gjvfblyv72m0nqv90m7qvbdnazsh5ind1pxwqz83vm4zjh9a873";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [ cargoSetupHook rust.cargo rust.rustc ]);

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    description = "Binary Rust extensions for SkyTemple";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}

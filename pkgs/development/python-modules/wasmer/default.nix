{ lib
, rustPlatform
, fetchFromGitHub
, maturin
, buildPythonPackage
, python
}:
let
  pname = "wasmer";
  version = "1.0.0";

  wheel = rustPlatform.buildRustPackage rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "wasmerio";
      repo = "wasmer-python";
      rev = version;
      hash = "sha256-I1GfjLaPYMIHKh2m/5IQepUsJNiVUEJg49wyuuzUYtY=";
    };

    cargoHash = "sha256-txOOia1C4W+nsXuXp4EytEn82CFfSmiOYwRLC4WPImc=";

    nativeBuildInputs = [ maturin python ];

    preBuild = ''
      cd packages/api
    '';

    buildPhase = ''
      runHook preBuild
      maturin build --release --manylinux off --strip
      runHook postBuild
    '';

    postBuild = ''
      cd ../..
    '';

    doCheck = false;

    installPhase = ''
      runHook preInstall
      install -Dm644 -t $out target/wheels/*.whl
      runHook postInstall
    '';
  };

in
buildPythonPackage rec {
  inherit pname version;

  format = "wheel";
  src = wheel;

  unpackPhase = ''
    mkdir -p dist
    cp $src/*.whl dist
  '';

  pythonImportsCheck = [ "wasmer" ];

  meta = with lib; {
    description = "Python extension to run WebAssembly binaries";
    homepage = "https://github.com/wasmerio/wasmer-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

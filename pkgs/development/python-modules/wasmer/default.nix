{ lib
, rustPlatform
, fetchFromGitHub
, maturin
, buildPythonPackage
, isPy38
, python
}:
let
  pname = "wasmer";
  version = "1.0.0-beta1";

  wheel = rustPlatform.buildRustPackage rec {
    name = "${pname}-${version}-py${python.version}";

    src = fetchFromGitHub {
      owner = "wasmerio";
      repo = "wasmer-python";
      rev = version;
      sha256 = "0302lcfjlw7nz18nf86z6swhhpp1qnpwcsm2fj4avl22rsv0h78j";
    };

    cargoSha256 = "0d83dniijjq8rc4fcwj6ja5x4hxh187afnqfd8c9fzb8nx909a0v";

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
  # we can only support one python version because the cargo hash changes with the python version
  disabled = !isPy38;

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

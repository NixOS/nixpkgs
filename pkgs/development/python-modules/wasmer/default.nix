{ lib
, rustPlatform
, fetchFromGitHub
, maturin
, buildPythonPackage
, pythonOlder
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

    cargoSha256 = {
      "3.9" = "15f80m41hapcbms0ydgadj8ykk811sgbzxjqlvmh68rw6qz4pbng";
      "3.8" = "0d83dniijjq8rc4fcwj6ja5x4hxh187afnqfd8c9fzb8nx909a0v";
      "3.7" = "0f9s454spr5kj5lzhni0kv0lyq8facb3kdsa1qbrx7vmh2qyis80";
      "3.6" = "0kvfz1pv5lfrkfy6zjs6zx7c79jczb8jnz2f8mb35vrj21y2lhg4";
    }.${python.pythonVersion};

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
  disabled = pythonOlder "3.6";

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

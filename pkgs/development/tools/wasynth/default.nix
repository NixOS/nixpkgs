{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasynth";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Rerumu";
    repo = "Wasynth";
    rev = "v${version}";
    sha256 = "sha256-hbY+epUtYSQrvnAbCELsVcqd3UoXGn24FkzWfrM0K14=";
  };

  # A lock file isn't provided, so it must be added manually.
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Not all of the tests pass.
  doCheck = false;

  # These binaries are tests and should be removed.
  postInstall = ''
    rm $out/bin/{luajit,luau}_translate
  '';

  meta = with lib; {
    description = "WebAssembly translation tools for various languages";
    longDescription = ''
      Wasynth provides the following WebAssembly translation tools:
       * wasm2luajit: translate WebAssembly to LuaJIT source code
       * wasm2luau: translate WebAssembly Luau source code
    '';
    homepage = "https://github.com/Rerumu/Wasynth";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ wackbyte ];
  };
}

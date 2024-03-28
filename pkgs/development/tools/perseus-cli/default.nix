{ lib
, stdenv
, rustPlatform
, fetchCrate
, makeWrapper
, wasm-pack
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "perseus-cli";
  version = "0.4.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Qq+DQOJP11A5WMG+l3F1Uh+VjK7A9fKej2UOmFIIYXs=";
  };

  cargoSha256 = "sha256-W1colldWSJ9/M3C8lWxgHCVGgksS9grzFZsMLd4ZFAo=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  postInstall = ''
    wrapProgram $out/bin/perseus \
      --prefix PATH : "${lib.makeBinPath [ wasm-pack ]}"
  '';

  # Disable tests for https://github.com/framesurge/perseus/issues/305
  doCheck = false;

  meta = with lib; {
    homepage = "https://framesurge.sh/perseus/en-US";
    description = "A high-level web development framework for Rust with full support for server-side rendering and static generation";
    maintainers = with maintainers; [ max-niederman ];
    license = with licenses; [ mit ];
    mainProgram = "perseus";
  };
}

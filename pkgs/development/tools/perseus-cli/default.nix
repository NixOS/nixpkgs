{ lib, rustPlatform, fetchCrate, makeWrapper, wasm-pack }:

rustPlatform.buildRustPackage rec {
  pname = "perseus-cli";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YyQQjuxNUxuo2PFluGyT/CpG22tgjRCfmFKA5MFRgHo=";
  };

  cargoSha256 = "sha256-SKxPsltXFH+ENexn/KDD43hGLSTgvtU9hv9Vdi2oeFA=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/perseus \
      --prefix PATH : "${lib.makeBinPath [ wasm-pack ]}"
  '';

  meta = with lib; {
    homepage = "https://arctic-hen7.github.io/perseus";
    description = "A high-level web development framework for Rust with full support for server-side rendering and static generation";
    maintainers = with maintainers; [ max-niederman ];
    license = with licenses; [ mit ];
    mainProgram = "perseus";
  };
}

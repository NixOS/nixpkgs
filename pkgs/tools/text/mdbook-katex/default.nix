{ lib, rustPlatform, fetchCrate, stdenv, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-katex";
  version = "0.5.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aG7mXMDogGfAHwz+itJthl7sJ4o+Oz5RnrTHNstrh28=";
  };

  cargoHash = "sha256-LE9NalzCTYvcj7WwQKVc7HkbyUj9zQIA2RfK8uxNfOk=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering LaTeX equations to HTML at build time.";
    homepage = "https://github.com/lzanini/${pname}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}

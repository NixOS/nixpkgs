{ lib
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
, typescript
, makeWrapper
}:

buildNpmPackage rec {
  pname = "typescript-formatter";
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "vvakame";
    repo = pname;
    rev = version;
    hash = "sha256-CUj6FRN3UnnkCCXbIVOFdMfebZNz7a1r2bcTxjHWJxI=";
  };

  npmDepsHash = "sha256-okL/dxxZlNwLNAtRd5lkOtgp5kxqit+NtCivgHNrwE0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/tsfmt" \
      --prefix NODE_PATH : ${typescript}/lib/node_modules
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A TypeScript code formatter powered by TypeScript Compiler Service";
    homepage = "https://github.com/vvakame/typescript-formatter";
    maintainers = [ maintainers.ocfox ];
    license = licenses.mit;
  };
}

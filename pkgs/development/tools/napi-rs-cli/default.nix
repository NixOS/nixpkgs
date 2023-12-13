{ lib, stdenv, fetchurl, makeWrapper, nodejs }:

stdenv.mkDerivation rec {
  pname = "napi-rs-cli";
  version = "2.12.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@napi-rs/cli/-/cli-${version}.tgz";
    hash = "sha256-TGhPPv73tb3tr1cY9mUuN4FaVql5tGh436uJeTkbnJs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/napi-rs-cli"

    cp scripts/index.js "$out/lib/napi-rs-cli"

    makeWrapper ${nodejs}/bin/node "$out/bin/napi" --add-flags "$out/lib/napi-rs-cli/index.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tools for napi-rs";
    homepage = "https://napi.rs";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
    inherit (nodejs.meta) platforms;
  };
}

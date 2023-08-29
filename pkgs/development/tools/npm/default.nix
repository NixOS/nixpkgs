{ lib, stdenvNoCC, fetchurl, nodejs-slim }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "npm";
  version = "9.8.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/npm/-/npm-${finalAttrs.version}.tgz";
    hash = "sha256-Dz4q6VaSkSdBFLdl2NebZE9j+hYkl9ruVERtmmAOD3k=";
  };

  dontUnpack = true;

  # We only want to patch shebangs in /bin, and not the whole node_modules
  dontPatchShebangs = true;

  buildInputs = [ nodejs-slim ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules/npm/ $out/share/{man/,bash-completion/completions/,fish/vendor_completions.d/}
    tar xf $src --strip-components=1 -C $out/lib/node_modules/npm/
    rm $out/lib/node_modules/npm/bin/{npm,npx}
    patchShebangs --host $out/lib/node_modules/npm/bin/
    ln -s $out/lib/node_modules/npm/bin/npm-cli.js $out/bin/npm
    ln -s $out/lib/node_modules/npm/bin/npx-cli.js $out/bin/npx
    mv $out/lib/node_modules/npm/man/ $out/share/
    mv $out/lib/node_modules/npm/lib/utils/completion.sh $out/share/bash-completion/completions/npm.bash
    mv $out/lib/node_modules/npm/lib/utils/completion.fish $out/share/fish/vendor_completions.d/npm.fish

    runHook postInstall
  '';

  meta = with lib; {
    description = "A package manager for JavaScript";
    homepage = "https://docs.npmjs.com/cli";
    changelog = "https://github.com/npm/cli/releases/tag/v${finalAttrs.version}";
    license = licenses.artistic2;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
})

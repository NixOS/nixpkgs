{
  writeShellApplication,
  pnpm,
  pnpmDeps,
}:

writeShellApplication {
  name = "serve-pnpm-store";

  runtimeInputs = [
    pnpm
  ];

  text = ''
    storePath=$(mktemp -d)

    clean() {
      echo "Cleaning up temporary store at '$storePath'..."

      rm -rf "$storePath"
    }

    echo "Copying pnpm store '${pnpmDeps}' to temporary store..."

    cp -Tr "${pnpmDeps}" "$storePath"
    chmod -R +w "$storePath"

    echo "Run 'pnpm install --store-dir \"$storePath\"' to install packages from this store."

    trap clean EXIT

    pnpm server start \
      --store-dir "$storePath"
  '';
}

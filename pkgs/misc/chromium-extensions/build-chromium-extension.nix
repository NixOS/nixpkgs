{ stdenv, pkgs }:
{
  buildChromiumExtension = args @ {
    name ? "${args.pname}-${args.version}",
    namePrefix ? "chromium-extension-",
    src ? "",
    unpackPhase ? "",
    configurePhase ? "",
    buildPhase ? "",
    installPhase ? null,
    preInstall ? "",
    postInstall ? "",
    ...
  }:
    stdenv.mkDerivation(args // {
      name = namePrefix + name;

      inherit configurePhase buildPhase preInstall postInstall;

      installPhase = if installPhase != null then installPhase else ''
        runHook preInstall

        mkdir -p $out
        cp -r . $out

        runHook postInstall
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        test -e $out/manifest.json || (echo "INVALID EXTENSION: missing manifest.json" && exit 1)
      '';

      # Filter out "key" and "update_url" entries from manifest.json
      fixupPhase = ''
        tmpmanifest=$(mktemp)
        ${stdenv.lib.getBin pkgs.jq}/bin/jq \
          'with_entries(.|select((.key != "key") and (.key != "update_url")))' \
          $out/manifest.json >$tmpmanifest
        mv $tmpmanifest $out/manifest.json
      '';
    });
}

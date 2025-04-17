{stdenv}:

rec {
  buildMinetestMod =
    attrs@{
      name ? "${attrs.pname}",
      namePrefix ? "",
      src,
      unpackPhase ? "",
      configurePhase ? "",
      buildPhase ? "",
      preInstall ? "",
      postInstall ? "",
      path ? ".",
      addonInfo ? null,
      ...
    }:
    stdenv.mkDerivation (attrs // {
        name = namePrefix + name;
        nativeBuildInputs = [];
        inherit unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;
        installPhase = ''
          runHook preInstall

          target=$out/share/minetest/mods/${name}
          mkdir -p $target
          cp -r ${src}/* $target/

          runHook postInstall
          '';

        });
      }

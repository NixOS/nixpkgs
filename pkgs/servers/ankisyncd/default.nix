{ lib
, python3
, pkgs
, makeWrapper
, poetry2nix
}:

poetry2nix.mkPoetryApplication rec {
  projectDir = ./.;

  pname = "ankisyncd";
  version = builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ./VERSION);

  src = pkgs.fetchFromGitHub {
    owner = "ankicommunity";
    repo = "anki-sync-server";
    rev = version;
    sha256 = "sha256-Jh7w1UCbqJQj9t2T++OhtMouBaI+wplT7yce84Qm+yA=";
  };

  overrides = [
    poetry2nix.defaultPoetryOverrides
    (self: super: {
      orjson = pkgs.python3Packages.orjson;

      # but cause duplicates in the closure and some other build issues
      # We can just ignore them for now
      notebook = null;
      jupyter = null;
      jupyterlab = null;
      mkdocs-jupyter = null;
      mkdocs-material = null;
      mkdocs = null;
    })
  ];
  nativeBuildInputs = [ makeWrapper ];
  python = python3;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp -a $src/src $out/lib

    makeWrapper "${python3}/bin/python" "$out/bin/ankisyncd" \
      --add-flags "-m ankisyncd" \
      --set PYTHONPATH "$PYTHONPATH" --argv0 "ankisyncd" \
      --chdir "$out/lib"

    runHook postInstall
  '';
  meta = with lib; {
    description = "Self-hosted Anki sync server";
    maintainers = with maintainers; [ matt-snider ];
    homepage = "https://github.com/ankicommunity/anki-sync-server";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };
}

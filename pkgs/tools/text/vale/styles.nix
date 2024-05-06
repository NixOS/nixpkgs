{ lib, stdenvNoCC, fetchFromGitHub, fetchzip, nix-update-script }:

let
  buildStyle =
    { name
    , stylePath ? name
    , ...
    }@args:
    stdenvNoCC.mkDerivation ({
      pname = "vale-style-${lib.toLower name}";

      dontConfigure = true;
      dontBuild = true;
      doCheck = false;
      dontFixup = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/vale/styles
        cp -R ${stylePath} "$out/share/vale/styles/${name}"
        runHook postInstall
      '';

      passthru.updateScript = nix-update-script { };

      meta = {
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ katexochen ];
      } // (args.meta or { });
    } // removeAttrs args [ "meta" "name" ]);
in
{
  alex = buildStyle rec {
    name = "alex";
    version = "0.2.1";
    src = fetchFromGitHub {
      owner = "errata-ai";
      repo = "alex";
      rev = "v${version}";
      hash = "sha256-xNF7se2FwKgNe5KYx/zvGWpIwBsBADYGH4JV1lUww+Q=";
    };
    meta = {
      description = "A Vale-compatible implementation of the guidelines enforced by the alex linter";
      homepage = "https://github.com/errata-ai/alex";
      license = lib.licenses.mit;
    };
  };

  google = buildStyle rec {
    name = "Google";
    version = "0.6.1";
    src = fetchFromGitHub {
      owner = "errata-ai";
      repo = "Google";
      rev = "v${version}";
      hash = "sha256-jSmfUgzlIbDVh2zLtnTNpM/z6dHMp358F9adLZ5+qcw=";
    };
    meta = {
      description = "A Vale-compatible implementation of the Google Developer Documentation Style Guide";
      homepage = "https://github.com/errata-ai/Google";
      license = lib.licenses.mit;
    };
  };

  joblint = buildStyle rec {
    name = "Joblint";
    version = "0.4.1";
    src = fetchFromGitHub {
      owner = "errata-ai";
      repo = "Joblint";
      rev = "v${version}";
      hash = "sha256-zRz5ThOg5RLTZj3dYPe0PDvOF5DjO31lduSpi2Us87U=";
    };
    meta = {
      description = "A Vale-compatible implementation of the Joblint linter";
      homepage = "https://github.com/errata-ai/Joblint";
      license = lib.licenses.mit;
    };
  };

  microsoft = buildStyle rec {
    name = "Microsoft";
    version = "0.14.1";
    src = fetchFromGitHub {
      owner = "errata-ai";
      repo = "Microsoft";
      rev = "v${version}";
      hash = "sha256-4j05bIGAVEy6untUqtrUxdLKlhyOcJsbcsow8OxRp1A=";
    };
    meta = {
      description = "A Vale-compatible implementation of the Microsoft Writing Style Guide";
      homepage = "https://github.com/errata-ai/Microsoft";
      license = lib.licenses.mit;
    };
  };

  proselint = buildStyle rec {
    name = "proselint";
    version = "0.3.3";
    src = fetchFromGitHub {
      owner = "errata-ai";
      repo = "proselint";
      rev = "v${version}";
      hash = "sha256-faeWr1bRhnKsycJY89WqnRv8qIowUmz3EQvDyjtl63w=";
    };
    meta = {
      description = "A Vale-compatible implementation of Python's proselint linter";
      homepage = "https://github.com/errata-ai/proselint";
      license = lib.licenses.bsd3;
    };
  };

  readability = buildStyle rec {
    name = "Readability";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner = "errata-ai";
      repo = "readability";
      rev = "v${version}";
      hash = "sha256-5Y9v8QsZjC2w3/pGIcL5nBdhpogyJznO5IFa0s8VOOI=";
    };
    meta = {
      description = "Vale-compatible implementations of many popular \"readability\" metrics";
      homepage = "https://github.com/errata-ai/readability";
      license = lib.licenses.mit;
    };
  };

  write-good = buildStyle rec {
    name = "write-good";
    version = "0.4.0";
    src = fetchFromGitHub {
      owner = "errata-ai";
      repo = "write-good";
      rev = "v${version}";
      hash = "sha256-KQzY6MeHV/owPVmUAfzGUO0HmFPkD7wdQqOvBkipwP8=";
    };
    meta = {
      description = "A Vale-compatible implementation of the write-good linter";
      homepage = "https://github.com/errata-ai/write-good";
      license = lib.licenses.mit;
    };
  };
}

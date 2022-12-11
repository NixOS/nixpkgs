{ lib, stdenv, fetchurl, ncurses, ocaml, writeText }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-findlib";
  version = "1.9.6";

  src = fetchurl {
    url = "http://download.camlcity.org/download/findlib-${version}.tar.gz";
    sha256 = "sha256-LfmWJ5rha2Bttf9Yefk9v63giY258aPoL3+EX6opMKI=";
  };

  nativeBuildInputs = [ ocaml ];
  buildInputs = lib.optional (lib.versionOlder ocaml.version "4.07") ncurses;

  patches = [ ./ldconf.patch ./install_topfind.patch ];

  dontAddPrefix=true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  configureFlags = [
      "-bindir" "${placeholder "out"}/bin"
      "-mandir" "${placeholder "out"}/share/man"
      "-sitelib" "${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib"
      "-config" "${placeholder "out"}/etc/findlib.conf"
  ];

  buildFlags = [ "all" "opt" ];

  setupHook = writeText "setupHook.sh" ''
    addOCamlPath () {
        if test -d "''$1/lib/ocaml/${ocaml.version}/site-lib"; then
            export OCAMLPATH="''${OCAMLPATH-}''${OCAMLPATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/"
        fi
        if test -d "''$1/lib/ocaml/${ocaml.version}/site-lib/stublibs"; then
            export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/stublibs"
        fi
    }
    exportOcamlDestDir () {
        export OCAMLFIND_DESTDIR="''$out/lib/ocaml/${ocaml.version}/site-lib/"
    }
    createOcamlDestDir () {
        if test -n "''${createFindlibDestdir-}"; then
          mkdir -p $OCAMLFIND_DESTDIR
        fi
    }
    detectOcamlConflicts () {
      local conflict
      conflict="$(ocamlfind list |& grep "has multiple definitions" || true)"
      if [[ -n "$conflict" ]]; then
        echo "Conflicting ocaml packages detected";
        echo "$conflict"
        exit 1
      fi
    }

    # run for every buildInput
    addEnvHooks "$targetOffset" addOCamlPath
    # run before installPhase, even without buildInputs, and not in nix-shell
    preInstallHooks+=(createOcamlDestDir)
    # run even in nix-shell, and even without buildInputs
    addEnvHooks "$hostOffset" exportOcamlDestDir
    # runs after all calls to addOCamlPath
    if [[ -z "''${dontDetectOcamlConflicts-}" ]]; then
      postHooks+=("detectOcamlConflicts")
    fi
  '';

  meta = {
    description = "O'Caml library manager";
    homepage = "http://projects.camlcity.org/projects/findlib.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maggesi vbmithr ];
    mainProgram = "ocamlfind";
    platforms = ocaml.meta.platforms or [];
  };
}



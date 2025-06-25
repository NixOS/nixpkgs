{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  perl,
  makeWrapper,
  rresult,
  bos,
  pcre2,
  re,
  camlp-streams,
  legacy ? false,
}:

if lib.versionOlder ocaml.version "4.02" then
  throw "camlp5 is not available for OCaml ${ocaml.version}"
else

  let
    params =
      if lib.versionAtLeast ocaml.version "4.12" && !legacy then
        rec {
          version = "8.03.02";

          src = fetchFromGitHub {
            owner = "camlp5";
            repo = "camlp5";
            rev = version;
            hash = "sha256-nz+VfGR/6FdBvMzPPpVpviAXXBWNqM3Ora96Yzx964o=";
          };

          nativeBuildInputs = [
            makeWrapper
            ocaml
            findlib
            perl
          ];
          buildInputs = [
            bos
            pcre2
            re
            rresult
          ];
          propagatedBuildInputs = [ camlp-streams ];
          postInstall = ''
            for prog in camlp5 camlp5o camlp5r camlp5sch mkcamlp5 ocpp5
            do
              wrapProgram $out/bin/$prog \
                --prefix CAML_LD_LIBRARY_PATH : "$CAML_LD_LIBRARY_PATH"
            done
          '';

        }
      else
        rec {
          version = "7.14";
          src = fetchFromGitHub {
            owner = "camlp5";
            repo = "camlp5";
            rev = "rel${builtins.replaceStrings [ "." ] [ "" ] version}";
            sha256 = "1dd68bisbpqn5lq2pslm582hxglcxnbkgfkwhdz67z4w9d5nvr7w";
          };
          nativeBuildInputs = [
            ocaml
            perl
          ];
        };
  in

  stdenv.mkDerivation (
    params
    // {

      pname = "ocaml${ocaml.version}-camlp5";

      strictDeps = true;

      prefixKey = "-prefix ";

      preConfigure = ''
        configureFlagsArray=(--strict --libdir $out/lib/ocaml/${ocaml.version}/site-lib)
        patchShebangs ./config/find_stuffversion.pl etc/META.pl
      '';

      buildFlags = [ "world.opt" ];

      dontStrip = true;

      meta = with lib; {
        description = "Preprocessor-pretty-printer for OCaml";
        longDescription = ''
          Camlp5 is a preprocessor and pretty-printer for OCaml programs.
          It also provides parsing and printing tools.
        '';
        homepage = "https://camlp5.github.io/";
        license = licenses.bsd3;
        platforms = ocaml.meta.platforms or [ ];
        maintainers = with maintainers; [
          maggesi
          vbgl
        ];
      };
    }
  )

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

stdenv.mkDerivation (
  finalAttrs:
  let
    recent = lib.versionAtLeast (lib.versions.major finalAttrs.version) "8";
  in
  {

    version = if lib.versionAtLeast ocaml.version "4.12" && !legacy then "8.04.00" else "7.14";

    pname = "ocaml${ocaml.version}-camlp5";

    src = fetchFromGitHub {
      owner = "camlp5";
      repo = "camlp5";
      tag =
        if recent then
          finalAttrs.version
        else
          "rel${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
      hash =
        {
          "8.04.00" = "sha256-5IQVGm/tqEzXmZmSYGbGqX+KN9nQLQgw+sBP+F2keXo=";
          "8.03.2" = "sha256-nz+VfGR/6FdBvMzPPpVpviAXXBWNqM3Ora96Yzx964o=";
          "7.14" = "sha256-/ORtS0uc/GN+g3y6N5ftjL4OBSqV6iswLRbfpeNCprU=";
        }
        ."${finalAttrs.version}";
    };
    nativeBuildInputs = [
      ocaml
      perl
    ]
    ++ lib.optionals recent [
      makeWrapper
      findlib
    ];

    buildInputs = lib.optionals recent [
      bos
      pcre2
      re
      rresult
    ];

    propagatedBuildInputs = lib.optional recent camlp-streams;

    strictDeps = true;

    prefixKey = "-prefix ";

    preConfigure = ''
      configureFlagsArray=(--strict --libdir $out/lib/ocaml/${ocaml.version}/site-lib)
      patchShebangs ./config/find_stuffversion.pl etc/META.pl tools/ ocaml_src/tools/
    '';

    buildFlags = [ "world.opt" ];

    postInstall = lib.optionalString recent ''
      for prog in camlp5 camlp5o camlp5r camlp5sch mkcamlp5 ocpp5
      do
        wrapProgram $out/bin/$prog \
          --prefix CAML_LD_LIBRARY_PATH : "$CAML_LD_LIBRARY_PATH"
      done
    '';
    dontStrip = true;

    meta = {
      broken =
        lib.versionAtLeast ocaml.version "5.04" && !lib.versionAtLeast finalAttrs.version "8.04.00";
      description = "Preprocessor-pretty-printer for OCaml";
      longDescription = ''
        Camlp5 is a preprocessor and pretty-printer for OCaml programs.
        It also provides parsing and printing tools.
      '';
      homepage = "https://camlp5.github.io/";
      license = lib.licenses.bsd3;
      platforms = ocaml.meta.platforms or [ ];
      maintainers = [ lib.maintainers.vbgl ];
    };
  }
)

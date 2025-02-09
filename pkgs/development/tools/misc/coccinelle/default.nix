{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, ocamlPackages
, pkg-config
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "coccinelle";
  version = "1.1.1";

  src = fetchFromGitHub {
    repo = pname;
    rev = version;
    owner = "coccinelle";
    hash = "sha256-rS9Ktp/YcXF0xUtT4XZtH5F9huvde0vRztY7vGtyuqY=";
  };

  patches = [
    # Fix data path lookup.
    # https://github.com/coccinelle/coccinelle/pull/270
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/540888ff426e0b1f7907b63ce26e712d1fc172cc.patch";
      sha256 = "sha256-W8RNIWDAC3lQ5bG+gD50r7x919JIcZRpt3QSOSMWpW4=";
    })

    # Fix attaching code before declarations.
    # https://github.com/coccinelle/coccinelle/issues/282
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/cd33db143416d820f547bf5869482cfcfc0ea9d0.patch";
      sha256 = "q7wbxbB9Ob0fSJwCjRtDPO3Xg4RO9yrQZG9G0/LGunI=";
    })

    # Fix attaching declaration metavariables.
    # https://github.com/coccinelle/coccinelle/issues/281
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/df71c5c0fe2a73c7358f73f45a550b57a7e30d85.patch";
      sha256 = "qrYfligJnXP7J5G/hfzyaKg9aFn74VExtc/Rs/DI2gc=";
    })

    # Support GLib’s autocleanup macros.
    # https://github.com/coccinelle/coccinelle/issues/275
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/6d5602aca8775c3c5c503939c3dcf0637649d09b.patch";
      sha256 = "NACf8joOOvN32H/sIfI+oqiT3289zXXQVVfXbRfbIe8=";
    })

    # Exit with non-zero status on failure.
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/6c0a855af14d41864e1e522b93dc39646a3b83c7.patch";
      sha256 = "6yfK8arB0GDW7o4cXsv0Y9TMvqgGf3/P1ebXrFFUC80=";
    })
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/5448bb2bd03491ffec356bf7bd6ddcdbf4d36bc9.patch";
      sha256 = "fyyxw2BNZUpyLBieIhOKeWbLFGP1tjULH70w/hU+jKw=";
    })
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/b8b1937657765e991195a10fcd7b8f7a300fc60b.patch";
      sha256 = "ergWJF6BKrhmJhx1aiVYDHztgjaQvaJ5iZRAmC9i22s=";
    })
  ];

  nativeBuildInputs = with ocamlPackages; [
    autoreconfHook
    pkg-config
    ocaml
    findlib
    menhir
  ];

  buildInputs = with ocamlPackages; [
    ocaml_pcre
    parmap
    pyml
    stdcompat
  ];

  strictDeps = true;

  postPatch = ''
    # Ensure dependencies from Nixpkgs are picked up.
    rm -rf bundles/
  '';

  meta = {
    description = "Program to apply semantic patches to C code";
    longDescription = ''
      Coccinelle is a program matching and transformation engine which
      provides the language SmPL (Semantic Patch Language) for
      specifying desired matches and transformations in C code.
      Coccinelle was initially targeted towards performing collateral
      evolutions in Linux.  Such evolutions comprise the changes that
      are needed in client code in response to evolutions in library
      APIs, and may include modifications such as renaming a function,
      adding a function argument whose value is somehow
      context-dependent, and reorganizing a data structure.  Beyond
      collateral evolutions, Coccinelle is successfully used (by us
      and others) for finding and fixing bugs in systems code.
    '';

    homepage = "https://coccinelle.gitlabpages.inria.fr/website/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}

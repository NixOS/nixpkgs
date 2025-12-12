{
  lib,
  stdenv,
  fetchzip,
  which,
  ocaml,
  camlp-streams,
  ocamlbuild,
  findlib,
}:

if lib.versionAtLeast ocaml.version "5.4" then
  throw "camlp4 is not available for OCaml ${ocaml.version}"
else

  let
    param =
      {
        "4.02" = {
          version = "4.02+6";
          sha256 = "06yl4q0qazl7g25b0axd1gdkfd4qpqzs1gr5fkvmkrcbz113h1hj";
        };
        "4.03" = {
          version = "4.03+1";
          sha256 = "1f2ndch6f1m4fgnxsjb94qbpwjnjgdlya6pard44y6n0dqxi1wsq";
        };
        "4.04" = {
          version = "4.04+1";
          sha256 = "1ad7rygqjxrc1im95gw9lp8q83nhdaf383f2808f1p63yl42xm7k";
        };
        "4.05" = {
          version = "4.05+1";
          sha256 = "0wm795hpwvwpib9c9z6p8kw2fh7p7b2hml6g15z8zry3y7w738sv";
        };
        "4.06" = {
          version = "4.06+1";
          sha256 = "0fazfw2l7wdmbwnqc22xby5n4ri1wz27lw9pfzhsbcdrighykysf";
        };
        "4.07" = {
          version = "4.07+1";
          sha256 = "0cxl4hkqcvspvkx4f2k83217rh6051fll9i2yz7cw6m3bq57mdvl";
        };
        "4.08" = {
          version = "4.08+1";
          sha256 = "0qplawvxwai25bi27niw2cgz2al01kcnkj8wxwhxslpi21z6pyx1";
        };
        "4.09" = {
          version = "4.09+1";
          sha256 = "1gr33x6xs1rs0bpyq4vzyfxd6vn47jfkg8imi81db2r0cbs0kxx1";
        };
        "4.10" = {
          version = "4.10+1";
          sha256 = "093bc1c28wid5li0jwglnd4p3csxw09fmbs9ffybq2z41a5mgay6";
        };
        "4.11" = {
          version = "4.11+1";
          sha256 = "0sn7f6im940qh0ixmx1k738xrwwdvy9g7r19bv5218jb6mh0g068";
        };
        "4.12" = {
          version = "4.12+1";
          sha256 = "1cfk5ppnd511vzsr9gc0grxbafmh0m3m897aij198rppzxps5kyz";
        };
        "4.13" = {
          version = "4.13+1";
          sha256 = "0fzxa1zdhk74mlxpin7p90flks6sp4gkc0mfclmj9zak15rii55n";
        };
        "4.14" = {
          version = "4.14+1";
          sha256 = "sha256-cPN3GioZT/Zt6uzbjGUPEGVJcPQdsAnCkU/AQoPfvuo=";
        };
        "5.0" = {
          version = "5.0";
          sha256 = "sha256-oZptFNPUEAq5YlcqAoDWfLghGMF9AN7E7hUN55SAX+4=";
        };
        "5.1" = {
          version = "5.1";
          sha256 = "sha256-Ubedjg3BeHA0bJbEalQN9eEk5+LRAI/er+8mWfVYchg=";
        };
        "5.2" = {
          version = "5.2";
          sha256 = "sha256-lzbc9xsgeYlbVf71O+PWYS14QivAH1aPdnvWhe0HHME=";
        };
        "5.3" = {
          version = "5.3";
          sha256 = "sha256-V/kKhTP9U4jWDFuQKuB7BS3XICg1lq/2Avj7UJR55+k=";
        };
      }
      .${ocaml.meta.branch};
  in

  stdenv.mkDerivation rec {
    pname = "camlp4";
    inherit (param) version;

    src = fetchzip {
      url = "https://github.com/ocaml/camlp4/archive/${version}.tar.gz";
      inherit (param) sha256;
    };

    strictDeps = true;

    nativeBuildInputs = [
      which
      ocaml
      ocamlbuild
    ]
    ++ lib.optionals (lib.versionAtLeast ocaml.version "5.0") [
      findlib
    ];

    buildInputs = lib.optionals (lib.versionAtLeast ocaml.version "5.0") [
      camlp-streams
      ocamlbuild
    ];

    # build fails otherwise
    enableParallelBuilding = false;

    dontAddPrefix = true;

    preConfigure = ''
      # increase stack space for spacetime variant of the compiler
      # https://github.com/ocaml/ocaml/issues/7435
      # but disallowed by darwin sandbox
      ulimit -s unlimited || true

      configureFlagsArray=(
        --bindir=$out/bin
        --libdir=$out/lib/ocaml/${ocaml.version}/site-lib
        --pkgdir=$out/lib/ocaml/${ocaml.version}/site-lib
      )
    '';

    postConfigure = ''
      substituteInPlace camlp4/META.in \
      --replace +camlp4 $out/lib/ocaml/${ocaml.version}/site-lib/camlp4
    '';

    makeFlags = [ "all" ];

    installTargets = [
      "install"
      "install-META"
    ];

    dontStrip = true;

    meta = {
      description = "Software system for writing extensible parsers for programming languages";
      homepage = "https://github.com/ocaml/camlp4";
      platforms = ocaml.meta.platforms or [ ];
    };
  }

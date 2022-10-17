{ stdenv, lib, fetchurl, makeWrapper, getconf,
  ocaml, unzip, ncurses, curl, bubblewrap
}:

assert lib.versionAtLeast ocaml.version "4.02.3";

let
  srcs = {
    "0install-solver" = fetchurl {
      url = "https://github.com/0install/0install/releases/download/v2.17/0install-v2.17.tbz";
      sha256 = "08q95mzmf9pyyqs68ff52422f834hi313cxmypwrxmxsabcfa10p";
    };
    "cmdliner" = fetchurl {
      url = "http://erratique.ch/software/cmdliner/releases/cmdliner-1.0.4.tbz";
      sha256 = "1h04q0zkasd0mw64ggh4y58lgzkhg6yhzy60lab8k8zq9ba96ajw";
    };
    "cppo" = fetchurl {
      url = "https://github.com/ocaml-community/cppo/archive/v1.6.8.tar.gz";
      sha256 = "0lxy4xkkkwgs1cj6d9lyzsqi9f6fc9r6cir5imi7yjqrpd86s1by";
    };
    "cudf" = fetchurl {
      url = "https://github.com/ocaml/opam-source-archives/raw/main/cudf-0.9.tar.gz";
      sha256 = "0771lwljqwwn3cryl0plny5a5dyyrj4z6bw66ha5n8yfbpcy8clr";
    };
    "dose3" = fetchurl {
      url = "https://gitlab.com/irill/dose3/-/archive/5.0.1/dose3-5.0.1.tar.gz";
      sha256 = "1mh6fv8qbf8xx4h2dc0dpv2lzygvikzjhw1idrknibbwsjw3jg9c";
    };
    "dune-local" = fetchurl {
      url = "https://github.com/ocaml/dune/releases/download/2.9.1/dune-2.9.1.tbz";
      sha256 = "09lzq04b642iy0ljp59p32lgk3q8iphjh8fkdp69q29l5frgwx5k";
    };
    "extlib" = fetchurl {
      url = "https://ygrek.org/p/release/ocaml-extlib/extlib-1.7.7.tar.gz";
      sha256 = "1sxmzc1mx3kg62j8kbk0dxkx8mkf1rn70h542cjzrziflznap0s1";
    };
    "mccs" = fetchurl {
      url = "https://github.com/AltGr/ocaml-mccs/archive/1.1+13.tar.gz";
      sha256 = "05nnji9h8mss3hzjr5faid2v3xfr7rcv2ywmpcxxp28y6h2kv9gv";
    };
    "ocamlgraph" = fetchurl {
      url = "https://github.com/backtracking/ocamlgraph/releases/download/2.0.0/ocamlgraph-2.0.0.tbz";
      sha256 = "029692bvdz3hxpva9a2jg5w5381fkcw55ysdi8424lyyjxvjdzi0";
    };
    "opam-0install-cudf" = fetchurl {
      url = "https://github.com/ocaml-opam/opam-0install-solver/releases/download/v0.4.2/opam-0install-cudf-v0.4.2.tbz";
      sha256 = "10wma4hh9l8hk49rl8nql6ixsvlz3163gcxspay5fwrpbg51fmxr";
    };
    "opam-file-format" = fetchurl {
      url = "https://github.com/ocaml/opam-file-format/archive/2.1.4.tar.gz";
      sha256 = "0xbdlpxb0348pbwijna2x6nbi8fcxdh63cwrznn4q4zzbv9zsy02";
    };
    "re" = fetchurl {
      url = "https://github.com/ocaml/ocaml-re/releases/download/1.10.3/re-1.10.3.tbz";
      sha256 = "1fqfg609996bgxr14yyfxhvl6hm9c1j0mm2xjdjigqrzgyb4crc4";
    };
    "result" = fetchurl {
      url = "https://github.com/janestreet/result/releases/download/1.5/result-1.5.tbz";
      sha256 = "0cpfp35fdwnv3p30a06wd0py3805qxmq3jmcynjc3x2qhlimwfkw";
    };
    "seq" = fetchurl {
      url = "https://github.com/c-cube/seq/archive/0.2.2.tar.gz";
      sha256 = "1ck15v3pg8bacdg6d6iyp2jc3kgrzxk5jsgzx3287x2ycb897j53";
    };
    "stdlib-shims" = fetchurl {
      url = "https://github.com/ocaml/stdlib-shims/releases/download/0.3.0/stdlib-shims-0.3.0.tbz";
      sha256 = "0jnqsv6pqp5b5g7lcjwgd75zqqvcwcl5a32zi03zg1kvj79p5gxs";
    };
    opam = fetchurl {
      url = "https://github.com/ocaml/opam/archive/2.1.3.zip";
      sha256 = "08n72n5wc476p28ypxjs8fmlvcb42129fcva753gqm0xicqh24xf";
    };
  };
in stdenv.mkDerivation {
  pname = "opam";
  version = "2.1.3";

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ curl ncurses ocaml getconf ] ++ lib.optional stdenv.isLinux bubblewrap;

  src = srcs.opam;

  postUnpack = ''
    ln -sv ${srcs."0install-solver"} $sourceRoot/src_ext/0install-solver.tbz
    ln -sv ${srcs."cmdliner"} $sourceRoot/src_ext/cmdliner.tbz
    ln -sv ${srcs."cppo"} $sourceRoot/src_ext/cppo.tar.gz
    ln -sv ${srcs."cudf"} $sourceRoot/src_ext/cudf.tar.gz
    ln -sv ${srcs."dose3"} $sourceRoot/src_ext/dose3.tar.gz
    ln -sv ${srcs."dune-local"} $sourceRoot/src_ext/dune-local.tbz
    ln -sv ${srcs."extlib"} $sourceRoot/src_ext/extlib.tar.gz
    ln -sv ${srcs."mccs"} $sourceRoot/src_ext/mccs.tar.gz
    ln -sv ${srcs."ocamlgraph"} $sourceRoot/src_ext/ocamlgraph.tbz
    ln -sv ${srcs."opam-0install-cudf"} $sourceRoot/src_ext/opam-0install-cudf.tbz
    ln -sv ${srcs."opam-file-format"} $sourceRoot/src_ext/opam-file-format.tar.gz
    ln -sv ${srcs."re"} $sourceRoot/src_ext/re.tbz
    ln -sv ${srcs."result"} $sourceRoot/src_ext/result.tbz
    ln -sv ${srcs."seq"} $sourceRoot/src_ext/seq.tar.gz
    ln -sv ${srcs."stdlib-shims"} $sourceRoot/src_ext/stdlib-shims.tbz
  '';

  patches = [ ./opam-shebangs.patch ];

  preConfigure = ''
    substituteInPlace ./src_ext/Makefile --replace "%.stamp: %.download" "%.stamp:"
    patchShebangs src/state/shellscripts
  '';

  postConfigure = "make lib-ext";

  # Dirty, but apparently ocp-build requires a TERM
  makeFlags = ["TERM=screen"];

  outputs = [ "out" "installer" ];
  setOutputFlags = false;

  # change argv0 to "opam" as a workaround for
  # https://github.com/ocaml/opam/issues/2142
  postInstall = ''
    mv $out/bin/opam $out/bin/.opam-wrapped
    makeWrapper $out/bin/.opam-wrapped $out/bin/opam \
      --argv0 "opam" \
      --suffix PATH : ${unzip}/bin:${curl}/bin:${lib.optionalString stdenv.isLinux "${bubblewrap}/bin:"}${getconf}/bin \
      --set OPAM_USER_PATH_RO /run/current-system/sw/bin:/nix/
    $out/bin/opam-installer --prefix=$installer opam-installer.install
  '';

  doCheck = false;

  meta = with lib; {
    description = "A package manager for OCaml";
    homepage = "https://opam.ocaml.org/";
    maintainers = [ maintainers.henrytill maintainers.marsam ];
    platforms = platforms.all;
  };
}
# Generated by: ./opam.nix.pl -v 2.1.3 -p opam-shebangs.patch

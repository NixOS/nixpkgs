{stdenv, fetchFromGitHub, ocaml, findlib, camlp4, core, async, async_unix, re2,
  async_extra, sexplib, async_shell, core_extended, async_find, cohttp, uri, tzdata}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.1.3";
in

assert stdenv.lib.versionOlder "4.02" ocaml_version;

stdenv.mkDerivation {
  name = "trv-${version}";

  src = fetchFromGitHub {
    owner = "afiniate";
    repo = "trv";
    rev = "${version}";
    sha256 = "0fv0zh76djqhkzfzwv6k60rnky50pw9gn01lwhijrggrcxrrphz1";
  };


  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ core async async_unix
                            async_extra sexplib async_shell core_extended
                            async_find cohttp uri re2 ];

  createFindlibDestdir = true;
  dontStrip = true;

  installFlags = "SEMVER=${version} PREFIX=$out";

  meta = with stdenv.lib; {
    homepage = https://github.com/afiniate/trv;
    description = "Shim for vrt to enable bootstrapping";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
    platforms = ocaml.meta.platforms or [];
  };
}

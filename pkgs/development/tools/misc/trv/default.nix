{stdenv, fetchFromGitHub, ocaml, findlib, camlp4, core_p4, async_p4, async_unix_p4
, re2_p4, async_extra_p4, sexplib_p4, async_shell, core_extended_p4, async_find
, cohttp, conduit, magic-mime, tzdata
}:

assert stdenv.lib.versionOlder "4.02" ocaml.version;

stdenv.mkDerivation rec {
  name = "trv-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "afiniate";
    repo = "trv";
    rev = "${version}";
    sha256 = "0fv0zh76djqhkzfzwv6k60rnky50pw9gn01lwhijrggrcxrrphz1";
  };


  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ core_p4 async_p4 async_unix_p4
                            async_extra_p4 sexplib_p4 async_shell core_extended_p4
                            async_find cohttp conduit magic-mime re2_p4 ];

  createFindlibDestdir = true;
  dontStrip = true;

  installFlags = "SEMVER=${version} PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/afiniate/trv;
    description = "Shim for vrt to enable bootstrapping";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
    platforms = ocaml.meta.platforms or [];
  };
}

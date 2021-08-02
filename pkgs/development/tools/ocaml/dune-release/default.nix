{ lib, buildDunePackage, fetchurl, makeWrapper
, curly, fmt, bos, cmdliner, re, rresult, logs
, odoc, opam-format, opam-core, opam-state, yojson, astring
, opam, git, findlib, mercurial, bzip2, gnutar, coreutils
, alcotest, mdx
}:

# don't include dune as runtime dep, so user can
# choose between dune and dune_2
let runtimeInputs = [ opam findlib git mercurial bzip2 gnutar coreutils ];
in buildDunePackage rec {
  pname = "dune-release";
  version = "1.5.0";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocamllabs/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1lyfaczskdbqnhmpiy6wga9437frds3m8prfk2rhwyb96h69y3pv";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ curly fmt cmdliner re opam-format opam-state opam-core
                  rresult logs odoc bos yojson astring ];
  checkInputs = [ alcotest mdx ] ++ runtimeInputs;
  doCheck = true;

  useDune2 = true;

  postPatch = ''
    # remove check for curl in PATH, since curly is patched
    # to have a fixed path to the binary in nix store
    sed -i '/must_exist (Cmd\.v "curl"/d' lib/github.ml

    # ignore weird yes error message
    sed -i 's/yes |/yes 2>\/dev\/null |/' \
      tests/bin/no_doc/run.t \
      tests/bin/draft/run.t \
      tests/bin/url-file/run.t
  '';

  preCheck = ''
    # it fails when it tries to reference "./make_check_deterministic.exe"
    rm -r tests/bin/check
  '';

  # tool specific env vars have been deprecated, use PATH
  preFixup = ''
    wrapProgram $out/bin/dune-release \
      --prefix PATH : "${lib.makeBinPath runtimeInputs}"
  '';

  meta = with lib; {
    description = "Release dune packages in opam";
    homepage = "https://github.com/ocamllabs/dune-release";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}

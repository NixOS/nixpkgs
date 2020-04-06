{ stdenv, lib, fetchFromGitHub, fetchpatch, makeWrapper, nim, pcre, tinycc }:

stdenv.mkDerivation {
  pname = "nrpl";
  version = "20150522";

  src = fetchFromGitHub {
    owner  = "wheineman";
    repo   = "nrpl";
    rev    = "6d6c189ab7d1c905cc29dc678d66e9e132026f69";
    sha256 = "1cly9lhrawnc42r31b7r0p0i6hcx8r00aa17gv7w9pcpj8ngb4v2";
  };

  buildInputs = [ makeWrapper nim pcre ];

  patches = [
    (fetchpatch {
      url    = https://patch-diff.githubusercontent.com/raw/wheineman/nrpl/pull/12.patch;
      name   = "update_for_new_nim.patch";
      sha256 = "1zff7inhn3l1jnxcnidy705lzi3wqib1chf4rayh1g9i23an7wg1";
    })
  ];

  NIX_LDFLAGS = "-lpcre";

  buildPhase = ''
    HOME=$TMPDIR
    nim c -d:release nrpl.nim
  '';

  installPhase = "install -Dt $out/bin nrpl";

  postFixup = ''
    wrapProgram $out/bin/nrpl \
      --prefix PATH : ${lib.makeBinPath [ nim tinycc ]}
  '';

  meta = with stdenv.lib; {
    description = "REPL for the Nim programming language";
    homepage = https://github.com/wheineman/nrpl;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux ++ darwin;
  };
}

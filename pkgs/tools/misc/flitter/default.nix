{ lib
, stdenv
, ocamlPackages
, fetchFromGitHub
, makeWrapper
, python3
}:

ocamlPackages.buildDunePackage rec {
  pname = "flitter";
  # request to tag releases: https://github.com/alexozer/flitter/issues/34
  version = "unstable-2020-10-05";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "alexozer";
    repo = "flitter";
    rev = "666c5483bc93efa6d01e0b7a927461269f8e14de";
    sha256 = "1k3m7bjq5yrrq7vhnbdykni65dsqhq6knnv9wvwq3svb3n07z4w3";
  };

  # compatibility with core >= 0.15
  patches = [ ./flitter.patch ];

  # https://github.com/alexozer/flitter/issues/28
  postPatch = ''
    for f in src/*.ml; do
      substituteInPlace "$f" \
        --replace 'Unix.gettimeofday' 'Caml_unix.gettimeofday' \
        --replace 'Core_kernel' 'Core' \
        --replace 'sexp_option' 'option[@sexp.option]' \
        --replace 'sexp_list' 'list[@sexp.list]'
    done
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = with ocamlPackages; [
    core_unix
    lwt_ppx
    sexp_pretty
    color
    notty
  ];

  postInstall = ''
    wrapProgram $out/bin/flitter \
      --prefix PATH : "${python3.withPackages (pp: [ pp.pynput ])}/bin"
  '';

  meta = with lib; {
    description = "A Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = platforms.unix;
  };
}

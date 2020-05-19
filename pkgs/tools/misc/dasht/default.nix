{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, coreutils
, gnused
, gnugrep
, sqlite
, wget
, w3m
, socat
, gawk
}:

stdenv.mkDerivation rec {
  pname   = "dasht";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner  = "sunaku";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "08wssmifxi7pnvn9gqrvpzpkc2qpkfbzbhxh0dk1gff2y2211qqk";
  };

  deps = lib.makeBinPath [
    coreutils
    gnused
    gnugrep
    sqlite
    wget
    w3m
    socat
    gawk
    (placeholder "out")
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/* $out/bin/

    mkdir -p $out/share/man/man1
    cp man/man1/* $out/share/man/man1/

    for i in $out/bin/*; do
      echo "Wrapping $i"
      wrapProgram $i --prefix PATH : ${deps};
    done;

    runHook postInstall
  '';

  meta = {
    description = "Search API docs offline, in terminal or browser";
    homepage    = "https://sunaku.github.io/dasht/man";
    license     = stdenv.lib.licenses.isc;
    platforms   = stdenv.lib.platforms.unix; #cannot test other
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

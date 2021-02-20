{ coreutils
, diffutils
, fetchurl
, findutils
, gawk
, lib
, makeWrapper
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "zsjed";
  version = "0.3";

  src = fetchurl {
    url = "https://ytrizja.de/distfiles/zsjed-${version}.tar.gz";
    sha256 = "1rcrvrqjsv80ldz7cscqbrf98jb0yd2in97irrzlpask699z5k29";
  };

  patches = [
    ./zsjed-0.3-Makefile.patch
  ];

  nativeBuildInputs = [
    diffutils
    makeWrapper
  ];

  doCheck = true;
  enableParallelBuilding = true;

  # doesn't test zsjed-mkls
  checkPhase = ''
    runHook preCheck

    dst="$(realpath .)"
    tmp="$(mktemp -d)"
    cd "$tmp"
    touch f1 f2
    echo f1 > l
    echo f2 >> l
    "$dst"/zsjed-clear l
    echo "a b c d e f g h i j k" > i
    "$dst"/zsjed-spread i l
    "$dst"/zsjed-collect j l
    cmp i j
    cd "$dst"

    runHook postCheck
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  # zsjed-mkls uses: sort find awk
  postInstall = ''
    wrapProgram $out/bin/zsjed-mkls --prefix PATH ":" "${lib.makeBinPath [coreutils findutils gawk]}"
  '';

  meta = with lib; {
    description = "Zscheile data split semi-steganography tool";
    longDescription = ''
      zsjed is a data split semi-steganography tool.
      It splits a file and pastes these parts
      at the end of many other files, recoverable.
    '';
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.zseri ];
    platforms = platforms.all;
  };
}

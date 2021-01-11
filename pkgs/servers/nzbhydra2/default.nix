{ lib, stdenv, fetchzip, makeWrapper, jre, python3, unzip }:

stdenv.mkDerivation rec {
  pname = "nzbhydra2";
  version = "3.8.0";

  src = fetchzip {
    url = "https://github.com/theotherp/${pname}/releases/download/v${version}/${pname}-${version}-linux.zip";
    sha512 = "1gybricq26hixr5cmw1iwyax7h17d0n5wqzhrx727xda1x35jfjp5ynjdkxzysbfhs1za6vy54bpm0sda4nkrh16p0xqnz3nsd4hvzh";
    stripRoot = false;
  };

  nativeBuildInputs = [ jre makeWrapper unzip ];

  installPhase = ''
    install -d -m 755 "$out/lib/${pname}"
    cp -dpr --no-preserve=ownership "lib" "readme.md" "$out/lib/nzbhydra2"
    install -D -m 755 "nzbhydra2wrapperPy3.py" "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py"

    makeWrapper ${python3}/bin/python $out/bin/nzbhydra2 \
      --add-flags "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py" \
      --prefix PATH ":" ${jre}/bin
  '';

  meta = with lib; {
    description = "Usenet meta search";
    homepage = "https://github.com/theotherp/nzbhydra2";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = with platforms; linux;
  };
}

{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  jre,
  python3,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "nzbhydra2";
  version = "4.7.6";

  src = fetchzip {
    url = "https://github.com/theotherp/${pname}/releases/download/v${version}/${pname}-${version}-linux.zip";
    hash = "sha512-vc+VInEnh00bASxcEwSjJcsa0QJHmtRzSz30uW60wGmA24tlaJYSk42N5KpGFbkQkOkb2ijHmKGxPogSa4izRQ==";
    stripRoot = false;
  };

  nativeBuildInputs = [jre makeWrapper unzip];

  installPhase = ''
    runHook preInstall

    install -d -m 755 "$out/lib/${pname}"
    cp -dpr --no-preserve=ownership "lib" "readme.md" "$out/lib/nzbhydra2"
    install -D -m 755 "nzbhydra2wrapperPy3.py" "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py"

    makeWrapper ${python3}/bin/python $out/bin/nzbhydra2 \
      --add-flags "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py" \
      --prefix PATH ":" ${jre}/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Usenet meta search";
    homepage = "https://github.com/theotherp/nzbhydra2";
    license = licenses.asl20;
    maintainers = with maintainers; [jamiemagee];
    platforms = with platforms; linux;
  };
}

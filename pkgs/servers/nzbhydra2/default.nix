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
  version = "7.3.0";

  src = fetchzip {
    url = "https://github.com/theotherp/${pname}/releases/download/v${version}/${pname}-${version}-generic.zip";
    hash = "sha256-ybI6nCw8yY2XceXiMkION7/p7gl58lrAPpUq6EpManU=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    jre
    makeWrapper
    unzip
  ];

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

  meta = {
    description = "Usenet meta search";
    homepage = "https://github.com/theotherp/nzbhydra2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.linux;
    mainProgram = "nzbhydra2";
  };
}

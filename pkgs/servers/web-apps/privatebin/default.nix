{ lib
, stdenv
, fetchFromGitHub
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "privatebin";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "PrivateBin";
    repo = pname;
    rev = version;
    sha256 = "sha256-DyVZPn10aisrZ42uVnfzJI05r5NS/ueUR/kWOid87RU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/privatebin
    cp -ar * $out/share/privatebin

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) privatebin;
  };

  meta = with lib; {
    description = "Minimalist, open source online pastebin where the server has zero knowledge of pasted data";
    changelog = "https://github.com/PrivateBin/PrivateBin/blob/${version}/CHANGELOG.md";
    license = with licenses; [ libpng gpl2 bsd3 mit cc-by-40 ];
    homepage = "https://privatebin.info/";
    platforms = platforms.all;
    maintainers = with maintainers; [ e1mo ];
  };
}

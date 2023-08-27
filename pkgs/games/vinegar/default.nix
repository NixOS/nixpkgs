{ lib
, buildGoModule
, fetchFromGitHub
, wine
, symlinkJoin
, makeWrapper
, pkg-config
, libGL
, libxkbcommon
, xorg
}:

let
  version = "1.5.4";

  unwrapped = buildGoModule rec {
    pname = "vinegar";

    inherit version;

    src = fetchFromGitHub {
      owner = "vinegarhq";
      repo = "vinegar";
      rev = "v${version}";
      hash = "sha256-6fQZ+NCJq7mMEGKubTIiffC2+05FUmM58Qb+6PMsoC8=";
    };

    vendorHash = "sha256-EO7G2WD00wVErO72pag9qIxmLeBGV9orY98piGuh8Ac=";

    makeFlags = [
      "PREFIX=$(out)"
      "VERSION=${version}"
    ];

    buildPhase = ''
      runHook preBuild
      make $makeFlags
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      make install $makeFlags
      runHook postInstall
    '';

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libGL libxkbcommon xorg.libX11 xorg.libXcursor xorg.libXfixes ];
  };

in
symlinkJoin {
  name = "vinegar";
  paths = [ unwrapped ];
  buildInputs = [ makeWrapper ];
  meta = with lib; {
    description = "An open-source, minimal, configurable, fast bootstrapper for running Roblox on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
    mainProgram = "vinegar";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
  postBuild = ''
    wrapProgram $out/bin/vinegar \
      --prefix PATH : ${lib.makeBinPath [ wine ]}
  '';
}

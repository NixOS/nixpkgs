{
  lib,
  fetchFromGitHub,
  fetchpatch,
  stdenvNoCC,
  darwin-stubs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "CoreSymbolication";
  inherit (darwin-stubs) version;

  src = fetchFromGitHub {
    repo = "CoreSymbolication";
    owner = "matthewbauer";
    rev = "24c87c23664b3ee05dc7a5a87d647ae476a680e4";
    hash = "sha256-PzvLq94eNhP0+rLwGMKcMzxuD6MlrNI7iT/eV0obtSE=";
  };

  patches = [
    # Add missing symbol definitions needed to build `zlog` in system_cmds.
    # https://github.com/matthewbauer/CoreSymbolication/pull/2
    (fetchpatch {
      url = "https://github.com/matthewbauer/CoreSymbolication/commit/ae7ac6a7043dbae8e63d6ce5e63dfaf02b5977fe.patch";
      hash = "sha256-IuXGMsaR1LIGs+BpDU1b4YlznKm9VhK5DQ+Dthtb1mI=";
    })
    (fetchpatch {
      url = "https://github.com/matthewbauer/CoreSymbolication/commit/6531da946949a94643e6d8424236174ae64fe0ca.patch";
      hash = "sha256-+nDX04yY92yVT9KxiAFY2LxKcS7P8JpU539K+YVRqV4=";
    })
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Library/Frameworks/CoreSymbolication.framework/Versions/A/Headers

    ln -s A $out/Library/Frameworks/CoreSymbolication.framework/Versions/Current
    ln -s Versions/Current/Headers $out/Library/Frameworks/CoreSymbolication.framework/Headers
    ln -s Versions/Current/CoreSymbolication.tbd $out/Library/Frameworks/CoreSymbolication.framework/CoreSymbolication.tbd

    cp *.h $out/Library/Frameworks/CoreSymbolication.framework/Versions/A/Headers
    cp ${darwin-stubs}/System/Library/PrivateFrameworks/CoreSymbolication.framework/Versions/A/CoreSymbolication.tbd \
      $out/Library/Frameworks/CoreSymbolication.framework/Versions/A/CoreSymbolication.tbd

    runHook postInstall
  '';

  meta = with lib; {
    description = "Reverse engineered headers for Apple's CoreSymbolication framework";
    homepage = "https://github.com/matthewbauer/CoreSymbolication";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
})

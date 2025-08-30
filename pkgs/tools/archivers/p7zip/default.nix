{
  lib,
  stdenvNoCC,
  linkFarm,
  _7zz,
  enableUnfree ? false,
}:

let
  _7zz' = _7zz.override { enableUnfree = enableUnfree; };
  outBin = linkFarm "p7zip-to-7zz-bin" (
    lib.forEach [ "7z" "7za" "7zr" ] (name: {
      inherit name;
      path = lib.getExe _7zz';
    })
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "p7zip-7zz-shim";
  version = "17.06";

  src = null;
  dontUnpack = true;

  outputs = [
    "out"
    "lib"
    "doc"
    "man"
  ];

  setupHook = ./setup-hook.sh;

  installPhase = ''
    runHook preInstall

    mkdir $out $lib $doc $man
    ln -s ${outBin} $out/bin

    runHook postInstall
  '';

  meta = {
    inherit (_7zz'.meta) homepage license;
    description = "Symlinks to the _7zz package to maintain compatibility";
    maintainers = with lib.maintainers; [
      raskin
      jk
    ];
    platforms = lib.platforms.unix;
    mainProgram = "7z";
  };
})

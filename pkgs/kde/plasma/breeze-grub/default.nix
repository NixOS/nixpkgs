{mkKdeDerivation}:
mkKdeDerivation {
  pname = "breeze-grub";

  # doesn't actually use cmake or anything
  nativeBuildInputs = [];
  buildInputs = [];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/grub/themes"
    mv breeze "$out/grub/themes"

    runHook postInstall
  '';
}

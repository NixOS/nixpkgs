{ R, xvfb_run, utillinux }:

{ name, buildInputs ? [], ... } @ attrs:

R.stdenv.mkDerivation ({
  buildInputs = buildInputs ++ [R xvfb_run utillinux];

  configurePhase = ''
    runHook preConfigure
    export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    runHook postBuild
  '';

  installOptions = if attrs.skipTest or false then
    "--no-test-load "
  else
    "";

  rCommand = if attrs.requireX or false then
    # Unfortunately, xvfb-run has a race condition even with -a option, so that
    # we acquire a lock explicitly.
    "flock ${xvfb_run} xvfb-run -a -e xvfb-error R"
  else
    "R";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/library
    $rCommand CMD INSTALL $installOptions --configure-args="$configureFlags" -l $out/library .
    runHook postInstall
  '';

  postFixup = ''
    if test -e $out/nix-support/propagated-native-build-inputs; then
        ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';
} // attrs // {
  name = "r-" + name;
})

{ stdenv, lib, R, libcxx, xvfb-run, util-linux, Cocoa, Foundation, gettext, gfortran, libiconv }:

{ name, buildInputs ? [], requireX ? false, ... } @ attrs:

stdenv.mkDerivation ({
  buildInputs = buildInputs ++ [R gettext] ++
                lib.optionals requireX [util-linux xvfb-run] ++
                lib.optionals stdenv.hostPlatform.isDarwin [Cocoa Foundation gfortran libiconv];

  env.NIX_CFLAGS_COMPILE =
    lib.optionalString stdenv.hostPlatform.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  enableParallelBuilding = true;

  configurePhase = ''
    runHook preConfigure
    export MAKEFLAGS+="''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
    export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    runHook postBuild
  '';

  installFlags = if attrs.doCheck or true then
    []
  else
    [ "--no-test-load" ];

  rCommand = if requireX then
    # Unfortunately, xvfb-run has a race condition even with -a option, so that
    # we acquire a lock explicitly.
    "flock ${xvfb-run} xvfb-run -a -e xvfb-error R"
  else
    "R";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/library
    $rCommand CMD INSTALL --built-timestamp='1970-01-01 00:00:00 UTC' $installFlags --configure-args="$configureFlags" -l $out/library .
    runHook postInstall
  '';

  postFixup = ''
    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';

  checkPhase = ''
    # noop since R CMD INSTALL tests packages
  '';
} // attrs // {
  name = "r-" + name;
})

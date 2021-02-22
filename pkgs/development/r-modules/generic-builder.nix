{ stdenv, lib, R, libcxx, xvfb_run, util-linux, Cocoa, Foundation, gettext, gfortran }:

{ name, buildInputs ? [], requireX ? false, ... } @ attrs:

stdenv.mkDerivation ({
  buildInputs = buildInputs ++ [R gettext] ++
                lib.optionals requireX [util-linux xvfb_run] ++
                lib.optionals stdenv.isDarwin [Cocoa Foundation gfortran];

  NIX_CFLAGS_COMPILE =
    lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  configurePhase = ''
    runHook preConfigure
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
    "flock ${xvfb_run} xvfb-run -a -e xvfb-error R"
  else
    "R";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/library
    $rCommand CMD INSTALL $installFlags --configure-args="$configureFlags" -l $out/library .
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

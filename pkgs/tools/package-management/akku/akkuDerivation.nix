{ stdenv, akku, chez, chibi, makeWrapper, lib, tree, callPackage }:
{ name, version, src, buildInputs ? [ ], r7rs ? false, nativeBuildInputs ? [ ], ... } @ args:
let
  overrides = callPackage ./overrides.nix { };
  baseName = lib.getName name;
  override =
    if builtins.hasAttr baseName overrides
    then
      builtins.getAttr baseName overrides
    else
      lib.id;
in
(stdenv.mkDerivation ({
  inherit version src;
  name = "akku-${name}";
  propagatedBuildInputs = buildInputs;
  buildInputs = [ ];
  nativeBuildInputs = [ makeWrapper akku chez chibi ] ++ nativeBuildInputs;
  buildPhase = ''
    runHook preBuild

    # only install the project
    rm -f Akku.lock Akku.manifest

    # build, filter out guile warnings
    akku install 2>&1 | grep -v "\(guile-user\)" - | cat

    runHook postBuild
  '';
  checkPhase = ''
    IS_R7RS=false
    runHook preCheck

    t=$CHEZSCHEMELIBDIRS
    export CHEZSCHEMELIBDIRS="$PWD/.akku/lib:$CHEZSCHEMELIBDIRS"

    # Run all test .sps files if they exist
    # and run tests for libs mirrored from snow-fort.
    for path in $(find test* -type f | grep -e "\.sps") \
                $(find . | grep "run-test" | grep "\.scm"); do
      echo Running test: $path
      [[ "\n$SKIP\n" =~ $(basename $path) ]] && continue
      if [ -x $path ]; then
        patchShebangs $path
        ./$path
      elif ${lib.trivial.boolToString r7rs}; then
        chibi-scheme $path
      else
        scheme-script $path
      fi
    done

    runHook postCheck

    export CHEZSCHEMELIBDIRS=$t
  '';
  doCheck = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    cd .akku

    rm -f bin/activate*


    cp -rL lib $out/lib/scheme-libs
    cp -rL bin $out/bin

    [ -d ffi ]    && cp -rL ffi $out/lib
    [ -d libobj ] && cp -rL libobj $out/lib

    for f in $out/bin/*
    do
    wrapProgram $f \
      --prefix CHEZSCHEMELIBDIRS : $CHEZSCHEMELIBDIRS
    done

    runHook postInstall
  '';
  meta = {
    inherit (akku.meta) platforms;
  } // args.meta or { };
  setupHook = ./setup-hook.sh;
} // builtins.removeAttrs args [ "name" "buildInputs" "meta" "nativeBuildInputs" ])
).overrideAttrs override

{
  stdenv,
  akku,
  chez,
  guile,
  chibi,
  makeWrapper,
  lib,
  writeShellScriptBin,
}:
{
  pname,
  version,
  src,
  buildInputs ? [ ],
  r7rs ? false,
  nativeBuildInputs ? [ ],
  ...
}@args:
let
  parse-akku_ = writeShellScriptBin "parse-akku" "${guile}/bin/guile --no-auto-compile ${./parse-akku.scm} \"$@\"";
  parse-akku = "${parse-akku_}/bin/parse-akku";
in
stdenv.mkDerivation (
  {
    inherit version src;

    pname = "akku-${pname}";
    propagatedBuildInputs = buildInputs;
    buildInputs = [ ];
    nativeBuildInputs = [
      makeWrapper
      akku
      chez
      chibi
    ] ++ nativeBuildInputs;
    buildPhase = ''
      runHook preBuild

      # only install the project
      rm -f Akku.lock Akku.manifest

      # build, filter out guile warnings
      akku install 2>&1 | grep -v "\(guile-user\)" - | cat

      # make sure akku metadata is present during testing and onwards
      echo $PWD $CHEZSCHEMELIBDIRS \
      | sed "s/:/ /g" \
      | xargs find \
      | grep "metadata.sls" \
      | xargs ${parse-akku} merge ${pname} ${version} > temp___
      mv temp___ .akku/lib/akku/metadata.sls

      runHook postBuild
    '';
    checkPhase = ''
      IS_R7RS=false
      runHook preCheck


      propagated_chez=$CHEZSCHEMELIBDIRS
      propagated_chibi=$CHIBI_MODULE_PATH

      export CHEZSCHEMELIBDIRS="$PWD/.akku/lib:$CHEZSCHEMELIBDIRS"
      export CHIBI_MODULE_PATH="$PWD/.akku/lib:$CHIBI_MODULE_PATH"

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

      export CHEZSCHEMELIBDIRS=$propagated_chez
      export CHIBI_MODULE_PATH=$propagated_chibi
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

      CHEZSCHEMELIBDIRS="$out/lib/scheme-libs:$CHEZSCHEMELIBDIRS"

      # add support for other schemes
      for f in $out/bin/*
      do
      patchShebangs $f
      wrapProgram $f \
        --prefix CHEZSCHEMELIBDIRS : $CHEZSCHEMELIBDIRS
      done

      runHook postInstall
    '';
    meta = {
      inherit (akku.meta) platforms;
    } // args.meta or { };
    setupHook = ./setup-hook.sh;
  }
  // builtins.removeAttrs args [
    "name"
    "buildInputs"
    "meta"
    "nativeBuildInputs"
  ]
)

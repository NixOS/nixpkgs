{ lib, stdenv, fetchurl, pkgs, buildEnv, cmake, recode, perl, fortune, withOffensive ? false }:

with lib;

let
  fortuneExtensions = import ./extensions { inherit pkgs; };

  env = extensions:
    let
      selected = [ fortune ] ++ extensions fortuneExtensions;
    in buildEnv {
      name = "fortune";
      paths = selected;
      buildInputs = concatMap (x: x.buildInputs) selected;

      postBuild = ''
      files=$(find $out/share/fortunes -type f -exec readlink -f {} \;)

      for i in $files; do
        if ! [ "$(readlink -f "$out/share/fortunes/$(basename $i)")" = "$i" ]; then
          ln -sf $i $out/share/fortunes/$(basename $i)
        fi
      done
      '';
    };
in

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "3.14.1";

  # We use fetchurl instead of fetchFromGitHub because the release pack has some
  # special files.
  src = fetchurl {
    url = "https://github.com/shlomif/fortune-mod/releases/download/${pname}-${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-NnAj9dsB1ZUuTm2W8mPdK2h15Dtro8ve6c+tPoKUsXs=";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ recode ];

  cmakeFlags = [
    "-DLOCALDIR=${placeholder "out"}/share/fortunes"
  ] ++ lib.optional (!withOffensive) "-DNO_OFFENSIVE=true";

  patches = [ (builtins.toFile "not-a-game.patch" ''
    diff --git a/CMakeLists.txt b/CMakeLists.txt
    index 865e855..5a59370 100644
    --- a/CMakeLists.txt
    +++ b/CMakeLists.txt
    @@ -154,7 +154,7 @@ ENDMACRO()
     my_exe(
         "fortune"
         "fortune/fortune.c"
    -    "games"
    +    "bin"
     )

     my_exe(
    --
  '') ];

  postFixup = lib.optionalString (!withOffensive) ''
    rm -f $out/share/fortunes/men-women*
  '';

  passthru = {
    extensions = fortuneExtensions;
    withExtensions = env;
  };

  meta = with lib; {
    mainProgram = "fortune";
    description = "A program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vonfry cafkafk ];
  };
}

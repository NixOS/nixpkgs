{ lib, stdenv, fetchurl, cmake, recode, perl, rinutils, withOffensive ? false }:

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "3.18.0";

  # We use fetchurl instead of fetchFromGitHub because the release pack has some
  # special files.
  src = fetchurl {
    url = "https://github.com/shlomif/fortune-mod/releases/download/${pname}-${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-xaaB8aJgG3GG0fYS0vOnxC4RifQybxejS8ysqYE0xCs=";
  };

  nativeBuildInputs = [ cmake perl rinutils ];

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

  meta = with lib; {
    mainProgram = "fortune";
    description = "A program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vonfry ];
  };
}

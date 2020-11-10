{ stdenv, fetchurl, cmake, recode, perl }:

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "3.2.0";

  # We use fetchurl instead of fetchFromGitHub because the release pack has some
  # special files.
  src = fetchurl {
    url = "https://github.com/shlomif/fortune-mod/releases/download/${pname}-${version}/${pname}-${version}.tar.xz";
    sha256 = "0j554ja4min5rbqni8qn5gzk4xiyd643b8r50jyi32pcs88dwp7n";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ recode ];

  cmakeFlags = [
    "-DLOCALDIR=${placeholder "out"}/share/fortunes"
  ];

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

  meta = with stdenv.lib; {
    description = "A program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vonfry ];
  };
}

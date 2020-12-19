{ stdenv, fetchFromGitHub }:
  
stdenv.mkDerivation {
  pname = "frogatto-data";
  version = "unstable-2018-12-18";
  
  src = fetchFromGitHub {
    owner = "frogatto";
    repo = "frogatto";
    # master branch as of 2020-12-17
    rev = "c1d0813b3b755a4e232369b6791397ad058efc16";
    sha256 = "1fhaidd35392zzavp93r6ihyansgkc3m1ilz71ia1zl4n3fbsxjg";
  };

  installPhase = ''
    mkdir -p $out/share/frogatto/modules
    cp -ar . $out/share/frogatto/modules/frogatto
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/frogatto/frogatto";
    description = "Data files to the frogatto game";
    license = with licenses; [ cc-by-30 unfree ];
    maintainers = with maintainers; [ astro ];
  };
}

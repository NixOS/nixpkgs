{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "pmd";
  version = "6.18.0";

  nativeBuildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "1zh52q8dmdk14zcn2bq16yy6pgyxnpdc87ir0sl6nvlz5d043q9a";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R {bin,lib} $out
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "An extensible cross-language static code analyzer";
    homepage = "https://pmd.github.io/";
    changelog = "https://pmd.github.io/pmd-${version}/pmd_release_notes.html";
    platforms = platforms.unix;
    license = with licenses; [ bsdOriginal asl20 lgpl3Plus ];
  };
}

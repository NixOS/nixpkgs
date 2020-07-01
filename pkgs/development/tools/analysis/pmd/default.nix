{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "pmd";
  version = "6.17.0";

  nativeBuildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "0000w28dg5z8gs7cxhx7d0fv10ry0yxamk5my28ncqqsg7a4qy8w";
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

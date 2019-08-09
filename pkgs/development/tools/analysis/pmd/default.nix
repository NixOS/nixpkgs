{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "pmd";
  version = "6.16.0";

  nativeBuildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "0h4818dxd9nq925asa9g3g9i2i5hg85ziapacyiqq4bhab67ysy4";
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

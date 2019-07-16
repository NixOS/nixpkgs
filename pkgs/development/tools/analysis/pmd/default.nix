{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "pmd";
  version = "6.15.0";

  nativeBuildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "0im64lg18bv764i14g3p42dzd7kqq9j5an8dkz1vanypb1jf5j3s";
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

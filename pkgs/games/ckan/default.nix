{ stdenv, fetchFromGitHub, makeWrapper, perl, mono, gtk }:

stdenv.mkDerivation rec {
  name = "ckan-${version}";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "KSP-CKAN";
    repo = "CKAN";
    rev = "v${version}";
    sha256 = "0lfvl8w09lakz35szp5grfvhq8xx486f5igvj1m6azsql4n929lg";
  };

  buildInputs = [ makeWrapper perl mono gtk ];

  postPatch = ''
    substituteInPlace bin/build \
      --replace /usr/bin/perl ${perl}/bin/perl
  '';

  # Tests don't currently work, as they try to write into /var/empty.
  doCheck = false;
  checkTarget = "test";

  installPhase = ''
    mkdir -p $out/bin
    for exe in *.exe; do
      install -m 0644 $exe $out/bin
      makeWrapper ${mono}/bin/mono $out/bin/$(basename $exe .exe) \
        --add-flags $out/bin/$exe \
        --set LD_LIBRARY_PATH ${gtk.out}/lib
    done
  '';

  meta = {
    description = "Mod manager for Kerbal Space Program";
    homepage = https://github.com/KSP-CKAN/CKAN;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.Baughn ];
    platforms = stdenv.lib.platforms.all;
  };    
}

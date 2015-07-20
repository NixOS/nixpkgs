{ stdenv, fetchurl, bobcat, gcc49, icmake, yodl }:

let version = "2.02.00"; in
stdenv.mkDerivation rec {
  name = "flexc++-${version}";

  src = fetchurl {
    sha256 = "0mz5d0axr4c8rrmn4iw7b5llmf6f3g9cnjzzz3kw02mfzwll79rz";
    url = "mirror://sourceforge/flexcpp/${version}/flexc++_${version}.orig.tar.gz";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "";
    longDescription = ''
      Flexc++ was designed after `flex'. Flexc++ offers a cleaner class design
      and requires simpler specification files than offered by flex's C++
      option.
    '';
    homepage = http://flexcpp.sourceforge.net/;
    downloadPage = http://sourceforge.net/projects/flexcpp/files/;
    license = licenses.gpl3;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ bobcat gcc49 ];
  nativeBuildInputs = [ icmake yodl ];

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs ./build
  '';

  buildPhase = ''
    ./build man
    ./build manual
    ./build program
  '';

  installPhase = ''
    ./build install man
    ./build install manual
    ./build install program
    ./build install skel
    ./build install std
  '';
}

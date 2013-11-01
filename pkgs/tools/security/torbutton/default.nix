{ stdenv, fetchgit, zip }:
stdenv.mkDerivation rec {

  name = "torbutton-${version}.xpi";
  version = "1.6.1";

  src = fetchgit {
    url = https://git.torproject.org/torbutton.git;
    rev = "refs/tags/${version}";
    sha256 = "0ypzrl8nhckrgh45rcwsjds1jnzz3w5nr09b926a4h3a5njammlv";
  };

  buildInputs = [ zip ];

  buildPhase = ''
    mkdir pkg
    ./makexpi.sh
  '';

  installPhase = "cat pkg/*.xpi > $out";

  meta = with stdenv.lib; {
    homepage = https://www.torproject.org/torbutton/;
    description = "Part of the Tor Browser Bundle";
    longDescription = ''
      The component in Tor Browser Bundle that takes care of application-level
      security and privacy concerns in Firefox. To keep you safe, Torbutton
      disables many types of active content.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}

{ stdenv
, fetchurl
, makeWrapper
, ruby
, rake
}:

let version = "v4.3.0";
in stdenv.mkDerivation rec {
  name = "gist-${version}";

  src = fetchurl {
    url = "https://github.com/defunkt/gist/archive/${version}.tar.gz";
    sha256 = "92b91ffe07cc51ca8576b091e7123b851ee0d7d2d3f0e21d18b19d8bd8f9aa47";
  };

  buildInputs = [ rake makeWrapper ];

  installPhase = ''
    rake install prefix=$out

    wrapProgram $out/bin/gist \
      --prefix PATH : ${ruby}/bin \
  '';

  meta = {
    homepage = "http://defunkt.io/gist/";
    description = "upload code to https://gist.github.com (or github enterprise)";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mit;
  };
}

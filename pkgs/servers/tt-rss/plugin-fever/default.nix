{ stdenv, fetchFromGitHub, ... }: stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-fever";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "DigitalDJ";
    repo = "tinytinyrss-fever-plugin";
    rev = "${version}";
    #sha256 = "0bylgm9w8rxgrgsh2zrq2wsjy3ff1mz09ad5zmv7pn547cldhqv6";
    sha256 = "000ys6r6a90x1v6fjyb86b0aab6j7g2d29w8d5sccyv895m4x8r1";
  };

  installPhase = ''
    mkdir -p $out/fever
    cp *.php $out/fever
  '';

  meta = with stdenv.lib; {
    description = "Allows Fever compatible RSS clients to use Tiny Tiny RSS";
    longDescription = ''
    This is an open source plugin for Tiny Tiny RSS which simulates the Fever API.
    This allows Fever compatible RSS clients to use Tiny Tiny RSS.
    end-point URL is https://example.com/tt-rss/plugins.local/fever/
    '';
    license = licenses.gpl3;
    homepage = "https://github.com/DigitalDJ/tinytinyrss-fever-plugin";
    maintainers = with maintainers; [ madahin ];
    platforms = platforms.all;
  };
}

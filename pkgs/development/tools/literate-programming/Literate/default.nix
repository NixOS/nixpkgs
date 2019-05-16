{ stdenv, fetchgit, dmd, dub }:

stdenv.mkDerivation {
  name = "Literate-2019-01-08";

  src = fetchgit {
    url = "https://github.com/zyedidia/Literate.git";
    rev = "e20c5c86713701d4d17fd2881779d758a27a3e5a";
    sha256 = "1pr7iipcnp6jxi13341p5b3szdrvs7aixpfbwifj6lgbb45vg9sm";
  };

  buildInputs = [ dmd dub ];

  installPhase = "install -D bin/lit $out/bin/lit";

  meta = with stdenv.lib; {
    description = "A literate programming tool for any language";
    homepage    = http://literate.zbyedidia.webfactional.com/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

{ lib, stdenv, fetchgit }:
stdenv.mkDerivation rec {
  pname = "blesh";
  version = "0.3.3"; 

  src = fetchgit {
    url = "https://github.com/akinomyoga/ble.sh.git";
    rev = "398e404d624ef6365d9175882e24f6e180d8b6b2";
    sha256 = "09i6a45lcd8gb0397hcffwsc5fqam8f7wk2yw9qgjjrb7i9n1235";
  };
  configurePhase = ''
 mkdir contrib/.git 
'';
  installPhase = ''
    mkdir -p $out/share/doc
    mv out/doc $out/share/doc/blesh
    mv out $out/share/blesh
  '';

 meta = with lib; {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "A full-featured line editor written in pure Bash";
    longDescription = "A full-featured line editor written in pure Bash with Syntax highlighting, auto suggestions, vim modes, etc. in Bash interactive sessions!";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aryak ];
    platforms = platforms.linux;
  };
}

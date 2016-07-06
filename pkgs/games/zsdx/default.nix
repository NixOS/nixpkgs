{ stdenv, fetchgit, cmake, zip }:

stdenv.mkDerivation rec {
  name = "zsdx-${version}";
  version = "1.10.3";
  
  src = fetchgit {
    url = "https://github.com/christopho/zsdx.git";
    rev = "cb4b1b50b03d9e9a0a852e8528e4450ca72ed8f8";
    sha256 = "18x5cbl27b294ilmdmvijy19da6vl0m32kxwdx51hc67vzzgnwxd";
  };
  
  buildInputs = [ cmake zip ];

  meta = with stdenv.lib; {
    description = "A solarus quest";
    longDescription = ''
      The Legend of Zelda: Mystery of Solarus DX is the
      first game made with Solarus.  It is written in lua.
    '';
    homepage = http://www.solarus-games.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.Nate-Devv ];
    platforms = platforms.all;
  };
  
}

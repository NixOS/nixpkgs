{ stdenv, lib, fetchurl, cmake, libx86 }:

stdenv.mkDerivation rec {
  pname = "read-edid";
  version = "3.0.2";

  src = fetchurl {
    url = "http://www.polypux.org/projects/read-edid/${pname}-${version}.tar.gz";
    sha256 = "0vqqmwsgh2gchw7qmpqk6idgzcm5rqf2fab84y7gk42v1x2diin7";
  };

  patches = [ ./fno-common.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace 'COPYING' 'LICENSE'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.hostPlatform.isx86 libx86;

  cmakeFlags = [ "-DCLASSICBUILD=${lib.boolToCMakeString stdenv.hostPlatform.isx86}" ];

  meta = with lib; {
    description = "Tool for reading and parsing EDID data from monitors";
    homepage = "http://www.polypux.org/projects/read-edid/";
    license = licenses.bsd2; # Quoted: "This is an unofficial license. Let's call it BSD-like."
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}

{ lib, stdenv, fetchFromGitHub, udev }:

stdenv.mkDerivation {
  pname = "moltengamepad";
  version = "unstable-2016-05-04";

  src = fetchFromGitHub {
    owner = "jgeumlek";
    repo = "MoltenGamepad";
    rev = "6656357964c22be97227fc5353b53c6ab1e69929";
    sha256 = "05cpxfzxgm86kxx0a9f76bshjwpz9w1g8bn30ib1i5a3fv7bmirl";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ udev ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp moltengamepad $out/bin
  '';

  patchPhase = ''
    sed -i -e '159d;161d;472d;473d;474d;475d' source/eventlists/key_list.cpp
  '';

  meta = with lib; {
    homepage = "https://github.com/jgeumlek/MoltenGamepad";
    description = "Flexible Linux input device translator, geared for gamepads";
    license = licenses.mit;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.linux;
  };

}

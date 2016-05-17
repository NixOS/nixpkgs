{ stdenv, fetchFromGitHub, libudev }:

stdenv.mkDerivation rec {
  name = "moltengamepad-git-${version}";
  version = "2016-05-04";

  src = fetchFromGitHub {
    owner = "jgeumlek";
    repo = "MoltenGamepad";
    rev = "6656357964c22be97227fc5353b53c6ab1e69929";
    sha256 = "05cpxfzxgm86kxx0a9f76bshjwpz9w1g8bn30ib1i5a3fv7bmirl";
  };

  buildInputs = [ libudev ];

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

  meta = with stdenv.lib; {
    homepage = https://github.com/jgeumlek/MoltenGamepad;
    description = "Flexible Linux input device translator, geared for gamepads";
    license = licenses.mit;
    maintainers = [ maintainers.ebzzry ];
  };

}

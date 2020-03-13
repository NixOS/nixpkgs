{ stdenv, lib, fetchFromGitHub, python36 }:

stdenv.mkDerivation rec {
  pname = "brainworkshop";
  version = "2020-03-10";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = pname;
    owner = "samcv";
    rev = "ea817f7e163c4fb07a60b2066c694cba92d23818";
    sha256 = "1ygbpc3ph0k6iv77b8qcv9qjdnmibi4qaxninrsaxpafa68v1a1h";
  };

  buildInputs = [
    (python36.withPackages (ps: with ps; [
      future
      pyglet
    ]))
  ];

  patches = [ ./datadir.patch ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* $out/bin/
    mv $out/bin/brainworkshop{.pyw,}
    chmod +x $out/bin/brainworkshop
  '';

  meta = with lib; {
    homepage = "https://github.com/samcv/brainworkshop";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mt-caret ];
    description = "Fork of the popular brainworkshop game";
  };
}

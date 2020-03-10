{ stdenv, lib, fetchFromGitHub, python36 }:

stdenv.mkDerivation rec {
  pname = "brainworkshop";
  version = "2020-01-20";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = pname;
    owner = "samcv";
    rev = "e33c4c7ee34ce058dc4e099f2cf32db4d56582f3";
    sha256 = "100j348dkrm1a6cym1wynl0xaas5apavpa3vwxj0d4s8n87a4dvn";
  };

  buildInputs = [
    (python36.withPackages (ps: with ps; [
      future
      pyglet
    ]))
  ];

  patches = [ ./changes.patch ];

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

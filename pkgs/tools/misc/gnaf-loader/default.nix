{ stdenv, fetchFromGitHub, makeWrapper, postgis, python3Packages, gnused }:

stdenv.mkDerivation {
  name = "gnaf-loader-2018-09-10";

  src = fetchFromGitHub {
    owner = "minus34";
    repo = "gnaf-loader";
    rev = "8561cae34fad996cdbbe24189bc5cd3c4da29955";
    sha256 = "1g1r1d0jz7as29hlamg9rdj8nh5hyq00haplppbvlz7a85wk4i1x";
  };

  nativeBuildInputs = [ makeWrapper gnused ];

  buildInputs = with python3Packages; [ psycopg2 ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mv load-gnaf.py $out
    mv psma.py $out
    mv postgres-scripts $out
    sed \
      -i \
      '1s;^;#!/usr/bin/env python\n;' \
      $out/load-gnaf.py
    chmod u+x,g+x,o+x $out/load-gnaf.py
    makeWrapper \
      $out/load-gnaf.py \
      $out/bin/load-gnaf.py \
      --set PYTHONPATH "$PYTHONPATH" \
      --set PATH '${stdenv.lib.makeBinPath [ postgis ]}'
  '';

  postFixup = ''
    sed \
      --regexp-extended \
      --in-place \
      's!log_file = .*!log_file = "./load-gnaf.log"!' \
      $out/load-gnaf.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/minus34/gnaf-loader;
    description = "A quick way to get started with PSMA's open GNAF & Admin Boundaries";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}

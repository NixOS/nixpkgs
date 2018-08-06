{ lib, python2, fetchFromGitHub, roundup }:

python2.pkgs.buildPythonApplication rec {
  pname = "ddar";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "basak";
    repo = pname;
    rev = "v${version}";
    sha256 = "158jdy5261k9yw540g48hddy5zyqrr81ir9fjlcy4jnrwfkg7ynm";
  };

  prePatch = ''
    substituteInPlace t/local-functions \
      --replace 'PATH="$ddar_src:$PATH"' 'PATH="$out/bin:$PATH"'
    # Test requires additional software and compilation of some C programs
    substituteInPlace t/basic-test.sh \
      --replace it_stores_and_extracts_corpus0 dont_test
  '';

  preBuild = ''
    make -f Makefile.prep synctus/ddar_pb2.py
  '';

  propagatedBuildInputs = with python2.pkgs; [ protobuf ];

  checkInputs = [ roundup ];

  checkPhase = ''
    roundup t/basic-test.sh
  '';

  meta = with lib; {
    description = "Unix de-duplicating archiver";
    license = licenses.gpl3;
    homepage = src.meta.homepage;
  };
}

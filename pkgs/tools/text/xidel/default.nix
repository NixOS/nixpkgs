{ lib, stdenv, fetchsvn, fetchFromGitHub, fpc, openssl }:

let
  flreSrc = fetchFromGitHub {
    owner = "benibela";
    repo = "flre";
    rev = "5aa8a9e032feff7a5790104f2d53fa74c70bb1d9"; # latest as of 0.9.8 release date
    sha256 = "1zny494jm92fjgfirzwmxff988j4yygblaxmaclkkmcvzkjrzs05";
  };
  synapseSrc = fetchsvn {
    url = "http://svn.code.sf.net/p/synalist/code/synapse/40/";
    rev = 237;
    sha256 = "0ciqd2xgpinwrk42cpyinh9gz2i5s5rlww4mdlsca1h6saivji96";
  };
  rcmdlineSrc = fetchFromGitHub {
    owner = "benibela";
    repo = "rcmdline";
    rev = "96859e574e82d76eae49d5552a8c5aa7574a5987"; # latest as of 0.9.8 release date
    sha256 = "0vwvpwrxsy9axicbck143yfxxrdifc026pv9c2lzqxzskf9fd78b";
  };
  internettoolsSrc = fetchFromGitHub {
    owner = "benibela";
    repo = "internettools";
    rev = "c9c5cc3a87271180d4fb5bb0b17040763d2cfe06"; # latest as of 0.9.8 release date
    sha256 = "057hn7cb1vy827gvim3b6vwgfdh2ckjy8h9yj1ry7lv6hw8ynx6n";
  };
in stdenv.mkDerivation rec {
  pname = "xidel";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "benibela";
    repo = pname;
    rev = "Xidel_${version}";
    sha256 = "0q75jjyciybvj6y17s2283zis9fcw8w5pfsq8bn7diinnbjnzgl6";
  };

  nativeBuildInputs = [ fpc ];
  buildInputs = [ openssl ];

  NIX_LDFLAGS = [ "-lcrypto" ];

  patchPhase = ''
    patchShebangs \
      build.sh \
      tests/test.sh \
      tests/tests-file-module.sh \
      tests/tests.sh \
      tests/downloadTest.sh \
      tests/downloadTests.sh \
      tests/zorbajsoniq.sh \
      tests/zorbajsoniq/download.sh
  '';

  preBuildPhase = ''
    mkdir -p import/{flre,synapse} rcmdline internettools
    cp -R ${flreSrc}/. import/flre
    cp -R ${synapseSrc}/. import/synapse
    cp -R ${rcmdlineSrc}/. rcmdline
    cp -R ${internettoolsSrc}/. internettools
  '';

  buildPhase = ''
    runHook preBuildPhase
    ./build.sh
    runHook postBuildPhase
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/man/man1"
    cp meta/xidel.1 "$out/share/man/man1/"
    cp xidel "$out/bin/"
  '';

  doCheck = true;

  checkPhase = ''
    # Not all, if any, of these tests are blockers. Failing or not this phase will pass.
    # As of 2021-08-15, all of 37 failed tests are linked with the lack of network access.
    ./tests/tests.sh
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/xidel --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Command line tool to download and extract data from HTML/XML pages as well as JSON APIs";
    homepage = "https://www.videlibri.de/xidel.html";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}

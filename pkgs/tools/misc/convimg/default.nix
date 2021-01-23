{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "convimg";
  version = "8.3";

  src = fetchFromGitHub {
    owner = "mateoconlechuga";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k2fkzfg08y2gcm8jabmb2plgqmgw6y30m73ys4mmbskxgy7hc3s";
    fetchSubmodules = true;
  };

  makeFlags = [ "CC=cc" ];

  checkPhase = ''
    pushd test
    patchShebangs test.sh
    ./test.sh
    popd
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bin/convimg $out/bin/convimg
  '';

  meta = with lib; {
    description = "Image palette quantization";
    longDescription = ''
      This program is used to convert images to other formats,
      specifically for the TI84+CE and related calculators.
    '';
    homepage = "https://github.com/mateoconlechuga/convimg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}

{ stdenv, lib, fetchFromGitHub, fetchpatch, gnugrep, kmod }:

stdenv.mkDerivation rec {
  name = "mbpfan-${version}";
  version = "1.9.1";
  src = fetchFromGitHub {
    owner = "dgraziotin";
    repo = "mbpfan";
    rev = "v${version}";
    sha256 = "0issn5233h2nclrmh2jzyy5y0dyyd57f1ia7gvs3bys95glcm2s5";
  };
  patches = [
    ./fixes.patch
    (fetchpatch { # buffer overflow fix https://github.com/dgraziotin/mbpfan/issues/72
                  url = https://github.com/dgraziotin/mbpfan/commit/f2736c8ab93cafffc25b86bcc6c33e6cbd537243.patch;
                  sha256 = "10sldc69c91qk3hq0f6r3gxay38l2iw93nl85qh94mwpb8hy92yj"; })
  ];
  postPatch = ''
    substituteInPlace src/main.c \
      --replace '@GREP@' '${gnugrep}/bin/grep' \
      --replace '@LSMOD@' '${kmod}/bin/lsmod'
  '';
  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp bin/mbpfan $out/bin
    cp mbpfan.conf $out/etc
  '';
  meta = with lib; {
    description = "Daemon that uses input from coretemp module and sets the fan speed using the applesmc module";
    homepage = https://github.com/dgraziotin/mbpfan;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}

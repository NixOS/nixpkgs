{ lib, stdenv, bash, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "vimv";
  version = "unstable-2019-10-31";
  src = fetchFromGitHub {
    owner = "thameera";
    repo = "vimv";
    rev = "4152496c1946f68a13c648fb7e583ef23dac4eb8";
    sha256 = "1fsrfx2gs6bqx7wk7pgcji2i2x4alqpsi66aif4kqvnpqfhcfzjd";
  };
  phases = [ "installPhase" ];
  installPhase = ''
    install -d $out/bin
    install $src/vimv $out/bin/vimv
    patchShebangs $out/bin/vimv
  '';
  meta = with lib; {
    homepage = "https://github.com/thameera/vimv";
    description = "Batch-rename files using Vim";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.kmein ];
  };
}

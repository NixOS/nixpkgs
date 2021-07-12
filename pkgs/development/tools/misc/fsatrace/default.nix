{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fsatrace";
  version = "0.0.1-324";

  src = fetchFromGitHub {
    owner = "jacereda";
    repo = "fsatrace";
    rev = "41fbba17da580f81ababb32ec7e6e5fd49f11473";
    sha256 = "1ihm2v723idd6m0kc1z9v73hmfvh2v0vjs8wvx5w54jaxh3lmj1y";
  };

  installDir = "libexec/${pname}-${version}";

  makeFlags = [ "INSTALLDIR=$(out)/$(installDir)" ];

  preInstall = ''
    mkdir -p $out/$installDir
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/$installDir/fsatrace $out/bin/fsatrace
  '';

  meta = with lib; {
    homepage = "https://github.com/jacereda/fsatrace";
    description = "filesystem access tracer";
    license = licenses.isc;
    maintainers = [ maintainers.peti ];
    platforms = platforms.linux;
  };
}

{ lib, stdenv, fetchFromGitHub, bash }:

stdenv.mkDerivation rec {
  pname = "incron";
  version = "0.5.12";
  src = fetchFromGitHub {
    owner = "ar-";
    repo = "incron";
    rev = "${pname}-${version}";
    sha256 = "11d5f98cjafiv9h9zzzrw2s06s2fvdg8gp64km7mdprd2xmy6dih";
  };

  patches = [ ./default_path.patch ];

  prePatch = ''
    sed -i "s|/bin/bash|${bash}/bin/bash|g" usertable.cpp
  '';

  installFlags = [ "PREFIX=$(out)" ];
  installTargets = [ "install-man" ];

  preInstall = ''
    mkdir -p $out/bin

    # make install doesn't work because setuid and permissions
    # just manually install the binaries instead
    cp incrond incrontab $out/bin/
  '';

  meta = with lib; {
    description = "Cron-like daemon which handles filesystem events";
    homepage = "https://github.com/ar-/incron";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "datefudge";
  version = "1.22";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://salsa.debian.org/debian/datefudge.git";
    rev = "fe27db47a0f250fb56164114fff8ae8d5af47ab6";
    sha256 = "1fmd05r00wx4zc90lbi804jl7xwdl11jq2a1kp5lqimk3yyvfw4c";
  };

  patchPhase = ''
    substituteInPlace Makefile \
     --replace "/usr" "/" \
     --replace "-o root -g root" ""
    substituteInPlace datefudge.sh \
     --replace "@LIBDIR@" "$out/lib/"
    '';

  preInstallPhase = "mkdir -P $out/lib/datefudge";

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = "chmod +x $out/lib/datefudge/datefudge.so";

  meta = with stdenv.lib; {
    description = "Fake the system date";
    longDescription = ''
      datefudge is a small utility that pretends that the system time is
      different by pre-loading a small library which modifies the time,
      gettimeofday and clock_gettime system calls.
    '';
    homepage = https://packages.qa.debian.org/d/datefudge.html;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}

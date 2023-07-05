{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, file
, findutils
, binutils-unwrapped
, glibc
, coreutils
, sysctl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "checksec";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "slimm609";
    repo = "checksec.sh";
    rev = version;
    hash = "sha256-BWtchWXukIDSLJkFX8M/NZBvfi7vUE2j4yFfS0KEZDo=";
  };

  patches = [
    ./0001-attempt-to-modprobe-config-before-checking-kernel.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase =
    let
      path = lib.makeBinPath [
        findutils
        file
        binutils-unwrapped
        sysctl
        openssl
      ];
    in
    ''
      mkdir -p $out/bin
      install checksec $out/bin
      substituteInPlace $out/bin/checksec --replace /lib/libc.so.6 ${glibc.out}/lib/libc.so.6
      substituteInPlace $out/bin/checksec --replace "/usr/bin/id -" "${coreutils}/bin/id -"
      wrapProgram $out/bin/checksec \
        --prefix PATH : ${path}
    '';

  meta = with lib; {
    description = "Tool for checking security bits on executables";
    homepage = "https://www.trapkit.de/tools/checksec/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice globin ];
  };
}

{ lib
, stdenv
, fetchpatch
, fetchFromGitHub
, makeWrapper

  # dependencies
, binutils
, coreutils
, curl
, elfutils
, file
, findutils
, gawk
, glibc
, gnugrep
, gnused
, openssl
, procps
, sysctl
, wget
, which
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
    # Tool would sanitize the environment, removing the PATH set by our wrapper.
    ./0002-don-t-sanatize-the-environment.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase =
    let
      path = lib.makeBinPath [
        binutils
        coreutils
        curl
        elfutils
        file
        findutils
        gawk
        gnugrep
        gnused
        openssl
        procps
        sysctl
        wget
        which
      ];
    in
    ''
      mkdir -p $out/bin
      install checksec $out/bin
      substituteInPlace $out/bin/checksec \
        --replace "/bin/sed" "${gnused}/bin/sed" \
        --replace "/usr/bin/id" "${coreutils}/bin/id" \
        --replace "/lib/libc.so.6" "${glibc}/lib/libc.so.6"
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

{ lib
, stdenv
, fetchFromGitLab
, makeWrapper
, pkg-config
, file
, scdoc
, openssl
, zlib
, busybox
, apk-tools
, perl
}:

stdenv.mkDerivation rec {
  pname = "abuild";
  version = "3.11.7";

  src = fetchFromGitLab {
    domain = "gitlab.alpinelinux.org";
    owner = "alpine";
    repo = pname;
    rev = version;
    sha256 = "sha256-QcfUbjveSGAOMAyIrG0ZNNM4rqT7zWUHIhaMzBenKm0=";
  };

  buildInputs = [
    openssl
    zlib
    busybox
    # for $out/bin/apkbuild-cpan and $out/bin/apkbuild-pypi
    (perl.withPackages (ps: with ps; [
      LWP
      JSON
      ModuleBuildTiny
      LWPProtocolHttps
      IPCSystemSimple
    ]))
  ];

  nativeBuildInputs = [
    pkg-config
    scdoc
    makeWrapper
    file
  ];

  patchPhase = ''
    substituteInPlace ./Makefile \
      --replace 'chmod 4555' '#chmod 4555'
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CFLAGS=-Wno-error"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    # this script requires unpackaged 'augeas' rubygem, no reason
    # to ship it if we can't provide the dependencies for it
    rm -f ${placeholder "out"}/bin/apkbuild-gem-resolver

    # Find all executables that are not compiled binaries and wrap
    # them, make `apk-tools` available in their PATH and also the
    # $out directory since many of the binaries provided call into
    # other binaries
    for prog in \
      $(find ${placeholder "out"}/bin -type f -exec ${file}/bin/file -i '{}' + \
      | grep -v x-executable | cut -d : -f1); do
      wrapProgram $prog \
        --prefix PATH : "${lib.makeBinPath [ apk-tools ]}" \
        --prefix PATH : "${placeholder "out"}/bin"
    done
  '';

  meta = with lib; {
    description = "Alpine Linux build tools";
    homepage = "https://gitlab.alpinelinux.org/alpine/abuild";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };

}

{ lib, stdenv, fetchFromGitHub, which, pcre2, zlib, ncurses, openssl }:
let
  version = "unstable-2023-08-09";
in
stdenv.mkDerivation {
  pname = "ossec-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "ossec";
    repo = "ossec-hids";
    rev = "c8a36b0af3d4ee5252855b90236407cbfb996eb2";
    sha256 = "sha256-AZ8iubyhNHXGR/l+hA61ifNDUoan7AQ42l/uRTt5GmE=";
  };

  # clear is used during the build process
  nativeBuildInputs = [ ncurses ];

  buildInputs = [ which pcre2 zlib openssl ];

  # patch to remove root manipulation, install phase which tries to add users to the system, and init phase which tries to modify the system to launch files
  patches = [ ./no-root.patch ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: src/common/mgmt/pint-worker-external.po:(.data.rel.local+0x0): multiple definition of
  #     `PINT_worker_external_impl'; src/common/mgmt/pint-mgmt.po:(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildPhase = ''
    mkdir -p $out/logs
    export USER_DIR="$out" # just to satisy the script
    ./install.sh <<EOF
en

server
n
n
EOF
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      mv $out/active-response/bin/* $out/bin
      mv $out/etc $out/share
      mv $out/queue $out/share
      mv $out/var $out/share
      mv $out/agentless $out/share
      mv $out/.ssh $out/share
      mv $out/logs $out/share
      mv $out/rules $out/share
      mv $out/stats $out/share
      rm -r $out/active-response
      rm -r $out/tmp

      runHook postInstall
  '';

  meta = with lib; {
    description = "Open source host-based instrusion detection system";
    homepage = "https://www.ossec.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.all;
  };
}


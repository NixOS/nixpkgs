{ lib, stdenv, python3, fetchFromGitHub, makeWrapper, schedtool, sysctl, util-linux, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "ananicy";
  version = "unstable-2021-11-05";

  src = fetchFromGitHub {
    owner = "nefelim4ag";
    repo = "ananicy";
    rev = "b8968e9b32b0e4e6a01dc2314e43de8fee9da691";
    sha256 = "sha256-tlPY81xdUpZrDYdApXooZ0Mst0n7ARVHyUrmymqg0rk=";
  };

  patches = [
    # https://github.com/Nefelim4ag/Ananicy/pull/437
    # fix makefile destinations
    (fetchpatch {
      url = "https://github.com/Nefelim4ag/Ananicy/commit/dbda0f50670de3f249991706ef1cc107c5197a2f.patch";
      sha256 = "sha256-vMcJxekg2QUbm253CLAv3tmo5kedSlw+/PI/LamNWwc=";
      # only used for debian packaging. lets exclude it so the patch applies even when that file is changed
      excludes = [ "package.sh" ];
    })
    # https://github.com/Nefelim4ag/Ananicy/pull/439
    # fix syntax error
    (fetchpatch {
      url = "https://github.com/Nefelim4ag/Ananicy/commit/0f8b809298ccfd88d0e2ab952d6e4131865246da.patch";
      sha256 = "sha256-PWE4F0G97gecgc9HnG7ScA78+QVc8u8aF9u74qVChX0=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  dontConfigure = true;
  dontBuild = true;

  postInstall = ''
    wrapProgram $out/bin/ananicy \
      --prefix PATH : ${lib.makeBinPath [ schedtool util-linux ]}

    substituteInPlace $out/lib/systemd/system/ananicy.service \
      --replace "/sbin/sysctl" "${sysctl}/bin/sysctl" \
      --replace "/usr/bin/ananicy" "$out/bin/ananicy"
  '';

  meta = with lib; {
    homepage = "https://github.com/Nefelim4ag/Ananicy";
    description = "Another auto nice daemon, with community rules support";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}

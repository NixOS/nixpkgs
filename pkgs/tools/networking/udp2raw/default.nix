{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
, iptables
}:

stdenv.mkDerivation rec {
  pname = "udp2raw";
  version = "20230206.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = "udp2raw";
    rev = version;
    hash = "sha256-mchSaqw6sOJ7+dydCM8juP7QMOVUrPL4MFA79Rvyjdo=";
  };

  patches = [
    # Add install target to CMakeLists.txt
    # https://github.com/wangyu-/udp2raw/pull/469
    (fetchpatch {
      url = "https://github.com/wangyu-/udp2raw/commit/4559e6d47bb69fda0fbd3fb4b7d04ddb1cf5e2ae.patch";
      hash = "sha256-2csZdXmMW89tjXhN5QIK0rnMSXlFjLvwGnmieeKRX90=";
    })
  ];

  postPatch = ''
    echo 'const char *gitversion = "${version}";' > git_version.h
    # Adress sanitization crashes the application, reported upstream at https://github.com/wangyu-/udp2raw/issues/474
    substituteInPlace CMakeLists.txt --replace "sanitize=address," "sanitize="
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/udp2raw" --prefix PATH : "${lib.makeBinPath [ iptables ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/wangyu-/udp2raw";
    description = "A tunnel which turns UDP traffic into encrypted UDP/FakeTCP/ICMP traffic by using a raw socket";
    license = licenses.mit;
    changelog = "https://github.com/wangyu-/udp2raw/releases/tag/${version}";
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.linux;
  };
}

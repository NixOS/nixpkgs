{ libcxxStdenv, lib, fetchurl, fetchFromGitHub, pkgconfig, git,
  cmake, python3, which, flex, bison, perl, libunwind, openssl,
  buildAws ? false, buildBpf ? true
}:

libcxxStdenv.mkDerivation rec {
  pname = "osquery";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256:0zr4fyw88jrg1z2cpy3gijmwjyr5qwdp5np1if6cy74rq6bdhfkw";
  };

  nativeBuildInputs = [python3 which git cmake pkgconfig flex bison perl];

  buildInputs = [libunwind];

  patches = [
    ./libaudit-define.patch
    ./libmagic-xlocale.patch
    ./nosysctl-header.patch
    ./openssl-src.patch
    ./sysmacros.patch
  ];

  postPatch = ''
    substituteInPlace ./libraries/cmake/formula/openssl/CMakeLists.txt \
    --replace "@OSQUERY_OPENSSL_TARBALL@" \
              "${openssl.src}"
    # Make dummy git repositories for cmake to detect.
    git init
    git config user.name "John Doe"
    git config user.email "JohnDoe@nixos.org"
    touch _NOTHING_
    git add _NOTHING_
    git commit -m "Convince build system we have git."
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOSQUERY_VERSION=${version}"
  ] ++ (if buildAws then [] else ["-DOSQUERY_BUILD_AWS=OFF"])
    ++ (if buildBpf then [] else ["-DOSQUERY_BUILD_BPF=OFF"]);

  installPhase = ''
    mkdir dist
    export DESTDIR="$(pwd)/dist"
    cmake --build . --target install
    cp -r ./dist/$out $out
  '';

  meta = with lib; {
    description = "SQL powered operating system instrumentation, monitoring, and analytics";
    homepage = https://osquery.io/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ andrewchambers ];
  };
}

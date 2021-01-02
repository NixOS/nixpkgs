{ lib
, cmake
, fetchFromGitHub
, gmp
, libidn
, nettle
, readline
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "pihole-ftl";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "pi-hole";
    repo = "FTL";
    rev = "v${version}";
    sha512 = "1ybf71jwr781c7q3xvjla2vhnarba6dpp94ghzd31vhdc038g36f0ad2xp3hh8bk1hmlwzzqpcd5pl23w0f4b19kgms4cbk8rh6nvpr";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gmp libidn nettle readline ];

  CFLAGS = [
    # Upstream converts from enum to const enum
    "-Wno-error=enum-conversion"
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "CMAKE_STATIC_LIBRARY_SUFFIX" "CMAKE_SHARED_LIBRARY_SUFFIX" \

    substituteInPlace src/version.h.in \
      --replace "@GIT_VERSION@" "v${version}" \
      --replace "@GIT_DATE@" "1970-01-01" \
      --replace "@GIT_BRANCH@" "master" \
      --replace "@GIT_TAG@" "v${version}" \
      --replace "@GIT_HASH@" "builtfromreleasetarball"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp pihole-FTL $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Pi-hole FTL engine";
    homepage = "https://github.com/pi-hole/FTL";
    license = licenses.eupl12;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = platforms.linux;
  };
}

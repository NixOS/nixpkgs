{ lib
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, expat
, zlib

# Pick one of
# - ipu6 (Tiger Lake)
# - ipu6ep (Alder Lake)
, ipuVersion ? "ipu6"
}:

stdenv.mkDerivation {
  pname = "${ipuVersion}-camera-bin";
  version = "unstable-2023-02-08";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-bins";
    rev = "276859fc6de83918a32727d676985ec40f31af2b";
    hash = "sha256-QnedM2UBbGyd2wIF762Mi+VkDZYtC6MifK4XGGxlUzw=";
  };

  sourceRoot = "source/${ipuVersion}";

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc.lib
    expat
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp --no-preserve=mode --recursive \
      lib \
      include \
      $out/

    install -m 0644 -D ../LICENSE $out/share/doc/LICENSE

    runHook postInstall
  '';

  postFixup = ''
    for pcfile in $out/lib/pkgconfig/*.pc; do
      substituteInPlace $pcfile \
        --replace 'exec_prefix=/usr' 'exec_prefix=''${prefix}' \
        --replace 'prefix=/usr' "prefix=$out" \
        --replace 'libdir=/usr/lib' 'libdir=''${prefix}/lib' \
        --replace 'includedir=/usr/include' 'includedir=''${prefix}/include'
    done
  '';

  passthru = {
    inherit ipuVersion;
  };

  meta = let
    generation = {
      ipu6 = "Tiger Lake";
      ipu6ep = "Alder Lake";
    }.${ipuVersion};
  in with lib; {
    description = "${generation} IPU firmware and proprietary image processing libraries";
    homepage = "https://github.com/intel/ipu6-camera-bins";
    license = licenses.issl;
    sourceProvenance = with sourceTypes; [
      binaryFirmware
    ];
    maintainers = with maintainers; [
      hexa
    ];
    platforms = [ "x86_64-linux" ];
  };
}

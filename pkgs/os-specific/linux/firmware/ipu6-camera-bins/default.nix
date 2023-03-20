{ lib
, stdenv
, fetchFromGitHub

# Pick one of
# - ipu6 (Tiger Lake)
# - ipu6ep (Alder Lake)
, ipuVersion ? "ipu6"
}:

stdenv.mkDerivation {
  pname = "${ipuVersion}-camera-bin";
  version = "unstable-2022-11-12";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-bins";
    rev = "4694ba7ee51652d29ef41e7fde846b83a2a1c53b";
    hash = "sha256-XPT3dbV6Kl1/TEeiQESF4Q4s95hjtiv4VLlqlahQXqE=";
  };

  sourceRoot = "source/${ipuVersion}";

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

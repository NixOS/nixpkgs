{ stdenv, fetchurl
, autoPatchelfHook
, curl
, libkrb5
, libunwind
, lttng-ust
, zlib
}:

stdenv.mkDerivation rec {
  pname = "dotnet-runtime";
  version = "2.2.7";

  src = fetchurl {
    url = "https://download.visualstudio.microsoft.com/download/pr/dc8dd18d-e165-4f58-a821-d657eea08bf1/efd846172658c27dde2d9eafa7d0082e/dotnet-runtime-${version}-linux-x64.tar.gz";
    sha256 = "11zcikd38k6x0paszfp582pzhsfzvj5kn7yl25n1m09wpp8yhqwd";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    curl
    libkrb5
    libunwind
    lttng-ust
    stdenv.cc.cc
    zlib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r ./ $out/bin
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dotnet --info
  '';

  meta = with stdenv.lib; {
    homepage = https://dotnet.github.io/;
    description = ".NET Core runtime v${version}";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jonringer ];
    license = licenses.mit;
  };
}

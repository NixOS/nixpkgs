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
  version = "3.0.0";

  src = fetchurl {
    url = "https://download.visualstudio.microsoft.com/download/pr/a5ff9cbb-d558-49d1-9fd2-410cb1c8b095/a940644f4133b81446cb3733a620983a/dotnet-runtime-${version}-linux-x64.tar.gz";
    sha256 = "18gz9xa79scdfglxyy1yy0ag5nvv6h0abff4yd1c00mi7jf7p86y";
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

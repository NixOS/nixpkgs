{ stdenv, fetchFromGitHub, lib, elfutils, vendorCertFile ? null
, defaultLoader ? null }:

let

  inherit (stdenv.targetPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  target = {
    x86_64-linux = "shimx64.efi";
    aarch64-linux = "shimaa64.efi";
  }.${system} or throwSystem;
in stdenv.mkDerivation rec {
  pname = "shim";
  version = "15.7";

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = pname;
    rev = version;
    hash = "sha256-CfUuq0anbXlCVo9r9NIb76oJzDqaPMIhL9cmXK1iqXo=";
    fetchSubmodules = true;
  };

  buildInputs = [ elfutils ];

  NIX_CFLAGS_COMPILE = [ "-I${toString elfutils.dev}/include" ];

  makeFlags =
    lib.optional (vendorCertFile != null) "VENDOR_CERT_FILE=${vendorCertFile}"
    ++ lib.optional (defaultLoader != null) "DEFAULT_LOADER=${defaultLoader}"
    ++ [ target ];

  installPhase = ''
    mkdir -p $out/share/shim
    install -m 644 ${target} $out/share/shim/
  '';

  meta = with lib; {
    description = "UEFI shim loader";
    homepage = "https://github.com/rhboot/shim";
    license = licenses.bsd1;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ baloo raitobezarius ];
  };
}

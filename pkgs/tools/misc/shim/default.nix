{ stdenv, fetchFromGitHub, lib, elfutils, vendorCertFile ? null
, overrideSecurityPolicy ? false
, defaultLoader ? null }:

let

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  target = {
    x86_64-linux = "shimx64.efi";
    aarch64-linux = "shimaa64.efi";
  }.${system} or throwSystem;
in stdenv.mkDerivation rec {
  pname = "shim";
  version = "15.8";

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = pname;
    rev = version;
    hash = "sha256-xnr9HBfYP035C7p2YTRZasx5SF4a2ZkOl9IpsVduNm4=";
    fetchSubmodules = true;
  };

  buildInputs = [ elfutils ];

  env.NIX_CFLAGS_COMPILE = toString ([
    "-I${elfutils.dev}/include"
    ]
  # Somehow the define doesn't end up in DEFINES for the scope of lib/,
  # so security_policy.c gets built without it, and that means it
  # compiles to nothing, so linking fails. Couldn't be bothered to
  # debug the makefiles just now, so here's a hack.
    ++ lib.optional overrideSecurityPolicy "-DOVERRIDE_SECURITY_POLICY"
  );

  makeFlags =
    lib.optional (vendorCertFile != null) "VENDOR_CERT_FILE=${vendorCertFile}"
    ++ lib.optional (defaultLoader != null) "DEFAULT_LOADER=${defaultLoader}"
    ++ lib.optional overrideSecurityPolicy "OVERRIDE_SECURITY_POLICY=1"
    ++ [ target ];

  installPhase = ''
    mkdir -p $out/share/shim
    install -m 644 ${target} $out/share/shim/
  '';

  passthru = {
    # Expose the target file name so that consumers
    # (e.g. infrastructure for signing this shim) don't need to
    # duplicate the logic from here
    inherit target;
  };

  meta = with lib; {
    description = "UEFI shim loader";
    homepage = "https://github.com/rhboot/shim";
    license = licenses.bsd1;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ baloo raitobezarius ];
  };
}

{stdenv, lib, fetchFromGitHub, dmd, curl}:

stdenv.mkDerivation rec {
  name = "dtools-${version}";
  version = "2.075.1";

  src = fetchFromGitHub {
    owner = "dlang";
    repo = "tools";
    rev = "v${version}";
    sha256 = "0lxn400s9las9hq6h9vj4mis2jr662k2yw0zcrvqcm1yg9pd245d";
  };

  postPatch = ''
      substituteInPlace posix.mak \
          --replace "../dmd/generated/\$(OS)/release/\$(MODEL)/dmd" ${dmd.out}/bin/dmd

      substituteInPlace posix.mak \
          --replace gcc $CC
  '';

  nativeBuildInputs = [ dmd ];
  buildInputs = [ curl ];

  buildPhase = ''
    make -f posix.mak DMD=${dmd.out}/bin/dmd INSTALL_DIR=$out
  '';

  doCheck = true;

  checkPhase = ''
      export BITS=${builtins.toString stdenv.hostPlatform.parsed.cpu.bits}
      export OSNAME=${if stdenv.hostPlatform.isDarwin then "osx" else stdenv.hostPlatform.parsed.kernel.name}
      ./generated/$OSNAME/$BITS/rdmd -main -unittest rdmd.d
      ${dmd.out}/bin/dmd rdmd_test.d
      ./rdmd_test
    '';

  installPhase = ''
    mkdir -p $out/bin
    ${
      let bits = builtins.toString stdenv.hostPlatform.parsed.cpu.bits;
      osname = if stdenv.hostPlatform.isDarwin then "osx" else stdenv.hostPlatform.parsed.kernel.name; in
      "find $PWD/generated/${osname}/${bits} -perm /a+x -type f -exec cp {} $out/bin \\;"
    }
	'';

  meta = {
    description = "Ancillary tools for the D programming language compiler";
    homepage = https://github.com/dlang/tools;
    license = lib.licenses.boost;
    platforms = stdenv.lib.platforms.unix;
  };
}

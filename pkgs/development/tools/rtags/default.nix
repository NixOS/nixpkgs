{ stdenv, lib, fetchFromGitHub
, apple_sdk
, cmake
, emacs
, llvmPackages
, openssl
, pkgconfig
, rct
}:

stdenv.mkDerivation rec {
  pname = "rtags";
  version = "2.33";

  src = fetchFromGitHub {
    owner = "andersbakken";
    repo = pname;
    rev = "v${version}";
    sha256 = "14whz3l2595vm0hj67hl3i1yw0mslhz3c5j4r6c1j9z3jwf93xim";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ llvmPackages.llvm openssl emacs ]
    ++ lib.optionals stdenv.cc.isGNU [ llvmPackages.clang-unwrapped ]
    ++ lib.optionals stdenv.isDarwin [ apple_sdk.libs.xpc apple_sdk.frameworks.CoreServices ];

  # emulate `git submodule update --init`, they only support rct as source
  prePatch = ''
    rm -r src/rct
    ln -sfv ${rct.src} src/rct
  '';

  preConfigure = ''
    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags) -fexceptions" \
           LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib"
  '';

  # seems to need rdm running as a daemon and additional setup
  doCheck = false;
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C/C++ client-server indexer based on clang";
    homepage = "https://github.com/andersbakken/rtags";
    license = licenses.gpl3;
    platforms = with platforms; x86_64 ++ aarch64;
    maintainers = with maintainers; [ jonringer ];
  };
}

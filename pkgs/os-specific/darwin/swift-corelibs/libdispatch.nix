{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, ninja }:

stdenv.mkDerivation rec {
  pname   = "libdispatch";
  version = "swift-5.3.2"; # not the real version, APPLE refuse to give one. https://github.com/apple/swift-corelibs-foundation/commit/df3ec55fe6c162d590a7653d89ad669c2b9716b1#commitcomment-30442619

  src = fetchFromGitHub {
    owner  = "apple";
    repo   = "swift-corelibs-libdispatch";
    rev    = "${version}-RELEASE";
    sha256 = "1bb32dqzijaqwz7wx919f7l50pk16smyi5cbc9vf9gr0d9grk8mw";
  };

  # TODO: patches may be in upstream. Check if they can be dropped in next update.
  patches = [
    # fix unneeded link BlocksRuntime
    (fetchpatch {
      url = "https://github.com/apple/swift-corelibs-libdispatch/pull/555/commits/f32bd924141d3740d4acdb3e3da27be517525cd5.patch";
      sha256 = "1dg8l87marrqvnz68b6lpyvbb3zyzjiwzcnahddd07z0dqajgp9r";
    })
  ];

  cmakeFlags = [
    "-D INSTALL_PRIVATE_HEADERS=ON"
  ];

  nativeBuildInputs = [ cmake ninja ];

  meta = with lib; {
    platforms   = platforms.darwin; # In fact it could build on linux too, but I doubt if anyone wants it.
    license     = licenses.apsl20;
  };
}

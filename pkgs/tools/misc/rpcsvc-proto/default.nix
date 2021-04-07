{ stdenv, lib, fetchFromGitHub, autoreconfHook, buildPackages }:

stdenv.mkDerivation rec {
  pname = "rpcsvc-proto";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "006l1f824r9bcbwn1s1vbs33cdwhs66jn6v97yas597y884y40z9";
  };

  outputs = [ "out" "man" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook ];

  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace rpcsvc/Makefile.am \
      --replace '$(top_builddir)/rpcgen/rpcgen' '${buildPackages.rpcsvc-proto}/bin/rpcgen'
  '';

  meta = with lib; {
    homepage = "https://github.com/thkukuk/rpcsvc-proto";
    description = "This package contains rpcsvc proto.x files from glibc, which are missing in libtirpc";
    longDescription = ''
      The RPC-API has been removed from glibc. The 2.32-release-notes
      (https://sourceware.org/pipermail/libc-announce/2020/000029.html) recommend to use
      `libtirpc` and this package instead.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}

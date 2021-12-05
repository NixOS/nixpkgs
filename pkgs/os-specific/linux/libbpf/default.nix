{ lib, stdenv, fetchFromGitHub, pkg-config, libelf, zlib, fetchpatch }:

with builtins;

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "libbpf";
    rev = "v${version}";
    sha256 = "sha256-p9wUDC7r6+ElbheNkTkZW4eMNAvPbvpUyQjTjCE34ck=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libelf zlib ];

  sourceRoot = "source/src";
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=$(out)" ];

  # FIXME: Multi-output requires some fixes to the way the pkg-config file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Upstream mirror of libbpf";
    homepage = "https://github.com/libbpf/libbpf";
    license = with licenses; [
      lgpl21 # or
      bsd2
    ];
    maintainers = with maintainers; [ thoughtpolice vcunat saschagrunert ];
    platforms = platforms.linux;
  };
}

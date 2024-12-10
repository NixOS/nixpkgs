{
  lib,
  stdenv,
  fetchurl,
  cmake,
  makeWrapper,
  boost,
  xz,
  libiconv,
  withGog ? false,
  unar ? null,
}:

stdenv.mkDerivation rec {
  pname = "innoextract";
  version = "1.9";

  src = fetchurl {
    url = "https://constexpr.org/innoextract/files/innoextract-${version}.tar.gz";
    sha256 = "09l1z1nbl6ijqqwszdwch9mqr54qb7df0wp2sd77v17dq6gsci33";
  };

  buildInputs = [
    xz
    boost
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  # Python is reported as missing during the build, however
  # including Python does not change the output.

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  strictDeps = true;

  # we need unar to for multi-archive extraction
  postFixup = lib.optionalString withGog ''
    wrapProgram $out/bin/innoextract \
      --prefix PATH : ${lib.makeBinPath [ unar ]}
  '';

  meta = with lib; {
    description = "A tool to unpack installers created by Inno Setup";
    homepage = "https://constexpr.org/innoextract/";
    license = licenses.zlib;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
    mainProgram = "innoextract";
  };
}

{ stdenv, fetchFromGitHub, ctags, perl, elfutils, vtable-dumper }:

stdenv.mkDerivation rec {
  pname = "abi-dumper";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "abi-dumper";
    rev = version;
    sha256 = "1byhw132aj7a5a5zh5s3pnjlrhdk4cz6xd5irp1y08jl980qba5j";
  };

  patchPhase = ''
    substituteInPlace abi-dumper.pl \
      --replace eu-readelf ${elfutils}/bin/eu-readelf \
      --replace vtable-dumper ${vtable-dumper}/bin/vtable-dumper \
      --replace '"ctags"' '"${ctags}/bin/ctags"'
  '';

  buildInputs = [ elfutils ctags perl vtable-dumper ];

  preBuild = "mkdir -p $out";
  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/lvc/abi-dumper";
    description = "Dump ABI of an ELF object containing DWARF debug info";
    license = licenses.lgpl21;
    maintainers = [ maintainers.bhipple ];
    platforms = platforms.all;
  };
}

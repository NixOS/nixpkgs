{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "xdxf2slob-unstable-2015-06-30";

  src = fetchFromGitHub {
    owner = "itkach";
    repo = "xdxf2slob";
    rev = "6831b93c3db8c73200900fa4ddcb17350a677e1b";
    sha256 = "0m3dnc3816ja3kmik1wabb706dkqdf5sxvabwgf2rcrq891xcddd";
  };

  propagatedBuildInputs = [ python3Packages.PyICU python3Packages.slob ];

  meta = with stdenv.lib; {
    description = "Tool to convert XDXF dictionary files to slob format";
    homepage = https://github.com/itkach/xdxf2slob/;
    license = licenses.gpl3;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}

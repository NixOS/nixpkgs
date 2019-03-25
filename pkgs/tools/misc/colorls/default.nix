{ buildRubyGem, ruby, fetchurl, stdenv }:

let
  gemName = "colorls";
  version = "1.1.1";

  clocale = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "clocale";
    version = "0.0.4";
    source.sha256 = "5f0e80577eb0dfa9717cfa29194ed570f02b17494f114b57b3dfb4fae159b718";
  };

  filesize = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "filesize";
    version = "0.2.0";
    source.sha256 = "0f5db8629d628b60857dd8e7b8d52f427e6b7b9dc49265bfda71c0d383cbe79e"; 
  };

  manpages = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "manpages";
    version = "0.6.1";
    source.sha256 = "cdbad16823c8510c15a93d4cdbd46e7b4290aff8b10f3d4b70caa8e62c8de686";
  };

  rainbow = buildRubyGem rec {
    inherit ruby;
    name = "ruby${ruby.version}-${gemName}-${version}";
    gemName = "rainbow";
    version = "3.0.0";
    source.sha256 = "13ce4ffc3c94fb7a842117ecabdcdc5ff7fa27bec15ea44137b9f9abe575622d";
  };

  nerdFont = fetchurl {
    name = "nerd-font-complete";
    url = https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf;
    sha256 = "0sv3by8gqymrsvipfddrmlhi8zirqb14y9x63wrqks6mvg7jjgl9";
  };
in

buildRubyGem {
  inherit ruby gemName version;
  name = "${gemName}-${version}";
  source.sha256 = "ac553738fc05778a6683cd66ca533a879e521f8a3673e3fa2c0c9b5c40572194";
  buildInputs = [ clocale filesize manpages rainbow ];
  postInstall = ''
    mkdir -p $out/share/fonts
    cp ${nerdFont} "$out/share/fonts/"
    printf '\033[0;31m' # red
    echo "You may need to run fc-cache -r and/or open a new terminal for fonts to work"
    printf '\033[0m' # no color
  '';

  meta = {
    description = "A Ruby gem that colorizes the ls output with color and icons";
    homepage = https://github.com/athityakumar/colorls;
    license = stdenv.lib.licenses.mit;
  };
}
